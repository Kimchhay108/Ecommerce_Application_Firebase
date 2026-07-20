import 'package:get/get.dart';
import '../../../data/models/order_model.dart';

class OrdersController extends GetxController {
  // Available status filters
  final List<String> statusFilters = const [
    'Processing',
    'Shipped',
    'Delivered',
    'Returned',
    'Canceled',
  ];

  // Active filter state
  final RxString activeFilter = 'Processing'.obs;

  // Master list of all orders
  final RxList<OrderModel> allOrders = <OrderModel>[
    // Processing Orders
    const OrderModel(id: '1', code: '#456765', itemCount: 4, status: 'Processing'),
    const OrderModel(id: '2', code: '#454569', itemCount: 2, status: 'Processing'),
    const OrderModel(id: '3', code: '#454809', itemCount: 1, status: 'Processing'),
    
    // Shipped Orders
    const OrderModel(id: '4', code: '#441920', itemCount: 3, status: 'Shipped'),
    const OrderModel(id: '5', code: '#439281', itemCount: 5, status: 'Shipped'),

    // Delivered Orders
    const OrderModel(id: '6', code: '#412982', itemCount: 2, status: 'Delivered'),
    const OrderModel(id: '7', code: '#409281', itemCount: 1, status: 'Delivered'),

    // Returned Orders
    const OrderModel(id: '8', code: '#392812', itemCount: 1, status: 'Returned'),

    // Canceled Orders
    const OrderModel(id: '9', code: '#381283', itemCount: 2, status: 'Canceled'),
  ].obs;

  // Getter to retrieve filtered list of orders
  List<OrderModel> get filteredOrders {
    return allOrders.where((order) => order.status == activeFilter.value).toList();
  }

  // Change active filter tab
  void changeFilter(String filter) {
    activeFilter.value = filter;
  }
}

