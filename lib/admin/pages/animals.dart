import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faun_alert/admin/animals/add_animals.dart';
import 'package:faun_alert/admin/animals/animal_profile.dart';
import 'package:faun_alert/admin/animals/edit_animals.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Animals extends StatefulWidget {
  const Animals({super.key});

  @override
  State<Animals> createState() => _AnimalsState();
}

class _AnimalsState extends State<Animals> {
  final CollectionReference<Map<String, dynamic>> _animalCollection =
      FirebaseFirestore.instance.collection('animals');

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel(); // Cancel debounce timer if active
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = value.trim().toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddAnimals();
              },
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.pets),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search animals...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onChanged: _onSearchChanged, // Use the debounced handler
              ),
              const SizedBox(height: 12),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _animalCollection.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: const Text('Loading...'));
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    final animals = snapshot.data?.docs ?? [];
                    if (animals.isEmpty) {
                      return const Text('No animals found.');
                    }
                    final filteredAnimals =
                        _searchQuery.isEmpty
                            ? animals
                            : animals.where((law) {
                              final data = law.data();
                              final name =
                                  (data['name'] ?? '').toString().toLowerCase();
                              final scientific_name =
                                  (data['scientific_name'] ?? '')
                                      .toString()
                                      .toLowerCase();
                              return name.contains(_searchQuery) ||
                                  scientific_name.contains(_searchQuery);
                            }).toList();

                    if (filteredAnimals.isEmpty) {
                      return Center(
                        child: Text(
                          'No data found.',
                          style: TextStyle(fontFamily: 'Inter Italic'),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredAnimals.length,
                      itemBuilder: (context, index) {
                        final animal = filteredAnimals[index];
                        final data = animal.data();
                        final name =
                            ((data['name'] ?? '').toString().toUpperCase())
                                .trim();
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6.0),
                          child: ListTile(
                            leading:
                                data['image_url'] != null &&
                                        data['image_url'].toString().isNotEmpty
                                    ? Image.network(
                                      data['image_url'],
                                      width: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.image_not_supported,
                                                size: 50,
                                              ),
                                    )
                                    : const Icon(Icons.image, size: 50),
                            title: Text(name),
                            subtitle: Text(
                              data['scientific_name'] ?? '',
                              style: TextStyle(fontFamily: 'Inter Italic'),
                            ),
                            trailing: Row(
                              mainAxisSize:
                                  MainAxisSize.min, // <-- Add this line
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => EditAnimals(
                                              animalId: animal.id,
                                              initialData: data,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: const Text('Delete User'),
                                            content: const Text(
                                              'Are you sure you want to delete this user? This action cannot be undone.',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.of(
                                                      context,
                                                    ).pop(false),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.of(
                                                      context,
                                                    ).pop(true),
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    );
                                    if (confirm != true) return;

                                    // Delete from Firestore
                                    await _animalCollection
                                        .doc(animal.id)
                                        .delete();
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => AnimalProfile(
                                        animalData:
                                            data, // Pass the animal data
                                      ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
