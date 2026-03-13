import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Color primaryColor = const Color(0xFFEE2B5B);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: const Icon(Icons.menu, color: Colors.black87),
        title: const Text(
          'User Management',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: primaryColor.withOpacity(0.1),
              child: IconButton(
                icon: Icon(Icons.person_add, color: primaryColor, size: 20),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withOpacity(0.1)),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search name, email, or role',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: primaryColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColor,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            tabs: const [
              Tab(text: 'All Users'),
              Tab(text: 'Admins'),
              Tab(text: 'Customers'),
            ],
          ),

          // User List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUserList(), // All Users

                _buildUserList(role: "admin"), // Admins

                _buildUserList(role: "customer"), // Customers
              ],
            ),
          )
        ],
      ),
    );
  }

  /// USER LIST FROM FIREBASE
  Widget _buildUserList({String? role}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        var users = snapshot.data!.docs;

        /// FILTER ROLE
        if (role != null) {
          users = users.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return (data['role'] ?? "").toString().toLowerCase() == role;
          }).toList();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userDoc = users[index];
            final data = userDoc.data() as Map<String, dynamic>;

            return _buildUserCard(
              userId: userDoc.id,
              name: data['fullName'] ?? "No Name",
              email: data['email'] ?? "No Email",
              role: data['role'] ?? "customer",
              imageUrl: "https://i.pravatar.cc/150?img=$index",
              isAdmin: data['role'] == "admin",
            );
          },
        );
      },
    );
  }

  Widget _buildUserCard({
    required String userId,
    required String name,
    required String email,
    required String role,
    required String imageUrl,
    required bool isAdmin,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primaryColor.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isAdmin
                            ? primaryColor.withOpacity(0.1)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        role,
                        style: TextStyle(
                          color: isAdmin ? primaryColor : Colors.grey[500],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey, size: 20),
                onPressed: () {},
              ),
//             IconButton(
//   icon: const Icon(Icons.delete, color: Colors.grey),
//   onPressed: () async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .delete();
//   },
// ),
            ],
          ),
        ],
      ),
    );
  }
}
