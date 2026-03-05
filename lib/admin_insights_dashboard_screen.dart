import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendify/add_new_product_screen.dart';
import 'package:trendify/admin/admin_settings_screen.dart';
import 'package:trendify/admin_manage_order_irem_widget.dart';
import 'package:trendify/admin_order_management_screen.dart';
import 'package:trendify/admin_order_tracking_screen.dart';
import 'package:trendify/admin_performance_chart_screen.dart';
import 'package:trendify/app_colors.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  double totalRevenue = 0;
  int totalOrders = 0;
  int totalProducts = 0;
  List<Map<String, dynamic>> recentOrders = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      // 🔥 Get Orders
      final orderSnapshot =
          await FirebaseFirestore.instance.collection('orders').get();

      double revenue = 0;

      for (var doc in orderSnapshot.docs) {
        final data = doc.data();
        revenue += (data['price'] ?? 0).toDouble();
      }

      // 🔥 Get Products
      final productSnapshot =
          await FirebaseFirestore.instance.collection('products').get();

      // 🔥 Recent Orders (Last 5)
      final recentSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .limit(5)
          .get();

      setState(() {
        totalRevenue = revenue;
        totalOrders = orderSnapshot.docs.length;
        totalProducts = productSnapshot.docs.length;
        // recentOrders = recentSnapshot.docs.map((e) => e.data()).toList();

        recentOrders = recentSnapshot.docs
            .map((e) => {
                  ...e.data(),
                  "docId": e.id,
                })
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print("Dashboard error: $e");
    }
  }

  int _selectedIndex = 0;

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    final difference = DateTime.now().difference(date);

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} mins ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hrs ago";
    } else {
      return "${difference.inDays} days ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F6F6).withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
        // leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color: const Color(0xFFEE2B5B).withOpacity(0.1),
        //       borderRadius: BorderRadius.circular(12),
        //     ),
        //     child: const Icon(Icons.menu, color: Color(0xFFEE2B5B)),
        //   ),
        // ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trendify',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            Text(
              'ADMIN CONSOLE',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                letterSpacing: 1.5,
                color: const Color(0xFFEE2B5B),
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              const IconButton(
                onPressed: null,
                icon: Icon(Icons.notifications_none, color: Colors.grey),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEE2B5B),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0, left: 8.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=100&auto=format&fit=crop'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Insights Overview',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'This Week',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFEE2B5B),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down,
                        color: Color(0xFFEE2B5B), size: 20),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            StatCard(
              title: 'Total Revenue',
              // value: '\$48,290',
              value: '\$${totalRevenue.toStringAsFixed(2)}',
              trend: '14%',
              icon: Icons.credit_card,
              color: AppColors.emerald,
              chartColor: AppColors.emerald,
            ),
            const SizedBox(height: 16),
            StatCard(
              title: 'Total Orders',
              // value: '1,432',
              value: totalOrders.toString(),
              trend: '8%',
              icon: Icons.shopping_bag_outlined,
              color: const Color(0xFFEE2B5B),
              chartColor: const Color(0xFFEE2B5B),
            ),
            const SizedBox(height: 16),
            StatCard(
              title: 'Total Products',
              // value: '2,854',
              value: totalProducts.toString(),
              trend: '0%',
              icon: Icons.checkroom,
              color: Colors.blue,
              isDashed: true,
            ),
            const SizedBox(height: 24),
            const PerformanceChart(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Orders',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFEE2B5B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // const OrderItem(
            //   id: '#TR-8942',
            //   name: 'Premium Denim Jacket',
            //   time: '2 mins ago',
            //   price: '\$89.00',
            //   status: 'Processing',
            //   imageUrl:
            //       'https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?q=80&w=200&auto=format&fit=crop',
            // ),
            // const SizedBox(height: 12),
            // const OrderItem(
            //   id: '#TR-8941',
            //   name: 'Floral Silk Maxi Dress',
            //   time: '15 mins ago',
            //   price: '\$124.50',
            //   status: 'Shipped',
            //   imageUrl:
            //       'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?q=80&w=200&auto=format&fit=crop',
            // ),
            // const SizedBox(height: 12),
            // const OrderItem(
            //   id: '#TR-8940',
            //   name: 'Slim-Fit Wool Suit',
            //   time: '1 hr ago',
            //   price: '\$450.00',
            //   status: 'Pending',
            //   imageUrl:
            //       'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?q=80&w=200&auto=format&fit=crop',
            // ),

            Column(
              children: recentOrders.map((order) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: OrderItem(
                    // id: order['orderNumber'] ?? '',
                    id: order['docId'], // firestore document id
                    orderNumber: order['orderNumber'],
                    // name: order['productName'] ?? '',
                    name: order['customerName'] ?? '',
                    time: _formatTime(order['createdAt']),
                    price: "\$${order['price']}",
                    status: order['status'] ?? 'Pending',
                    imageUrl:
                        "https://picsum.photos/200", // Replace with product image if stored
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 30),
        height: 64,
        width: 64,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNewProductScreen(),
              ),
            );
          },
          backgroundColor: const Color(0xFFEE2B5B),
          elevation: 8,
          shape: const CircleBorder(
            side: BorderSide(color: Color(0xFFF8F6F6), width: 4),
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 10,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.dashboard_outlined, 'Dashboard'),
            _buildNavItem(1, Icons.bar_chart_outlined, 'Analytics'),
            const SizedBox(width: 40),
            // _buildNavItem(2, Icons.inventory_2_outlined, 'Inventory'),
            _buildNavItem(2, Icons.inventory_2_outlined, 'Orders'),

            _buildNavItem(3, Icons.settings_outlined, 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      // onTap: () => setState(() => _selectedIndex = index),
      onTap: () {
        setState(() => _selectedIndex = index);

        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ManageOrdersScreen(),
            ),
          );
        }
        if (index == 1) {
          // // Analytics Clicked
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const AdminPerformanceChartScreen(),
          //   ),
          // );
        }

        if (index == 3) {
          // // Settings Clicked
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminSettingsPage(),
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFFEE2B5B) : Colors.grey[400],
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isSelected ? const Color(0xFFEE2B5B) : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String trend;
  final IconData icon;
  final Color color;
  final Color? chartColor;
  final bool isDashed;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.trend,
    required this.icon,
    required this.color,
    this.chartColor,
    this.isDashed = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFEE2B5B).withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                Row(
                  children: [
                    if (trend != '0%')
                      Icon(Icons.trending_up, color: color, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      trend,
                      style: GoogleFonts.inter(
                        color: trend == '0%' ? Colors.grey[400] : color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.grey[500],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
         
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: isDashed
                  ? Center(
                      child: Container(
                        height: 1,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.blue.withOpacity(0.3),
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                    )
                  : LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              const FlSpot(0, 1),
                              const FlSpot(1, 1.5),
                              const FlSpot(2, 1.2),
                              const FlSpot(3, 2.5),
                              const FlSpot(4, 2),
                              const FlSpot(5, 3),
                            ],
                            isCurved: true,
                            color: chartColor,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: chartColor?.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
