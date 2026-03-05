import 'package:flutter/material.dart';

import 'package:trendify/admin_insights_dashboard_screen.dart';
import 'package:trendify/admin_order_management_screen.dart';
import 'package:trendify/admin/admin_settings_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AdminDashboardScreen(),
    const ManageOrdersScreen(),
    const AdminSettingsPage(), // Inventory screen
    const AdminSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFEE2B5B),
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(0, Icons.dashboard_outlined, "Dashboard"),
            _navItem(1, Icons.shopping_bag_outlined, "Orders"),
            const SizedBox(width: 40),
            _navItem(2, Icons.inventory_2_outlined, "Inventory"),
            _navItem(3, Icons.settings_outlined, "Settings"),
          ],
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    bool isActive = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? const Color(0xFFEE2B5B) : Colors.grey),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isActive ? const Color(0xFFEE2B5B) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
