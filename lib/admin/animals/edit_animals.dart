import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditAnimals extends StatefulWidget {
  final String animalId;
  final Map<String, dynamic> initialData;

  const EditAnimals({
    Key? key,
    required this.animalId,
    required this.initialData,
  }) : super(key: key);

  @override
  State<EditAnimals> createState() => _EditAnimalsState();
}

class _EditAnimalsState extends State<EditAnimals> {
  late TextEditingController nameController;
  late TextEditingController scientificNameController;
  File? _imageFile;
  String? _imageUrl;
  final List<String> animal_type = [
    'Mammals',
    'Birds',
    'Reptiles',
    'Amphibians',
    'Fish',
    'Invertebrates',
  ];

  final List<String> category = [
    'Endangered',
  ];

  late Set<String> selectedCategories;
   late Set<String> selectedAnimalType;

  // Cloudinary config
  static const String cloudName = 'dyp7aay1y';
  static const String uploadPreset = 'ml_default';

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.initialData['name'] ?? '',
    );
    scientificNameController = TextEditingController(
      text: widget.initialData['scientific_name'] ?? '',
    );
    _imageUrl = widget.initialData['image_url'];
    selectedCategories = Set<String>.from(
      widget.initialData['category'] ?? [],
    );
    selectedAnimalType = Set<String>.from(
      widget.initialData['animal_type'] ?? [],
    );
  }

  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<String?> uploadImageToCloudinary(File image) async {
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );
    final request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = uploadPreset
          ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    final resStr = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      final resJson = jsonDecode(resStr);
      return resJson['secure_url'];
    } else {
      print('Cloudinary upload failed: ${response.statusCode}');
      print('Cloudinary response: $resStr');
      return null;
    }
  }

  Future<void> saveEdit() async {
    String? imageUrl = _imageUrl;

    // If a new image is picked, upload it
    if (_imageFile != null) {
      imageUrl = await uploadImageToCloudinary(_imageFile!);
    }

    await FirebaseFirestore.instance
        .collection('animals')
        .doc(widget.animalId)
        .update({
          'name': nameController.text.trim(),
          'scientific_name': scientificNameController.text.trim(),
          'image_url': imageUrl,
          'category': selectedCategories.toList(),
          'animal_type': selectedAnimalType.toList(),
          'updated_at': DateTime.now(),
        });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Animal updated successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Animal')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _imageFile != null
                        ? Image.file(_imageFile!, height: 120)
                        : (_imageUrl != null && _imageUrl!.isNotEmpty)
                        ? Image.network(_imageUrl!, height: 120)
                        : const Text('No image selected'),
                    ElevatedButton(
                      onPressed: pickImage,
                      child: const Text('Pick Animal Image'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: scientificNameController,
                  decoration: const InputDecoration(
                    labelText: 'Scientific Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 3 * 56.0,
                      child: ListView(
                        children:
                            category.map((category) {
                              return CheckboxListTile(
                                title: Text(category),
                                value: selectedCategories.contains(category),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedCategories.add(category);
                                    } else {
                                      selectedCategories.remove(category);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
                 const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Type',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 3 * 56.0,
                      child: ListView(
                        children:
                            animal_type.map((category) {
                              return CheckboxListTile(
                                title: Text(category),
                                value: selectedAnimalType.contains(category),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedAnimalType.add(category);
                                    } else {
                                      selectedAnimalType.remove(category);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: saveEdit,
                  child: const Text('Save Changes'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
