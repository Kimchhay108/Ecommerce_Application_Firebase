import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void register() async {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (firstName.isEmpty) {
      Get.snackbar(
        'First Name Required',
        'Please enter your first name.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (lastName.isEmpty) {
      Get.snackbar(
        'Last Name Required',
        'Please enter your last name.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

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

    if (password.isEmpty) {
      Get.snackbar(
        'Password Required',
        'Please enter your password.',
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

      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'gender': '',
        'ageRange': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      isLoading.value = false;
      Get.offAllNamed(Routes.ONBOARDING);
      Get.snackbar(
        'Welcome!',
        'Account created successfully for $firstName $lastName!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      String errorMessage = 'An error occurred during account creation.';

      if (e.code == 'email-already-in-use') {
        errorMessage = 'This email address is already in use.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is badly formatted.';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'Email/password accounts are not enabled.';
      }

      Get.snackbar(
        'Sign Up Failed',
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
