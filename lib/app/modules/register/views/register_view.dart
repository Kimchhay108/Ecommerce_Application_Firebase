import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                
                // Back Button
                GestureDetector(
                  onTap: () => Get.back(),
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

                // Title
                const Text(
                  'Create Account',
                  style: TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),

                // First Name Input
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TextField(
                    controller: controller.firstNameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Firstname',
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

                // Last Name Input
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TextField(
                    controller: controller.lastNameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Lastname',
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

                // Email Address Input
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

                // Password Input
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Obx(() => TextField(
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
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
                  )),
                ),
                const SizedBox(height: 32),

                // Continue Button
                Obx(() => GestureDetector(
                  onTap: controller.isLoading.value ? null : controller.register,
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
                const SizedBox(height: 24),

                // "Already have an Account ? Sign In"
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an Account ? ",
                      style: const TextStyle(
                        color: AppTheme.textPrimaryColor,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: const TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.back(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
