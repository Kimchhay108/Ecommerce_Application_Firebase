import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  void _showAddressBottomSheet(BuildContext context) {
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Shipping Address',
                style: TextStyle(
                  color: AppTheme.textPrimaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.home_outlined, color: AppTheme.primaryColor),
                title: const Text('Default Address'),
                subtitle: const Text('2715 Ash Dr. San Jose, South Dakota 83475'),
                onTap: () {
                  controller.updateShippingAddress('2715 Ash Dr. San Jose, South Dakota 83475');
                  Get.back();
                },
              ),
              const Divider(color: AppTheme.surfaceColor),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.business_outlined, color: AppTheme.primaryColor),
                title: const Text('Office Address'),
                subtitle: const Text('456 Broadway, Los Angeles, CA 90001'),
                onTap: () {
                  controller.updateShippingAddress('456 Broadway, Los Angeles, CA 90001');
                  Get.back();
                },
              ),
              const Divider(color: AppTheme.surfaceColor),
              const SizedBox(height: 12),
              const Text(
                'Custom Address',
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: controller.addressInputController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Enter your custom delivery address...',
                    hintStyle: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 13),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: AppTheme.textPrimaryColor, fontSize: 13),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final text = controller.addressInputController.text.trim();
                    if (text.isNotEmpty) {
                      controller.updateShippingAddress(text);
                    }
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Save custom address', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentBottomSheet(BuildContext context) {
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
              'Select Payment Method',
              style: TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.credit_card_outlined, color: AppTheme.primaryColor),
              title: const Text('Mastercard ending in 4187'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textSecondaryColor),
              onTap: () {
                controller.updatePaymentMethod('**** 4187');
                Get.back();
              },
            ),
            const Divider(color: AppTheme.surfaceColor),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.payment_outlined, color: AppTheme.primaryColor),
              title: const Text('PayPal'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textSecondaryColor),
              onTap: () {
                controller.updatePaymentMethod('PayPal (paypal@example.com)');
                Get.back();
              },
            ),
            const Divider(color: AppTheme.surfaceColor),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.monetization_on_outlined, color: AppTheme.primaryColor),
              title: const Text('Cash on Delivery (COD)'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textSecondaryColor),
              onTap: () {
                controller.updatePaymentMethod('Cash on Delivery');
                Get.back();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMastercardLogo() {
    return SizedBox(
      width: 28,
      height: 16,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: Color(0xFFFA3636),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            left: 10,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Color(0xFFF4BD2F),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Checkout',
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [

                    GestureDetector(
                      onTap: () => _showAddressBottomSheet(context),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Shipping Address',
                                    style: TextStyle(
                                      color: AppTheme.textSecondaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Obx(() => Text(
                                        controller.shippingAddress.value,
                                        style: const TextStyle(
                                          color: AppTheme.textPrimaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppTheme.textSecondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () => _showPaymentBottomSheet(context),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Payment Method',
                                    style: TextStyle(
                                      color: AppTheme.textSecondaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Obx(() {
                                    final method = controller.paymentMethod.value;
                                    final isMastercard = method.contains('4187');
                                    return Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          method,
                                          style: const TextStyle(
                                            color: AppTheme.textPrimaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (isMastercard) ...[
                                          const SizedBox(width: 8),
                                          _buildMastercardLogo(),
                                        ],
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppTheme.textSecondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    Column(
                      children: [
                        _buildPriceRow('Subtotal', '\$${controller.subtotal.toStringAsFixed(2)}'),
                        const SizedBox(height: 12),
                        if (controller.isCouponApplied) ...[
                          _buildPriceRow(
                              'Discount (${controller.appliedCouponCode})',
                              '-\$${controller.discount.toStringAsFixed(2)}',
                              isHighlight: true),
                          const SizedBox(height: 12),
                        ],
                        _buildPriceRow('Shipping Cost', '\$${controller.shippingCost.toStringAsFixed(2)}'),
                        const SizedBox(height: 12),
                        _buildPriceRow('Tax', '\$${controller.tax.toStringAsFixed(2)}'),
                        const SizedBox(height: 12),
                        _buildPriceRow('Total', '\$${controller.total.toStringAsFixed(2)}', isBold: true),
                      ],
                    ),
                  ],
                ),
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
            onTap: controller.placeOrder,
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
                  Text(
                    '\$${controller.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Place Order',
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
