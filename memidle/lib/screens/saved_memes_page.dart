import 'dart:io';
import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class SavedMemesPage extends StatefulWidget {
  final int userId;
  
  const SavedMemesPage({super.key, required this.userId});

  @override
  State<SavedMemesPage> createState() => _SavedMemesPageState();
}

class _SavedMemesPageState extends State<SavedMemesPage> {
  final _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Memes'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dbHelper.getUserMemes(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final memes = snapshot.data ?? [];
          
          if (memes.isEmpty) {
            return const Center(child: Text('No saved memes'));
          }
          
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: memes.length,
            itemBuilder: (context, index) {
              final meme = memes[index];
              return _buildMemeCard(meme);
            },
          );
        },
      ),
    );
  }

  Widget _buildMemeCard(Map<String, dynamic> meme) {
    final file = File(meme['image_path']);
    final createdAt = DateTime.parse(meme['created_at']);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.file(
            file,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            right: 4,
            top: 4,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () => _deleteMeme(meme['id']),
            ),
          ),
          Positioned(
            left: 4,
            bottom: 4,
            child: Text(
              _formatDate(createdAt),
              style: const TextStyle(
                color: Colors.white,
                backgroundColor: Colors.black54,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _deleteMeme(int memeId) async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Meme'),
        content: const Text('Are you sure you want to delete this meme?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _dbHelper.deleteMeme(memeId);
      setState(() {}); // Refresh the list
    }
  }
} 