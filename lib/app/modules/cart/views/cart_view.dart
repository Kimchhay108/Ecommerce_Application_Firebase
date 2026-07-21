import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

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
                  const Text(
                    'Cart',
                    style: TextStyle(
                      color: AppTheme.textPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.cartItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_bag_outlined,
                          size: 64,
                          color: AppTheme.textSecondaryColor,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Your Cart is Empty',
                          style: TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Browse products and add them to your shopping bag!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => Get.back(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Go Shopping'),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: controller.clearAll,
                            behavior: HitTestBehavior.opaque,
                            child: const Text(
                              'Remove All',
                              style: TextStyle(
                                color: AppTheme.textPrimaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        itemCount: controller.cartItems.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = controller.cartItems[index];

                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [

                                Container(
                                  width: 64,
                                  height: 64,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Image.network(
                                    item.product.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.image, color: Colors.grey),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.product.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: AppTheme.textPrimaryColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '\$${item.product.price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              color: AppTheme.textPrimaryColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Row(
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: 'Size',
                                                      style: TextStyle(
                                                          color: AppTheme.textSecondaryColor,
                                                          fontSize: 12),
                                                    ),
                                                    const TextSpan(
                                                      text: ' - ',
                                                      style: TextStyle(
                                                          color: AppTheme.textPrimaryColor,
                                                          fontSize: 12),
                                                    ),
                                                    TextSpan(
                                                      text: item.selectedSize,
                                                      style: const TextStyle(
                                                          color: AppTheme.textPrimaryColor,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: 'Color',
                                                      style: TextStyle(
                                                          color: AppTheme.textSecondaryColor,
                                                          fontSize: 12),
                                                    ),
                                                    const TextSpan(
                                                      text: ' - ',
                                                      style: TextStyle(
                                                          color: AppTheme.textPrimaryColor,
                                                          fontSize: 12),
                                                    ),
                                                    TextSpan(
                                                      text: item.selectedColor,
                                                      style: const TextStyle(
                                                          color: AppTheme.textPrimaryColor,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () => controller.decrementItem(item),
                                                behavior: HitTestBehavior.opaque,
                                                child: Container(
                                                  width: 24,
                                                  height: 24,
                                                  decoration: const BoxDecoration(
                                                    color: AppTheme.primaryColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(Icons.remove,
                                                      color: Colors.white, size: 12),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${item.quantity}',
                                                style: const TextStyle(
                                                  color: AppTheme.textPrimaryColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              GestureDetector(
                                                onTap: () => controller.incrementItem(item),
                                                behavior: HitTestBehavior.opaque,
                                                child: Container(
                                                  width: 24,
                                                  height: 24,
                                                  decoration: const BoxDecoration(
                                                    color: AppTheme.primaryColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(Icons.add,
                                                      color: Colors.white, size: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.local_offer_outlined,
                                color: AppTheme.textSecondaryColor,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: controller.isCouponApplied.value,
                                  child: TextField(
                                    controller: controller.couponController,
                                    decoration: InputDecoration(
                                      hintText: controller.isCouponApplied.value
                                          ? 'Coupon applied: ${controller.appliedCouponCode.value}'
                                          : 'Enter Coupon Code (Try SALE10)',
                                      hintStyle: const TextStyle(
                                        color: AppTheme.textSecondaryColor,
                                        fontSize: 13,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(
                                      color: AppTheme.textPrimaryColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: controller.isCouponApplied.value
                                    ? controller.removeCoupon
                                    : controller.applyCoupon,
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    controller.isCouponApplied.value ? Icons.close : Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Obx(() => controller.couponError.value.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  controller.couponError.value,
                                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                                ),
                              ),
                            )
                          : const SizedBox.shrink()),
                      const SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            _buildPriceRow('Subtotal', '\$${controller.subtotal.toStringAsFixed(2)}'),
                            const SizedBox(height: 12),
                            if (controller.isCouponApplied.value) ...[
                              _buildPriceRow(
                                  'Discount (${controller.appliedCouponCode.value})',
                                  '-\$${controller.discount.toStringAsFixed(2)}',
                                  isHighlight: true),
                              const SizedBox(height: 12),
                            ],
                            _buildPriceRow('Shipping Cost', '\$${controller.shippingCost.toStringAsFixed(2)}'),
                            const SizedBox(height: 12),
                            _buildPriceRow('Tax', '\$${controller.tax.toStringAsFixed(2)}'),
                            const SizedBox(height: 12),
                            _buildPriceRow('Total', '\$${controller.total.toStringAsFixed(2)}',
                                isBold: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => controller.cartItems.isEmpty
          ? const SizedBox.shrink()
          : Container(
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
                  onTap: controller.checkout,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Checkout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false, bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isHighlight ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isHighlight ? AppTheme.primaryColor : AppTheme.textPrimaryColor,
            fontSize: 16,
            fontWeight: isBold || isHighlight ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
