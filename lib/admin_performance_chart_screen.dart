
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PerformanceChart extends StatelessWidget {
  const PerformanceChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEE2B5B).withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Performance',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Sales vs Target',
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildLegendItem('Sales', const Color(0xFFEE2B5B)),
                  const SizedBox(width: 12),
                  _buildLegendItem('Target', Colors.grey[200]!),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return Text(
                          days[value.toInt()],
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _makeGroupData(0, 60, 80),
                  _makeGroupData(1, 85, 90),
                  _makeGroupData(2, 60, 75),
                  _makeGroupData(3, 95, 100, isHighlighted: true),
                  _makeGroupData(4, 40, 65),
                  _makeGroupData(5, 75, 85),
                  _makeGroupData(6, 70, 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
              fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  BarChartGroupData _makeGroupData(int x, double sales, double target,
      {bool isHighlighted = false}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: target,
          color: Colors.grey[100],
          width: 30,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          rodStackItems: [
            BarChartRodStackItem(
              0,
              sales,
              isHighlighted
                  ? const Color(0xFFEE2B5B)
                  : const Color(0xFFEE2B5B).withOpacity(0.4),
            ),
          ],
        ),
      ],
    );
  }
}



// below using firebase data

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class PerformanceChart extends StatefulWidget {
//   const PerformanceChart({super.key});

//   @override
//   State<PerformanceChart> createState() => _PerformanceChartState();
// }

// class _PerformanceChartState extends State<PerformanceChart> {
//   List<double> weeklySales = List.filled(7, 0);
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchWeeklySales();
//   }

//   Future<void> fetchWeeklySales() async {
//     try {
//       final now = DateTime.now();
//       List<double> tempSales = List.filled(7, 0);

//       final snapshot =
//           await FirebaseFirestore.instance.collection('orders').get();

//       for (var doc in snapshot.docs) {
//         final data = doc.data();

//         final createdAt =
//             (data['createdAt'] as Timestamp?)?.toDate();

//         if (createdAt != null) {
//           final difference = now.difference(createdAt).inDays;

//           if (difference <= 6) {
//             int weekdayIndex = createdAt.weekday - 1;

//             tempSales[weekdayIndex] +=
//                 (data['price'] ?? 0).toDouble();
//           }
//         }
//       }

//       setState(() {
//         weeklySales = tempSales;
//         isLoading = false;
//       });
//     } catch (e) {
//       print("Weekly sales error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double maxValue =
//         weeklySales.reduce((a, b) => a > b ? a : b) + 50;

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: const Color(0xFFEE2B5B).withOpacity(0.05)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Header
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Performance',
//                     style: GoogleFonts.inter(fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     'Sales This Week',
//                     style: GoogleFonts.inter(
//                         fontSize: 12, color: Colors.grey),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   _buildLegendItem('Sales', const Color(0xFFEE2B5B)),
//                   const SizedBox(width: 12),
//                   _buildLegendItem('Target', Colors.grey[200]!),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),

//           /// Chart
//           SizedBox(
//             height: 150,
//             child: isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : BarChart(
//                     BarChartData(
//                       alignment: BarChartAlignment.spaceAround,
//                       maxY: maxValue == 0 ? 100 : maxValue,
//                       barTouchData: BarTouchData(enabled: false),
//                       titlesData: FlTitlesData(
//                         show: true,
//                         bottomTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             getTitlesWidget: (value, meta) {
//                               const days = [
//                                 'M',
//                                 'T',
//                                 'W',
//                                 'T',
//                                 'F',
//                                 'S',
//                                 'S'
//                               ];
//                               return Text(
//                                 days[value.toInt()],
//                                 style: GoogleFonts.inter(
//                                   fontSize: 10,
//                                   color: Colors.grey[400],
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         leftTitles: const AxisTitles(
//                             sideTitles: SideTitles(showTitles: false)),
//                         topTitles: const AxisTitles(
//                             sideTitles: SideTitles(showTitles: false)),
//                         rightTitles: const AxisTitles(
//                             sideTitles: SideTitles(showTitles: false)),
//                       ),
//                       gridData: const FlGridData(show: false),
//                       borderData: FlBorderData(show: false),
//                       barGroups: List.generate(7, (index) {
//                         return _makeGroupData(
//                           index,
//                           weeklySales[index],
//                           weeklySales[index] + 20,
//                         );
//                       }),
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLegendItem(String label, Color color) {
//     return Row(
//       children: [
//         Container(
//           width: 8,
//           height: 8,
//           decoration:
//               BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         const SizedBox(width: 4),
//         Text(
//           label,
//           style: GoogleFonts.inter(
//               fontSize: 10,
//               color: Colors.grey,
//               fontWeight: FontWeight.w500),
//         ),
//       ],
//     );
//   }

//   BarChartGroupData _makeGroupData(
//       int x, double sales, double target) {
//     return BarChartGroupData(
//       x: x,
//       barRods: [
//         BarChartRodData(
//           toY: target,
//           color: Colors.grey[100],
//           width: 30,
//           borderRadius:
//               const BorderRadius.vertical(top: Radius.circular(4)),
//           rodStackItems: [
//             BarChartRodStackItem(
//               0,
//               sales,
//               const Color(0xFFEE2B5B),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }