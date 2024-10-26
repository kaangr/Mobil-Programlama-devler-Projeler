import 'package:flutter/material.dart';
import '../users.dart';

class TeacherPage extends StatelessWidget {
  final Teacher teacher;

  const TeacherPage({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Öğretmen Sayfası')),
      body: Center(child: Text('Hoş geldiniz, ${teacher.name}!')),
    );
  }
}
