import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller if it's not already put globally
    final controller = Get.put(OrdersController());

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
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            // Horizontal Filter Tabs
            SizedBox(
              height: 38,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.statusFilters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final filter = controller.statusFilters[index];
                  return Obx(() {
                    final isSelected = controller.activeFilter.value == filter;

                    return GestureDetector(
                      onTap: () => controller.changeFilter(filter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 24),

            // Orders List
            Expanded(
              child: Obx(() {
                final orders = controller.filteredOrders;

                if (orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: AppTheme.textSecondaryColor,
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
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  physics: const BouncingScrollPhysics(),
                  itemCount: orders.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = orders[index];

                    return GestureDetector(
                      onTap: () => Get.snackbar(
                        'Order Detail',
                        'Viewing order details for code ${order.code}',
                        snackPosition: SnackPosition.BOTTOM,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            // Icon package badge
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.receipt_long_outlined,
                                color: AppTheme.textPrimaryColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Order details info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order  ${order.code}',
                                    style: const TextStyle(
                                      color: AppTheme.textPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${order.itemCount} items',
                                    style: const TextStyle(
                                      color: AppTheme.textSecondaryColor,
                                      fontSize: 12,
                                      height: 1.40,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Chevron icon
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppTheme.textSecondaryColor,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

