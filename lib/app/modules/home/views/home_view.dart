import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/bottom_nav_bar.dart';
import '../../../../widgets/category_item.dart';
import '../../../../widgets/custom_search_bar.dart';
import '../../../../widgets/home_header.dart';
import '../../../../widgets/product_card.dart';
import '../../../../widgets/section_header.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../../orders/views/orders_view.dart';
import '../../settings/views/settings_view.dart';
import '../../categories/views/categories_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          switch (controller.currentIndex.value) {
            case 0:
              return _buildHomeContent();
            case 1:
              return const CategoriesView();
            case 2:
              return const OrdersView();
            case 3:
              return const SettingsView();
            default:
              return _buildTabPlaceholder(controller.currentIndex.value);
          }
        }),
      ),
      bottomNavigationBar: Obx(() => BottomNavBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
          )),
    );
  }

  Widget _buildHomeContent() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchData,
        color: AppTheme.primaryColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Obx(() => HomeHeader(
                    profileImageUrl:
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
                    notificationCount: 4,
                    cartCount: controller.cartItemCount.value,
                    onNotificationTap: () => Get.toNamed(Routes.NOTIFICATIONS),
                    onCartTap: () => Get.toNamed(Routes.CART),
                  )),
              const SizedBox(height: 24),

              CustomSearchBar(
                hintText: 'Search',
                readOnly: true,
                onTap: () => Get.toNamed(Routes.SEARCH),
              ),
              const SizedBox(height: 24),

              const SectionHeader(title: 'Categories'),
              const SizedBox(height: 16),
              SizedBox(
                height: 85,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final item = controller.categories[index];
                    return CategoryItem(
                      title: item.title,
                      imageUrl: item.imageUrl,
                      onTap: () => Get.toNamed(Routes.SEARCH, arguments: {'category': item.title}),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              const SectionHeader(title: 'Top Selling'),
              const SizedBox(height: 16),
              SizedBox(
                height: 285,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.topSelling.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final product = controller.topSelling[index];
                    return Obx(() {
                      final isFav = controller.favoritedProductIds.contains(product.id);
                      return ProductCard(
                        title: product.title,
                        imageUrl: product.imageUrl,
                        price: product.price,
                        originalPrice: product.originalPrice,
                        isFavorited: isFav,
                        onFavoriteTap: () => controller.toggleFavorite(product.id),
                        onTap: () => Get.toNamed(Routes.PRODUCT_DETAIL, arguments: product),
                      );
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              const SectionHeader(title: 'New In'),
              const SizedBox(height: 16),
              SizedBox(
                height: 285,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.newIn.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final product = controller.newIn[index];
                    return Obx(() {
                      final isFav = controller.favoritedProductIds.contains(product.id);
                      return ProductCard(
                        title: product.title,
                        imageUrl: product.imageUrl,
                        price: product.price,
                        originalPrice: product.originalPrice,
                        isFavorited: isFav,
                        onFavoriteTap: () => controller.toggleFavorite(product.id),
                        onTap: () => Get.toNamed(Routes.PRODUCT_DETAIL, arguments: product),
                      );
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTabPlaceholder(int index) {
    String tabTitle;
    IconData tabIcon;

    switch (index) {
      case 1:
        tabTitle = 'Explore Categories';
        tabIcon = Icons.category_outlined;
        break;
      case 2:
        tabTitle = 'Track Orders';
        tabIcon = Icons.local_shipping_outlined;
        break;
      case 3:
        tabTitle = 'Profile & Settings';
        tabIcon = Icons.person_outline;
        break;
      default:
        tabTitle = 'Page';
        tabIcon = Icons.error_outline;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(tabIcon, size: 64, color: AppTheme.textSecondaryColor),
          const SizedBox(height: 16),
          Text(
            tabTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This is a placeholder for tab index $index',
            style: const TextStyle(color: AppTheme.textSecondaryColor),
          ),
        ],
      ),
    );
  }
}

