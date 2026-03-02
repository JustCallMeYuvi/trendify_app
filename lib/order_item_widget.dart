
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OrderItemWidget extends StatelessWidget {
  final String name;
  final String details;
  final String price;

  const OrderItemWidget({
    super.key,
    required this.name,
    required this.details,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: const Icon(LucideIcons.shirt, color: Colors.grey, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
              Text(details,
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
            ],
          ),
        ),
        Text(price,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
