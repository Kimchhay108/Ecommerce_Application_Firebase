import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../../data/models/order_model.dart';

class OrdersController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authSubscription;

  final List<String> statusFilters = const [
    'Processing',
    'Shipped',
    'Delivered',
    'Returned',
    'Canceled',
  ];

  final RxString activeFilter = 'Processing'.obs;
  final RxList<OrderModel> allOrders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to authentication state changes to fetch user-specific orders
    _authSubscription = _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        fetchUserOrders(user.uid);
      } else {
        allOrders.clear();
      }
    });
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }

  Future<void> fetchUserOrders(String uid) async {
    isLoading.value = true;
    try {
      final List<dynamic> response = await sb.Supabase.instance.client
          .from('orders')
          .select()
          .eq('user_id', uid)
          .order('date', ascending: false);

      final list = response.map((data) {
        final mappedJson = {
          'id': data['id'].toString(),
          'code': data['code'],
          'date': data['date'],
          'items': data['items'],
          'status': data['status'],
          'shippingAddress': data['shipping_address'] ?? 'N/A',
          'paymentMethod': data['payment_method'] ?? 'N/A',
          'subtotal': (data['subtotal'] as num).toDouble(),
          'discount': (data['discount'] as num).toDouble(),
          'shippingCost': (data['shipping_cost'] as num).toDouble(),
          'tax': (data['tax'] as num).toDouble(),
          'total': (data['total'] as num).toDouble(),
        };
        return OrderModel.fromJson(mappedJson);
      }).toList();

      allOrders.assignAll(list);
    } catch (e) {
      print('Error fetching orders from Supabase: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addOrder(OrderModel order) async {
    // Add locally to update UI immediately
    allOrders.insert(0, order);
    activeFilter.value = order.status;

    // Save to Supabase
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final orderJson = order.toJson();

        // Self-heal: ensure user row exists in Supabase to prevent foreign key violations
        final userDoc = await sb.Supabase.instance.client
            .from('users')
            .select()
            .eq('id', user.uid)
            .maybeSingle();

        if (userDoc == null) {
          await sb.Supabase.instance.client.from('users').insert({
            'id': user.uid,
            'first_name': user.displayName ?? '',
            'last_name': '',
            'email': user.email ?? '',
            'avatar_url': user.photoURL ?? '',
            'gender': '',
            'age_range': '',
          });
        }

        await sb.Supabase.instance.client.from('orders').insert({
          'user_id': user.uid,
          'code': order.code,
          'date': order.date.toIso8601String(),
          'items': orderJson['items'],
          'status': order.status,
          'shipping_address': order.shippingAddress,
          'payment_method': order.paymentMethod,
          'subtotal': order.subtotal,
          'discount': order.discount,
          'shipping_cost': order.shippingCost,
          'tax': order.tax,
          'total': order.total,
        });
      } catch (e) {
        print('Error saving order to Supabase: $e');
      }
    }
  }

  List<OrderModel> get filteredOrders {
    return allOrders.where((order) => order.status == activeFilter.value).toList();
  }

  void changeFilter(String filter) {
    activeFilter.value = filter;
  }
}
