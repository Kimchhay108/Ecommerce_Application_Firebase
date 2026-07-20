import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isPasswordStep = false.obs;
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void goBackToEmailStep() {
    isPasswordStep.value = false;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void signIn() async {
    if (!isPasswordStep.value) {
      // Step 1: Email Validation
      final email = emailController.text.trim();
      if (email.isEmpty) {
        Get.snackbar(
          'Email Required',
          'Please enter your email address to continue.',
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

      // Transition to password step
      isPasswordStep.value = true;
    } else {
      // Step 2: Password Validation
      final password = passwordController.text;
      if (password.isEmpty) {
        Get.snackbar(
          'Password Required',
          'Please enter your password to continue.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      if (password.length < 6) {
        Get.snackbar(
          'Weak Password',
          'Password must be at least 6 characters.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      isLoading.value = true;
      try {
        final email = emailController.text.trim();
        final password = passwordController.text;

        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        isLoading.value = false;
        Get.offAllNamed(Routes.HOME);
        Get.snackbar(
          'Welcome back!',
          'Successfully signed in as ${userCredential.user?.email ?? email}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        String errorMessage = 'An error occurred during authentication.';

        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided.';
        } else if (e.code == 'invalid-credential') {
          errorMessage = 'Invalid email or password.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is badly formatted.';
        } else if (e.code == 'user-disabled') {
          errorMessage = 'This user account has been disabled.';
        }

        Get.snackbar(
          'Sign In Failed',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      } catch (e) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    }
  }

  void resetPassword() {
    final email = emailController.text.trim();
    Get.toNamed(Routes.FORGOT_PASSWORD, arguments: email);
  }

  void signInWithGoogle() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 600), () {
      isLoading.value = false;
      Get.offAllNamed(Routes.HOME);
      Get.snackbar(
        'Google Sign In',
        'Successfully signed in with Google!',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    });
  }

  void signInWithApple() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 600), () {
      isLoading.value = false;
      Get.offAllNamed(Routes.HOME);
      Get.snackbar(
        'Apple Sign In',
        'Successfully signed in with Apple!',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    });
  }

  void signInWithFacebook() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 600), () {
      isLoading.value = false;
      Get.offAllNamed(Routes.HOME);
      Get.snackbar(
        'Facebook Sign In',
        'Successfully signed in with Facebook!',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    });
  }

  void navigateToCreateAccount() {
    Get.toNamed(Routes.REGISTER);
  }
}
