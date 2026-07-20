import 'package:get/get.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class LaravelApiProvider extends GetConnect {
  @override
  void onInit() {
    baseUrl = 'https://fakestoreapi.com';
    super.onInit();
  }

  // Capitalize title helper
  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  // Map category strings to rich Unsplash images
  String _getCategoryImage(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=150';
      case 'jewelery':
        return 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=150';
      case "men's clothing":
        return 'https://images.unsplash.com/photo-1488161628813-04466f872be2?w=150';
      case "women's clothing":
        return 'https://images.unsplash.com/photo-1485462537746-965f33f7f6a7?w=150';
      default:
        return 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=150';
    }
  }

  // Fetch Categories from FakeStoreAPI
  Future<List<CategoryModel>> getCategories() async {
    final response = await get('/products/categories');
    if (response.hasError) {
      throw Exception(response.statusText ?? 'Failed to load categories');
    }
    
    final List<dynamic> data = response.body ?? [];
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final categoryName = entry.value as String;
      return CategoryModel(
        id: 'cat_$index',
        title: _capitalize(categoryName),
        imageUrl: _getCategoryImage(categoryName),
      );
    }).toList();
  }

  // Fetch Top Selling products (we will query first 8 items)
  Future<List<ProductModel>> getTopSellingProducts() async {
    final response = await get('/products?limit=8');
    if (response.hasError) {
      throw Exception(response.statusText ?? 'Failed to load top selling products');
    }

    final List<dynamic> data = response.body ?? [];
    return data.map((e) {
      final idInt = e['id'] as int;
      final priceNum = e['price'] as num;
      final price = priceNum.toDouble();
      
      // Mock original price on even IDs to showcase discount tags
      final originalPrice = idInt % 2 == 0 ? price * 1.45 : null;

      return ProductModel(
        id: 'ts_$idInt',
        title: e['title'] as String,
        imageUrl: e['image'] as String,
        price: price,
        originalPrice: originalPrice,
        category: e['category'] as String?,
        description: e['description'] as String?,
      );
    }).toList();
  }

  // Fetch New In products (we will query last 8 items using sort=desc)
  Future<List<ProductModel>> getNewInProducts() async {
    final response = await get('/products?sort=desc&limit=8');
    if (response.hasError) {
      throw Exception(response.statusText ?? 'Failed to load new products');
    }

    final List<dynamic> data = response.body ?? [];
    return data.map((e) {
      final idInt = e['id'] as int;
      final priceNum = e['price'] as num;
      final price = priceNum.toDouble();

      return ProductModel(
        id: 'ni_$idInt',
        title: e['title'] as String,
        imageUrl: e['image'] as String,
        price: price,
        category: e['category'] as String?,
        description: e['description'] as String?,
      );
    }).toList();
  }

  // Fetch all products for search/filter functionality
  Future<List<ProductModel>> getAllProducts() async {
    final response = await get('/products');
    if (response.hasError) {
      throw Exception(response.statusText ?? 'Failed to load products');
    }

    final List<dynamic> data = response.body ?? [];
    return data.map((e) {
      final idInt = e['id'] as int;
      final priceNum = e['price'] as num;
      final price = priceNum.toDouble();

      // Mock original price on even IDs to showcase discount tags
      final originalPrice = idInt % 2 == 0 ? price * 1.45 : null;

      return ProductModel(
        id: 'search_$idInt',
        title: e['title'] as String,
        imageUrl: e['image'] as String,
        price: price,
        originalPrice: originalPrice,
        category: e['category'] as String?,
        description: e['description'] as String?,
      );
    }).toList();
  }
}
