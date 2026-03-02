import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trendify/customer_explore_trends_screen.dart';
import 'package:trendify/order_success_sreen.dart';

class PlaceOrderScreen extends StatefulWidget {
  final Product product;

  const PlaceOrderScreen({super.key, required this.product});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  String _selectedPayment = 'upi';
  bool _isPlacingOrder = false;
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEE2B5B);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Secure Checkout',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Progress Stepper
            Row(
              children: [
                _buildStep(1, 'ADDRESS', true, primaryColor),
                Expanded(
                    child: Container(
                        height: 2,
                        color: primaryColor,
                        margin: const EdgeInsets.only(bottom: 20))),
                _buildStep(2, 'PAYMENT', false, primaryColor, isCurrent: true),
                Expanded(
                    child: Container(
                        height: 2,
                        color: Colors.grey[300],
                        margin: const EdgeInsets.only(bottom: 20))),
                _buildStep(3, 'REVIEW', false, Colors.grey[400]!),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Delivery Address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('addresses')
                  .where('isDefault', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Column(
                    children: [
                      const Text(
                        "No Address Found",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      _buildAddAddressButton(),
                    ],
                  );
                }

                final data =
                    snapshot.data!.docs.first.data() as Map<String, dynamic>;

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEE2B5B).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'DEFAULT',
                                style: TextStyle(
                                  color: Color(0xFFEE2B5B),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFEE2B5B).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.home_outlined,
                                    color: Color(0xFFEE2B5B)),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Home",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "${data['house'] ?? ''}, ${data['area'] ?? ''}",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "${data['city'] ?? ''} - ${data['pincode'] ?? ''}",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildAddAddressButton(),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            // Payment Options
            _buildPaymentOption(
              'upi',
              'UPI (Google Pay / PhonePe)',
              'Pay using any UPI app',
              Icons.account_balance_wallet_outlined,
              primaryColor,
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              'card',
              'Credit / Debit Card',
              'Visa, Mastercard, Amex',
              Icons.credit_card_outlined,
              primaryColor,
            ),
            const SizedBox(height: 140), // Space for bottom bar
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          border: Border(top: BorderSide(color: Colors.grey[100]!)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('GRAND TOTAL',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2)),
                    const SizedBox(height: 4),
                    // Text('\$114.00', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                    Text(
                      '\$${widget.product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Estimated Delivery',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Wed, 24 Oct',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF444444))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                // onPressed: _placeOrder,
                onPressed: _isPlacingOrder ? null : _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  elevation: 10,
                  shadowColor: primaryColor.withOpacity(0.4),
                ),
                child: _isPlacingOrder
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Place Order',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.chevron_right, size: 24),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _placeOrder() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    try {
      setState(() => _isPlacingOrder = true);
      // 🔥 1️⃣ Get Default Address
      final addressSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('addresses')
          .where('isDefault', isEqualTo: true)
          .get();

      if (addressSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No default address found")),
        );
        return;
      }
      

      final addressData = addressSnapshot.docs.first.data();

      // 🔥 2️⃣ Create Order in Firestore
      // final orderRef =
      //     await FirebaseFirestore.instance.collection('orders').add({
      //   'userId': user.uid,
      //   'productId': widget.product.id,
      //   'productName': widget.product.name,
      //   'price': widget.product.price,
      //   'paymentMethod': _selectedPayment,
      //   'status': 'placed',

      //   /// ✅ SAVE PRODUCT IMAGE (VERY IMPORTANT)
      //   'image': widget.product.imageUrls.isNotEmpty
      //       ? widget.product.imageUrls.first
      //       : null,

      //   'address': addressData,
      //   'createdAt': Timestamp.now(),
      // });

      // 🔥 Generate custom order number
final orderNumber =
    "#TR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";

// 🔥 Get customer name from users collection
final userDoc = await FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .get();

final userData = userDoc.data();

final orderRef =
    await FirebaseFirestore.instance.collection('orders').add({
  'orderNumber': orderNumber,
  'userId': user.uid,
  // 'customerName': userData?['name'] ?? "Customer",
  'customerName': userData?['fullName'] ?? "Customer",

  'productId': widget.product.id,
  'productName': widget.product.name,
  'price': widget.product.price,
  'paymentMethod': _selectedPayment,
  'status': 'Pending',

  'imageUrl': widget.product.imageUrls.isNotEmpty
      ? widget.product.imageUrls.first
      : null,

  'address': addressData,
  'createdAt': Timestamp.now(),
});

      // 🔥 3️⃣ Navigate to Success Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(
            orderId: orderRef.id,
            productName: widget.product.name,
            price: widget.product.price,
            address: addressData,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order failed: $e")),
      );
    } finally {
      setState(() => _isPlacingOrder = true);
    }
  }

  Widget _buildStep(int number, String label, bool isCompleted, Color color,
      {bool isCurrent = false}) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted ? color : Colors.transparent,
            border: Border.all(
                color: isCompleted || isCurrent ? color : Colors.grey[300]!,
                width: 2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                color: isCompleted
                    ? Colors.white
                    : (isCurrent ? color : Colors.grey[400]),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isCompleted || isCurrent
                ? (isCurrent ? Colors.grey[600] : color)
                : Colors.grey[400],
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String value, String title, String subtitle,
      IconData icon, Color primaryColor) {
    bool isSelected = _selectedPayment == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? primaryColor : Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  color: isSelected ? primaryColor : Colors.grey[600],
                  size: 20),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: isSelected ? primaryColor : Colors.grey[300]!,
                    width: 2),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: primaryColor, shape: BoxShape.circle),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAddressButton() {
    return OutlinedButton(
      onPressed: () {
        // Navigate to Add Address Screen
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey[200]!, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline, color: Colors.grey),
          SizedBox(width: 10),
          Text(
            'Add New Address',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
