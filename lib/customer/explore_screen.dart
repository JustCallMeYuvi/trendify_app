import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String activeCategory = 'All';
  int activeIndex = 1;

  final List<String> categories = ['All', 'Dresses', 'Tops', 'Suits', 'Skirts'];

  final List<Product> products = [
    Product(
      brand: 'LUXE STUDIO',
      name: 'Emerald Silk Wrap Dress',
      price: 189.00,
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBmP4C-_gR-U4q8LNlwu3hIUFzM3xZdSBLfIom-WqY2QONhHTLx6gGngxp-_WgvuC0IOwmtAICrRCTcwXAdRXj6oF4j3xzhjzTveehsZT7rrGT3XBPrtJrv7-r-DRl0lUdcoNDSpF_1AcxFmmAN5cYDk_6xmmZxyhq3H0ROAOacsdJ1t-iLNvJ0rMwSwujiIAUFXE6_o2MOKS5xABYLR8CAuA_uiOcv-8MCbSHWyVCu6muENFpox3pZO7MCXEtRZV0NFyLhGhOnsw',
      isFavorite: true,
    ),
    Product(
      brand: 'FLORA & CO',
      name: 'Petal Blossom Midi',
      price: 124.00,
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAVLm64yivP5Df_jFWdBN4RejQuNCai3PhaGwRGshGTFoPPcGJ5yY6qobV3OWElr4qjrliJnzZ8CiWG4fTob9SgF5D6qnXBi1GdkxcQMBNGG6Xuu1TaBd-2eK_zPKrWlGVsBQER59Yi2WOc5K9tBbYi2Ac9diehFqmIQVMjmHGiSRuItDaVicQDNiMmZLWoBD30FsW5xBL7DniPr3GUVXJn4DyHyHF_afQzg2MqTUQeNYyqGpydcb60X7vzrDTuW1yi2UVdCHi0RQ',
      isFavorite: false,
    ),
    Product(
      brand: 'MINIMALIST',
      name: 'Linen Breeze Shift',
      price: 95.00,
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA1EIGRUTtWVZwVaHVoiTy2yjGCVpMMNxKxZ9CcTCdpJpo5-sWYp4ENuQRj7WSQ5Bcd1NwBlrv25dm3xS_fjhSi_uEb9ivhvVYCz_ebYf95-Mzu0jaOQhb4OOy10MT72HTaG8cFYIkhElIOx9SdGqwsF_V67gVl6vRmnRenEr1H6bhqzbCf0cjQHcZCHZpDwY7ZaCfpHuxXJwxNuzizQubPnbGfKH5j38pjkxRqWMFsHM_ybqC706fr5t0K8a7MpSsJFTH94jxi0w',
      isFavorite: false,
    ),
    Product(
      brand: 'NOIR LABEL',
      name: 'Midnight Cutout Dress',
      price: 210.00,
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuARLsGfzXfVQp263IQRHtrwkLY9DV3_X32g1QFQEbkvO5nc5i2rg4-3gKLc4T4w6x1ItM5qPqcMU3-yCaTgmC9Pwi275uC9xscGFp5EpSAs4C5GUhf7rkNb3oGSLjdk6T3D7hELaZyIyg-lsi9aBQjzTaGR6fpJ9APWrngA3qQQZ-7tcsFJAvbm54_h3boqJzWM9ECaW44r8P_wTcnThrGEkFacDPtw5bH-Jju6u08plFsAlJqeG7z9Q0g6B5SV3QzGUICK7Uu4dg',
      isFavorite: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F6),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Trendify',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none_outlined),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.shopping_bag_outlined),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search dresses, brands...',
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEE2B5B),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Categories
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = activeCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => activeCategory = category);
                      },
                      selectedColor: const Color(0xFFEE2B5B),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide.none,
                      showCheckmark: false,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Trending Collection Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Trending Collection',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See All',
                      style: TextStyle(color: Color(0xFFEE2B5B)),
                    ),
                  ),
                ],
              ),
            ),
            // Product Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(product: product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: DecorationImage(
                    image: NetworkImage(product.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: const Color(0xFFEE2B5B),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.brand,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFEE2B5B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add, color: Color(0xFFEE2B5B), size: 20),
            ),
          ],
        ),
      ],
    );
  }
}

class Product {
  final String brand;
  final String name;
  final double price;
  final String image;
  final bool isFavorite;

  Product({
    required this.brand,
    required this.name,
    required this.price,
    required this.image,
    required this.isFavorite,
  });
}
