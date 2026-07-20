import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/providers/laravel_api_provider.dart';
import '../../home/controllers/home_controller.dart';

class SearchController extends GetxController {
  final LaravelApiProvider _apiProvider = Get.find<LaravelApiProvider>();
  
  HomeController? get _homeController {
    try {
      return Get.find<HomeController>();
    } catch (_) {
      return null;
    }
  }

  final RxList<ProductModel> allProducts = <ProductModel>[].obs;
  final RxList<ProductModel> filteredProducts = <ProductModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  // Active filters and query
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxBool filterOnSale = false.obs;
  final RxString selectedSort = 'Sort by'.obs; // 'Sort by', 'Price: Low to High', 'Price: High to Low'

  // Categories list mapping exactly to FakeStoreAPI categories plus a custom "Men" filter
  final RxList<String> categories = <String>['All', "Men's Clothing", "Women's Clothing", 'Electronics', 'Jewelery'].obs;

  final TextEditingController searchTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Read category or query from arguments if passed
    if (Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args['category'] != null) {
        selectedCategory.value = args['category'] as String;
      }
      if (args['query'] != null) {
        searchQuery.value = args['query'] as String;
        searchTextController.text = searchQuery.value;
      }
    }

    // Debounce search query changes to prevent excessive filtering UI lag
    debounce(searchQuery, (_) => applyFilters(), time: const Duration(milliseconds: 300));
    
    // Apply filters immediately when other criteria change
    ever(selectedCategory, (_) => applyFilters());
    ever(filterOnSale, (_) => applyFilters());
    ever(selectedSort, (_) => applyFilters());

    fetchProducts();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedProducts = await _apiProvider.getAllProducts();
      allProducts.assignAll(fetchedProducts);
      applyFilters();
    } catch (e) {
      errorMessage.value = 'Failed to load products: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Count active filters to display in the filter chip
  int get activeFiltersCount {
    int count = 0;
    if (selectedCategory.value != 'All') count++;
    if (filterOnSale.value) count++;
    if (selectedSort.value != 'Sort by') count++;
    return count;
  }

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
    applyFilters();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void toggleCategory(String category) {
    if (selectedCategory.value == category) {
      selectedCategory.value = 'All';
    } else {
      selectedCategory.value = category;
    }
  }

  void toggleOnSale() {
    filterOnSale.toggle();
  }

  void selectSort(String sortOption) {
    selectedSort.value = sortOption;
  }

  void resetFilters() {
    selectedCategory.value = 'All';
    filterOnSale.value = false;
    selectedSort.value = 'Sort by';
  }

  void applyFilters() {
    List<ProductModel> results = List.from(allProducts);

    // 1. Text Search Filter
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      results = results.where((product) {
        return product.title.toLowerCase().contains(query);
      }).toList();
    }

    // 2. Category Filter
    final category = selectedCategory.value;
    if (category != 'All') {
      results = results.where((product) {
        return product.category?.toLowerCase() == category.toLowerCase();
      }).toList();
    }

    // 3. On Sale Filter (items with originalPrice represent items on sale)
    if (filterOnSale.value) {
      results = results.where((product) {
        return product.originalPrice != null;
      }).toList();
    }

    // 4. Sorting
    if (selectedSort.value == 'Price: Low to High') {
      results.sort((a, b) => a.price.compareTo(b.price));
    } else if (selectedSort.value == 'Price: High to Low') {
      results.sort((a, b) => b.price.compareTo(a.price));
    }

    filteredProducts.assignAll(results);
  }

  // Sync Favorites with HomeController
  bool isFavorited(String productId) {
    return _homeController?.favoritedProductIds.contains(productId) ?? false;
  }

  void toggleFavorite(String productId) {
    _homeController?.toggleFavorite(productId);
    filteredProducts.refresh(); // refresh list to show updated favorite icon
  }

  // Sync Cart
  void addToCart(ProductModel product) {
    _homeController?.incrementCart();
  }
}
