import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trendify/app_colors.dart';
import 'package:trendify/track_order_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'My Orders History',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black, size: 28),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search & Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search orders...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.tune, color: Color(0xFFF43F5E)),
                ),
              ],
            ),
          ),
          // Tab Bar
          TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFFF43F5E),
            indicatorWeight: 2,
            labelColor: const Color(0xFFF43F5E),
            unselectedLabelColor: Colors.grey,
            labelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: const [
              Tab(text: 'Active Orders'),
              Tab(text: 'Past Orders'),
            ],
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveOrdersList(),
                const Center(child: Text('No past orders found.')),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFF43F5E),
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: 'Shop'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Orders'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  // Widget _buildActiveOrdersList() {
  //   return ListView(
  //     padding: const EdgeInsets.all(20),
  //     children: [
  //       const OrderCard(
  //         id: 'TRND-5542',
  //         title: 'Velvet Evening Gown',
  //         date: 'Oct 12, 2023',
  //         items: 1,
  //         price: '124.00',
  //         status: 'OUT FOR DELIVERY',
  //         statusColor: Colors.orange,
  //         image:
  //             'https://images.unsplash.com/photo-1566174053879-31528523f8ae?q=80&w=400&auto=format&fit=crop',
  //         actions: ['Track'],
  //       ),
  //       const OrderCard(
  //         id: 'TRND-5531',
  //         title: 'Floral Midi Summer Dress',
  //         date: 'Oct 10, 2023',
  //         items: 1,
  //         price: '89.00',
  //         status: 'ORDER PLACED',
  //         statusColor: Colors.blue,
  //         image:
  //             'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?q=80&w=400&auto=format&fit=crop',
  //         actions: ['Details'],
  //       ),
  //       const SizedBox(height: 20),
  //       // Section Header
  //       Row(
  //         children: [
  //           const Text(
  //             'RECENTLY DELIVERED',
  //             style: TextStyle(
  //                 color: Colors.grey,
  //                 fontWeight: FontWeight.w900,
  //                 fontSize: 11,
  //                 letterSpacing: 1.2),
  //           ),
  //           const SizedBox(width: 10),
  //           Expanded(child: Container(height: 1, color: Colors.grey.shade200)),
  //         ],
  //       ),
  //       const SizedBox(height: 20),
  //       const OrderCard(
  //         id: 'TRND-5490',
  //         title: 'Silk Cocktail Dress',
  //         date: 'Oct 05, 2023',
  //         items: 2,
  //         price: '156.00',
  //         status: 'DELIVERED',
  //         statusColor: AppColors.emerald,
  //         image:
  //             'https://images.unsplash.com/photo-1566174053879-31528523f8ae?q=80&w=400&auto=format&fit=crop',
  //         actions: ['Reorder', 'Leave Review'],
  //       ),
  //     ],
  //   );
  // }
  Widget _buildActiveOrdersList() {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: user?.uid)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No Orders Found"));
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;

            final status = data['status'] ?? "placed";
            final createdAt = (data['createdAt'] as Timestamp?)?.toDate();

            return OrderCard(
              orderId: doc.id, // 🔥 important
              id: doc.id,
              title: data['productName'] ?? "",
              date: createdAt != null
                  ? "${createdAt.day}/${createdAt.month}/${createdAt.year}"
                  : "",
              items: 1,
              price: data['price'].toString(),
              status: status.toUpperCase(),
              statusColor: _getStatusColor(status),
              image: data['image'] ?? "https://picsum.photos/200",
              actions: _getActions(status),
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'placed':
        return Colors.blue;
      case 'packed':
        return Colors.orange;
      case 'shipped':
        return Colors.purple;
      case 'out_for_delivery':
        return Colors.deepOrange;
      case 'delivered':
        return AppColors.emerald;
      default:
        return Colors.grey;
    }
  }

  List<String> _getActions(String status) {
    if (status == 'delivered') {
      return ['Reorder', 'Review'];
    }
    return ['Track'];
  }
}

class OrderCard extends StatelessWidget {
  final String orderId; // 🔥 add this
  final String id;
  final String title;
  final String date;
  final int items;
  final String price;
  final String status;
  final Color statusColor;
  final String image;
  final List<String> actions;

  const OrderCard({
    super.key,
    required this.orderId, // 🔥 required
    required this.id,
    required this.title,
    required this.date,
    required this.items,
    required this.price,
    required this.status,
    required this.statusColor,
    required this.image,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // Order Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#$id',
                      style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 11),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor.withOpacity(0.2)),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  '$date • $items ${items == 1 ? 'Item' : 'Items'}',
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 12),
                // Price and Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$$price',
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                    Row(
                      children: actions.map((action) {
                        final isPrimary = action == 'Track';
                        return Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: ElevatedButton(
                            // onPressed: () {},
                            onPressed: () {
                              if (action == 'Track') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TrackOrderScreen(orderId: orderId),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isPrimary
                                  ? const Color(0xFFF43F5E)
                                  : const Color(0xFFF1F5F9),
                              foregroundColor:
                                  isPrimary ? Colors.white : Colors.black87,
                              elevation: isPrimary ? 4 : 0,
                              shadowColor:
                                  const Color(0xFFF43F5E).withOpacity(0.4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              minimumSize: const Size(0, 32),
                            ),
                            child: Text(action,
                                style: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
