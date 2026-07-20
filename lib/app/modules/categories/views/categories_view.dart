import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/app_theme.dart';
import '../../home/controllers/home_controller.dart';

class CategoriesView extends GetView<HomeController> {
  const CategoriesView({super.key});

  // Curated, high-resolution Unsplash images for full category cards
  String _getLargeCategoryImage(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=600&auto=format&fit=crop&q=80';
      case 'jewelery':
        return 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=600&auto=format&fit=crop&q=80';
      case "men's clothing":
        return 'https://images.unsplash.com/photo-1488161628813-04466f872be2?w=600&auto=format&fit=crop&q=80';
      case "women's clothing":
        return 'https://images.unsplash.com/photo-1485462537746-965f33f7f6a7?w=600&auto=format&fit=crop&q=80';
      default:
        return 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=600&auto=format&fit=crop&q=80';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Text(
                'Shop by Category',
                style: TextStyle(
                  color: AppTheme.textPrimaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Categories List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppTheme.primaryColor),
                  );
                }

                if (controller.categories.isEmpty) {
                  return const Center(
                    child: Text(
                      'No categories found',
                      style: TextStyle(color: AppTheme.textSecondaryColor),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.categories.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    final imageUrl = _getLargeCategoryImage(category.title);

                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.SEARCH, arguments: {'category': category.title});
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.surfaceColor,
                        ),
                        child: Stack(
                          children: [
                            // Background Image
                            Image.network(
                              imageUrl,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.image, color: Colors.grey),
                                );
                              },
                            ),
                            
                            // Dark Gradient Overlay for premium text contrast
                            Container(
                              height: 100,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.black87,
                                    Colors.black45,
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            
                            // Category Title
                            Positioned(
                              left: 20,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  category.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),

                            // Small arrow indicator on the right
                            const Positioned(
                              right: 20,
                              top: 0,
                              bottom: 0,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white70,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
