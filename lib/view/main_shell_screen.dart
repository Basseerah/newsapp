import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'archive_screen.dart';
import 'vintage_components.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    ArchiveScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VintageColors.background,
      body: Stack(
        children: [
          // Screen contents
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          // Floating Bottom Navigation Dock overlay
          FloatingDock(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
