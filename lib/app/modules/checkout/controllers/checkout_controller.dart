import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/order_model.dart';
import '../../../routes/app_pages.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../orders/controllers/orders_controller.dart';

class CheckoutController extends GetxController {
  final CartController cartController = Get.find<CartController>();
  final HomeController homeController = Get.find<HomeController>();

  final RxString shippingAddress = '2715 Ash Dr. San Jose, South Dakota 83475'.obs;
  final RxString paymentMethod = '**** 4187'.obs;

  final TextEditingController addressInputController = TextEditingController();

  @override
  void onClose() {
    addressInputController.dispose();
    super.onClose();
  }

  double get subtotal => cartController.subtotal;
  double get discount => cartController.discount;
  double get shippingCost => cartController.shippingCost;
  double get tax => cartController.tax;
  double get total => cartController.total;

  bool get isCouponApplied => cartController.isCouponApplied.value;
  String get appliedCouponCode => cartController.appliedCouponCode.value;

  void updateShippingAddress(String address) {
    shippingAddress.value = address;
  }

  void updatePaymentMethod(String method) {
    paymentMethod.value = method;
  }

  void placeOrder() {
    if (cartController.cartItems.isEmpty) {
      Get.snackbar(
        'Empty Cart',
        'Your cart is empty. Add items before checking out.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (shippingAddress.value == 'Add Shipping Address') {
      Get.snackbar(
        'Address Required',
        'Please add a shipping address before placing your order.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
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
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    final cartItemsSnapshot = cartController.cartItems
        .map((item) => CartItemModel(
              product: item.product,
              selectedSize: item.selectedSize,
              selectedColor: item.selectedColor,
              quantity: item.quantity,
            ))
        .toList();

    final orderCode = '#${100000 + Random().nextInt(899999)}';

    final newOrder = OrderModel(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      code: orderCode,
      date: DateTime.now(),
      items: cartItemsSnapshot,
      status: 'Processing',
      shippingAddress: shippingAddress.value,
      paymentMethod: paymentMethod.value,
      subtotal: subtotal,
      discount: discount,
      shippingCost: shippingCost,
      tax: tax,
      total: total,
    );

    final OrdersController ordersController = Get.isRegistered<OrdersController>()
        ? Get.find<OrdersController>()
        : Get.put(OrdersController(), permanent: true);
    ordersController.addOrder(newOrder);

    cartController.clearAll();
    homeController.clearCart();

    Get.toNamed(Routes.ORDER_SUCCESS, arguments: newOrder);
  }
}
