import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:trendify/customer_explore_trends_screen.dart';
import 'package:trendify/order_item_widget.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final String productName;
  final double price;
  final Map<String, dynamic> address;
  const OrderSuccessScreen(
      {super.key,
      required this.orderId,
      required this.productName,
      required this.price,
      required this.address});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Close Button
                  Positioned(
                    top: 24,
                    right: 24,
                    child: IconButton(
                      icon: const Icon(LucideIcons.x, color: Colors.grey),
                      onPressed: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 64),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Success Icon Section
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE6F9F1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4ADE80),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x404ADE80),
                                    blurRadius: 15,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                LucideIcons.check,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Title & Subtitle
                        const Text(
                          'Order Placed Successfully!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Your style journey has begun. We've sent the confirmation to your email.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Order Details Card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: const Color(0xFFF3F4F6)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('ORDER ID',
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                              letterSpacing: 1.2)),
                                      const SizedBox(height: 4),
                                      Text('#$orderId',
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('EXPECTED DELIVERY',
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                              letterSpacing: 1.2)),
                                      SizedBox(height: 4),
                                      Text('Wed, 24 Oct',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFF43F5E))),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // const OrderItemWidget(
                              //   name: 'Premium Silk Wrap Dress',
                              //   details: 'Midnight Blue • Size M',
                              //   price: '\$129.00',
                              // ),
                              OrderItemWidget(
                                name: productName,
                                details: 'Selected Item',
                                price: '\$${price.toStringAsFixed(2)}',
                              ),
                              const SizedBox(height: 20),
                              // const OrderItemWidget(
                              //   name: 'Floral Summer Midi',
                              //   details: 'Pastel Pink • Size S',
                              //   price: '\$89.00',
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Shipping Info Card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: const Color(0xFFF3F4F6)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                child: const Icon(LucideIcons.truck,
                                    color: Color(0xFFF43F5E), size: 20),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('SHIPPING TO',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                            letterSpacing: 1.2)),
                                    const SizedBox(height: 4),
                                    // Text('123 Premium Lane, Fashion District, NY 10001', style: TextStyle(fontSize: 14, color: Color(0xFF4B5563))),
                                    Text(
                                      "${address['house'] ?? ''}, ${address['area'] ?? ''}, "
                                      "${address['city'] ?? ''} - ${address['pincode'] ?? ''}",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Action Buttons
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF43F5E),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 64),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.rotateCcw, size: 20),
                              SizedBox(width: 12),
                              Text('Track Order',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const CustomerExploreTrendsScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFF3F4F6),
                            foregroundColor: const Color(0xFF111827),
                            minimumSize: const Size(double.infinity, 64),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Continue Shopping',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 12),
                              Icon(LucideIcons.shoppingBag, size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
