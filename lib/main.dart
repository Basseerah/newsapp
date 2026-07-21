import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';
import 'views/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

// Custom ScrollBehavior allowing mouse, trackpad, touchpad drag, and touch gestures globally
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
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
 