import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  late SharedPreferences prefs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: '502799509485-9t4pp3n3ho6qr7lgm7bon7oacj986bsd.apps.googleusercontent.com',
  );

  Future<AuthService> init() async {
    prefs = await SharedPreferences.getInstance();
    return this;
  }

  bool get isLoggedIn => prefs.getBool('is_logged_in') ?? false;

  Future<void> setLoggedIn(bool value) async {
    await prefs.setBool('is_logged_in', value);
  }

  User? get currentUser => _auth.currentUser;

  /// Sign in or Sign up with Google
  /// Returns Map with keys: 'user' (User?), 'isNewUser' (bool), 'error' (String?)
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled sign-in process
        return {'user': null, 'isNewUser': false, 'error': null};
      }

      // Obtain auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create OAuth credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase using credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        return {'user': null, 'isNewUser': false, 'error': 'Failed to authenticate user.'};
      }

      // Check if user record exists in Supabase
      final userDoc = await sb.Supabase.instance.client
          .from('users')
          .select()
          .eq('id', user.uid)
          .maybeSingle();

      final bool isNewUser = userDoc == null;

      if (isNewUser) {
        // Parse display name into firstName and lastName
        String firstName = '';
        String lastName = '';
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          final nameParts = user.displayName!.trim().split(' ');
          firstName = nameParts.first;
          if (nameParts.length > 1) {
            lastName = nameParts.sublist(1).join(' ');
          }
        }

        // Save user details to Supabase
        await sb.Supabase.instance.client.from('users').insert({
          'id': user.uid,
          'first_name': firstName,
          'last_name': lastName,
          'email': user.email ?? '',
          'avatar_url': user.photoURL ?? '',
          'gender': '',
          'age_range': '',
        });
      } else {
        await sb.Supabase.instance.client
            .from('users')
            .update({
              'last_login_at': DateTime.now().toIso8601String(),
            })
            .eq('id', user.uid);
      }

      return {
        'user': user,
        'isNewUser': isNewUser,
        'error': null,
      };
    } on FirebaseAuthException catch (e) {
      return {'user': null, 'isNewUser': false, 'error': e.message ?? e.code};
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains('10') || errorMessage.contains('sign_in_failed')) {
        errorMessage =
            'Developer Configuration Error (ApiException 10).\n\nPlease add your SHA-1 fingerprint to Firebase Console and download the updated google-services.json.';
      }
      return {'user': null, 'isNewUser': false, 'error': errorMessage};
    }
  }

  /// Check if user is banned
  Future<bool> checkIfBanned(String uid) async {
    try {
      final userDoc = await sb.Supabase.instance.client
          .from('users')
          .select('is_banned')
          .eq('id', uid)
          .maybeSingle();
      if (userDoc != null) {
        return userDoc['is_banned'] == true;
      }
    } catch (e) {
      print('Error checking ban status: $e');
    }
    return false;
  }

  /// Sign out from Firebase and Google
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
    await setLoggedIn(false);
  }
}
