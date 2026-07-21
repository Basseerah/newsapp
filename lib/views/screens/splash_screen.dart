import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import 'main_shell_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to the main shell screen after a short delay
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainShellScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo image container
          Center(
            child: Container(
              width: 160,
              height: 160,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(36),
                border: Border.all(color: Colors.white12, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  AppConstants.logoAsset,
                  fit: BoxFit.contain,
                  cacheWidth: 320,
                  cacheHeight: 320,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF252525),
                      child: const Center(
                        child: Icon(
                          Icons.newspaper_rounded,
                          size: 64,
                          color: Colors.white70,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.04),

          // Stylized Title
          Text(
            AppConstants.appName,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Curated News at Your Fingertips",
            style: GoogleFonts.outfit(
              color: Colors.white38,
              fontSize: 14,
            ),
          ),
          SizedBox(height: height * 0.05),

          // Spinner
          const SpinKitRotatingCircle(
            color: Colors.white60,
            size: 40.0,
          )
        ],
      ),
    );
  }
}
