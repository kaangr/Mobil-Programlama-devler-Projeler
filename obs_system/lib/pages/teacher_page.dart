import 'package:flutter/material.dart';
import '../users.dart';

class TeacherPage extends StatefulWidget {
  final Teacher teacher;
  const TeacherPage({super.key, required this.teacher});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _midtermController = TextEditingController();
  final TextEditingController _finalController = TextEditingController();
  String _selectedStudent = '';
  Map<String, double> _grades = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Öğretmen Sayfası')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Hoş geldiniz, ${widget.teacher.name}',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _studentNameController,
              decoration: const InputDecoration(
                labelText: 'Öğrenci Adı',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _midtermController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Vize Notu',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _finalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Final Notu',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_studentNameController.text.isNotEmpty &&
                    _midtermController.text.isNotEmpty &&
                    _finalController.text.isNotEmpty) {
                  setState(() {
                    double midterm = double.tryParse(_midtermController.text) ?? 0;
                    double final_ = double.tryParse(_finalController.text) ?? 0;
                    
                    widget.teacher.addGrades(
                      _studentNameController.text,
                      midterm,
                      final_,
                    );
                    
                    _selectedStudent = _studentNameController.text;
                    _grades = widget.teacher.getGrades(_selectedStudent);
                    
                    // Temizle
                    _studentNameController.clear();
                    _midtermController.clear();
                    _finalController.clear();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Notları Kaydet'),
            ),
            if (_grades.isNotEmpty) ...[
              const SizedBox(height: 30),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Öğrenci: $_selectedStudent',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text('Vize: ${_grades['midterm']?.toStringAsFixed(2)}'),
                      Text('Final: ${_grades['final']?.toStringAsFixed(2)}'),
                      const Divider(),
                      Text(
                        'Ortalama: ${_grades['average']?.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
