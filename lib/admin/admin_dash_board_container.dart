import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendify/admin/admin_settings_screen.dart';
import 'package:trendify/admin_insights_dashboard_screen.dart';
import 'package:trendify/admin_order_management_screen.dart';

class AdminDashboardContainer extends StatefulWidget {
  const AdminDashboardContainer({super.key});

  @override
  State<AdminDashboardContainer> createState() =>
      _AdminDashboardContainerState();
}

class _AdminDashboardContainerState extends State<AdminDashboardContainer> {

  int _selectedIndex = 0;

  final List<Widget> pages = [
    const AdminDashboardScreen(),
    const AdminDashboardScreen(),
    const ManageOrdersScreen(),
    const AdminSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
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

  Widget _navItem(int index, IconData icon, String label) {

    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: isSelected
                  ? const Color(0xFFEE2B5B)
                  : Colors.grey),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? const Color(0xFFEE2B5B)
                  : Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}