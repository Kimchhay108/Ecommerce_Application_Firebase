import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../home/controllers/home_controller.dart';

class CheckoutController extends GetxController {
  final CartController cartController = Get.find<CartController>();
  final HomeController homeController = Get.find<HomeController>();

  // Interactive selectors initialized with default address/payment mockup states
  final RxString shippingAddress = '2715 Ash Dr. San Jose, South Dakota 83475'.obs;
  final RxString paymentMethod = '**** 4187'.obs;

  // Custom text editing controller for custom addresses
  final TextEditingController addressInputController = TextEditingController();

  @override
  void onClose() {
    addressInputController.dispose();
    super.onClose();
  }

  // Retrieve calculated totals from CartController
  double get subtotal => cartController.subtotal;
  double get discount => cartController.discount;
  double get shippingCost => cartController.shippingCost;
  double get tax => cartController.tax;
  double get total => cartController.total;

  bool get isCouponApplied => cartController.isCouponApplied.value;
  String get appliedCouponCode => cartController.appliedCouponCode.value;

  // Select shipping address bottom sheet trigger
  void updateShippingAddress(String address) {
    shippingAddress.value = address;
  }

  // Select payment method bottom sheet trigger
  void updatePaymentMethod(String method) {
    paymentMethod.value = method;
  }

  // Checkout and place order validation
  void placeOrder() {
    if (shippingAddress.value == 'Add Shipping Address') {
      Get.snackbar(
        'Address Required',
        'Please add a shipping address before placing your order.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (paymentMethod.value == 'Add Payment Method') {
      Get.snackbar(
        'Payment Required',
        'Please add a payment method before placing your order.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    // Process order: Clear cart and transition to success screen
    cartController.clearAll();
    Get.toNamed(Routes.ORDER_SUCCESS);
  }
}
