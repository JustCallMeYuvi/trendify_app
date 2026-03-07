import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trendify/customer/product_card_widget.dart';
import 'package:trendify/customer_explore_trends_screen.dart';
import 'package:trendify/place_order_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String selectedSize = 'M';
  Color selectedColor = const Color(0xFF1A1A2E);
  bool isFavorite = true;
  int activeImageIndex = 0;
  late List<String> images;

  // final List<String> images = [
  //   "https://lh3.googleusercontent.com/aida-public/AB6AXuC32XNfJQQ4xVplKfJKsKqmXz6nCt1rniEMTASUtKfHgUZfgkFYYDZJ2ziyYjxj3i-89sVP0JNv6vUp01v7d4zMUpw1zaWxCmoyxchY3JQIXeFkhqGNg8JAA4M4EuD65o0j0Vk0Ayr4IyBMnYAoVLT3oh_t6tWbBrUWLJNGv_G4ExXINg69Iz4PydeCis2v5GnyJA6bzk6nfOIeF0Er0ObY0KLO9fEa-JsPrxhYNZd-0PjhDy41YJfTyhRDnLFL2MbTdo5KfN90aQ",
  //   "https://lh3.googleusercontent.com/aida-public/AB6AXuCTLwdkxDafYLWw94ntlaHoioYoaMtTU-pvkd-QXG_AfI65YPrfaRa-pryZWsh03fFUK9GalpJFSrF9vdlmyMC-HOAIyouSZFwAmv8dAXeGmAeq9PACgCUMg23uQZTX14xtxxMn4BCotlKNzXkc844RyfJCNgEBYe-UTDdeeQ5I-yHp7_CY4jiBkiB-0hskh8X9-MxQGDpQuSRSYDEA13JwHlFZKyfzc3L88wClF2rCOkbHkdWO00qUr_y2aOlP-4yOHwioVMshfg",
  //   "https://lh3.googleusercontent.com/aida-public/AB6AXuDWUWTp0f5Td9ilhdXGKuuwlqsIUd2shZvO0EhIiuvj8uEfFiVVPuKQeatHOAr1hW3_ruzgKwkfmjXMcbGOFCy2s3PwOfxEkS85OtGS1ALQKXA6jF6ty8ja8Vk7YmPaCNoCyznL5E8I9W4Dm7fPI4qhm8jXonCz84mgz9mdGkl8vuiFbmhJJVXMFbIrZ4iBN5zSRP5Rhjyqmfau77BZEjC6R5Ftc_5wi-WLhpfwcIQWCUFtL5pANphyZDwygljkQ6QdeRbyQJ7IFQ"
  // ];

  @override
  void initState() {
    super.initState();
    images = widget.product.imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F6),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // backgroundColor: Colors.white.withOpacity(0.8),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,

        // title: const Text(
        //   'Trendify',
        //   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        // ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: const Color(0xFFEE2B5B),
                ),
                onPressed: () => setState(() => isFavorite = !isFavorite),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.share, color: Colors.black),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Slider
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: PageView.builder(
                    onPageChanged: (index) =>
                        setState(() => activeImageIndex = index),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return
                          // Image.network(
                          //   images[index],
                          //   fit: BoxFit.cover,
                          // );
                          Image.memory(
                        base64Decode(images[index]),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      images.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: activeImageIndex == index ? 12 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: activeImageIndex == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // const Expanded(
                      //   child: Text(
                      //     'Midnight Velvet Evening Gown',
                      //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEE2B5B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.star,
                                color: Color(0xFFEE2B5B), size: 16),
                            SizedBox(width: 4),
                            Text(
                              '4.9',
                              style: TextStyle(
                                  color: Color(0xFFEE2B5B),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // const Text(
                  //   'Premium Collection • Limited Edition',
                  //   style: TextStyle(color: Colors.grey, fontSize: 14),
                  // ),
                  Text(
                    widget.product.brand,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // const Text(
                      //   '\$249.00',
                      //   style: TextStyle(
                      //       fontSize: 30, fontWeight: FontWeight.bold),
                      // ),

                      Text(
                        '\$${widget.product.price}',
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '\$320.00',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEE2B5B),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '25% OFF',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Select Size',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Size Guide',
                          style: TextStyle(
                              color: Color(0xFFEE2B5B),
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    // children: ['S', 'M', 'L', 'XL'].map((size) {
                    children: widget.product.sizes.map((size) {
                      final isSelected = selectedSize == size;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedSize = size),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFEE2B5B).withOpacity(0.05)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFEE2B5B)
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                size,
                                style: TextStyle(
                                  color: isSelected
                                      ? const Color(0xFFEE2B5B)
                                      : Colors.grey.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text('Color',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Color(0xFF1A1A2E),
                      const Color(0xFF4A0E0E),
                      const Color(0xFF0E2A1E),
                      const Color(0xFFC0C0C0),
                    ].map((color) {
                      final isSelected = selectedColor == color;
                      return GestureDetector(
                        onTap: () => setState(() => selectedColor = color),
                        child: Container(
                          margin: const EdgeInsets.only(right: 16),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFEE2B5B)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text('Description',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  // const Text(
                  //   'Elevate your evening allure with our Midnight Velvet Gown. Meticulously crafted from ultra-soft Italian velvet, this floor-length masterpiece features a sophisticated silhouette...',
                  //   style: TextStyle(color: Colors.grey, height: 1.5),
                  // ),
                  Text(
                    widget.product.description,
                    style: const TextStyle(color: Colors.grey, height: 1.5),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Read More',
                            style: TextStyle(
                                color: Color(0xFFEE2B5B),
                                fontWeight: FontWeight.bold)),
                        Icon(Icons.keyboard_arrow_down,
                            color: Color(0xFFEE2B5B)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.local_shipping,
                              color: Color(0xFFEE2B5B)),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Free Express Delivery',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Estimated delivery: 2-3 business days',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120), // Space for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text('Add to Cart'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFEE2B5B),
                  side: const BorderSide(color: Color(0xFFEE2B5B), width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlaceOrderScreen(
                        product: widget.product,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEE2B5B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  shadowColor: const Color(0xFFEE2B5B).withOpacity(0.4),
                ),
                child: const Text('Buy Now',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
