import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isPassword = controller.isPasswordStep.value;
      return PopScope(
        canPop: !isPassword,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            controller.goBackToEmailStep();
          }
        },
        child: Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    if (isPassword) ...[
                      GestureDetector(
                        onTap: controller.goBackToEmailStep,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: AppTheme.surfaceColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 16,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ] else ...[
                      const SizedBox(height: 64),
                    ],

                    const Text(
                      'Sign in',
                      style: TextStyle(
                        color: AppTheme.textPrimaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),

                    if (!isPassword) ...[

                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: TextField(
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email Address',
                            hintStyle: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 16,
                            ),
                          ),
                          style: const TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Obx(() => GestureDetector(
                        onTap: controller.isLoading.value ? null : controller.signIn,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          height: 56,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          alignment: Alignment.center,
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Continue',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      )),
                      const SizedBox(height: 16),

                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an Account ? ",
                            style: const TextStyle(
                              color: AppTheme.textPrimaryColor,
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: 'Create One',
                                style: const TextStyle(
                                  color: AppTheme.textPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = controller.navigateToCreateAccount,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),

                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: AppTheme.textSecondaryColor.withOpacity(0.2),
                              thickness: 1,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                color: AppTheme.textSecondaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: AppTheme.textSecondaryColor.withOpacity(0.2),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      _buildSocialButton(
                        icon: const Icon(
                          Icons.apple,
                          color: AppTheme.textPrimaryColor,
                          size: 24,
                        ),
                        label: 'Continue With Apple',
                        onTap: controller.signInWithApple,
                      ),
                      const SizedBox(height: 12),
                      _buildSocialButton(
                        icon: Image.network(
                          'https://developers.google.com/identity/images/g-logo.png',
                          height: 24,
                          width: 24,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.g_mobiledata,
                            color: AppTheme.textPrimaryColor,
                            size: 28,
                          ),
                        ),
                        label: 'Continue With Google',
                        onTap: controller.signInWithGoogle,
                      ),
                      const SizedBox(height: 12),
                      _buildSocialButton(
                        icon: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/2021_Facebook_icon.svg/256px-2021_Facebook_icon.svg.png',
                          height: 24,
                          width: 24,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.facebook,
                            color: Color(0xFF1877F2),
                            size: 24,
                          ),
                        ),
                        label: 'Continue With Facebook',
                        onTap: controller.signInWithFacebook,
                      ),
                      const SizedBox(height: 24),
                    ] else ...[

                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: TextField(
                          controller: controller.passwordController,
                          obscureText: !controller.isPasswordVisible.value,
                          autofocus: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 16,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppTheme.textSecondaryColor,
                                size: 20,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                          style: const TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Obx(() => GestureDetector(
                        onTap: controller.isLoading.value ? null : controller.signIn,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          height: 56,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          alignment: Alignment.center,
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Continue',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      )),
                      const SizedBox(height: 16),

                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Forgot Password ? ",
                            style: const TextStyle(
                              color: AppTheme.textPrimaryColor,
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: 'Reset',
                                style: const TextStyle(
                                  color: AppTheme.textPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = controller.resetPassword,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSocialButton({
    required Widget icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Container(
              width: 28,
              alignment: Alignment.centerLeft,
              child: icon,
            ),
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 28),
          ],
        ),
      ),
    );
  }
}
