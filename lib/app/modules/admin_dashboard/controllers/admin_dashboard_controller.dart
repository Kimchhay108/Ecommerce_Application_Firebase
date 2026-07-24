import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/product_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/order_model.dart';

class AdminDashboardController extends GetxController {
  // Base REST API Configurations
  static const String baseUrl =
      'https://lneyfipmxlphxajwznvo.supabase.co/rest/v1';
  static const String anonKey =
      'sb_publishable_X3LgLoVkiEze75XavDLRaQ_jeHvo-uj';

  final Map<String, String> _headers = {
    'apikey': anonKey,
    'Authorization': 'Bearer $anonKey',
    'Content-Type': 'application/json',
    'Prefer': 'return=representation',
  };

  // State Management
  final RxString currentTab = 'Overview'.obs;
  final RxBool isLoading = false.obs;

  // Database lists
  final RxList<ProductModel> productsList = <ProductModel>[].obs;
  final RxList<CategoryModel> categoriesList = <CategoryModel>[].obs;
  final RxList<OrderModel> ordersList = <OrderModel>[].obs;
  final RxList<Map<String, dynamic>> usersList = <Map<String, dynamic>>[].obs;

  // Selected details
  final Rxn<OrderModel> selectedOrder = Rxn<OrderModel>();

  // Add/Edit Product Form state
  final RxString editingProductId = ''.obs;
  final productTitleController = TextEditingController();
  final productPriceController = TextEditingController();
  final productOriginalPriceController = TextEditingController();
  final productImageController = TextEditingController();
  final productDescController = TextEditingController();
  final RxString selectedCategoryId = ''.obs;

  // Add/Edit Category Form state
  final RxString editingCategoryId = ''.obs;
  final categoryTitleController = TextEditingController();
  final categoryImageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    refreshAllData();
  }

  @override
  void onClose() {
    productTitleController.dispose();
    productPriceController.dispose();
    productOriginalPriceController.dispose();
    productImageController.dispose();
    productDescController.dispose();
    categoryTitleController.dispose();
    categoryImageController.dispose();
    super.onClose();
  }

  // --- Fetch Operations (Read) ---
  Future<void> refreshAllData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        fetchCategories(),
        fetchProducts(),
        fetchOrders(),
        fetchUsers(),
      ]);
    } catch (e) {
      Get.snackbar(
        'Data Sync Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategories() async {
    final url = Uri.parse('$baseUrl/categories?select=*&order=title.asc');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      categoriesList.assignAll(
        data.map((e) => _mapDbToCategoryModel(e)).toList(),
      );
    } else {
      throw Exception('Failed to load categories: ${response.body}');
    }
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse(
      '$baseUrl/products?select=*,categories(id,title)&order=created_at.desc',
    );
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      productsList.assignAll(data.map((e) => _mapDbToProductModel(e)).toList());
    } else {
      throw Exception('Failed to load products: ${response.body}');
    }
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse('$baseUrl/orders?select=*&order=date.desc');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      ordersList.assignAll(data.map((e) => _mapDbToOrderModel(e)).toList());
    } else {
      throw Exception('Failed to load orders: ${response.body}');
    }
  }

  // --- Product CRUD (Create, Update, Delete) ---
  void prepareNewProduct() {
    editingProductId.value = '';
    productTitleController.clear();
    productPriceController.clear();
    productOriginalPriceController.clear();
    productImageController.clear();
    productDescController.clear();
    selectedCategoryId.value =
        categoriesList.isNotEmpty ? categoriesList.first.id : '';
  }

  void prepareEditProduct(ProductModel p) {
    editingProductId.value = p.id;
    productTitleController.text = p.title;
    productPriceController.text = p.price.toString();
    productOriginalPriceController.text = p.originalPrice?.toString() ?? '';
    productImageController.text = p.imageUrl;
    productDescController.text = p.description ?? '';

    // Find category ID matching title
    final match = categoriesList.firstWhere(
      (c) => c.title == p.category,
      orElse: () => const CategoryModel(id: '', title: '', imageUrl: ''),
    );
    selectedCategoryId.value =
        match.id.isNotEmpty
            ? match.id
            : (categoriesList.isNotEmpty ? categoriesList.first.id : '');
  }

  Future<void> saveProduct() async {
    final title = productTitleController.text.trim();
    final price = double.tryParse(productPriceController.text) ?? 0.0;
    final origPriceText = productOriginalPriceController.text.trim();
    final originalPrice =
        origPriceText.isNotEmpty ? double.tryParse(origPriceText) : null;
    final imageUrl = productImageController.text.trim();
    final description = productDescController.text.trim();
    final categoryId = selectedCategoryId.value;

    if (title.isEmpty || price <= 0.0 || imageUrl.isEmpty) {
      Get.snackbar(
        'Input Error',
        'Please complete the product form validations.',
      );
      return;
    }

    final payload = {
      'title': title,
      'price': price,
      'original_price': originalPrice,
      'category_id': categoryId.isNotEmpty ? categoryId : null,
      'image_url': imageUrl,
      'description': description.isNotEmpty ? description : null,
    };

    isLoading.value = true;
    try {
      http.Response response;
      if (editingProductId.value.isNotEmpty) {
        // UPDATE (PATCH)
        final url = Uri.parse(
          '$baseUrl/products?id=eq.${editingProductId.value}',
        );
        response = await http.patch(
          url,
          headers: _headers,
          body: jsonEncode(payload),
        );
      } else {
        // CREATE (POST)
        final url = Uri.parse('$baseUrl/products');
        response = await http.post(
          url,
          headers: _headers,
          body: jsonEncode(payload),
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // close modal dialog
        Get.snackbar('Success', 'Successfully saved product "$title"');
        refreshAllData();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      Get.snackbar('Failure', 'Could not save product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(String id) async {
    isLoading.value = true;
    try {
      final url = Uri.parse('$baseUrl/products?id=eq.$id');
      final response = await http.delete(url, headers: _headers);

      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.snackbar('Product Deleted', 'Record removed successfully.');
        refreshAllData();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      Get.snackbar('Deletion Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // --- Category CRUD (Create, Update, Delete) ---
  void prepareNewCategory() {
    editingCategoryId.value = '';
    categoryTitleController.clear();
    categoryImageController.clear();
  }

  void prepareEditCategory(CategoryModel c) {
    editingCategoryId.value = c.id;
    categoryTitleController.text = c.title;
    categoryImageController.text = c.imageUrl;
  }

  Future<void> saveCategory() async {
    final title = categoryTitleController.text.trim();
    final imageUrl = categoryImageController.text.trim();

    if (title.isEmpty || imageUrl.isEmpty) {
      Get.snackbar(
        'Input Error',
        'Please complete the category validation checks.',
      );
      return;
    }

    final payload = {'title': title, 'image_url': imageUrl};

    isLoading.value = true;
    try {
      http.Response response;
      if (editingCategoryId.value.isNotEmpty) {
        // UPDATE (PATCH)
        final url = Uri.parse(
          '$baseUrl/categories?id=eq.${editingCategoryId.value}',
        );
        response = await http.patch(
          url,
          headers: _headers,
          body: jsonEncode(payload),
        );
      } else {
        // CREATE (POST)
        final url = Uri.parse('$baseUrl/categories');
        response = await http.post(
          url,
          headers: _headers,
          body: jsonEncode(payload),
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // close modal dialog
        Get.snackbar('Success', 'Successfully saved category "$title"');
        refreshAllData();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      Get.snackbar('Failure', 'Could not save category: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory(String id) async {
    isLoading.value = true;
    try {
      final url = Uri.parse('$baseUrl/categories?id=eq.$id');
      final response = await http.delete(url, headers: _headers);

      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.snackbar('Category Deleted', 'The category was deleted.');
        refreshAllData();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      Get.snackbar('Deletion Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // --- Order Status Actions ---
  Future<void> updateOrderStatus(String orderId, String status) async {
    isLoading.value = true;
    try {
      final url = Uri.parse('$baseUrl/orders?id=eq.$orderId');
      final response = await http.patch(
        url,
        headers: _headers,
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.back(); // close order modal
        Get.snackbar('Order Updated', 'Status changed to "$status"');
        refreshAllData();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      Get.snackbar('Update Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // --- Calculations for Overview ---
  double get totalRevenue {
    return ordersList
        .where((o) => o.status != 'Canceled')
        .fold(0.0, (sum, o) => sum + o.total);
  }

  int get ordersCount => ordersList.length;
  int get productsCount => productsList.length;
  int get categoriesCount => categoriesList.length;

  int getStatusCount(String status) {
    return ordersList
        .where((o) => o.status.toLowerCase() == status.toLowerCase())
        .length;
  }

  // --- REST Object Mapping Helpers ---
  CategoryModel _mapDbToCategoryModel(Map<String, dynamic> data) {
    return CategoryModel(
      id: data['id'].toString(),
      title: data['title'] as String,
      imageUrl: data['image_url'] as String? ?? '',
    );
  }

  ProductModel _mapDbToProductModel(Map<String, dynamic> data) {
    final categoryTitle =
        data['categories'] != null
            ? data['categories']['title'] as String?
            : null;
    return ProductModel(
      id: data['id'].toString(),
      title: data['title'] as String,
      imageUrl: data['image_url'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice:
          data['original_price'] != null
              ? (data['original_price'] as num).toDouble()
              : null,
      category: categoryTitle,
      description: data['description'] as String?,
    );
  }

  OrderModel _mapDbToOrderModel(Map<String, dynamic> data) {
    final mappedJson = {
      'id': data['id'].toString(),
      'code': data['code'] as String? ?? '',
      'date': data['date'] as String? ?? DateTime.now().toIso8601String(),
      'items':
          data['items'] is String ? jsonDecode(data['items']) : data['items'],
      'status': data['status'] as String? ?? 'Processing',
      'shippingAddress': data['shipping_address'] ?? 'N/A',
      'paymentMethod': data['payment_method'] ?? 'N/A',
      'subtotal': (data['subtotal'] as num?)?.toDouble() ?? 0.0,
      'discount': (data['discount'] as num?)?.toDouble() ?? 0.0,
      'shippingCost': (data['shipping_cost'] as num?)?.toDouble() ?? 0.0,
      'tax': (data['tax'] as num?)?.toDouble() ?? 0.0,
      'total': (data['total'] as num?)?.toDouble() ?? 0.0,
      'userId': data['user_id'] as String?,
    };
    return OrderModel.fromJson(mappedJson);
  }

  // --- User Management CRUD ---
  Future<void> fetchUsers() async {
    final url = Uri.parse('$baseUrl/users?select=*&order=created_at.desc');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      usersList.assignAll(
        data.map((e) => Map<String, dynamic>.from(e)).toList(),
      );
    } else {
      throw Exception('Failed to load users: ${response.body}');
    }
  }

  Future<void> toggleUserBan(String id, bool isBanned) async {
    isLoading.value = true;
    try {
      final url = Uri.parse('$baseUrl/users?id=eq.$id');
      final response = await http.patch(
        url,
        headers: _headers,
        body: jsonEncode({'is_banned': isBanned}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.snackbar(
          isBanned ? 'User Banned' : 'User Unbanned',
          'Successfully updated the user state.',
          backgroundColor: isBanned ? Colors.orangeAccent : Colors.green,
          colorText: Colors.white,
        );
        refreshAllData();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      Get.snackbar('Action Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUser(String id) async {
    isLoading.value = true;
    try {
      final url = Uri.parse('$baseUrl/users?id=eq.$id');
      final response = await http.delete(url, headers: _headers);

      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.snackbar(
          'User Deleted',
          'Successfully removed the user account.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        refreshAllData();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      Get.snackbar('Deletion Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }


}
