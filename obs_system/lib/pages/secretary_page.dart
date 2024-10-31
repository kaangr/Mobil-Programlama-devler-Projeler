import 'package:flutter/material.dart';
import '../users.dart';

class SecretaryPage extends StatefulWidget {
  final Secretary secretary;
  const SecretaryPage({super.key, required this.secretary});

  @override
  State<SecretaryPage> createState() => _SecretaryPageState();
}

class _SecretaryPageState extends State<SecretaryPage> {
  final TextEditingController _announcementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sekreter Sayfası'),
        backgroundColor: const Color(0xFF199DB5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Hoş geldiniz, Sekreter ${widget.secretary.name}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            // Duyuru ekleme alanı
            TextField(
              controller: _announcementController,
              decoration: const InputDecoration(
                labelText: 'Duyuru/Haber',
                hintText: 'Yeni duyuru giriniz',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_announcementController.text.isNotEmpty) {
                  setState(() {
                    widget.secretary.addAnnouncement(_announcementController.text);
                    _announcementController.clear();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF199DB5),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Duyuru Ekle'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Duyurular',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Duyuruları listeleyen alan
            Expanded(
              child: ListView.builder(
                itemCount: widget.secretary.getAnnouncements().length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(widget.secretary.getAnnouncements()[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            widget.secretary.removeAnnouncement(index);
                          });
                        },
                      ),
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
