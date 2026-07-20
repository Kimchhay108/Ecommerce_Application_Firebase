import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../routes/app_pages.dart';

class OnboardingController extends GetxController {
  final selectedGender = 'Men'.obs;
  final selectedAgeRange = 'Age Range'.obs;
  final isLoading = false.obs;

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  void selectAgeRange(String ageRange) {
    selectedAgeRange.value = ageRange;
  }

  void finishOnboarding() async {
    if (selectedAgeRange.value == 'Age Range') {
      Get.snackbar(
        'Age Range Required',
        'Please select your age range to complete onboarding.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isLoading.value = true;
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        // Save preferences to Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'gender': selectedGender.value,
          'ageRange': selectedAgeRange.value,
        });
      }

      // Sign out the user so they can log back in
      await FirebaseAuth.instance.signOut();

      isLoading.value = false;
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar(
        'Success',
        'Account & Onboarding completed! Please sign in with your email.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error saving preferences',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }
}
