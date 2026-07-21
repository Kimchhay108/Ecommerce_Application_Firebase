import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  void _showSizeBottomSheet(BuildContext context) {
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
              'Select Size',
              style: TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: controller.sizes.map((size) {
                return Obx(() {
                  final isSelected = controller.selectedSize.value == size;
                  return GestureDetector(
                    onTap: () {
                      controller.selectSize(size);
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        size,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                });
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showColorBottomSheet(BuildContext context) {
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
              'Select Color',
              style: TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: controller.colors.asMap().entries.map((entry) {
                final index = entry.key;
                final colorObj = entry.value;
                return Obx(() {
                  final isSelected = controller.selectedColorIndex.value == index;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: colorObj['color'] as Color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                      ),
                    ),
                    title: Text(
                      colorObj['name'] as String,
                      style: TextStyle(
                        color: AppTheme.textPrimaryColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: AppTheme.primaryColor)
                        : null,
                    onTap: () {
                      controller.selectColor(index);
                      Get.back();
                    },
                  );
                });
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = controller.product;

    final RxInt activeCarouselIndex = 0.obs;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Stack(
              children: [
                SizedBox(
                  height: 440,
                  width: double.infinity,
                  child: PageView.builder(
                    itemCount: 3,
                    onPageChanged: (index) => activeCarouselIndex.value = index,
                    itemBuilder: (context, index) {

                      final displayUrl = index == 0
                          ? product.imageUrl
                          : (product.category?.toLowerCase() == 'electronics'
                              ? 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=600&auto=format&fit=crop'
                              : 'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=600&auto=format&fit=crop');

                      return Image.network(
                        displayUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            alignment: Alignment.center,
                            child: const Icon(Icons.image, size: 64, color: Colors.grey),
                          );
                        },
                      );
                    },
                  ),
                ),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                        GestureDetector(
                          onTap: controller.toggleFavorite,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: AppTheme.surfaceColor,
                              shape: BoxShape.circle,
                            ),
                            child: Obx(() => Icon(
                                  controller.isFavorited.value
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 20,
                                  color: controller.isFavorited.value
                                      ? Colors.redAccent
                                      : AppTheme.textPrimaryColor,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Obx(() {
                        final isSelected = activeCarouselIndex.value == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isSelected ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : AppTheme.textSecondaryColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      });
                    }),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    product.title,
                    style: const TextStyle(
                      color: AppTheme.textPrimaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSelectorCard(
                    label: 'Size',
                    valueWidget: Obx(() => Text(
                          controller.selectedSize.value,
                          style: const TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    onTap: () => _showSizeBottomSheet(context),
                  ),
                  const SizedBox(height: 16),

                  _buildSelectorCard(
                    label: 'Color',
                    valueWidget: Obx(() {
                      final colorObj = controller.colors[controller.selectedColorIndex.value];
                      return Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: colorObj['color'] as Color,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey[400]!, width: 0.5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            colorObj['name'] as String,
                            style: const TextStyle(
                              color: AppTheme.textPrimaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    }),
                    onTap: () => _showColorBottomSheet(context),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Quantity',
                          style: TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: controller.incrementQuantity,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.add, color: Colors.white, size: 16),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Obx(() => Text(
                                  '${controller.quantity.value}',
                                  style: const TextStyle(
                                    color: AppTheme.textPrimaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: controller.decrementQuantity,
                              behavior: HitTestBehavior.opaque,
                              child: Obx(() {
                                final canDecrement = controller.quantity.value > 1;
                                return Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: canDecrement
                                        ? AppTheme.primaryColor
                                        : AppTheme.primaryColor.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.remove, color: Colors.white, size: 16),
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    product.description ?? 'Built for life and made to last, this premium item is crafted with premium fabrics and standard details.',
                    style: const TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: const Text(
                        'Shipping & Returns',
                        style: TextStyle(
                          color: AppTheme.textPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text(
                            'Free standard shipping and free 60-day returns on all items. Orders are processed within 1-2 business days.',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: AppTheme.surfaceColor),
                  const SizedBox(height: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reviews',
                        style: TextStyle(
                          color: AppTheme.textPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          const Text(
                            '4.5 Ratings',
                            style: TextStyle(
                              color: AppTheme.textPrimaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '213 Reviews',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildReviewItem(
                        name: 'Alex Morgan',
                        avatarUrl:
                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
                        rating: 3,
                        text:
                            'Gucci transcribes its heritage, creativity, and innovation into a plenitude of collections. From staple items to distinctive accessories.',
                        date: '12 days ago',
                      ),
                      const SizedBox(height: 20),
                      _buildReviewItem(
                        name: 'Jordan Belfort',
                        avatarUrl:
                            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
                        rating: 5,
                        text:
                            'Excellent product! The material quality is premium, it fits exactly as expected. Highly recommend this brand!',
                        date: '2 weeks ago',
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: controller.addToBag,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                        '\$${(product.price * controller.quantity.value).toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const Text(
                    'Add to Bag',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectorCard({
    required String label,
    required Widget valueWidget,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              children: [
                valueWidget,
                const SizedBox(width: 8),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.textPrimaryColor,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem({
    required String name,
    required String avatarUrl,
    required int rating,
    required String text,
    required String date,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppTheme.textPrimaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    date,
                    style: const TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: index < rating ? AppTheme.primaryColor : Colors.grey[300],
                  size: 14,
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
