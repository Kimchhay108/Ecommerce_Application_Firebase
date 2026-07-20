class OrderModel {
  final String id;
  final String code;
  final int itemCount;
  final String status; // 'Processing', 'Shipped', 'Delivered', 'Returned', 'Canceled'

  const OrderModel({
    required this.id,
    required this.code,
    required this.itemCount,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      code: json['code'] as String,
      itemCount: json['itemCount'] as int,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'itemCount': itemCount,
      'status': status,
    };
  }
}
