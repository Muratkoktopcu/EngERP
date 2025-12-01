import 'package:flutter/material.dart';
import 'package:eng_erp/architect.dart';

void main() {
  runApp(const EngErp());
}

class EngErp extends StatelessWidget {
  const EngErp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Menü Örneği',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AnaIskelet(),
    );
  }
}