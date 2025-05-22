import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class SightingPage extends StatefulWidget {
  const SightingPage({super.key});

  @override
  State<SightingPage> createState() => _SightingPageState();
}

class _SightingPageState extends State<SightingPage> {
  final List<String> _categories = [
    'All',
    'Mammals',
    'Birds',
    'Reptiles',
    'Amphibians',
    'Fish',
    'Invertebrates',
  ];

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
      appBar: AppBar(
        centerTitle: true,
        actionsPadding: EdgeInsets.all(8),
        title: const Text(
          'File Report',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 60,
                  child: TextField(
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
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 30,
                  width: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      return Text(
                        _categories[index],
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                        ),
                      );
                    },
                  ),
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
                      // Filter animals based on search query
                      final filteredAnimals =
                          _searchQuery.isEmpty
                              ? animals
                              : animals.where((animal) {
                                final data = animal.data();
                                final title =
                                    (data['name'] ?? '')
                                        .toString()
                                        .toLowerCase();
                                final description =
                                    (data['scientific_name'] ?? '')
                                        .toString()
                                        .toLowerCase();
                                return title.contains(_searchQuery) ||
                                    description.contains(_searchQuery);
                              }).toList();
            
                      if (filteredAnimals.isEmpty) {
                        return Center(
                          child: Text(
                            'No data found.',
                            style: TextStyle(fontFamily: 'Inter Italic'),
                          ),
                        );
                      }
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio:
                                  0.95, // Adjust as needed for your card layout
                            ),
                        itemCount: filteredAnimals.length,
                        itemBuilder: (context, index) {
                          final animal = filteredAnimals[index];
                          final data = animal.data();
                          final name =
                              ((data['name'] ?? '').toString().toUpperCase())
                                  .trim();
                          final imageUrl = data['image_url']?.toString() ?? '';
            
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                // Optionally handle tap to show more details
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child:
                                        imageUrl.isNotEmpty
                                            ? ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                    top: Radius.circular(12),
                                                  ),
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                                                child: Image.network(
                                                  imageUrl,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) => const Icon(
                                                        Icons.image_not_supported,
                                                        size: 50,
                                                      ),
                                                ),
                                              ),
                                            )
                                            : const Icon(Icons.image, size: 50),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'Inter Bold',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
      ),
    );
  }
}
