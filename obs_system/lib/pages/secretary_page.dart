import 'package:flutter/material.dart';
import '../users.dart';

class SecretaryPage extends StatelessWidget {
  final Secretary secretary;

  const SecretaryPage({super.key, required this.secretary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sekreter Sayfası')),
      body: const Center(child: Text('Hoş geldiniz, Sekreter!')),
    );
  }
}
