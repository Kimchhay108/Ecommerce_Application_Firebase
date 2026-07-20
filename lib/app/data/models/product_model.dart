class ProductModel {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final String? category;
  final String? description;

  const ProductModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    this.category,
    this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : null,
      category: json['category'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'price': price,
      'originalPrice': originalPrice,
      'category': category,
      'description': description,
    };
  }
}
