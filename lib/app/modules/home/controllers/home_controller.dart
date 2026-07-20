import 'package:get/get.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/providers/laravel_api_provider.dart';

class HomeController extends GetxController {
  final LaravelApiProvider _apiProvider = Get.put(LaravelApiProvider());

  // Observables
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<ProductModel> topSelling = <ProductModel>[].obs;
  final RxList<ProductModel> newIn = <ProductModel>[].obs;
  
  final RxBool isLoading = true.obs;
  final RxString selectedGender = 'Men'.obs;
  final RxInt currentIndex = 0.obs;
  final RxList<String> favoritedProductIds = <String>[].obs;
  final RxInt cartItemCount = 0.obs;

  // Reactive Cart items list initialized with the two mock items from Figma design
  final RxList<CartItemModel> cartItems = <CartItemModel>[
    CartItemModel(
      product: const ProductModel(
        id: 'ts_1',
        title: "Men's Harrington Jacket",
        imageUrl: 'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=150',
        price: 148.0,
        category: "Men's Clothing",
      ),
      selectedSize: 'M',
      selectedColor: 'Lemon',
      quantity: 1,
    ),
    CartItemModel(
      product: const ProductModel(
        id: 'ts_2',
        title: "Men's Coaches Jacket",
        imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=150',
        price: 52.0,
        category: "Men's Clothing",
      ),
      selectedSize: 'M',
      selectedColor: 'Black',
      quantity: 1,
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Synchronize cart count badge reactively
    cartItemCount.value = cartItems.fold(0, (sum, item) => sum + item.quantity);
    cartItems.listen((items) {
      cartItemCount.value = items.fold(0, (sum, item) => sum + item.quantity);
    });
    fetchData();
  }

  // Fetch data from provider
  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final fetchedCategories = await _apiProvider.getCategories();
      final fetchedTopSelling = await _apiProvider.getTopSellingProducts();
      final fetchedNewIn = await _apiProvider.getNewInProducts();

      categories.assignAll(fetchedCategories);
      topSelling.assignAll(fetchedTopSelling);
      newIn.assignAll(fetchedNewIn);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle favorite status
  void toggleFavorite(String productId) {
    if (favoritedProductIds.contains(productId)) {
      favoritedProductIds.remove(productId);
    } else {
      favoritedProductIds.add(productId);
    }
  }

  // Toggle/cycle through genders for the header dropdown
  void toggleGender() {
    if (selectedGender.value == 'Men') {
      selectedGender.value = 'Women';
    } else if (selectedGender.value == 'Women') {
      selectedGender.value = 'Kids';
    } else {
      selectedGender.value = 'Men';
    }
  }

  // Handle bottom navigation tab changes
  void changeTab(int index) {
    currentIndex.value = index;
  }

  // Add item to cart
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

  // Remove item from cart
  void removeFromCart(CartItemModel item) {
    cartItems.remove(item);
  }

  // Clear all items from cart
  void clearCart() {
    cartItems.clear();
  }

  // Fallback for simple cart additions
  void incrementCart() {
    addToCart(
      const ProductModel(
        id: 'ts_1',
        title: "Men's Harrington Jacket",
        imageUrl: 'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=150',
        price: 148.0,
      ),
      'M',
      'Lemon',
      1,
    );
    Get.snackbar(
      'Cart Updated',
      'An item has been added to your shopping bag!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }
}

