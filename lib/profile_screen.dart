import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trendify/login_screen.dart';
import 'package:trendify/my_order_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () {},
        // ),
        title: const Text(
          'My Trendify Profile',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      // body: SingleChildScrollView(
      //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      //   child: Column(
      //     children: [
      //       // Profile Hero
      //       Center(
      //         child: Stack(
      //           children: [
      //             Container(
      //               decoration: BoxDecoration(
      //                 shape: BoxShape.circle,
      //                 border: Border.all(color: Colors.white, width: 4),
      //                 boxShadow: [
      //                   BoxShadow(
      //                     color: Colors.black.withOpacity(0.1),
      //                     blurRadius: 20,
      //                     offset: const Offset(0, 10),
      //                   ),
      //                 ],
      //               ),
      //               child: const CircleAvatar(
      //                 radius: 60,
      //                 backgroundImage: NetworkImage(
      //                   'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=256',
      //                 ),
      //               ),
      //             ),
      //             Positioned(
      //               bottom: 5,
      //               right: 5,
      //               child: Container(
      //                 padding: const EdgeInsets.all(6),
      //                 decoration: BoxDecoration(
      //                   color: const Color(0xFFEE2B5B),
      //                   shape: BoxShape.circle,
      //                   border: Border.all(color: Colors.white, width: 2),
      //                 ),
      //                 child:
      //                     const Icon(Icons.edit, color: Colors.white, size: 16),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       const SizedBox(height: 16),
      //       const Text(
      //         'Alexandra Vane',
      //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      //       ),
      //       const Text(
      //         'alexandra.vane@trendify.com',
      //         style: TextStyle(
      //             color: Colors.grey,
      //             fontSize: 14,
      //             fontWeight: FontWeight.w500),
      //       ),
      //       const SizedBox(height: 32),

      //       // Personal Information Card
      //       _buildInfoCard(
      //         icon: Icons.person_outline,
      //         title: 'Personal Information',
      //         children: [
      //           _buildInfoRow('Full Name', 'Alexandra Vane'),
      //           _buildInfoRow('Phone', '+1 (555) 892-4412'),
      //           _buildInfoRow('Email', 'alexandra.vane@trendify.com'),
      //         ],
      //       ),
      //       const SizedBox(height: 16),

      //       // Shipping Address Card
      //       _buildInfoCard(
      //         icon: Icons.local_shipping_outlined,
      //         title: 'Primary Shipping Address',
      //         trailing: Container(
      //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      //           decoration: BoxDecoration(
      //             color: const Color(0xFFEE2B5B).withOpacity(0.1),
      //             borderRadius: BorderRadius.circular(20),
      //           ),
      //           child: const Text(
      //             'HOME',
      //             style: TextStyle(
      //                 color: Color(0xFFEE2B5B),
      //                 fontSize: 10,
      //                 fontWeight: FontWeight.bold),
      //           ),
      //         ),
      //         child: Row(
      //           children: [
      //             ClipRRect(
      //               borderRadius: BorderRadius.circular(12),
      //               child: Image.network(
      //                 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?q=80&w=200',
      //                 width: 80,
      //                 height: 80,
      //                 fit: BoxFit.cover,
      //               ),
      //             ),
      //             const SizedBox(width: 16),
      //             const Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text('4521 Riverside Avenue',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.bold, fontSize: 14)),
      //                 Text('Apartment 4B, Upper West Side',
      //                     style: TextStyle(color: Colors.grey, fontSize: 12)),
      //                 Text('New York, NY 10024',
      //                     style: TextStyle(color: Colors.grey, fontSize: 12)),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //       const SizedBox(height: 16),

      //       // Account Role Card
      //       _buildActionCard(
      //         icon: Icons.verified_user_outlined,
      //         title: 'Account Role',
      //         value: 'Customer',
      //       ),
      //       const SizedBox(height: 24),

      //       // Quick Links
      //       _buildQuickLink(Icons.history, 'Order History'),
      //       _buildQuickLink(Icons.map_outlined, 'My Saved Addresses'),
      //       const SizedBox(height: 24),

      //       // Logout Button
      //       SizedBox(
      //         width: double.infinity,
      //         child: TextButton.icon(
      //           onPressed: () {},
      //           icon: const Icon(Icons.logout, color: Color(0xFFEE2B5B)),
      //           label: const Text('Logout',
      //               style: TextStyle(
      //                   color: Color(0xFFEE2B5B), fontWeight: FontWeight.bold)),
      //           style: TextButton.styleFrom(
      //             backgroundColor: const Color(0xFFEE2B5B).withOpacity(0.1),
      //             padding: const EdgeInsets.symmetric(vertical: 16),
      //             shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(16)),
      //           ),
      //         ),
      //       ),
      //       const SizedBox(height: 80), // Space for bottom nav
      //     ],
      //   ),
      // ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return const Center(child: Text("User data not found"));
          }

          final userData = userSnapshot.data!.data() as Map<String, dynamic>;

          final name = userData['fullName'] ?? "No Name";
          final phone = userData['phone'] ?? "No Phone";
          final role = userData['role'] ?? "Customer";
          final email = userData['email'] ??
              FirebaseAuth.instance.currentUser?.email ??
              "";

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                /// 🔥 PROFILE HERO
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=256',
                  ),
                ),
                const SizedBox(height: 16),

                Text(name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                Text(email,
                    style: const TextStyle(color: Colors.grey, fontSize: 14)),

                const SizedBox(height: 32),

                /// 🔥 PERSONAL INFO
                _buildInfoCard(
                  icon: Icons.person_outline,
                  title: 'Personal Information',
                  children: [
                    _buildInfoRow('Full Name', name),
                    _buildInfoRow('Phone', phone),
                    _buildInfoRow('Email', email),
                  ],
                ),

                const SizedBox(height: 16),

                /// 🔥 DEFAULT ADDRESS STREAM
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('addresses')
                      .where('isDefault', isEqualTo: true)
                      .snapshots(),
                  builder: (context, addressSnapshot) {
                    if (addressSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (!addressSnapshot.hasData ||
                        addressSnapshot.data!.docs.isEmpty) {
                      print("No default address found");
                      return const SizedBox();
                    }

                    final addressData = addressSnapshot.data!.docs.first.data()
                        as Map<String, dynamic>;

                    print("Address Data: $addressData"); // 🔥 Debug

                    return _buildInfoCard(
                      icon: Icons.local_shipping_outlined,
                      title: 'Primary Shipping Address',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${addressData['house'] ?? ''}, ${addressData['area'] ?? ''}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${addressData['city'] ?? ''} - ${addressData['pincode'] ?? ''}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                /// 🔥 ROLE
                _buildActionCard(
                  icon: Icons.verified_user_outlined,
                  title: 'Account Role',
                  value: role,
                ),
                const SizedBox(height: 16),

                //       // Quick Links
                _buildQuickLink(
                  Icons.history,
                  'Order History',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OrderHistoryScreen(),
                      ),
                    );
                  },
                ),
                _buildQuickLink(
                    Icons.map_outlined, 'My Saved Addresses', () {}),
                const SizedBox(height: 24),

                const SizedBox(height: 24),

                /// 🔥 LOGOUT
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () async {
                      final shouldLogout = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: const Text(
                            "Logout",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content:
                              const Text("Are you sure you want to logout?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text(
                                "Logout",
                                style: TextStyle(
                                  color: Color(0xFFEE2B5B),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (shouldLogout == true) {
                        await FirebaseAuth.instance.signOut();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    icon: const Icon(Icons.logout, color: Color(0xFFEE2B5B)),
                    label: const Text('Logout',
                        style: TextStyle(
                            color: Color(0xFFEE2B5B),
                            fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFEE2B5B).withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   selectedItemColor: const Color(0xFFEE2B5B),
      //   unselectedItemColor: Colors.grey,
      //   currentIndex: 3,
      //   selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      //   unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'SHOP'),
      //     BottomNavigationBarItem(icon: Icon(Icons.search), label: 'EXPLORE'),
      //     BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'CART'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PROFILE'),
      //   ],
      // ),
    );
  }

  Widget _buildInfoCard(
      {required IconData icon,
      required String title,
      Widget? trailing,
      Widget? child,
      List<Widget>? children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: const Color(0xFFEE2B5B), size: 20),
                  const SizedBox(width: 12),
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              if (trailing != null) trailing,
            ],
          ),
          if (child != null) ...[const SizedBox(height: 16), child],
          if (children != null) ...[const SizedBox(height: 16), ...children],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildActionCard(
      {required IconData icon, required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFEE2B5B), size: 20),
              const SizedBox(width: 12),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          Row(
            children: [
              Text(value,
                  style: const TextStyle(
                      color: Color(0xFFEE2B5B),
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLink(
    IconData icon,
    String label,
    VoidCallback? onTap,
  ) {
    return ListTile(
      onTap: onTap, // 🔥 THIS WAS MISSING
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFEE2B5B).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFFEE2B5B), size: 20),
      ),
      title: Text(label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }
}
