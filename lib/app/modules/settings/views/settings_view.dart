import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller if it's not already put globally
    final controller = Get.put(SettingsController());
    controller.fetchUserProfile();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              const Center(
                child: Text(
                  'Profile',
                  style: TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Avatar Circle
              Obx(() => Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(controller.userAvatarUrl.value),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
              const SizedBox(height: 24),

              // User Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.userName.value,
                                style: const TextStyle(
                                  color: AppTheme.textPrimaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.userEmail.value,
                                style: const TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.userPhone.value,
                                style: const TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: controller.editProfile,
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Settings Options Lists
              _buildSettingItem('Address', () => Get.snackbar('Address', 'Address settings coming soon!')),
              const SizedBox(height: 12),
              _buildSettingItem('Wishlist', () => Get.snackbar('Wishlist', 'Wishlist screen coming soon!')),
              const SizedBox(height: 12),
              _buildSettingItem('Payment', () => Get.snackbar('Payment', 'Payment settings coming soon!')),
              const SizedBox(height: 12),
              _buildSettingItem('Help', () => Get.snackbar('Help', 'Help center coming soon!')),
              const SizedBox(height: 12),
              _buildSettingItem('Support', () => Get.snackbar('Support', 'Support ticketing coming soon!')),
              const SizedBox(height: 32),

              // Sign Out Button
              GestureDetector(
                onTap: controller.signOut,
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Color(0xFFFA3636),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondaryColor,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

