import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; // 1. Tambahkan import Firebase
import 'firebase_options.dart'; // 2. Tambahkan import file hasil generate tadi

import 'product_provider.dart';
import 'main_navigation.dart';
import 'splash_screen.dart';

// 3. Ubah main menjadi Future<void> dan tambahkan async
void main() async {
  // 4. Baris ini WAJIB ada jika menggunakan Firebase di fungsi main
  WidgetsFlutterBinding.ensureInitialized();

  // 5. Inisialisasi Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Luxe Jewels',
      theme: ThemeData(primarySwatch: Colors.amber, fontFamily: 'Serif'),
      home: const SplashScreen(),
    );
  }
}
