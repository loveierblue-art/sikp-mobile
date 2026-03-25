import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF337418), // Hijau Utama dari palet kamu
          primary: const Color(0xFF337418),   // Hijau Tua
          secondary: const Color(0xFF202020), // Abu Gelap untuk elemen sekunder
          surface: const Color(0xFFF8F8F8),   // Background bersih (Off-White)
          
          onPrimary: Colors.white,            // Teks di atas hijau
          onSurface: const Color(0xFF0F0F0F), // Teks di atas putih (Hampir Hitam)
        ),

        // Styling Input Field agar bersih dan modern
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIconColor: const Color(0xFF337418),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF337418), width: 2),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
