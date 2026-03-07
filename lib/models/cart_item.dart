class CartItem {
  final String id;
  final String name;
    final String brand;
  final double price;
  final String size;
  final String color;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.size,
    required this.color,
    required this.imageUrl,
    this.quantity = 1,
  });
}