import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trendify/add_new_product_screen.dart';
import 'package:trendify/admin/admin_dash_board_container.dart';
import 'package:trendify/admin_insights_dashboard_screen.dart';
import 'package:trendify/customer_explore_trends_screen.dart';
import 'package:trendify/login_screen.dart';

import 'package:trendify/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // 👈 No options needed

  /// 🔥 Get stored login data
  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
  String role = prefs.getString("role") ?? "";

  runApp(TrendifyApp(
    isLoggedIn: isLoggedIn,
    role: role,
  ));
}

class TrendifyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String role;
  const TrendifyApp({super.key, required this.isLoggedIn, required this.role});

  @override
  Widget build(BuildContext context) {
    Widget homeScreen;

    if (isLoggedIn) {
      if (role == "admin") {
        homeScreen = const AdminDashboardScreen();
        // homeScreen = const AdminDashboardContainer();
      } else {
        homeScreen = const CustomerExploreTrendsScreen();
      }
    } else {
      homeScreen = const LoginScreen();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trendify',
      theme: ThemeData(
        primaryColor: const Color(0xFFE11D48),
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      home: homeScreen,
    );
  }
}
