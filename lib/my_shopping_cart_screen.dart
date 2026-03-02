import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final String size;
  final String color;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.size,
    required this.color,
    required this.imageUrl,
    this.quantity = 1,
  });
}

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final List<CartItem> _cartItems = [
    CartItem(
      id: '1',
      name: 'Floral Summer Dress',
      price: 89.00,
      size: 'M',
      color: 'Rose',
      imageUrl: 'https://picsum.photos/seed/dress/200',
    ),
    CartItem(
      id: '2',
      name: 'Classic Denim Jacket',
      price: 120.00,
      size: 'L',
      color: 'Blue',
      imageUrl: 'https://picsum.photos/seed/jacket/200',
    ),
    CartItem(
      id: '3',
      name: 'Slim Fit Chinos',
      price: 65.00,
      size: '32',
      color: 'Beige',
      imageUrl: 'https://picsum.photos/seed/pants/200',
      quantity: 2,
    ),
  ];

  double get subtotal =>
      _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get delivery => 15.00;
  double get discount => subtotal * 0.20;
  double get total => subtotal + delivery - discount;

  void _updateQuantity(int index, int delta) {
    setState(() {
      _cartItems[index].quantity =
          (_cartItems[index].quantity + delta).clamp(1, 99);
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F6),

      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'My Shopping Cart',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () => setState(() => _cartItems.clear()),
            ),
          ]),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return _buildCartItem(item, index);
              },
            ),
          ),
          _buildOrderSummary(),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   selectedItemColor: const Color(0xFFEE2B5B),
      //   unselectedItemColor: Colors.grey,
      //   currentIndex: 2,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Shop'),
      //     BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      //   ],
      // ),
    );
  }

  Widget _buildCartItem(CartItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.close, size: 18, color: Colors.grey),
                      onPressed: () => _removeItem(index),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFFEE2B5B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Size: ${item.size} | Color: ${item.color}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F6F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _qtyBtn(Icons.remove, () => _updateQuantity(index, -1),
                          isMinus: true),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      _qtyBtn(Icons.add, () => _updateQuantity(index, 1)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onPressed,
      {bool isMinus = false}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isMinus ? Colors.white : const Color(0xFFEE2B5B),
          shape: BoxShape.circle,
          boxShadow: [
            if (isMinus)
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
              ),
          ],
        ),
        child: Icon(
          icon,
          size: 14,
          color: isMinus ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          _summaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _summaryRow('Delivery', '\$${delivery.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _summaryRow('Discount (PROMO20)', '-\$${discount.toStringAsFixed(2)}',
              isDiscount: true),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFFEE2B5B),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _cartItems.isEmpty ? null : () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEE2B5B),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              shadowColor: const Color(0xFFEE2B5B).withOpacity(0.4),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Proceed to Checkout',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDiscount ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }
}
