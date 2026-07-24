import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

/// OOP Contract (Interface) for Product and Category operations
abstract class IProductRepository {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> getProductsByCategory(String categoryId);
  Future<ProductModel?> getProductById(String id);
  Future<ProductModel> createProduct(ProductModel product, {String? categoryId});
  Future<ProductModel> updateProduct(ProductModel product, {String? categoryId});
  Future<void> deleteProduct(String id);
  
  Future<CategoryModel> createCategory(CategoryModel category);
  Future<void> deleteCategory(String id);
}

/// OOP Implementation using Supabase client
class SupabaseProductRepository implements IProductRepository {
  final SupabaseClient _client;

  SupabaseProductRepository(this._client);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final List<dynamic> response = await _client
          .from('categories')
          .select()
          .order('title', ascending: true);
      
      return response.map((data) => CategoryModel(
        id: data['id'].toString(),
        title: data['title'] as String,
        imageUrl: data['image_url'] as String,
      )).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      // Query joining the categories table to retrieve the category title
      final List<dynamic> response = await _client
          .from('products')
          .select('*, categories(title)')
          .order('created_at', ascending: false);

      return response.map((data) {
        final categoryTitle = data['categories'] != null 
            ? data['categories']['title'] as String? 
            : null;
        return ProductModel(
          id: data['id'].toString(),
          title: data['title'] as String,
          imageUrl: data['image_url'] as String,
          price: (data['price'] as num).toDouble(),
          originalPrice: data['original_price'] != null 
              ? (data['original_price'] as num).toDouble() 
              : null,
          category: categoryTitle,
          description: data['description'] as String?,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      final List<dynamic> response = await _client
          .from('products')
          .select('*, categories(title)')
          .eq('category_id', categoryId)
          .order('created_at', ascending: false);

      return response.map((data) {
        final categoryTitle = data['categories'] != null 
            ? data['categories']['title'] as String? 
            : null;
        return ProductModel(
          id: data['id'].toString(),
          title: data['title'] as String,
          imageUrl: data['image_url'] as String,
          price: (data['price'] as num).toDouble(),
          originalPrice: data['original_price'] != null 
              ? (data['original_price'] as num).toDouble() 
              : null,
          category: categoryTitle,
          description: data['description'] as String?,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch products by category: $e');
    }
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    try {
      final data = await _client
          .from('products')
          .select('*, categories(title)')
          .eq('id', id)
          .maybeSingle();

      if (data == null) return null;

      final categoryTitle = data['categories'] != null 
          ? data['categories']['title'] as String? 
          : null;

      return ProductModel(
        id: data['id'].toString(),
        title: data['title'] as String,
        imageUrl: data['image_url'] as String,
        price: (data['price'] as num).toDouble(),
        originalPrice: data['original_price'] != null 
            ? (data['original_price'] as num).toDouble() 
            : null,
        category: categoryTitle,
        description: data['description'] as String?,
      );
    } catch (e) {
      throw Exception('Failed to fetch product by ID: $e');
    }
  }

  @override
  Future<ProductModel> createProduct(ProductModel product, {String? categoryId}) async {
    try {
      final Map<String, dynamic> insertData = {
        'title': product.title,
        'image_url': product.imageUrl,
        'price': product.price,
        'original_price': product.originalPrice,
        'description': product.description,
      };

      if (categoryId != null) {
        insertData['category_id'] = categoryId;
      }

      final dynamic response = await _client
          .from('products')
          .insert(insertData)
          .select('*, categories(title)')
          .single();

      final categoryTitle = response['categories'] != null 
          ? response['categories']['title'] as String? 
          : null;

      return ProductModel(
        id: response['id'].toString(),
        title: response['title'] as String,
        imageUrl: response['image_url'] as String,
        price: (response['price'] as num).toDouble(),
        originalPrice: response['original_price'] != null 
            ? (response['original_price'] as num).toDouble() 
            : null,
        category: categoryTitle,
        description: response['description'] as String?,
      );
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product, {String? categoryId}) async {
    try {
      final Map<String, dynamic> updateData = {
        'title': product.title,
        'image_url': product.imageUrl,
        'price': product.price,
        'original_price': product.originalPrice,
        'description': product.description,
      };

      if (categoryId != null) {
        updateData['category_id'] = categoryId;
      }

      final dynamic response = await _client
          .from('products')
          .update(updateData)
          .eq('id', product.id)
          .select('*, categories(title)')
          .single();

      final categoryTitle = response['categories'] != null 
          ? response['categories']['title'] as String? 
          : null;

      return ProductModel(
        id: response['id'].toString(),
        title: response['title'] as String,
        imageUrl: response['image_url'] as String,
        price: (response['price'] as num).toDouble(),
        originalPrice: response['original_price'] != null 
            ? (response['original_price'] as num).toDouble() 
            : null,
        category: categoryTitle,
        description: response['description'] as String?,
      );
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await _client
          .from('products')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  @override
  Future<CategoryModel> createCategory(CategoryModel category) async {
    try {
      final response = await _client
          .from('categories')
          .insert({
            'title': category.title,
            'image_url': category.imageUrl,
          })
          .select()
          .single();

      return CategoryModel(
        id: response['id'].toString(),
        title: response['title'] as String,
        imageUrl: response['image_url'] as String,
      );
    } catch (e) {
      throw Exception('Failed to create category: $e');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await _client
          .from('categories')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }
}

/// GetX Service wrapper to expose the Repository across the app
class SupabaseProductService extends GetxService {
  static SupabaseProductService get to => Get.find();

  late final IProductRepository repository;

  Future<SupabaseProductService> init() async {
    repository = SupabaseProductRepository(Supabase.instance.client);
    return this;
  }
}
