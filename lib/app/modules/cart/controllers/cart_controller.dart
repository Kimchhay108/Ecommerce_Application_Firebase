import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';

class CartController extends GetxController {

  final HomeController homeController = Get.find<HomeController>();

  final TextEditingController couponController = TextEditingController();
  final RxString appliedCouponCode = ''.obs;
  final RxBool isCouponApplied = false.obs;
  final RxString couponError = ''.obs;

  @override
  void onClose() {
    couponController.dispose();
    super.onClose();
  }

  List<CartItemModel> get cartItems => homeController.cartItems;

  double get subtotal {
    return cartItems.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  double get shippingCost {
    return subtotal > 0 ? 8.00 : 0.00;
  }

  double get tax => 0.00;

  double get discount {
    if (!isCouponApplied.value) return 0.00;

    if (appliedCouponCode.value.toUpperCase() == 'SALE10') {
      return subtotal * 0.10;
    } else if (appliedCouponCode.value.toUpperCase() == 'SALE20') {
      return subtotal * 0.20;
    }
    return 0.00;
  }

  double get total {
    final computed = subtotal - discount + shippingCost + tax;
    return computed < 0 ? 0.00 : computed;
  }

  void incrementItem(CartItemModel item) {
    item.quantity++;
    homeController.cartItems.refresh();
  }

  void decrementItem(CartItemModel item) {
    if (item.quantity > 1) {
      item.quantity--;
      homeController.cartItems.refresh();
    } else {
      removeItem(item);
    }
  }

  void removeItem(CartItemModel item) {
    homeController.removeFromCart(item);
  }

  void clearAll() {
    homeController.clearCart();
    removeCoupon();
  }

  void applyCoupon() {
    final code = couponController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    if (code == 'SALE10' || code == 'SALE20') {
      appliedCouponCode.value = code;
      isCouponApplied.value = true;
      couponError.value = '';
    } else {
      isCouponApplied.value = false;
      appliedCouponCode.value = '';
      couponError.value = 'Invalid coupon code (Try SALE10)';
    }
  }

  void removeCoupon() {
    isCouponApplied.value = false;
    appliedCouponCode.value = '';
    couponError.value = '';
    couponController.clear();
  }

  void checkout() {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Empty Cart',
        'Please add items to your cart before checking out.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.toNamed(Routes.CHECKOUT);
  }
}
