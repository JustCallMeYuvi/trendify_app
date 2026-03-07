import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendify/admin/admin_order_tracking_screen.dart';
import 'package:trendify/app_colors.dart';

class OrderItem extends StatelessWidget {
  final String id;
  final String orderNumber;
  final String name;
  final String time;
  final String price;
  final String status;
  final String imageUrl;

  const OrderItem({
    super.key,
    required this.id,
    required this.name,
    required this.time,
    required this.price,
    required this.status,
    required this.imageUrl,
    required this.orderNumber,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color statusBg;
    switch (status) {
      case 'Processing':
        statusColor = AppColors.emerald;
        statusBg = AppColors.emerald[50]!;
        break;
      case 'Shipped':
        statusColor = Colors.blue;
        statusBg = Colors.blue[50]!;
        break;
      default:
        statusColor = Colors.amber[700]!;
        statusBg = Colors.amber[50]!;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminOrderStatusScreen(
              orderId: id,
              orderNumber: orderNumber,
              customerName: name,
              price: price,
              status: status,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFEE2B5B).withOpacity(0.05)),
        ),
        child: Row(
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(12),
            //   child: Image.network(
            //     imageUrl,
            //     width: 48,
            //     height: 48,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl.startsWith("http")
                  ? Image.network(
                      imageUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    )
                  : Image.memory(
                      base64Decode(imageUrl),
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        price,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    '$id • $time',
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: GoogleFonts.inter(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right,
                          color: Colors.grey, size: 16),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
