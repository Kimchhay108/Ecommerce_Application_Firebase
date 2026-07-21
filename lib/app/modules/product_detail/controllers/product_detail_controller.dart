import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../home/controllers/home_controller.dart';

class ProductDetailController extends GetxController {
  late final ProductModel product;

  HomeController? get _homeController {
    try {
      return Get.find<HomeController>();
    } catch (_) {
      return null;
    }
  }

  final RxString selectedSize = 'S'.obs;
  final RxInt selectedColorIndex = 0.obs;
  final RxInt quantity = 1.obs;
  final RxBool isFavorited = false.obs;

  final List<String> sizes = const ['S', 'M', 'L', 'XL', 'XXL'];

  final List<Map<String, dynamic>> colors = const [
    {'name': 'Olive Green', 'color': Color(0xFF9E9E7C)},
    {'name': 'Navy Blue', 'color': Color(0xFF1E2A38)},
    {'name': 'Black', 'color': Color(0xFF272727)},
    {'name': 'Heather Gray', 'color': Color(0xFFB0B0B0)},
  ];

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is ProductModel) {
      product = Get.arguments as ProductModel;
    } else {

      product = const ProductModel(
        id: 'mock_1',
        title: 'Mock Jacket',
        imageUrl: 'https://placehold.co/161x220',
        price: 99.99,
        description: 'Built for life and made to last, this premium item is a perfect match.',
      );
    }

    if (_homeController != null) {
      isFavorited.value = _homeController!.favoritedProductIds.contains(product.id);
    }
  }

  void toggleFavorite() {
    if (_homeController != null) {
      _homeController!.toggleFavorite(product.id);
      isFavorited.toggle();
    }
  }

  void selectSize(String size) {
    selectedSize.value = size;
  }

  void selectColor(int index) {
    selectedColorIndex.value = index;
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void addToBag() {
    if (_homeController != null) {
      _homeController!.addToCart(
        product,
        selectedSize.value,
        colors[selectedColorIndex.value]['name'] as String,
        quantity.value,
      );

      Get.snackbar(
        'Added to Bag',
        '${quantity.value}x ${product.title} (${selectedSize.value}) has been added to your shopping bag!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white.withOpacity(0.9),
        colorText: const Color(0xFF272727),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    }
  }
}
