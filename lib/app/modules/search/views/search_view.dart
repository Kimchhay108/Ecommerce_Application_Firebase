import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/product_card.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/search_controller.dart' as app_search;

class SearchView extends GetView<app_search.SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 8),
              child: Row(
                children: [
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            size: 18,
                            color: AppTheme.textPrimaryColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: controller.searchTextController,
                              onChanged: controller.setSearchQuery,
                              textInputAction: TextInputAction.search,
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: 'Search products...',
                                hintStyle: TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: const TextStyle(
                                color: AppTheme.textPrimaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Obx(() => controller.searchQuery.value.isNotEmpty
                              ? GestureDetector(
                                  onTap: controller.clearSearch,
                                  behavior: HitTestBehavior.opaque,
                                  child: const Icon(
                                    Icons.close,
                                    size: 18,
                                    color: AppTheme.textPrimaryColor,
                                  ),
                                )
                              : const SizedBox.shrink()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                height: 36,
                child: Obx(() {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [

                      _buildActiveFiltersChip(),

                      _buildOnSaleChip(),

                      _buildSortChip(context),

                      ...controller.categories.where((cat) => cat != 'All').map((cat) {
                        final isSelected = controller.selectedCategory.value.toLowerCase() == cat.toLowerCase();
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: GestureDetector(
                            onTap: () => controller.toggleCategory(cat),
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: ShapeDecoration(
                                color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    cat,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (isSelected) ...[
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.close,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                }),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                        '${controller.filteredProducts.length} Results Found',
                        style: const TextStyle(
                          color: AppTheme.textPrimaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Obx(() => controller.activeFiltersCount > 0
                      ? GestureDetector(
                          onTap: controller.resetFilters,
                          behavior: HitTestBehavior.opaque,
                          child: const Text(
                            'Clear All',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : const SizedBox.shrink()),
                ],
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            controller.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: controller.fetchProducts,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (controller.filteredProducts.isEmpty) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: 400,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off_outlined,
                            size: 64,
                            color: AppTheme.textSecondaryColor,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No Results Found',
                            style: TextStyle(
                              color: AppTheme.textPrimaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'We couldn\'t find any matching products. Try checking your spelling or adjusting filters.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchProducts,
                  color: AppTheme.primaryColor,
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.56,
                    ),
                    itemCount: controller.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = controller.filteredProducts[index];
                      return Obx(() {
                        final isFav = controller.isFavorited(product.id);
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
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFiltersChip() {
    final count = controller.activeFiltersCount;
    if (count == 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: ShapeDecoration(
        color: AppTheme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.tune,
            size: 14,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnSaleChip() {
    final isOn = controller.filterOnSale.value;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: controller.toggleOnSale,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: ShapeDecoration(
            color: isOn ? AppTheme.primaryColor : AppTheme.surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: Text(
            'On Sale',
            style: TextStyle(
              color: isOn ? Colors.white : AppTheme.textPrimaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSortChip(BuildContext context) {
    final sort = controller.selectedSort.value;
    final isSorted = sort != 'Sort by';

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: PopupMenuButton<String>(
        initialValue: sort,
        onSelected: controller.selectSort,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'Sort by',
            child: Text('Default Sort', style: TextStyle(color: AppTheme.textPrimaryColor)),
          ),
          const PopupMenuItem(
            value: 'Price: Low to High',
            child: Text('Price: Low to High', style: TextStyle(color: AppTheme.textPrimaryColor)),
          ),
          const PopupMenuItem(
            value: 'Price: High to Low',
            child: Text('Price: High to Low', style: TextStyle(color: AppTheme.textPrimaryColor)),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: ShapeDecoration(
            color: isSorted ? AppTheme.primaryColor : AppTheme.surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                sort,
                style: TextStyle(
                  color: isSorted ? Colors.white : AppTheme.textPrimaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 14,
                color: isSorted ? Colors.white : AppTheme.textPrimaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
