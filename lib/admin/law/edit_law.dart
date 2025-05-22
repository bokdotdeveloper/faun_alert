import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditLaw extends StatefulWidget {
  final String lawId;
  final Map<String, dynamic> initialData;

  const EditLaw({super.key, required this.lawId, required this.initialData});

  @override
  State<EditLaw> createState() => _EditLawState();
}

class _EditLawState extends State<EditLaw> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialData['title']);
    descriptionController = TextEditingController(
      text: widget.initialData['description'],
    );
  }

  Future<void> saveEdit() async {
    await FirebaseFirestore.instance
        .collection('laws')
        .doc(widget.lawId)
        .update({
          'title': titleController.text,
          'description': descriptionController.text,
        });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actionsPadding: EdgeInsets.all(8),
        title: const Text(
          'Update Law Details',
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
      body: Column(
        children: [
          const SizedBox(height: 40),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
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
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                saveEdit();
              },
              child: Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Update',
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
    );
  }
}
