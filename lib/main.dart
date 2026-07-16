import 'package:flutter/material.dart';
import '../view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF111111),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
//98dee3928461470d8f4fcbbfbc664f4a
//https://newsapi.org/v2/everything?q=bitcoin&apiKey=98dee3928461470d8f4fcbbfbc664f4a

//https://newsapi.org/v2/top-headlines?country=us&apiKey=98dee3928461470d8f4fcbbfbc664f4a

//https://newsapi.org/v2/top-headlines?q=category=business&apiKey=98dee3928461470d8f4fcbbfbc664f4a
 