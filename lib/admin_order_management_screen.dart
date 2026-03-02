import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({super.key});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  String activeFilter = 'All';

  Stream<QuerySnapshot> getOrdersStream() {
    if (activeFilter == 'All') {
      return FirebaseFirestore.instance
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('orders')
          .where('status', isEqualTo: activeFilter)
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
  }

  final List<Map<String, dynamic>> orders = [
    {
      'name': 'Sarah Jenkins',
      'id': '#TR-8941',
      'time': '12:45 PM',
      'amount': 128.00,
      'status': 'Pending',
      'image':
          'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=150&h=150&fit=crop'
    },
    {
      'name': 'Michael Chen',
      'id': '#TR-8942',
      'time': '11:20 AM',
      'amount': 89.50,
      'status': 'Processing',
      'image':
          'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=150&h=150&fit=crop'
    },
    {
      'name': 'Elena Rodriguez',
      'id': '#TR-8939',
      'time': '10:05 AM',
      'amount': 450.00,
      'status': 'Pending',
      'image':
          'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=150&h=150&fit=crop'
    },
    {
      'name': 'David Kim',
      'id': '#TR-8938',
      'time': 'Yesterday',
      'amount': 62.00,
      'status': 'Shipped',
      'image':
          'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=150&h=150&fit=crop'
    },
  ];

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    final difference = DateTime.now().difference(date);

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} mins ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hrs ago";
    } else {
      return "${difference.inDays} days ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = activeFilter == 'All'
        ? orders
        : orders.where((o) => o['status'] == activeFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F6F6).withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEE2B5B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.shopping_bag_outlined,
                  color: Color(0xFFEE2B5B)),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage Orders',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  'ORDER MANAGEMENT',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Color(0xFFEE2B5B),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.grey)),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.filter_list, color: Colors.grey)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Summary Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEE2B5B), Color(0xFFFF4D7D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEE2B5B).withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Orders to Process',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8), fontSize: 14),
                      ),
                      // const Text(
                      //   '24 Orders',
                      //   style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                      // ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('orders')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text(
                              "0 Orders",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold),
                            );
                          }

                          return Text(
                            "${snapshot.data!.docs.length} Orders",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.access_time,
                        color: Colors.white, size: 32),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Filters
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children:
                    ['All', 'Pending', 'Processing', 'Shipped'].map((filter) {
                  final isSelected = activeFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      onTap: () => setState(() => activeFilter = filter),
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFEE2B5B)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFEE2B5B)
                                : Colors.grey.shade200,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFFEE2B5B)
                                        .withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : null,
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            // Order List
            // ...filteredOrders.map((order) => Padding(
            //       padding: const EdgeInsets.only(bottom: 16),
            //       child: Container(
            //         padding: const EdgeInsets.all(16),
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(24),
            //           border: Border.all(color: Colors.grey.shade100),
            //         ),
            //         child: Row(
            //           children: [
            //             ClipRRect(
            //               borderRadius: BorderRadius.circular(16),
            //               child: Image.network(
            //                 order['image'],
            //                 width: 64,
            //                 height: 64,
            //                 fit: BoxFit.cover,
            //               ),
            //             ),
            //             const SizedBox(width: 16),
            //             Expanded(
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                     children: [
            //                       Text(
            //                         order['name'],
            //                         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            //                       ),
            //                       Text(
            //                         '\$${order['amount'].toStringAsFixed(2)}',
            //                         style: const TextStyle(
            //                           color: Color(0xFFEE2B5B),
            //                           fontWeight: FontWeight.bold,
            //                           fontSize: 14,
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   Text(
            //                     '${order['id']} • ${order['time']}',
            //                     style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            //                   ),
            //                   const SizedBox(height: 12),
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                     children: [
            //                       _buildStatusBadge(order['status']),
            //                       Row(
            //                         children: [
            //                           Text(
            //                             'Details',
            //                             style: TextStyle(
            //                               color: Colors.grey.shade400,
            //                               fontSize: 12,
            //                               fontWeight: FontWeight.bold,
            //                             ),
            //                           ),
            //                           Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 16),
            //                         ],
            //                       ),
            //                     ],
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     )),

            StreamBuilder<QuerySnapshot>(
              stream: getOrdersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No Orders Found"));
                }

                final orders = snapshot.data!.docs;

                return Column(
                  children: orders.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child:
                                  // Image.network(
                                  //   data['imageUrl'] ?? "https://picsum.photos/200",
                                  //   width: 64,
                                  //   height: 64,
                                  //   fit: BoxFit.cover,
                                  // ),
                                  data['imageUrl'] != null
                                      ? Image.memory(
                                          base64Decode(data['imageUrl']),
                                          width: 64,
                                          height: 64,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          "https://picsum.photos/200",
                                          width: 64,
                                          height: 64,
                                          fit: BoxFit.cover,
                                        ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data['customerName'] ?? '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        "\$${data['price']?.toStringAsFixed(2) ?? '0.00'}",
                                        style: const TextStyle(
                                          color: Color(0xFFEE2B5B),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${data['orderNumber']} • ${_formatTime(data['createdAt'])}",
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 12),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildStatusBadge(
                                          data['status'] ?? 'Pending'),
                                      const Icon(Icons.chevron_right),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 100), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'Pending':
        bgColor = const Color(0xFFFFF8E1);
        textColor = const Color(0xFFFFA000);
        break;
      case 'Processing':
        bgColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1976D2);
        break;
      case 'Shipped':
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF388E3C);
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
            color: textColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isActive = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            color: isActive ? const Color(0xFFEE2B5B) : Colors.grey.shade400),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: isActive ? const Color(0xFFEE2B5B) : Colors.grey.shade400,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
