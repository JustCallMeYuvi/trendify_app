import 'package:flutter/material.dart';
import 'package:trendify/models/cart_item.dart';

class CartManager {

  static ValueNotifier<List<CartItem>> cartItems = ValueNotifier([]);

  static void addToCart(CartItem item) {
    final list = cartItems.value;

    int index = list.indexWhere((e) => e.id == item.id);

    if (index != -1) {
      list[index].quantity++;
    } else {
      list.add(item);
    }

    cartItems.value = List.from(list);
  }

  static void removeItem(String id) {
    cartItems.value =
        cartItems.value.where((item) => item.id != id).toList();
  }

  static void clearCart() {
    cartItems.value = [];
  }
}