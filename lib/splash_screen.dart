import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendify/on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
void initState() {
  super.initState();
  Future.delayed(Duration(seconds: 3), () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => OnboardingScreen()),
    );
  });
}
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFFFFF1F2),
              Color(0xFFFFD1D9),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top Progress Indicators
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProgress(20, 0.2),
                  const SizedBox(width: 8),
                  _buildProgress(8, 1.0),
                  const SizedBox(width: 8),
                  _buildProgress(20, 0.2),
                ],
              ),
            ),
            const Spacer(),
            
            // Logo Container
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE11D48).withOpacity(0.15),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Center(
                child: Transform.rotate(
                  angle: -0.1,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE11D48),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 48),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Brand Name
            Text(
              'Trendify',
              style: GoogleFonts.outfit(
                fontSize: 56,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0F172A),
                letterSpacing: -1.5,
              ),
            ),
            
            // Tagline
            const Text(
              'STYLE MEETS COMFORT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE11D48),
                letterSpacing: 4.0,
              ),
            ),
            const Spacer(),
            
            // Pagination Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(true),
                const SizedBox(width: 8),
                _buildDot(false),
                const SizedBox(width: 8),
                _buildDot(false),
              ],
            ),
            const SizedBox(height: 16),
            
            Text(
              'Premium Fashion Experience',
              style: TextStyle(
                color: const Color(0xFF0F172A).withOpacity(0.5),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress(double width, double opacity) {
    return Container(
      height: 4,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFFE11D48).withOpacity(opacity),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildDot(bool active) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE11D48) : const Color(0xFFE11D48).withOpacity(0.2),
        shape: BoxShape.circle,
      ),
    );
  }
}