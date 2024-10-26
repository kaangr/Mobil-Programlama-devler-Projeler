import 'package:flutter/material.dart';
import '../users.dart';

class StudentPage extends StatelessWidget {
  final Student student;

  const StudentPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Öğrenci Sayfası')),
      body: Center(child: Text('Hoş geldiniz, ${student.name}!')),
    );
  }
}
