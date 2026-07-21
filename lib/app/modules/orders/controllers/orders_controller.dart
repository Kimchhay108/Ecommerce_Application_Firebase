import 'package:get/get.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/product_model.dart';

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

  // Master reactive list of all orders
  final RxList<OrderModel> allOrders = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialOrders();
  }

  void _loadInitialOrders() {
    if (allOrders.isNotEmpty) return;

    final sampleProduct1 = const ProductModel(
      id: 'p1',
      title: "Men's Fleece Hooded Sweatshirt",
      imageUrl: 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=500',
      price: 100.0,
    );

    final sampleProduct2 = const ProductModel(
      id: 'p2',
      title: 'Fleece Pullover Skate Hoodie',
      imageUrl: 'https://images.unsplash.com/photo-1578587018452-892bacefd3f2?w=500',
      price: 148.0,
    );

    allOrders.assignAll([
      OrderModel(
        id: 'ord_sample_1',
        code: '#456765',
        date: DateTime.now().subtract(const Duration(hours: 3)),
        items: [
          CartItemModel(product: sampleProduct1, selectedSize: 'M', selectedColor: 'Black', quantity: 2),
          CartItemModel(product: sampleProduct2, selectedSize: 'L', selectedColor: 'Grey', quantity: 1),
        ],
        status: 'Processing',
        shippingAddress: '2715 Ash Dr. San Jose, South Dakota 83475',
        paymentMethod: '**** 4187',
        subtotal: 348.0,
        discount: 0.0,
        shippingCost: 8.0,
        tax: 0.0,
        total: 356.0,
      ),
      OrderModel(
        id: 'ord_sample_2',
        code: '#441920',
        date: DateTime.now().subtract(const Duration(days: 2)),
        items: [
          CartItemModel(product: sampleProduct2, selectedSize: 'S', selectedColor: 'Red', quantity: 1),
        ],
        status: 'Shipped',
        shippingAddress: '123 Main St, Springfield, IL 62701',
        paymentMethod: '**** 9821',
        subtotal: 148.0,
        discount: 14.8,
        shippingCost: 8.0,
        tax: 0.0,
        total: 141.2,
      ),
      OrderModel(
        id: 'ord_sample_3',
        code: '#412982',
        date: DateTime.now().subtract(const Duration(days: 5)),
        items: [
          CartItemModel(product: sampleProduct1, selectedSize: 'XL', selectedColor: 'Blue', quantity: 1),
        ],
        status: 'Delivered',
        shippingAddress: '2715 Ash Dr. San Jose, South Dakota 83475',
        paymentMethod: '**** 4187',
        subtotal: 100.0,
        discount: 0.0,
        shippingCost: 8.0,
        tax: 0.0,
        total: 108.0,
      ),
    ]);
  }

  // Add a newly placed order to top of list
  void addOrder(OrderModel order) {
    allOrders.insert(0, order);
    activeFilter.value = order.status; // Switch filter to see newly placed order
  }

  // Getter to retrieve filtered list of orders
  List<OrderModel> get filteredOrders {
    return allOrders.where((order) => order.status == activeFilter.value).toList();
  }

  // Change active filter tab
  void changeFilter(String filter) {
    activeFilter.value = filter;
  }
}
