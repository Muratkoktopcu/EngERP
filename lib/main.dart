import 'package:flutter/material.dart';

void main() {
  runApp(const IlkUygulamam());
}

class IlkUygulamam extends StatelessWidget {
  const IlkUygulamam({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Sağ üstteki 'Debug' bandını kaldırır
      home: Scaffold(
        appBar: AppBar(
          title: const Text('İlk Projem'),
          backgroundColor: Colors.blue,
        ),
        body: const Center(
          child: Text(
            'Merhaba Flutter!',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}