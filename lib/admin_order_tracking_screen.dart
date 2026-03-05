import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminOrderStatusScreen extends StatefulWidget {
  final String orderId;
  final String customerName;
  final String price;
  final String status;
  final String imageUrl;
  final String orderNumber;
  const AdminOrderStatusScreen(
      {super.key,
      required this.orderId,
      required this.customerName,
      required this.price,
      required this.status,
      required this.imageUrl,
      required this.orderNumber});

  @override
  State<AdminOrderStatusScreen> createState() => _AdminOrderStatusScreenState();
}

class _AdminOrderStatusScreenState extends State<AdminOrderStatusScreen> {
  // String currentStatus = 'Packed';
  // List<String> completedStatuses = ['Packed'];
  late String currentStatus;
  late List<String> completedStatuses;
  @override
  void initState() {
    super.initState();

    currentStatus = widget.status;
    completedStatuses = [widget.status];

    _loadOrderStatus(); // 🔥 fetch latest status from Firestore
  }

  // void _updateStatus(String status) {
  //   setState(() {
  //     currentStatus = status;
  //     if (!completedStatuses.contains(status)) {
  //       completedStatuses.add(status);
  //     }
  //   });
  // }
  void _confirmStatusUpdate(String status) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Confirm Status Update",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Are you sure you want to update order status to \"$status\"?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEE2B5B),
              ),
              onPressed: () async {
                /// Save messenger before pop
                final messenger = ScaffoldMessenger.of(context);

                Navigator.pop(dialogContext);

                int index = statusFlow.indexOf(status);

                /// 🔥 Prevent skipping status
                int currentIndex = statusFlow.indexOf(currentStatus);

                if (index > currentIndex + 1) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text("Please complete previous status first"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                } 

                /// Update UI
                setState(() {
                  currentStatus = status;
                  completedStatuses = statusFlow.sublist(0, index + 1);
                });

                final Map<String, String> statusFieldMap = {
                  "Packed": "packedAt",
                  "Shipped": "shippedAt",
                  "Out for Delivery": "outForDeliveryAt",
                  "Delivered": "deliveredAt",
                };

                String? fieldName = statusFieldMap[status];

                /// 🔥 Update Firebase
                await FirebaseFirestore.instance
                    .collection('orders')
                    .doc(widget.orderId)
                    .update({
                  'status': status,
                  // '${status.toLowerCase().replaceAll(" ", "")}At':
                  //     FieldValue.serverTimestamp(),
                  if (fieldName != null)
                    fieldName: FieldValue.serverTimestamp(),
                });

                /// Show snackbar
                messenger.showSnackBar(
                  SnackBar(
                    content: Text("$status updated successfully"),
                    backgroundColor: const Color(0xFFEE2B5B),
                  ),
                );
              },
              child: const Text("Yes"),
            )
          ],
        );
      },
    );
  }

  final List<String> statusFlow = [
    'Packed',
    'Shipped',
    'Out for Delivery',
    'Delivered'
  ];

  Future<void> _loadOrderStatus() async {
    final doc = await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId)
        .get();

    if (doc.exists) {
      final data = doc.data();
      String status = data?['status'] ?? widget.status;

      int index = statusFlow.indexOf(status);

      setState(() {
        currentStatus = status;
        completedStatuses = statusFlow.sublist(0, index + 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Update Order Status',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.more_horiz, color: Colors.black),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderInfoCard(),
            const SizedBox(height: 24),
            _buildStatusManagement(),
            const SizedBox(height: 24),
            _buildOrderSummary(),
            const SizedBox(height: 120), // Space for footer
          ],
        ),
      ),
      // bottomSheet: _buildFooter(),
    );
  }

  Widget _buildOrderInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // 'ORDER #TD-8829',
                    // 'ORDER #${widget.orderId}',
                    'ORDER #${widget.orderNumber}',

                    style: const TextStyle(
                      color: Color(0xFFEE2B5B),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    // 'Esther Howard',
                    widget.customerName,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const Text(
                    'Placed on Oct 24, 2023 • 02:45 PM',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  // 'PROCESSING',
                  // widget.status.toUpperCase(),
                  currentStatus.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFEE2B5B),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: Color(0xFFF8F9FB)),
          ),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F3FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_on,
                    color: Colors.indigo, size: 20),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DELIVERY ADDRESS',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                  ),
                  Text(
                    '4140 Parker Rd. Richardson, Texas',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Status Management',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'TAP TO UPDATE',
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            _buildStatusBtn('Packed', Icons.inventory_2, 'COMPLETED'),
            _buildStatusBtn('Shipped', Icons.local_shipping, 'PENDING'),
            _buildStatusBtn(
                'Out for Delivery', Icons.directions_bike, 'UPCOMING'),
            _buildStatusBtn('Delivered', Icons.verified, 'UPCOMING'),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBtn(String label, IconData icon, String statusText) {
    bool isActive = currentStatus == label;
    bool isCompleted = completedStatuses.contains(label);

    return GestureDetector(
      // onTap: () => _updateStatus(label),
      onTap: () => _confirmStatusUpdate(label),

      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isActive ? const Color(0xFFEE2B5B) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? const Color(0xFFEE2B5B).withOpacity(0.1)
                  : Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: (isCompleted || isActive)
                        ? const Color(0xFFEE2B5B).withOpacity(0.1)
                        : const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: (isCompleted || isActive)
                        ? const Color(0xFFEE2B5B)
                        : Colors.grey[300],
                    size: 20,
                  ),
                ),
                const Spacer(),
                Text(
                  label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  isCompleted ? 'COMPLETED' : statusText,
                  style: TextStyle(
                    color: isCompleted ? const Color(0xFFEE2B5B) : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
            if (isCompleted)
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.check_circle,
                    color: Color(0xFFEE2B5B), size: 20),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            children: [
              _buildOrderItem('Floral Midi Dress', 'M', 'Pastel Pink', 89.00),
              const Divider(height: 1, color: Color(0xFFF8F9FB)),
              _buildOrderItem('Classic Silk Scarf', 'One Size', 'Cream', 35.00),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB).withOpacity(0.5),
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(32)),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow('Subtotal', '\$124.00'),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Shipping', '\$12.00'),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Color(0xFFE0E0E0)),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('\$136.00',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(String name, String size, String color, double price) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FB),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.image, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                Text('Size: $size | Color: $color',
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${price.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Color(0xFFEE2B5B),
                            fontWeight: FontWeight.bold)),
                    const Text('Qty: 01',
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
