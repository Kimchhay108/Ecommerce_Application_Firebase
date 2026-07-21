import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/models/order_model.dart';
import '../../../theme/app_theme.dart';
import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject or find the OrdersController
    final controller = Get.isRegistered<OrdersController>()
        ? Get.find<OrdersController>()
        : Get.put(OrdersController(), permanent: true);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Centered Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Center(
                child: Text(
                  'Orders',
                  style: TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            // Horizontal Filter Tabs
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.statusFilters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = controller.statusFilters[index];
                  return Obx(() {
                    final isSelected = controller.activeFilter.value == filter;
                    final count = controller.allOrders
                        .where((o) => o.status == filter)
                        .length;

                    return GestureDetector(
                      onTap: () => controller.changeFilter(filter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Text(
                              filter,
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (count > 0) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white.withOpacity(0.25)
                                      : AppTheme.textSecondaryColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$count',
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // Orders List
            Expanded(
              child: Obx(() {
                final orders = controller.filteredOrders;

                if (orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.receipt_long_outlined,
                            size: 40,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No orders in ${controller.activeFilter.value}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'When you place orders, they will appear here.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  physics: const BouncingScrollPhysics(),
                  itemCount: orders.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 0, height: 16),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _buildOrderCard(context, order);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showReceiptBottomSheet(context, order),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Code + Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.receipt_outlined,
                            size: 20,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order ${order.code}',
                              style: const TextStyle(
                                color: AppTheme.textPrimaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatDate(order.date),
                              style: const TextStyle(
                                color: AppTheme.textSecondaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    _buildStatusBadge(order.status),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(height: 1, color: Color(0xFFE5E5E5)),
                ),

                // Item Thumbnails Row
                if (order.items.isNotEmpty) ...[
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: order.items.length,
                      separatorBuilder: (context, i) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final item = order.items[i];
                        return Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200,
                            image: item.product.imageUrl.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(item.product.imageUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: item.product.imageUrl.isEmpty
                              ? const Icon(Icons.shopping_bag_outlined, size: 24)
                              : null,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Bottom row: Item Count + Total + View Receipt Action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${order.itemCount} ${order.itemCount == 1 ? 'item' : 'items'}',
                      style: const TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '\$${order.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                'View Receipt',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 10,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color text;

    switch (status) {
      case 'Processing':
        bg = Colors.orange.withOpacity(0.12);
        text = Colors.orange.shade800;
        break;
      case 'Shipped':
        bg = Colors.blue.withOpacity(0.12);
        text = Colors.blue.shade800;
        break;
      case 'Delivered':
        bg = Colors.green.withOpacity(0.12);
        text = Colors.green.shade800;
        break;
      case 'Returned':
        bg = Colors.purple.withOpacity(0.12);
        text = Colors.purple.shade800;
        break;
      case 'Canceled':
        bg = Colors.red.withOpacity(0.12);
        text = Colors.red.shade800;
        break;
      default:
        bg = Colors.grey.withOpacity(0.12);
        text = Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showReceiptBottomSheet(BuildContext context, OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Drag Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Receipt Header Badge
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.receipt_long,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'ORDER RECEIPT',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              order.code,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 16, color: AppTheme.primaryColor),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: order.code));
                                Get.snackbar(
                                  'Copied',
                                  'Order code copied to clipboard',
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(seconds: 2),
                                );
                              },
                            ),
                          ],
                        ),
                        Text(
                          _formatDate(order.date),
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildStatusBadge(order.status),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Divider(thickness: 1, height: 1),
                  const SizedBox(height: 20),

                  // Shipping & Payment Info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.location_on_outlined, size: 16, color: AppTheme.primaryColor),
                                SizedBox(width: 4),
                                Text(
                                  'Shipping Address',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              order.shippingAddress,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textPrimaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.payment_outlined, size: 16, color: AppTheme.primaryColor),
                                SizedBox(width: 4),
                                Text(
                                  'Payment Method',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              order.paymentMethod,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textPrimaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(thickness: 1, height: 1),
                  const SizedBox(height: 20),

                  // Purchased Items Section
                  const Text(
                    'Order Items',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: order.items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = order.items[index];
                      final itemTotal = item.product.price * item.quantity;

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // Product Image
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade200,
                                image: item.product.imageUrl.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(item.product.imageUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: item.product.imageUrl.isEmpty
                                  ? const Icon(Icons.shopping_bag, size: 24)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            // Item Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: AppTheme.textPrimaryColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Size: ${item.selectedSize}  •  Color: ${item.selectedColor}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.quantity} x \$${item.product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.textPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Item Subtotal
                            Text(
                              '\$${itemTotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),
                  const Divider(thickness: 1, height: 1),
                  const SizedBox(height: 20),

                  // Receipt Cost Breakdown Summary
                  const Text(
                    'Price Summary',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildReceiptRow('Subtotal', '\$${order.subtotal.toStringAsFixed(2)}'),
                  if (order.discount > 0)
                    _buildReceiptRow('Discount', '-\$${order.discount.toStringAsFixed(2)}', isDiscount: true),
                  _buildReceiptRow('Shipping Fee', '\$${order.shippingCost.toStringAsFixed(2)}'),
                  _buildReceiptRow('Tax', '\$${order.tax.toStringAsFixed(2)}'),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(thickness: 1, height: 1),
                  ),

                  _buildReceiptRow(
                    'Total Amount',
                    '\$${order.total.toStringAsFixed(2)}',
                    isTotal: true,
                  ),

                  const SizedBox(height: 28),

                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 52,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Close Receipt',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppTheme.textPrimaryColor : AppTheme.textSecondaryColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal
                  ? AppTheme.primaryColor
                  : (isDiscount ? Colors.green : AppTheme.textPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final month = months[date.month - 1];
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '$month ${date.day}, ${date.year} • ${hour.toString().padLeft(2, '0')}:$minute $period';
  }
}
