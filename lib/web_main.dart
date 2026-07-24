import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/theme/app_theme.dart';
import 'app/modules/admin_dashboard/views/admin_dashboard_view.dart';
import 'app/modules/admin_dashboard/bindings/admin_dashboard_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase (used for Database and Storage)
  await Supabase.initialize(
    url: 'https://lneyfipmxlphxajwznvo.supabase.co',
    anonKey: 'sb_publishable_X3LgLoVkiEze75XavDLRaQ_jeHvo-uj',
  );

  runApp(
    GetMaterialApp(
      title: "ShopAdmin Dashboard",
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AdminDashboardView(),
      initialBinding: AdminDashboardBinding(),
    ),
  );
}
