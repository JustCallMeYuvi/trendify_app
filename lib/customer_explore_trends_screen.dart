import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trendify/app_colors.dart';
import 'package:trendify/my_shopping_cart_screen.dart';
import 'package:trendify/product_details_screen.dart';
import 'package:trendify/profile_screen.dart';

class CustomerExploreTrendsScreen extends StatelessWidget {
  const CustomerExploreTrendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trendify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEE2B5B),
          primary: const Color(0xFFEE2B5B),
        ),
        fontFamily: 'Inter', // Ensure you add Inter to pubspec.yaml
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F6F6),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Trendify',
          style: TextStyle(
            color: Color(0xFFEE2B5B),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_outlined,
                  color: Colors.black87),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16, left: 8),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for dresses, brands...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Categories
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  CategoryItem(
                      label: 'Men', icon: Icons.man, color: Colors.blue),
                  CategoryItem(
                      label: 'Women', icon: Icons.woman, color: Colors.pink),
                  CategoryItem(
                      label: 'Kids',
                      icon: Icons.child_care,
                      color: Colors.orange),
                  CategoryItem(
                      label: 'Offers',
                      icon: Icons.local_offer,
                      color: AppColors.emerald),
                  CategoryItem(
                      label: 'Luxury', icon: Icons.watch, color: Colors.purple),
                ],
              ),
            ),

            // Featured Banner
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: const DecorationImage(
                    image: NetworkImage(
                        'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=800'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFEE2B5B).withOpacity(0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'LIMITED TIME',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2),
                          ),
                          const Text(
                            'SEASONAL SALE',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Up to 50% Off New Arrivals',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFFEE2B5B),
                              shape: const StadiumBorder(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                            ),
                            child: const Text('SHOP NOW',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            // New Trends Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('New Trends',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All',
                        style: TextStyle(color: Color(0xFFEE2B5B))),
                  ),
                ],
              ),
            ),

            // Product Grid
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: GridView.builder(
            //     shrinkWrap: true,
            //     physics: const NeverScrollableScrollPhysics(),
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2,
            //       childAspectRatio: 0.65,
            //       crossAxisSpacing: 16,
            //       mainAxisSpacing: 16,
            //     ),
            //     itemCount: products.length,
            //     itemBuilder: (context, index) => ProductCard(product: products[index]),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("products")
                    .orderBy("createdAt", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No Products Available"));
                  }

                  final docs = snapshot.data!.docs;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: docs.length,
                    // itemBuilder: (context, index) {
                    //   final data = docs[index].data() as Map<String, dynamic>;

                    //   return ProductCard(
                    //     product: Product(
                    //       name: data["name"] ?? "",
                    //       brand: data["category"] ?? "",
                    //       price: (data["price"] ?? 0).toDouble(),
                    //       rating: 4.5,
                    //       // image: (data["imageUrls"] != null &&
                    //       //         data["imageUrls"].isNotEmpty)
                    //       //     ? data["imageUrls"][0]
                    //       //     : "https://lh3.googleusercontent.com/aida-public/AB6AXuDMq4boT_8LPuye8AUOZNqLN5qcovxLYLzFbTaj399iD6-62hLv5d53Bs_kJzoM1ne2ZOupHqiS-vYBz8fSENXUMYjj_IpJTsy_4BM_JlGhfzrPBGooPl24lISW9BgXui6GKcABMFAYDy83frOZIj7bk2P5CzUPEyFAyRZOSPp7t9M8SEYMOBcpjWMFgHsJHAh6L7d6KRBuqg2Dbr2cDk5UPQirQ18IduqUS4zWGv4Yy_1WTYlM366XKondJkxYjoSojt-00FqOww",
                    //         imageUrls: List<String>.from(data["imageUrls"] ?? []),
                    //       isNew: true,

                    //     ),

                    //   );

                    // },
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = docs[index].data() as Map<String, dynamic>;

                      final product = Product(
                        doc.id, // 🔥 FIRST positional parameter
                        name: data["name"] ?? "",
                        brand: data["category"] ?? "",
                        description: data["description"] ?? "",
                        price: (data["price"] ?? 0).toDouble(),
                        // imageUrls: List<String>.from(data["imageUrls"] ?? []),
                        imageUrls: data["imageUrls"] != null
                            ? List<String>.from(data["imageUrls"])
                            : [],
                        // sizes: List<String>.from(data["sizes"] ?? []),
                        sizes: data["sizes"] != null
                            ? List<String>.from(data["sizes"])
                            : [],
                        rating: 4.5,
                        isNew: true,
                      );

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailScreen(product: product),
                            ),
                          );
                        },
                        child: ProductCard(product: product),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        // onTap: (index) => setState(() => _selectedIndex = index),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 3) {
            // CART Screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ShoppingCartScreen(),
              ),
            );
          }
          if (index == 4) {
            // PROFILE index
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfileScreen(),
              ),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFEE2B5B),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle:
            const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'HOME'),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view), label: 'EXPLORE'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'WISHLIST'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: 'CART'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'PROFILE'),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const CategoryItem(
      {super.key,
      required this.label,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  child:
                      //  Image.network(
                      //     product.imageUrls.isNotEmpty
                      //         ? product.imageUrls.first
                      //         : 'https://lh3.googleusercontent.com/aida-public/AB6AXuCIq7d-7AeFjDaskOfM93tQSrm4-BqyyRcUDa19QPp6RUBkv_vUIQaQxhmX3sQX_4zanCndfpZlONmNiDVBDdqpaBfwGLl0zu8-j_KNUnBEcy_iwaZT55X9xLq4cl8sOA86MEJ0PftnNKPIVTwgyRcX7bwYYOAgPf6i_RE934P4vsogf_-B3tdLzZhFymwuG_QNMlav5upagcVBjSbpIwML5hqBuureCRbvVVhMP4Rbwrpi0dvDYO4qTrVWvuYOmX1b3mLalne36A',
                      //     fit: BoxFit.cover,
                      //     width: double.infinity),
                      product.imageUrls.isNotEmpty
                          ? Image.memory(
                              base64Decode(product.imageUrls.first),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : Image.network(
                              "https://lh3.googleusercontent.com/aida-public/AB6AXuCIq7d-7AeFjDaskOfM93tQSrm4-BqyyRcUDa19QPp6RUBkv_vUIQaQxhmX3sQX_4zanCndfpZlONmNiDVBDdqpaBfwGLl0zu8-j_KNUnBEcy_iwaZT55X9xLq4cl8sOA86MEJ0PftnNKPIVTwgyRcX7bwYYOAgPf6i_RE934P4vsogf_-B3tdLzZhFymwuG_QNMlav5upagcVBjSbpIwML5hqBuureCRbvVVhMP4Rbwrpi0dvDYO4qTrVWvuYOmX1b3mLalne36A",
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.8),
                    radius: 16,
                    child: const Icon(Icons.favorite_border,
                        size: 18, color: Color(0xFFEE2B5B)),
                  ),
                ),
                if (product.isNew)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: const Color(0xFFEE2B5B),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Text('NEW',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.brand,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
                Text(product.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${product.price}',
                        style: const TextStyle(
                            color: Color(0xFFEE2B5B),
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(product.rating.toString(),
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// class Product {
//   final String name, brand, image;
//   final double price, rating;
//   final bool isNew;
//   Product(
//       {required this.name,
//       required this.brand,
//       required this.image,
//       required this.price,
//       required this.rating,
//       this.isNew = false});
// }

// final List<Product> products = [
//   Product(
//     name: 'Silk Floral Maxi Dress',
//     brand: 'Aura Collection',
//     price: 129.00,
//     rating: 4.8,
//     image:
//         'https://lh3.googleusercontent.com/aida-public/AB6AXuDMq4boT_8LPuye8AUOZNqLN5qcovxLYLzFbTaj399iD6-62hLv5d53Bs_kJzoM1ne2ZOupHqiS-vYBz8fSENXUMYjj_IpJTsy_4BM_JlGhfzrPBGooPl24lISW9BgXui6GKcABMFAYDy83frOZIj7bk2P5CzUPEyFAyRZOSPp7t9M8SEYMOBcpjWMFgHsJHAh6L7d6KRBuqg2Dbr2cDk5UPQirQ18IduqUS4zWGv4Yy_1WTYlM366XKondJkxYjoSojt-00FqOww',
//   ),
//   Product(
//     name: 'Premium Linen Blazer',
//     brand: 'Urban Tailor',
//     price: 185.00,
//     rating: 4.9,
//     isNew: true,
//     image:
//         'https://lh3.googleusercontent.com/aida-public/AB6AXuCIq7d-7AeFjDaskOfM93tQSrm4-BqyyRcUDa19QPp6RUBkv_vUIQaQxhmX3sQX_4zanCndfpZlONmNiDVBDdqpaBfwGLl0zu8-j_KNUnBEcy_iwaZT55X9xLq4cl8sOA86MEJ0PftnNKPIVTwgyRcX7bwYYOAgPf6i_RE934P4vsogf_-B3tdLzZhFymwuG_QNMlav5upagcVBjSbpIwML5hqBuureCRbvVVhMP4Rbwrpi0dvDYO4qTrVWvuYOmX1b3mLalne36A',
//   ),
//   Product(
//     name: 'Patterned Wrap Skirt',
//     brand: 'Boho Chic',
//     price: 64.00,
//     rating: 4.5,
//     image:
//         'https://lh3.googleusercontent.com/aida-public/AB6AXuCeu9m-G10ZJDCJpcQhWBZq7onGtWOEg_QfB7HrJSP0hQ5lZw9uxdZLYuu9KoaZgz0Qr5jf24MTVNeaqx_Z0PPYCgzcK1CQTcxcdxpbq2NuvgYQ2k_PYDgbTWp7uSpwzlRzKBOOabW_hYPI0kPI33Ov1hS-8drR2pYrHLL3mqU-5_HXAXXKXeyetbpPihu3cnn9CFl8cHUfvA8anDIYsT2M00jGnHR3bNCspk9p_7RM_EnsiazgMs1Cw4N4zr5x6ueAwQOp9F3gow',
//   ),
//   Product(
//     name: 'Organic Cotton Tee',
//     brand: 'Essentials',
//     price: 35.00,
//     rating: 5.0,
//     image:
//         'https://lh3.googleusercontent.com/aida-public/AB6AXuDPNT4r-qru7EoUdByhXUKlRs0pv7gTihCuBMVCJbOT2Ywt1G8RyZ7pK1ccnvFDFUhxrr_Fv-mlNr6x20viUw9h_8vDng4_JaBR-im72rfWg9zCrCb9_AjNpjo6_L9z4jYz47JV9dytyqKqQMF30si8Gxu9e0gbmz3iUiFoDERSd9n_T1aAh3FVbXSIW2FnGqCdjCU3GpJgCaXeuuqZdPFi9uV0aZXTqNa4kDOioOUPEMHriSkpHL_7ugYItxXSFr6nLasWcBGBkA',
//   ),
// ];

class Product {
  final String id; // 🔥 ADD THIS
  final String name;
  final String brand;
  final String description;
  final List<String> imageUrls;
  final List<String> sizes;
  final double price;
  final double rating;
  final bool isNew;

  Product(
    this.id, {
    required this.name,
    required this.brand,
    required this.description,
    required this.imageUrls,
    required this.sizes,
    required this.price,
    required this.rating,
    this.isNew = false,
  });
}
