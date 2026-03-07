import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendify/add_new_product_screen.dart';
import 'package:trendify/admin/admin_settings_screen.dart';
import 'package:trendify/admin/admin_insights_dashboard_screen.dart';
import 'package:trendify/admin/admin_order_management_screen.dart';

class AdminDashboardContainer extends StatefulWidget {
  const AdminDashboardContainer({super.key});

  @override
  State<AdminDashboardContainer> createState() =>
      _AdminDashboardContainerState();
}

class _AdminDashboardContainerState extends State<AdminDashboardContainer> {
  int _selectedIndex = 0;

  final List<Widget> pages = const [
    AdminDashboardScreen(),
    AdminDashboardScreen(),

    // AdminPerformanceChartScreen(),
    ManageOrdersScreen(),
    AdminSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      floatingActionButton: SizedBox(
        height: 64,
        width: 64,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddNewProductScreen(),
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
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        height: 80,
        color: Colors.white,
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.dashboard_outlined, 'Dashboard'),
            _buildNavItem(1, Icons.bar_chart_outlined, 'Analytics'),

            const SizedBox(width: 40),

            _buildNavItem(2, Icons.inventory_2_outlined, 'Orders'),
            _buildNavItem(3, Icons.settings_outlined, 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
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