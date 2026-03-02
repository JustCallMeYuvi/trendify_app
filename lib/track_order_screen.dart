import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrackOrderScreen extends StatelessWidget {
  final String orderId;
  const TrackOrderScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
 
        title: const Text(
          'Track Order',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.more_horiz, color: Color(0xFFEA3E69)),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      // body: Stack(
      //   children: [
      //     SingleChildScrollView(
      //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           _buildOrderSummary(),
      //           const SizedBox(height: 24),
      //           _buildMapPreview(),
      //           const SizedBox(height: 32),
      //           const Text(
      //             'TRACKING DETAILS',
      //             style: TextStyle(
      //               fontSize: 10,
      //               fontWeight: FontWeight.bold,
      //               letterSpacing: 2,
      //               color: Colors.grey,
      //             ),
      //           ),
      //           const SizedBox(height: 24),
      //           _buildTrackingStepper(),
      //           const SizedBox(height: 120), // Space for sticky button
      //         ],
      //       ),
      //     ),
      //     _buildStickyFooter(),
      //   ],
      // ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orderData = snapshot.data!.data() as Map<String, dynamic>?;

          if (orderData == null) {
            return const Center(child: Text("Order not found"));
          }

          final status = orderData['status'] ?? 'confirmed';
          final orderNumber = orderData['orderNumber'] ?? orderId;
          final expectedDelivery =
              (orderData['expectedDelivery'] as Timestamp?)?.toDate();

          return Stack(
            children: [
              SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderSummary(
                      orderNumber,
                      status,
                      expectedDelivery,
                    ),
                    const SizedBox(height: 24),
                    _buildMapPreview(),
                    const SizedBox(height: 32),
                    const Text(
                      'TRACKING DETAILS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTrackingStepper(status),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
              _buildStickyFooter(),
            ],
          );
        },
      ),
    );
  }

  // Widget _buildOrderSummary() {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFEA3E69).withOpacity(0.05),
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border.all(color: const Color(0xFFEA3E69).withOpacity(0.1)),
  //     ),
  //     child: Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text('ORDER NUMBER', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
  //                 const Text('#TRD-982410-SH', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //               ],
  //             ),
  //             Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFFEA3E69),
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               child: const Text('IN TRANSIT', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
  //             ),
  //           ],
  //         ),
  //         const Divider(height: 32, color: Color(0x1AEA3E69)),
  //         Row(
  //           children: [
  //             Container(
  //               width: 48,
  //               height: 48,
  //               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
  //               child: const Icon(Icons.calendar_today, color: Color(0xFFEA3E69)),
  //             ),
  //             const SizedBox(width: 12),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text('Expected Arrival', style: TextStyle(fontSize: 10, color: Colors.grey)),
  //                 const Text('Monday, 24 Oct 2023', style: TextStyle(fontWeight: FontWeight.bold)),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildOrderSummary(
    String orderNumber,
    String status,
    DateTime? expectedDelivery,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEA3E69).withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ORDER NUMBER',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    orderNumber,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEA3E69),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Color(0xFFEA3E69)),
              const SizedBox(width: 12),
              Text(
                expectedDelivery != null
                    ? "Expected: ${expectedDelivery.day}/${expectedDelivery.month}/${expectedDelivery.year}"
                    : "Delivery date pending",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage('https://picsum.photos/seed/map/800/400'),
          fit: BoxFit.cover,
          opacity: 0.4,
        ),
      ),
      child: Stack(
        children: [
          // Simplified Route Line
          Center(
            child: Icon(Icons.home,
                color: const Color(0xFFEA3E69).withOpacity(0.5), size: 100),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://picsum.photos/seed/driver/100/100'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('YOUR COURIER',
                            style: TextStyle(
                                fontSize: 8,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        const Text('Marcus Johnson',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _buildMapAction(Icons.phone),
                      const SizedBox(width: 8),
                      _buildMapAction(Icons.chat_bubble),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapAction(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration:
          const BoxDecoration(color: Color(0xFFEA3E69), shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 14),
    );
  }

  // Widget _buildTrackingStepper() {
  //   return Column(
  //     children: [
  //       _buildStep(Icons.check, 'Order Confirmed', 'Your order has been placed and confirmed.', '10:30 AM, 20 Oct', true, false),
  //       _buildStep(Icons.inventory_2, 'Packed', 'Item has been packed and ready to ship.', '02:45 PM, 21 Oct', true, false),
  //       _buildStep(Icons.local_shipping, 'Shipped', 'Order is on its way to your location.', '09:15 AM, 23 Oct', false, true),
  //       _buildStep(Icons.delivery_dining, 'Out for Delivery', 'Courier is delivering to your doorstep.', null, false, false),
  //       _buildStep(Icons.task_alt, 'Delivered', 'Enjoy your Trendify fashion!', null, false, false, isLast: true),
  //     ],
  //   );
  // }

  Widget _buildTrackingStepper(String status) {
    int currentStep = 0;

    switch (status) {
      case 'confirmed':
        currentStep = 0;
        break;
      case 'packed':
        currentStep = 1;
        break;
      case 'shipped':
        currentStep = 2;
        break;
      case 'out_for_delivery':
        currentStep = 3;
        break;
      case 'delivered':
        currentStep = 4;
        break;
    }

    return Column(
      children: [
        _buildStep(
            Icons.check, 'Order Confirmed', currentStep >= 0, currentStep == 0),
        _buildStep(
            Icons.inventory_2, 'Packed', currentStep >= 1, currentStep == 1),
        _buildStep(Icons.local_shipping, 'Shipped', currentStep >= 2,
            currentStep == 2),
        _buildStep(Icons.delivery_dining, 'Out for Delivery', currentStep >= 3,
            currentStep == 3),
        _buildStep(
            Icons.task_alt, 'Delivered', currentStep >= 4, currentStep == 4,
            isLast: true),
      ],
    );
  }
  // Widget _buildStep(IconData icon, String title, String desc, String? time, bool isDone, bool isCurrent, {bool isLast = false}) {
  //   return IntrinsicHeight(
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Column(
  //           children: [
  //             Container(
  //               width: 40,
  //               height: 40,
  //               decoration: BoxDecoration(
  //                 color: (isDone || isCurrent) ? const Color(0xFFEA3E69) : Colors.grey[200],
  //                 shape: BoxShape.circle,
  //                 border: isCurrent ? Border.all(color: const Color(0xFFEA3E69).withOpacity(0.2), width: 4) : null,
  //               ),
  //               child: Icon(icon, color: (isDone || isCurrent) ? Colors.white : Colors.grey, size: 20),
  //             ),
  //             if (!isLast)
  //               Expanded(
  //                 child: Container(width: 2, color: isDone ? const Color(0xFFEA3E69) : Colors.grey[200]),
  //               ),
  //           ],
  //         ),
  //         const SizedBox(width: 16),
  //         Expanded(
  //           child: Padding(
  //             padding: const EdgeInsets.only(bottom: 24),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isCurrent ? const Color(0xFFEA3E69) : Colors.black)),
  //                 Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
  //                 if (time != null)
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 4),
  //                     child: Text(time, style: const TextStyle(fontSize: 10, color: Color(0xFFEA3E69), fontWeight: FontWeight.bold)),
  //                   ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildStep(IconData icon, String title, bool isDone, bool isCurrent,
      {bool isLast = false}) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (isDone || isCurrent)
                    ? const Color(0xFFEA3E69)
                    : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: (isDone || isCurrent) ? Colors.white : Colors.grey),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: isDone ? const Color(0xFFEA3E69) : Colors.grey[200],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isCurrent ? const Color(0xFFEA3E69) : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildStickyFooter() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          border: const Border(top: BorderSide(color: Color(0x1F000000))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.support_agent, color: Colors.white),
              label: const Text('Contact Support',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEA3E69),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 12),
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2))),
          ],
        ),
      ),
    );
  }
}
