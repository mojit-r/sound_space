import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_space/provider/audio_provider.dart';
import 'package:sound_space/screen/homescreen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AudioProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
