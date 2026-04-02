import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'product_provider.dart';
import 'splash_screen.dart';
import 'firebase_options.dart'; // Sudah ditambah titik koma (;)

void main() async {
  // 1. Wajib ada ini sebelum Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Tambahkan options agar Flutter tahu konfigurasi project kamu
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProductProvider())],
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
      theme: ThemeData(
        // Tips: Pakai warna Navy biar cocok sama branding Luxe Jewels kamu
        primaryColor: const Color(0xFF000080),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
