import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  void _showAgeRangeBottomSheet(BuildContext context) {
    final List<String> ageRanges = [
      'Under 18',
      '18-24',
      '25-34',
      '35-44',
      '45-54',
      '55+'
    ];

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Age Range',
              style: TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: ageRanges.length,
                separatorBuilder: (context, index) => const Divider(color: AppTheme.surfaceColor),
                itemBuilder: (context, index) {
                  final age = ageRanges[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      age,
                      style: const TextStyle(color: AppTheme.textPrimaryColor),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textSecondaryColor),
                    onTap: () {
                      controller.selectAgeRange(age);
                      Get.back();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),

              const Text(
                'Tell us About yourself',
                style: TextStyle(
                  color: AppTheme.textPrimaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),

              const Text(
                'Who do you shop for ?',
                style: TextStyle(
                  color: AppTheme.textPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              Obx(() {
                final isMen = controller.selectedGender.value == 'Men';
                return Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.selectGender('Men'),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: isMen ? AppTheme.primaryColor : AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Men',
                            style: TextStyle(
                              color: isMen ? Colors.white : AppTheme.textPrimaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.selectGender('Women'),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: !isMen ? AppTheme.primaryColor : AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Women',
                            style: TextStyle(
                              color: !isMen ? Colors.white : AppTheme.textPrimaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 48),

              const Text(
                'How Old are you ?',
                style: TextStyle(
                  color: AppTheme.textPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: () => _showAgeRangeBottomSheet(context),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 56,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                            controller.selectedAgeRange.value,
                            style: const TextStyle(
                              color: AppTheme.textPrimaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 120),

              Obx(() => GestureDetector(
                onTap: controller.isLoading.value ? null : controller.finishOnboarding,
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
                          'Finish',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              )),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
