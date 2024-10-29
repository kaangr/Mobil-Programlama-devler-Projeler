import 'package:flutter/material.dart';
import '../users.dart';


class SecretaryPage extends StatelessWidget {
  final Secretary secretary;

  const SecretaryPage({super.key, required this.secretary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sekreter Sayfası')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Hoş geldiniz, Sekreter ${secretary.name}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              secretary.printInfo(); // Sekreter bilgilerini yazdır
            },
            child: const Text('Bilgileri Göster'),
          ),
        ],
      ),
    );
  }
}
