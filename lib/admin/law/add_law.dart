import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddLaw extends StatefulWidget {
  const AddLaw({super.key});

  @override
  State<AddLaw> createState() => _AddLawState();
}

class _AddLawState extends State<AddLaw> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future add() async {
    try {
      await addLawDetails(
        titleController.text.trim(),
        descriptionController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Law added successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred.')),
        );
      }
    }
  }

  Future addLawDetails(String title, String description) async {
    try {
      await FirebaseFirestore.instance.collection('laws').doc().set({
        'title': title,
        'description': description,
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
        centerTitle: true,
        actionsPadding: EdgeInsets.all(8),
        title: const Text(
          'Law Details',
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
