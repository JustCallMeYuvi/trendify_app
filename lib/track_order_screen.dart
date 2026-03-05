import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrackOrderScreen extends StatefulWidget {
  final String orderId;
  const TrackOrderScreen({super.key, required this.orderId});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  String formatTime(Timestamp? time) {
    if (time == null) return "";

    DateTime date = time.toDate();

    int hour = date.hour > 12 ? date.hour - 12 : date.hour;
    String period = date.hour >= 12 ? "PM" : "AM";

    return "${date.day}/${date.month}  $hour:${date.minute.toString().padLeft(2, '0')} $period";
  }

  String formatDate(DateTime? date) {
    if (date == null) return "Delivery date pending";

    return "${date.day}/${date.month}/${date.year}";
  }

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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(widget.orderId)
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
          final orderNumber = orderData['orderNumber'] ?? widget.orderId;
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
                    _buildTrackingStepper(status, orderData),
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
                status == "Delivered"
                    ? "Delivered on: ${formatDate(expectedDelivery)}"
                    : "Expected: ${formatDate(expectedDelivery)}",
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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('YOUR COURIER',
                            style: TextStyle(
                                fontSize: 8,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        Text('Marcus Johnson',
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

  Widget _buildTrackingStepper(String status, Map<String, dynamic> orderData) {
    final statusFlow = ['Packed', 'Shipped', 'Out for Delivery', 'Delivered'];
    // int currentStep = 0;

    // switch (status) {
    //   case 'confirmed':
    //     currentStep = 0;
    //     break;
    //   case 'packed':
    //     currentStep = 1;
    //     break;
    //   case 'shipped':
    //     currentStep = 2;
    //     break;
    //   case 'out_for_delivery':
    //     currentStep = 3;
    //     break;
    //   case 'delivered':
    //     currentStep = 4;
    //     break;
    // }

    // 🔥 Get current step
    int currentStep = statusFlow.indexOf(status);

    // 🔥 Protection if status not found
    if (currentStep == -1) currentStep = 0;

    return Column(
      children: [
        // _buildStep(
        //     Icons.check, 'Order Confirmed', currentStep >= 0, currentStep == 0),
        // _buildStep(
        //     Icons.inventory_2, 'Packed', currentStep >= 1, currentStep == 1),
        // _buildStep(Icons.local_shipping, 'Shipped', currentStep >= 2,
        //     currentStep == 2),
        // _buildStep(Icons.delivery_dining, 'Out for Delivery', currentStep >= 3,
        //     currentStep == 3),
        // _buildStep(
        //     Icons.task_alt, 'Delivered', currentStep >= 4, currentStep == 4,
        //     isLast: true),
        _buildStep(Icons.check, 'Packed', formatTime(orderData['packedAt']),
            currentStep >= 0, currentStep == 0),

        _buildStep(
            Icons.inventory_2,
            'Shipped',
            formatTime(orderData['shippedAt']),
            currentStep >= 1,
            currentStep == 1),

        _buildStep(
            Icons.local_shipping,
            'Out for Delivery',
            formatTime(orderData['outfordeliveryAt']),
            currentStep >= 2,
            currentStep == 2),

        _buildStep(
            Icons.task_alt,
            'Delivered',
            formatTime(orderData['deliveredAt']),
            currentStep >= 3,
            currentStep == 3,
            isLast: true),
      ],
    );
  }

  Widget _buildStep(
      IconData icon, String title, String time, bool isDone, bool isCurrent,
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
        // Text(
        //   title,
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     color: isCurrent ? const Color(0xFFEA3E69) : Colors.black,
        //   ),
        // ),
        /// 🔥 Title + Time
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isCurrent ? const Color(0xFFEA3E69) : Colors.black,
              ),
            ),
            if (time.isNotEmpty)
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
          ],
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
