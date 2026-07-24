import 'package:get/get.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/services/supabase_product_service.dart';
import '../../../data/services/auth_service.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  final IProductRepository _productRepository = SupabaseProductService.to.repository;

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<ProductModel> topSelling = <ProductModel>[].obs;
  final RxList<ProductModel> newIn = <ProductModel>[].obs;

  final RxBool isLoading = true.obs;
  final RxString selectedGender = 'Men'.obs;
  final RxInt currentIndex = 0.obs;
  final RxList<String> favoritedProductIds = <String>[].obs;
  final RxInt cartItemCount = 0.obs;

  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _checkUserBanStatus();

    cartItemCount.value = cartItems.fold(0, (sum, item) => sum + item.quantity);
    cartItems.listen((items) {
      cartItemCount.value = items.fold(0, (sum, item) => sum + item.quantity);
    });
    fetchData();
  }

  Future<void> _checkUserBanStatus() async {
    final user = AuthService.to.currentUser;
    if (user != null) {
      final isBanned = await AuthService.to.checkIfBanned(user.uid);
      if (isBanned) {
        await AuthService.to.signOut();
        Get.offAllNamed('/login');
        Get.dialog(
          AlertDialog(
            title: const Text('Account Banned', style: TextStyle(fontWeight: FontWeight.bold)),
            content: const Text('Your account has been banned by the administrator.'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('OK'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      }
    }
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final fetchedCategories = await _productRepository.getCategories();
      final fetchedProducts = await _productRepository.getProducts();

      if (fetchedCategories.isNotEmpty) categories.assignAll(fetchedCategories);
      if (fetchedProducts.isNotEmpty) {
        newIn.assignAll(fetchedProducts.take(8).toList());
        topSelling.assignAll(fetchedProducts.take(8).toList());
      }
    } catch (_) {
      _loadFallbackData();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadFallbackData() {
    if (categories.isEmpty) {
      categories.assignAll(const [
        CategoryModel(id: 'c1', title: 'Hoodies', imageUrl: 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=150'),
        CategoryModel(id: 'c2', title: 'Jackets', imageUrl: 'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=150'),
        CategoryModel(id: 'c3', title: 'Shoes', imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=150'),
        CategoryModel(id: 'c4', title: 'Accessories', imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=150'),
      ]);
    }

    if (topSelling.isEmpty) {
      topSelling.assignAll(const [
        ProductModel(
          id: 'ts_1',
          title: "Men's Harrington Jacket",
          imageUrl: 'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=300',
          price: 148.0,
          originalPrice: 198.0,
          category: "Men's Clothing",
        ),
        ProductModel(
          id: 'ts_2',
          title: "Men's Coaches Jacket",
          imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=300',
          price: 52.0,
          category: "Men's Clothing",
        ),
      ]);
    }

    if (newIn.isEmpty) {
      newIn.assignAll(const [
        ProductModel(
          id: 'ni_1',
          title: "Max90 Unisex T-Shirt",
          imageUrl: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=300',
          price: 35.0,
          category: "Men's Clothing",
        ),
        ProductModel(
          id: 'ni_2',
          title: "Fleece Pullover Hoodie",
          imageUrl: 'https://images.unsplash.com/photo-1578587018452-892bacefd3f2?w=300',
          price: 78.0,
          category: "Men's Clothing",
        ),
      ]);
    }
  }

  void toggleFavorite(String productId) {
    if (favoritedProductIds.contains(productId)) {
      favoritedProductIds.remove(productId);
    } else {
      favoritedProductIds.add(productId);
    }
  }

  void toggleGender() {
    if (selectedGender.value == 'Men') {
      selectedGender.value = 'Women';
    } else if (selectedGender.value == 'Women') {
      selectedGender.value = 'Kids';
    } else {
      selectedGender.value = 'Men';
    }
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void addToCart(ProductModel product, String size, String color, int qty) {
    final existingIndex = cartItems.indexWhere((item) =>
        item.product.id == product.id &&
        item.selectedSize == size &&
        item.selectedColor == color);

    if (existingIndex != -1) {
      cartItems[existingIndex].quantity += qty;
      cartItems.refresh();
    } else {
      cartItems.add(CartItemModel(
        product: product,
        selectedSize: size,
        selectedColor: color,
        quantity: qty,
      ));
    }
  }

  void removeFromCart(CartItemModel item) {
    cartItems.remove(item);
  }

  void clearCart() {
    cartItems.clear();
    cartItemCount.value = 0;
  }
}
