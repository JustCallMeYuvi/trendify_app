import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendify/add_new_product_screen.dart';
import 'package:trendify/admin_insights_dashboard_screen.dart';
import 'package:trendify/customer_explore_trends_screen.dart';
import 'package:trendify/login_screen.dart';

import 'package:trendify/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();   // 👈 No options needed
  runApp(const TrendifyApp());
}

class TrendifyApp extends StatelessWidget {
  const TrendifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trendify',
      theme: ThemeData(
        primaryColor: const Color(0xFFE11D48),
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      home: const LoginScreen(),
    );
  }
}
