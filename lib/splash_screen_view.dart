import 'package:flutter/material.dart';
import 'dart:async';

import 'package:mynotes/constants/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHomePage();
  }

  Future<void> _navigateToHomePage() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacementNamed(context, homeRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Menampilkan gambar cartoon.png dengan animasi fade-in
            AnimatedContainer(
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              child: Image.asset(
                'assets/cartoon.png',
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            // Loading Bar
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 3),
              builder: (context, value, child) {
                return Column(
                  children: [
                    // LinearProgressIndicator (loading bar)
                    SizedBox(
                      width: 200, // Lebar loading bar
                      child: LinearProgressIndicator(
                        value: value,
                        backgroundColor: Colors.white.withOpacity(0.5),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Sedang memuat...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
