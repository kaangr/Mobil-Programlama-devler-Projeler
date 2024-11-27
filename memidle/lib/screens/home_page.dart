import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/database_helper.dart';
import 'dart:ui' as ui;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'saved_memes_page.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  final int? userId;
  const HomePage({super.key, this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class MemeText {
  String text;
  Offset position;
  double fontSize;
  Color color;
  double strokeWidth;
  Color strokeColor;
  double blurRadius;
  Color shadowColor;
  Offset shadowOffset;
  
  TextStyle get style => strokeWidth > 0 
    ? TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            offset: shadowOffset,
            blurRadius: blurRadius,
            color: shadowColor,
          ),
        ],
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..color = strokeColor,
        background: Paint()
          ..color = color
      )
    : TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            offset: shadowOffset,
            blurRadius: blurRadius,
            color: shadowColor,
          ),
        ]
      );

  MemeText({
    required this.text,
    required this.position,
    this.fontSize = 24,
    this.color = Colors.white,
    this.strokeWidth = 0,
    this.strokeColor = Colors.black,
    this.blurRadius = 3,
    this.shadowColor = Colors.black,
    this.shadowOffset = const Offset(1, 1),
  });
}

class _HomePageState extends State<HomePage> {
  File? _selectedImage;
  final _textController = TextEditingController();
  final _dbHelper = DatabaseHelper();
  final ImagePicker _picker = ImagePicker();
  final List<MemeText> _memeTexts = [];
  int? _selectedTextIndex;
  
  double _currentFontSize = 24;
  Color _currentColor = Colors.white;
  double _currentStrokeWidth = 0;
  Color _currentStrokeColor = Colors.black;
  double _currentBlurRadius = 3;
  Color _currentShadowColor = Colors.black;
  Offset _currentShadowOffset = const Offset(1, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meme Creator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SavedMemesPage(userId: widget.userId ?? 0),
              ),
            ),
          ),
          if (_selectedImage != null) ...[
            IconButton(
              icon: const Icon(Icons.crop),
              onPressed: _cropImage,
            ),
            IconButton(
              icon: const Icon(Icons.rotate_right),
              onPressed: _rotateImage,
            ),
          ],
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewText,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveMeme,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (_selectedImage != null)
                    Stack(
                      children: [
                        Image.file(_selectedImage!),
                        ..._memeTexts.asMap().entries.map((entry) {
                          final index = entry.key;
                          final memeText = entry.value;
                          return Positioned(
                            left: memeText.position.dx,
                            top: memeText.position.dy,
                            child: GestureDetector(
                              onTap: () => _selectText(index),
                              onPanUpdate: (details) {
                                setState(() {
                                  memeText.position += details.delta;
                                });
                              },
                              child: Text(
                                memeText.text,
                                style: memeText.style,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    )
                  else
                    Container(
                      height: 300,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Text('No image selected'),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_selectedTextIndex != null) _buildTextEditingPanel(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addNewText() {
    setState(() {
      _memeTexts.add(MemeText(
        text: 'New Text',
        position: const Offset(100, 100),
      ));
      _selectedTextIndex = _memeTexts.length - 1;
      _textController.text = 'New Text';
    });
  }

  void _selectText(int index) {
    setState(() {
      _selectedTextIndex = index;
      _textController.text = _memeTexts[index].text;
      _currentFontSize = _memeTexts[index].fontSize;
      _currentColor = _memeTexts[index].color;
    });
  }

  void _deleteSelectedText() {
    if (_selectedTextIndex != null) {
      setState(() {
        _memeTexts.removeAt(_selectedTextIndex!);
        _selectedTextIndex = null;
        _textController.clear();
      });
    }
  }

  void _showColorPicker({
    required String title,
    required Color color,
    required ValueChanged<Color> onColorChanged,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: color,
            onColorChanged: onColorChanged,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 100,
    );
    
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _memeTexts.clear();
        _selectedTextIndex = null;
      });
    }
  }

  Future<void> _saveMeme() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Load the image
      final originalImage = await _loadImage(_selectedImage!.path);
      
      // Create a new image with the same size
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final size = Size(originalImage.width.toDouble(), originalImage.height.toDouble());
      
      // Draw the original image
      canvas.drawImage(originalImage, Offset.zero, Paint());
      
      // Draw all text elements
      for (final memeText in _memeTexts) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: memeText.text,
            style: memeText.style,
          ),
          textDirection: TextDirection.ltr,
        );
        
        textPainter.layout();
        textPainter.paint(
          canvas,
          memeText.position,
        );
      }
      
      // Convert to image
      final picture = recorder.endRecording();
      final img = await picture.toImage(
        originalImage.width,
        originalImage.height,
      );
      final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
      
      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = '${directory.path}/meme_$timestamp.png';
      
      final file = File(path);
      await file.writeAsBytes(pngBytes!.buffer.asUint8List());
      
      // Save to database
      await _dbHelper.saveMeme(widget.userId ?? 0, path);
      
      // Close loading indicator
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Meme saved successfully')),
        );
      }
    } catch (e) {
      // Close loading indicator
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving meme: $e')),
        );
      }
    }
  }

  Future<ui.Image> _loadImage(String path) async {
    final data = await File(path).readAsBytes();
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(data, completer.complete);
    return completer.future;
  }

  Future<void> _cropImage() async {
    if (_selectedImage == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _selectedImage!.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _selectedImage = File(croppedFile.path);
      });
    }
  }

  Future<void> _rotateImage() async {
    if (_selectedImage == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _selectedImage!.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Rotate Image',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(
          title: 'Rotate Image',
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _selectedImage = File(croppedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Widget _buildTextEditingPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Edit text',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _memeTexts[_selectedTextIndex!].text = value;
              });
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text('Font Size'),
                    Slider(
                      value: _currentFontSize,
                      min: 12,
                      max: 48,
                      onChanged: (value) {
                        setState(() {
                          _currentFontSize = value;
                          _memeTexts[_selectedTextIndex!].fontSize = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.color_lens),
                onPressed: () => _showColorPicker(
                  title: 'Text Color',
                  color: _currentColor,
                  onColorChanged: (color) {
                    setState(() {
                      _currentColor = color;
                      _memeTexts[_selectedTextIndex!].color = color;
                    });
                  },
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Advanced Styles'),
            children: [
              ListTile(
                title: const Text('Stroke'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Slider(
                        value: _currentStrokeWidth,
                        min: 0,
                        max: 5,
                        onChanged: (value) {
                          setState(() {
                            _currentStrokeWidth = value;
                            _memeTexts[_selectedTextIndex!].strokeWidth = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.color_lens),
                      onPressed: () => _showColorPicker(
                        title: 'Stroke Color',
                        color: _currentStrokeColor,
                        onColorChanged: (color) {
                          setState(() {
                            _currentStrokeColor = color;
                            _memeTexts[_selectedTextIndex!].strokeColor = color;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Shadow'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Slider(
                        value: _currentBlurRadius,
                        min: 0,
                        max: 10,
                        onChanged: (value) {
                          setState(() {
                            _currentBlurRadius = value;
                            _memeTexts[_selectedTextIndex!].blurRadius = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.color_lens),
                      onPressed: () => _showColorPicker(
                        title: 'Shadow Color',
                        color: _currentShadowColor,
                        onColorChanged: (color) {
                          setState(() {
                            _currentShadowColor = color;
                            _memeTexts[_selectedTextIndex!].shadowColor = color;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _deleteSelectedText,
              ),
            ],
          ),
        ],
      ),
    );
  }
} 