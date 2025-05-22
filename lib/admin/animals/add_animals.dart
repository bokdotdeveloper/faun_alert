import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddAnimals extends StatefulWidget {
  const AddAnimals({super.key});

  @override
  State<AddAnimals> createState() => _AddAnimalsState();
}

class _CategoryCheckboxList extends StatelessWidget {
  final List<String> categories;
  final Set<String> selectedCategories;
  final void Function(String category, bool value) onChanged;

  const _CategoryCheckboxList({
    Key? key,
    required this.categories,
    required this.selectedCategories,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children:
          categories.map((category) {
            return CheckboxListTile(
              title: Text(category),
              value: selectedCategories.contains(category),
              onChanged: (bool? value) {
                if (value != null) {
                  onChanged(category, value);
                }
              },
            );
          }).toList(),
    );
  }
}

class _AddAnimalsState extends State<AddAnimals> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController scientificNameController =
      TextEditingController();
  File? _imageFile;

  @override
  void dispose() {
    nameController.dispose();
    scientificNameController.dispose();
    super.dispose();
  }

  final List<String> animal_type = [
    'Mammals',
    'Birds',
    'Reptiles',
    'Amphibians',
    'Fish',
    'Invertebrates',
  ];

  final List<String> category = ['Endangered'];

  final Set<String> selectedCategories = {};
  final Set<String> selectedAnimalType = {};

  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  // Replace with your Cloudinary upload preset and cloud name
  static const String cloudName = 'dyp7aay1y';
  static const String uploadPreset = 'ml_default';

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

  Future add() async {
    if (nameController.text.trim().isEmpty ||
        scientificNameController.text.trim().isEmpty ||
        selectedCategories.isEmpty || _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all required fields and select at least one category.',
          ),
        ),
      );
      return;
    }

    try {
      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await uploadImageToCloudinary(_imageFile!);
      }
      await addAnimalDetails(
        nameController.text.trim(),
        scientificNameController.text.trim(),
        imageUrl,
        selectedCategories.toList(),
        selectedAnimalType.toList(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Animal added successfully!')),
        );

        setState(() {
          selectedCategories.clear();
        });
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred.')),
        );
      }
    }
  }

  Future addAnimalDetails(
    String name,
    String scientific_name,
    String? imageUrl,
    List<String> selectedCategories,
    List<String> selectedAnimalType,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('animals').doc().set({
        'name': name,
        'scientific_name': scientific_name,
        'image_url': imageUrl,
        'category': selectedCategories,
        'animal_type': selectedAnimalType,
        'dateCreated': DateTime.now(),
      });
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actionsPadding: EdgeInsets.all(8),
        title: const Text(
          'Animal Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Add notification logic here
              debugPrint(
                'Notification bell pressed',
              ); // Use debugPrint for logging
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _imageFile != null
                        ? Image.file(_imageFile!, height: 120)
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
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: scientificNameController,
                  decoration: InputDecoration(
                    labelText: 'Scientific Name',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Category checkboxes with fixed height and vertical scrolling
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter Bold',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height:
                          3 *
                          56.0, // 3 items, each CheckboxListTile is about 56px tall
                      child: _CategoryCheckboxList(
                        categories: category,
                        selectedCategories: selectedCategories,
                        onChanged: (category, value) {
                          setState(() {
                            if (value) {
                              selectedCategories.add(category);
                            } else {
                              selectedCategories.remove(category);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
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
                child: GestureDetector(
                  onTap: () {
                    add();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Inter Bold',
                        ),
                      ),
                    ),
                  ),
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
