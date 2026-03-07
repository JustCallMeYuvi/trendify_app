import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trendify/customer/cart_manager.dart';
import 'package:trendify/models/cart_item.dart';
import 'package:trendify/my_shopping_cart_screen.dart';
import 'package:trendify/product_details_screen.dart';

import 'wishlist_manager.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;
  bool isAddedToCart = false;

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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductDetailScreen(product: widget.product),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    child:
                        //  Image.network(
                        //     product.imageUrls.isNotEmpty
                        //         ? product.imageUrls.first
                        //         : 'https://lh3.googleusercontent.com/aida-public/AB6AXuCIq7d-7AeFjDaskOfM93tQSrm4-BqyyRcUDa19QPp6RUBkv_vUIQaQxhmX3sQX_4zanCndfpZlONmNiDVBDdqpaBfwGLl0zu8-j_KNUnBEcy_iwaZT55X9xLq4cl8sOA86MEJ0PftnNKPIVTwgyRcX7bwYYOAgPf6i_RE934P4vsogf_-B3tdLzZhFymwuG_QNMlav5upagcVBjSbpIwML5hqBuureCRbvVVhMP4Rbwrpi0dvDYO4qTrVWvuYOmX1b3mLalne36A',
                        //     fit: BoxFit.cover,
                        //     width: double.infinity),
                        widget.product.imageUrls.isNotEmpty
                            ? Image.memory(
                                base64Decode(widget.product.imageUrls.first),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Image.network(
                                "https://lh3.googleusercontent.com/aida-public/AB6AXuCIq7d-7AeFjDaskOfM93tQSrm4-BqyyRcUDa19QPp6RUBkv_vUIQaQxhmX3sQX_4zanCndfpZlONmNiDVBDdqpaBfwGLl0zu8-j_KNUnBEcy_iwaZT55X9xLq4cl8sOA86MEJ0PftnNKPIVTwgyRcX7bwYYOAgPf6i_RE934P4vsogf_-B3tdLzZhFymwuG_QNMlav5upagcVBjSbpIwML5hqBuureCRbvVVhMP4Rbwrpi0dvDYO4qTrVWvuYOmX1b3mLalne36A",
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: ValueListenableBuilder(
                    valueListenable: WishlistManager.wishlistItems,
                    builder: (context, wishlist, _) {
                      bool isFavorite =
                          wishlist.any((item) => item.id == widget.product.id);

                      return GestureDetector(
                        onTap: () {
                          if (isFavorite) {
                            WishlistManager.remove(widget.product.id);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Removed from Wishlist"),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          } else {
                            WishlistManager.add(widget.product);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Added to Wishlist ❤️"),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.9),
                          radius: 16,
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: const Color(0xFFEE2B5B),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (widget.product.isNew)
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
                Text(widget.product.brand,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
                Text(widget.product.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${widget.product.price}',
                        style: const TextStyle(
                            color: Color(0xFFEE2B5B),
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(widget.product.rating.toString(),
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                        ValueListenableBuilder(
                          valueListenable: CartManager.cartItems,
                          builder: (context, cartItems, _) {
                            bool isAddedToCart = cartItems
                                .any((item) => item.id == widget.product.id);

                            return GestureDetector(
                              onTap: () {
                                if (isAddedToCart) {
                                  CartManager.removeItem(widget.product.id);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Removed from Cart")),
                                  );
                                } else {
                                  CartManager.addToCart(
                                    CartItem(
                                      id: widget.product.id,
                                      name: widget.product.name,
                                      brand: widget.product.brand,
                                      price: widget.product.price,
                                      size: widget.product.sizes.isNotEmpty
                                          ? widget.product.sizes.first
                                          : "M",
                                      color: "Default",
                                      imageUrl:
                                          widget.product.imageUrls.isNotEmpty
                                              ? widget.product.imageUrls.first
                                              : "",
                                    ),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Added to Cart 🛒")),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[100]!),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isAddedToCart
                                      ? Icons.shopping_bag
                                      : Icons.shopping_bag_outlined,
                                  size: 16,
                                  color: isAddedToCart
                                      ? const Color(0xFFEE2B5B)
                                      : Colors.black,
                                ),
                              ),
                            );
                          },
                        )
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
