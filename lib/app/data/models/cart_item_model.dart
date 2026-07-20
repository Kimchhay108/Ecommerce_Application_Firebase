import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  final String selectedSize;
  final String selectedColor;
  int quantity;

  CartItemModel({
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
    this.quantity = 1,
  });

  // Serialization helpers
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      selectedSize: json['selectedSize'] as String,
      selectedColor: json['selectedColor'] as String,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
      'quantity': quantity,
    };
  }
}
