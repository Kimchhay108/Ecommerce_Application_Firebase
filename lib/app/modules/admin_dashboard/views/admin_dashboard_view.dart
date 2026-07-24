import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../../../theme/app_theme.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/order_model.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered if web_main binds it directly
    final controller = Get.put(AdminDashboardController());

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19), // Deep Slate dark background
      body: Row(
        children: [
          // Sidebar Navigation (Left Panel)
          _buildSidebar(controller),
          
          // Main Panel (Right Panel)
          Expanded(
            child: Column(
              children: [
                _buildTopBar(controller),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C3AED)),
                        ),
                      );
                    }

                    switch (controller.currentTab.value) {
                      case 'Overview':
                        return _buildOverviewTab(context, controller);
                      case 'Products':
                        return _buildProductsTab(context, controller);
                      case 'Categories':
                        return _buildCategoriesTab(context, controller);
                      case 'Orders':
                        return _buildOrdersTab(context, controller);
                      case 'Users':
                        return _buildUsersTab(context, controller);
                      default:
                        return _buildOverviewTab(context, controller);
                    }
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Sidebar Component ---
  Widget _buildSidebar(AdminDashboardController controller) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: Color(0xFF121826),
        border: Border(
          right: BorderSide(color: Colors.white10, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Logo Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white10, width: 1),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shopping_bag,
                  color: Color(0xFF7C3AED),
                  size: 28,
                ),
                const SizedBox(width: 12),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFA78BFA), Color(0xFF7C3AED)],
                  ).createShader(bounds),
                  child: const Text(
                    'ShopAdmin',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Nav Items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildNavItem(controller, 'Overview', Icons.dashboard),
                  const SizedBox(height: 8),
                  _buildNavItem(controller, 'Products', Icons.inventory_2),
                  const SizedBox(height: 8),
                  _buildNavItem(controller, 'Categories', Icons.folder),
                  const SizedBox(height: 8),
                  _buildNavItem(controller, 'Orders', Icons.shopping_cart),
                  const SizedBox(height: 8),
                  _buildNavItem(controller, 'Users', Icons.people),
                ],
              ),
            ),
          ),

          // User Footer
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white10, width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFA78BFA), Color(0xFF7C3AED)],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'A',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Administrator',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Super User',
                      style: TextStyle(color: Colors.white30, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(AdminDashboardController controller, String tabName, IconData icon) {
    return Obx(() {
      final isActive = controller.currentTab.value == tabName;
      return InkWell(
        onTap: () => controller.currentTab.value = tabName,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isActive
                ? const LinearGradient(
                    colors: [
                      Color(0x267C3AED),
                      Color(0x0D7C3AED),
                    ],
                  )
                : null,
            border: isActive
                ? Border.all(color: const Color(0x407C3AED), width: 1)
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? const Color(0xFFC084FC) : const Color(0xFF9CA3AF),
                size: 20,
              ),
              const SizedBox(width: 14),
              Text(
                tabName,
                style: TextStyle(
                  color: isActive ? const Color(0xFFC084FC) : const Color(0xFF9CA3AF),
                  fontSize: 15,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // --- Top Bar Component ---
  Widget _buildTopBar(AdminDashboardController controller) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        color: Color(0xCC0B0F19),
        border: Border(
          bottom: BorderSide(color: Colors.white10, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Search box
          Container(
            width: 320,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0x8C161E31),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Color(0xFF9CA3AF), size: 18),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search dashboard...',
                      hintStyle: TextStyle(color: Color(0xFF6B7280)),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Actions
          Row(
            children: [
              IconButton(
                onPressed: () => controller.refreshAllData(),
                icon: const Icon(Icons.refresh, color: Color(0xFF9CA3AF)),
                tooltip: 'Refresh Database',
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0x1A10B981),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: const Color(0x3310B981)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified, color: Color(0xFF10B981), size: 14),
                    SizedBox(width: 8),
                    Text(
                      'REST API Active',
                      style: TextStyle(color: Color(0xFF10B981), fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- TAB 1: OVERVIEW VIEW ---
  Widget _buildOverviewTab(BuildContext context, AdminDashboardController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview Dashboard',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5),
          ),
          const SizedBox(height: 6),
          const Text(
            'Real-time metrics synced directly from Supabase PostgREST.',
            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 15),
          ),
          const SizedBox(height: 32),

          // Metrics Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 4 * 24) / 5;
              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  _buildMetricCard('Total Revenue', '\$${controller.totalRevenue.toStringAsFixed(2)}', Icons.attach_money, const Color(0xFF10B981), itemWidth),
                  _buildMetricCard('Total Orders', controller.ordersCount.toString(), Icons.shopping_cart, const Color(0xFF60A5FA), itemWidth),
                  _buildMetricCard('Active Products', controller.productsCount.toString(), Icons.inventory_2, const Color(0xFFFBBF24), itemWidth),
                  _buildMetricCard('Categories', controller.categoriesCount.toString(), Icons.folder, const Color(0xFFC084FC), itemWidth),
                  _buildMetricCard('Total Users', controller.usersList.length.toString(), Icons.people, const Color(0xFFEC4899), itemWidth),
                ],
              );
            },
          ),
          const SizedBox(height: 32),

          // Secondary details grid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Visual Chart Simulation
              Expanded(
                flex: 3,
                child: _buildGlassPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Orders Distribution',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      _buildChartBar('Processing', controller.getStatusCount('Processing'), controller.ordersCount, const Color(0xFFF59E0B)),
                      const SizedBox(height: 16),
                      _buildChartBar('Shipped', controller.getStatusCount('Shipped'), controller.ordersCount, const Color(0xFF60A5FA)),
                      const SizedBox(height: 16),
                      _buildChartBar('Delivered', controller.getStatusCount('Delivered'), controller.ordersCount, const Color(0xFF10B981)),
                      const SizedBox(height: 16),
                      _buildChartBar('Returned', controller.getStatusCount('Returned'), controller.ordersCount, const Color(0xFF6B7280)),
                      const SizedBox(height: 16),
                      _buildChartBar('Canceled', controller.getStatusCount('Canceled'), controller.ordersCount, const Color(0xFFEF4444)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Recent orders panel
              Expanded(
                flex: 2,
                child: _buildGlassPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Orders',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () => controller.currentTab.value = 'Orders',
                            child: const Text('View All', style: TextStyle(color: Color(0xFF7C3AED))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (controller.ordersList.isEmpty)
                        const Text('No orders placed yet.', style: TextStyle(color: Colors.white30))
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.ordersList.take(4).length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, idx) {
                            final o = controller.ordersList[idx];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const CircleAvatar(
                                backgroundColor: Color(0x1A7C3AED),
                                child: Icon(Icons.receipt, color: Color(0xFF7C3AED)),
                              ),
                              title: Text(o.code, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                o.date.toLocal().toString().substring(0, 16),
                                style: const TextStyle(color: Colors.white30, fontSize: 11),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$${o.total.toStringAsFixed(2)}',
                                    style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    o.status,
                                    style: TextStyle(color: _getStatusColor(o.status), fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              onTap: () => _showOrderDetailsDialog(context, o, controller),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0x8C161E31),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
            ],
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(String status, int count, int total, Color color) {
    final double percentage = total > 0 ? (count / total) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(status, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
            Text(
              '$count orders (${(percentage * 100).toStringAsFixed(1)}%)',
              style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 10,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  // --- TAB 2: PRODUCTS VIEW ---
  Widget _buildProductsTab(BuildContext context, AdminDashboardController controller) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Products Directory',
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Create, view, modify, and delete products in the database.',
                    style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 15),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  controller.prepareNewProduct();
                  _showProductDialog(context, controller);
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Product'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Products Table
          Expanded(
            child: _buildGlassPanel(
              child: controller.productsList.isEmpty
                  ? const Center(child: Text('No products found in database.', style: TextStyle(color: Colors.white30)))
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(Colors.white12),
                        columns: const [
                          DataColumn(label: Text('Product', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Category', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Price', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Original Price', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        ],
                        rows: controller.productsList.map((p) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        p.imageUrl,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 40,
                                          height: 40,
                                          color: Colors.white10,
                                          child: const Icon(Icons.broken_image, color: Colors.white24, size: 20),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(p.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0x1F7C3AED),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: const Color(0x337C3AED)),
                                  ),
                                  child: Text(
                                    p.category ?? 'Uncategorized',
                                    style: const TextStyle(color: Color(0xFFC084FC), fontSize: 12, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              DataCell(Text('\$${p.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              DataCell(
                                Text(
                                  p.originalPrice != null ? '\$${p.originalPrice!.toStringAsFixed(2)}' : '-',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    decoration: p.originalPrice != null ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.amber, size: 18),
                                      onPressed: () {
                                        controller.prepareEditProduct(p);
                                        _showProductDialog(context, controller);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
                                      onPressed: () => _showDeleteConfirmation(context, () => controller.deleteProduct(p.id)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 3: CATEGORIES VIEW ---
  Widget _buildCategoriesTab(BuildContext context, AdminDashboardController controller) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories Directory',
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Manage your product category buckets and covers.',
                    style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 15),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  controller.prepareNewCategory();
                  _showCategoryDialog(context, controller);
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Category'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Categories Grid
          Expanded(
            child: controller.categoriesList.isEmpty
                ? const Center(child: Text('No categories configured yet.', style: TextStyle(color: Colors.white30)))
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 320,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      childAspectRatio: 1.6,
                    ),
                    itemCount: controller.categoriesList.length,
                    itemBuilder: (context, idx) {
                      final c = controller.categoriesList[idx];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white10),
                          boxShadow: const [
                            BoxShadow(color: Colors.black38, blurRadius: 16, offset: Offset(0, 8)),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                c.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(color: Colors.white10),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xCC0B0F19), Color(0x1A0B0F19)],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        c.title,
                                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.white12,
                                          child: IconButton(
                                            icon: const Icon(Icons.edit, color: Colors.amber, size: 16),
                                            onPressed: () {
                                              controller.prepareEditCategory(c);
                                              _showCategoryDialog(context, controller);
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        CircleAvatar(
                                          backgroundColor: Colors.white12,
                                          child: IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.redAccent, size: 16),
                                            onPressed: () => _showDeleteConfirmation(context, () => controller.deleteCategory(c.id)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: ORDERS VIEW ---
  Widget _buildOrdersTab(BuildContext context, AdminDashboardController controller) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Orders',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5),
          ),
          const SizedBox(height: 6),
          const Text(
            'Track customer orders, transactions, payment status, and update shipment status.',
            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 15),
          ),
          const SizedBox(height: 32),

          // Orders Table
          Expanded(
            child: _buildGlassPanel(
              child: controller.ordersList.isEmpty
                  ? const Center(child: Text('No orders found.', style: TextStyle(color: Colors.white30)))
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(Colors.white12),
                        columns: const [
                          DataColumn(label: Text('Code', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Date', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Subtotal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Shipping', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Total', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        ],
                        rows: controller.ordersList.map((o) {
                          return DataRow(
                            cells: [
                              DataCell(Text(o.code, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              DataCell(Text(o.date.toLocal().toString().substring(0, 16), style: const TextStyle(color: Colors.white70))),
                              DataCell(Text('\$${o.subtotal.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white))),
                              DataCell(Text('\$${o.shippingCost.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white))),
                              DataCell(Text('\$${o.total.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold))),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(o.status).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    o.status,
                                    style: TextStyle(color: _getStatusColor(o.status), fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.visibility, color: Colors.blueAccent),
                                  onPressed: () => _showOrderDetailsDialog(context, o, controller),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // --- POPUP DIALOGS ---
  void _showProductDialog(BuildContext context, AdminDashboardController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF121826),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.white10)),
          title: Text(
            controller.editingProductId.value.isNotEmpty ? 'Edit Product' : 'Add New Product',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('Product Name', controller.productTitleController),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Price (\$)', controller.productPriceController)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField('Original Price (\$) (optional)', controller.productOriginalPriceController)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Category', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Obx(() {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: const Color(0xFF121826),
                          style: const TextStyle(color: Colors.white),
                          value: controller.selectedCategoryId.value.isNotEmpty ? controller.selectedCategoryId.value : null,
                          items: controller.categoriesList.map((c) {
                            return DropdownMenuItem<String>(
                              value: c.id,
                              child: Text(c.title),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) controller.selectedCategoryId.value = val;
                          },
                          isExpanded: true,
                          hint: const Text('Select Category', style: TextStyle(color: Colors.white30)),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  _buildTextField('Image URL', controller.productImageController),
                  const SizedBox(height: 16),
                  _buildTextField('Description', controller.productDescController, maxLines: 3),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF9CA3AF))),
            ),
            ElevatedButton(
              onPressed: () => controller.saveProduct(),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED)),
              child: const Text('Save Product', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showCategoryDialog(BuildContext context, AdminDashboardController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF121826),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.white10)),
          title: Text(
            controller.editingCategoryId.value.isNotEmpty ? 'Edit Category' : 'Add New Category',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField('Category Name', controller.categoryTitleController),
                const SizedBox(height: 16),
                _buildTextField('Cover Image URL', controller.categoryImageController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF9CA3AF))),
            ),
            ElevatedButton(
              onPressed: () => controller.saveCategory(),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED)),
              child: const Text('Save Category', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showOrderDetailsDialog(BuildContext context, OrderModel o, AdminDashboardController controller) {
    showDialog(
      context: context,
      builder: (context) {
        final user = controller.usersList.firstWhere(
          (u) => u['id'] == o.userId,
          orElse: () => <String, dynamic>{},
        );
        final String customerName = user.isNotEmpty
            ? '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'.trim()
            : 'Unknown Customer';
        final String customerEmail = user.isNotEmpty ? (user['email'] ?? '') : '';

        return AlertDialog(
          backgroundColor: const Color(0xFF121826),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.white10)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order specifications for ${o.code}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close, color: Colors.white30), onPressed: () => Get.back()),
            ],
          ),
          content: SizedBox(
            width: 640,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetaDetail('Order Code', o.code),
                      _buildMetaDetail('Order Date', o.date.toLocal().toString().substring(0, 16)),
                      _buildMetaDetail('Address', o.shippingAddress),
                      _buildMetaDetail('Payment Method', o.paymentMethod),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 12),
                  const Text('Customer Profile', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color(0x1F7C3AED),
                          child: Icon(Icons.person, color: Color(0xFFC084FC)),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customerName.isNotEmpty ? customerName : 'Unnamed Customer',
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            if (customerEmail.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                customerEmail,
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 12),
                  const Text('Ordered Items', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  
                  // Items list
                  Container(
                    constraints: const BoxConstraints(maxHeight: 180),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: o.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, idx) {
                        final item = o.items[idx];
                        final prod = item.product;
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(
                                      prod.imageUrl,
                                      width: 36,
                                      height: 36,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(color: Colors.white10, width: 36, height: 36),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(prod.title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                      Text('Size: ${item.selectedSize} • Color: ${item.selectedColor}', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                                    ],
                                  ),
                                ],
                              ),
                              Text('${item.quantity}x \$${prod.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Summary Calculations
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        _buildSummaryLine('Subtotal', '\$${o.subtotal.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        _buildSummaryLine('Shipping Cost', '\$${o.shippingCost.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        _buildSummaryLine('Discount', '-\$${o.discount.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        const Divider(color: Colors.white10),
                        const SizedBox(height: 8),
                        _buildSummaryLine('Total Amount', '\$${o.total.toStringAsFixed(2)}', isTotal: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Status update section
                  const Text('Update Shipping Status', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          dropdownColor: const Color(0xFF121826),
                          style: const TextStyle(color: Colors.white),
                          value: o.status,
                          items: const [
                            DropdownMenuItem(value: 'Processing', child: Text('Processing')),
                            DropdownMenuItem(value: 'Shipped', child: Text('Shipped')),
                            DropdownMenuItem(value: 'Delivered', child: Text('Delivered')),
                            DropdownMenuItem(value: 'Returned', child: Text('Returned')),
                            DropdownMenuItem(value: 'Canceled', child: Text('Canceled')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              controller.updateOrderStatus(o.id, val);
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white12,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF121826),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.white10)),
          title: const Text('Delete Confirmation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: const Text('Are you sure you want to delete this item? This action is irreversible.', style: TextStyle(color: Color(0xFF9CA3AF))),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Cancel', style: TextStyle(color: Color(0xFF9CA3AF)))),
            ElevatedButton(
              onPressed: () {
                Get.back();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // --- UI DETAIL HELPERS ---
  Widget _buildTextField(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white12,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildMetaDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white30, fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildSummaryLine(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? const Color(0xFF10B981) : const Color(0xFF9CA3AF),
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? const Color(0xFF10B981) : Colors.white,
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassPanel({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0x8C161E31),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return const Color(0xFFF59E0B);
      case 'shipped':
        return const Color(0xFF60A5FA);
      case 'delivered':
        return const Color(0xFF10B981);
      case 'canceled':
      case 'returned':
        return const Color(0xFFEF4444);
      default:
        return Colors.white54;
    }
  }

  Widget _buildUsersTab(BuildContext context, AdminDashboardController controller) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Accounts Directory',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5),
          ),
          const SizedBox(height: 6),
          const Text(
            'Manage customer profiles, access permissions, banning, and deletion.',
            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 15),
          ),
          const SizedBox(height: 32),

          // Users Table
          Expanded(
            child: _buildGlassPanel(
              child: controller.usersList.isEmpty
                  ? const Center(child: Text('No users found in database.', style: TextStyle(color: Colors.white30)))
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(Colors.white12),
                        columns: const [
                          DataColumn(label: Text('Customer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Email', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Phone', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        ],
                        rows: controller.usersList.map((u) {
                          final String uid = u['id']?.toString() ?? '';
                          final String firstName = u['first_name']?.toString() ?? '';
                          final String lastName = u['last_name']?.toString() ?? '';
                          final String fullName = '$firstName $lastName'.trim();
                          final String email = u['email']?.toString() ?? '-';
                          final String phone = u['phone']?.toString() ?? '-';
                          final String avatarUrl = u['avatar_url']?.toString() ?? '';
                          final bool isBanned = u['is_banned'] == true;

                          return DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                                      backgroundColor: const Color(0x1F7C3AED),
                                      child: avatarUrl.isEmpty
                                          ? Text(
                                              fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U',
                                              style: const TextStyle(color: Color(0xFFC084FC), fontWeight: FontWeight.bold),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      fullName.isNotEmpty ? fullName : 'Unnamed User',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(Text(email, style: const TextStyle(color: Colors.white70))),
                              DataCell(Text(phone, style: const TextStyle(color: Colors.white70))),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isBanned ? const Color(0x1FEF4444) : const Color(0x1F10B981),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    isBanned ? 'Banned' : 'Active',
                                    style: TextStyle(
                                      color: isBanned ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        isBanned ? Icons.check_circle : Icons.block,
                                        color: isBanned ? Colors.green : Colors.orangeAccent,
                                        size: 18,
                                      ),
                                      tooltip: isBanned ? 'Unban User' : 'Ban User',
                                      onPressed: () => controller.toggleUserBan(uid, !isBanned),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
                                      tooltip: 'Delete User Account',
                                      onPressed: () => _showDeleteConfirmation(context, () => controller.deleteUser(uid)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
