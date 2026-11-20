import 'package:flutter/material.dart';

void main() {
  runApp(const FlatFitApp());
}

class FlatFitApp extends StatelessWidget {
  const FlatFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlatFit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child: Text('FlatFit')),
      ),
    );
  }
}
