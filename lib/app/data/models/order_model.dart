import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String code;
  final DateTime date;
  final List<CartItemModel> items;
  final String status;
  final String shippingAddress;
  final String paymentMethod;
  final double subtotal;
  final double discount;
  final double shippingCost;
  final double tax;
  final double total;

  const OrderModel({
    required this.id,
    required this.code,
    required this.date,
    required this.items,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.subtotal,
    required this.discount,
    required this.shippingCost,
    required this.tax,
    required this.total,
  });

  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      code: json['code'] as String,
      date: DateTime.parse(json['date'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
      shippingAddress: json['shippingAddress'] as String? ?? 'N/A',
      paymentMethod: json['paymentMethod'] as String? ?? 'N/A',
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      shippingCost: (json['shippingCost'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'date': date.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'status': status,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'subtotal': subtotal,
      'discount': discount,
      'shippingCost': shippingCost,
      'tax': tax,
      'total': total,
    };
  }
}
