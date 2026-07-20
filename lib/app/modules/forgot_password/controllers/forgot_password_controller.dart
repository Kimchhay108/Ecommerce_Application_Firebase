import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final String? emailArg = Get.arguments as String?;
    if (emailArg != null && emailArg.isNotEmpty) {
      emailController.text = emailArg;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  void sendResetEmail() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar(
        'Email Required',
        'Please enter your email address.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Invalid Email',
        'Please enter a valid email address.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isLoading.value = true;
    // Mock password reset request
    Future.delayed(const Duration(milliseconds: 1000), () {
      isLoading.value = false;
      Get.back(); // Pop back to Login screen
      Get.snackbar(
        'Email Sent',
        'A password reset link has been successfully sent to $email.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    });
  }
}
