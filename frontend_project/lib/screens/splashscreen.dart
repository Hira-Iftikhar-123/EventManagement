import 'package:flutter/material.dart';
import 'options.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Options()),
      );
    });
  }

  @override
  Widget build(context) {
    return Center(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
              'assets/images/LOGO.png',
              width: 200,
            )
            )
      ],
      ),
    );
  }
}

