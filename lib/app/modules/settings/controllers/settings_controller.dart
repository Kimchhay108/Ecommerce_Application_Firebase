import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/app_theme.dart';

class SettingsController extends GetxController {

  final RxString userName = 'Gilbert Jones'.obs;
  final RxString userEmail = 'Glbertjones001@gmail.com'.obs;
  final RxString userPhone = '121-224-7890'.obs;
  final RxString userAvatarUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data();
          if (data != null) {
            final first = data['firstName'] ?? '';
            final last = data['lastName'] ?? '';
            userName.value = '$first $last'.trim().isEmpty ? 'User' : '$first $last'.trim();
            userEmail.value = data['email'] ?? user.email ?? '';
            userPhone.value = data['phone'] ?? '';
            if (data['avatarUrl'] != null && data['avatarUrl'].toString().isNotEmpty) {
              userAvatarUrl.value = data['avatarUrl'];
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
  }

  void editProfile() {
    final nameParts = userName.value.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final firstNameCtrl = TextEditingController(text: firstName);
    final lastNameCtrl = TextEditingController(text: lastName);
    final phoneCtrl = TextEditingController(text: userPhone.value);
    final isSaving = false.obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                     'Edit Profile Info',
                     style: TextStyle(
                       color: AppTheme.textPrimaryColor,
                       fontSize: 18,
                       fontWeight: FontWeight.w700,
                     ),
                  ),
                  IconButton(
                     icon: const Icon(Icons.close, color: AppTheme.textSecondaryColor),
                     onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text(
                 'First Name',
                 style: TextStyle(
                   color: AppTheme.textPrimaryColor,
                   fontSize: 14,
                   fontWeight: FontWeight.w500,
                 ),
              ),
              const SizedBox(height: 8),
              TextField(
                 controller: firstNameCtrl,
                 style: const TextStyle(color: AppTheme.textPrimaryColor),
                 decoration: InputDecoration(
                   filled: true,
                   fillColor: AppTheme.surfaceColor,
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(8),
                     borderSide: BorderSide.none,
                   ),
                   hintText: 'Enter your first name',
                   hintStyle: const TextStyle(color: AppTheme.textSecondaryColor),
                 ),
              ),
              const SizedBox(height: 16),

              const Text(
                 'Last Name',
                 style: TextStyle(
                   color: AppTheme.textPrimaryColor,
                   fontSize: 14,
                   fontWeight: FontWeight.w500,
                 ),
              ),
              const SizedBox(height: 8),
              TextField(
                 controller: lastNameCtrl,
                 style: const TextStyle(color: AppTheme.textPrimaryColor),
                 decoration: InputDecoration(
                   filled: true,
                   fillColor: AppTheme.surfaceColor,
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(8),
                     borderSide: BorderSide.none,
                   ),
                   hintText: 'Enter your last name',
                   hintStyle: const TextStyle(color: AppTheme.textSecondaryColor),
                 ),
              ),
              const SizedBox(height: 16),

              const Text(
                 'Phone Number',
                 style: TextStyle(
                   color: AppTheme.textPrimaryColor,
                   fontSize: 14,
                   fontWeight: FontWeight.w500,
                 ),
              ),
              const SizedBox(height: 8),
              TextField(
                 controller: phoneCtrl,
                 keyboardType: TextInputType.phone,
                 style: const TextStyle(color: AppTheme.textPrimaryColor),
                 decoration: InputDecoration(
                   filled: true,
                   fillColor: AppTheme.surfaceColor,
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(8),
                     borderSide: BorderSide.none,
                   ),
                   hintText: 'Enter your phone number',
                   hintStyle: const TextStyle(color: AppTheme.textSecondaryColor),
                 ),
              ),
              const SizedBox(height: 24),

              Obx(() => SizedBox(
                 width: double.infinity,
                 height: 48,
                 child: ElevatedButton(
                   onPressed: isSaving.value
                       ? null
                       : () async {
                           final newFirst = firstNameCtrl.text.trim();
                           final newLast = lastNameCtrl.text.trim();
                           final newPhone = phoneCtrl.text.trim();

                           if (newFirst.isEmpty) {
                             Get.snackbar(
                               'Validation Error',
                               'First name cannot be empty',
                               snackPosition: SnackPosition.BOTTOM,
                               backgroundColor: Colors.redAccent.withOpacity(0.9),
                               colorText: Colors.white,
                               margin: const EdgeInsets.all(16),
                             );
                             return;
                           }

                           isSaving.value = true;
                           try {
                             final user = FirebaseAuth.instance.currentUser;
                             if (user != null) {
                               await FirebaseFirestore.instance
                                   .collection('users')
                                   .doc(user.uid)
                                   .update({
                                     'firstName': newFirst,
                                     'lastName': newLast,
                                     'phone': newPhone,
                                   });

                               userName.value = '$newFirst $newLast'.trim();
                               userPhone.value = newPhone;

                               Get.back();
                               Get.snackbar(
                                 'Profile Updated',
                                 'Your profile information has been saved.',
                                 snackPosition: SnackPosition.BOTTOM,
                                 backgroundColor: Colors.green.withOpacity(0.9),
                                 colorText: Colors.white,
                                 margin: const EdgeInsets.all(16),
                               );
                             }
                           } catch (e) {
                             Get.snackbar(
                               'Error updating profile',
                               e.toString(),
                               snackPosition: SnackPosition.BOTTOM,
                               backgroundColor: Colors.redAccent.withOpacity(0.9),
                               colorText: Colors.white,
                               margin: const EdgeInsets.all(16),
                             );
                           } finally {
                             isSaving.value = false;
                           }
                         },
                   style: ElevatedButton.styleFrom(
                     backgroundColor: AppTheme.primaryColor,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(24),
                     ),
                   ),
                   child: isSaving.value
                       ? const SizedBox(
                           width: 24,
                           height: 24,
                           child: CircularProgressIndicator(
                             strokeWidth: 2,
                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                           ),
                         )
                       : const Text(
                           'Save Changes',
                           style: TextStyle(
                             color: Colors.white,
                             fontSize: 16,
                             fontWeight: FontWeight.w700,
                           ),
                         ),
                 ),
              )),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void signOut() {
    Get.defaultDialog(
      title: 'Sign Out',
      middleText: 'Are you sure you want to sign out?',
      textConfirm: 'Yes',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        Get.back();
        await FirebaseAuth.instance.signOut();
        Get.delete<SettingsController>();
        Get.offAllNamed(Routes.LOGIN);
        Get.snackbar(
          'Sign Out',
          'Successfully signed out!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      },
    );
  }
}

