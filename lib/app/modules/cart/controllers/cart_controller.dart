import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';

class CartController extends GetxController {
  // Retrieve HomeController to get cart items
  final HomeController homeController = Get.find<HomeController>();

  // Coupon state
  final TextEditingController couponController = TextEditingController();
  final RxString appliedCouponCode = ''.obs;
  final RxBool isCouponApplied = false.obs;
  final RxString couponError = ''.obs;

  @override
  void onClose() {
    couponController.dispose();
    super.onClose();
  }

  // Get reactive list of cart items
  List<CartItemModel> get cartItems => homeController.cartItems;

  // Subtotal calculation
  double get subtotal {
    return cartItems.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  // Shipping cost: Flat $8.00 if cart is not empty
  double get shippingCost {
    return subtotal > 0 ? 8.00 : 0.00;
  }

  // Tax: Flat 0%
  double get tax => 0.00;

  // Coupon discount calculation
  double get discount {
    if (!isCouponApplied.value) return 0.00;
    
    // Support SALE10 for 10% discount, SALE20 for 20% discount
    if (appliedCouponCode.value.toUpperCase() == 'SALE10') {
      return subtotal * 0.10;
    } else if (appliedCouponCode.value.toUpperCase() == 'SALE20') {
      return subtotal * 0.20;
    }
    return 0.00;
  }

  // Total calculation
  double get total {
    final computed = subtotal - discount + shippingCost + tax;
    return computed < 0 ? 0.00 : computed;
  }

  // Quantity adjusters
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

  // Coupon actions
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

  // Checkout action
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
