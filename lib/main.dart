import 'package:flutter/material.dart';
import 'package:image_processing_penelitian_tus/main_page/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Penelitian Image Processing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade900),
        useMaterial3: true,
      ),
      home: MainPage(),
    );
  }
}