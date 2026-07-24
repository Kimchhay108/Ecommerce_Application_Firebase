import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'app/data/services/auth_service.dart';
import 'app/data/services/supabase_product_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (used for Authentication)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Supabase (used for Database and Storage)
  await Supabase.initialize(
    url: 'https://lneyfipmxlphxajwznvo.supabase.co',
    anonKey: 'sb_publishable_X3LgLoVkiEze75XavDLRaQ_jeHvo-uj',
  );

  // Initialize SharedPreferences & AuthService
  await Get.putAsync(() => AuthService().init());

  // Initialize SupabaseProductService
  await Get.putAsync(() => SupabaseProductService().init());

  // Determine initial route based on authentication state
  final initialRoute = AuthService.to.isLoggedIn ? Routes.HOME : AppPages.INITIAL;

  runApp(
    GetMaterialApp(
      title: "Application",
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    ),
  );
}
