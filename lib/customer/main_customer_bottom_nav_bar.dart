import 'package:flutter/material.dart';
import 'package:trendify/customer/cart_manager.dart';
import 'package:trendify/customer/explore_screen.dart';
import 'package:trendify/customer/my_wishlist_screen.dart';
import 'package:trendify/customer_explore_trends_screen.dart';
import 'package:trendify/my_shopping_cart_screen.dart';
import 'package:trendify/profile_screen.dart';

class CustomerMainNavigationScreen extends StatefulWidget {
  const CustomerMainNavigationScreen({super.key});

  @override
  State<CustomerMainNavigationScreen> createState() =>
      _CustomerMainNavigationScreenState();
}

class _CustomerMainNavigationScreenState
    extends State<CustomerMainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    CustomerHomeScreen(), // HOME
    // CustomerHomeScreen(), // EXPLORE (replace later)
    ExploreScreen(),
    // Center(child: Text("Wishlist")), // WISHLIST
    WishlistPage(),
    ShoppingCartScreen(), // CART
    ProfileScreen(), // PROFILE
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // if (index == 3) {
          //   // CART TAB refresh

          //   CartManager.cartItems.value =
          //       List.from(CartManager.cartItems.value);
          // }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFEE2B5B),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle:
            const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), label: 'HOME'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view), label: 'EXPLORE'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'WISHLIST'),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.shopping_bag_outlined), label: 'CART'),
          BottomNavigationBarItem(
            label: "CART",
            icon: ValueListenableBuilder(
              valueListenable: CartManager.cartItems,
              builder: (context, cartItems, _) {
                int count = cartItems.length;

                return Stack(
                  children: [
                    const Icon(Icons.shopping_bag_outlined),
                    if (count > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEE2B5B),
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'PROFILE'),
        ],
      ),
    );
  }
}
