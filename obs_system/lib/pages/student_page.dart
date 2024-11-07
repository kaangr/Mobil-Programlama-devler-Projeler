import 'package:flutter/material.dart';
import '../users.dart';

class StudentPage extends StatefulWidget {
  final Student student;

  const StudentPage({super.key, required this.student});

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final TextEditingController _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Öğrenci Sayfası'),), //renge bak
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Hoş geldiniz, ${widget.student.name}'),
            TextField(
              controller: _todoController,
              decoration: const InputDecoration(labelText: 'Yapılacak İş'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_todoController.text.isNotEmpty) {
                  setState(() {
                    widget.student.addTodo(_todoController.text);
                    _todoController.clear();
                  });
                }
              },
              child: const Text('Ekle'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.student.getTodoList().length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.student.getTodoList()[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          widget.student.removeTodo(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
