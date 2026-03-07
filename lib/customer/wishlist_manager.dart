import 'package:flutter/material.dart';
import 'package:trendify/customer/product_card_widget.dart';

class WishlistManager {
  static ValueNotifier<List<Product>> wishlistItems =
      ValueNotifier<List<Product>>([]);

  static void add(Product product) {
    if (!wishlistItems.value.any((p) => p.id == product.id)) {
      wishlistItems.value = [...wishlistItems.value, product];
    }
  }

  static void remove(String productId) {
    wishlistItems.value =
        wishlistItems.value.where((p) => p.id != productId).toList();
  }

  static bool isFavorite(String productId) {
    return wishlistItems.value.any((p) => p.id == productId);
  }
}