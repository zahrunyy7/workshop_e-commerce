import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const JewelryStoreApp());
}

class JewelryStoreApp extends StatelessWidget {
  const JewelryStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber, fontFamily: 'Serif'),
      home: const SplashScreen(),
    );
  }
}
