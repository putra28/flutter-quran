import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const QuranApp());
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.outfit().fontFamily,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF564f47),
          onPrimary: Color(0xFF564f47),
          secondary: Color(0xFF8b7458),
          onSecondary: Color(0xFF8b7458),
          surface: Color(0xFFffecdc),
          onSurface: Color(0xFFffecdc),
          error: Color(0xFF6C4E31),
          onError: Color(0xFF6C4E31),
          background: Color(0xFFFfFaf5),
        ),
        useMaterial3: false,
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const splashScreen();
  }
}
