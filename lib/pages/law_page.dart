import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class LawPage extends StatefulWidget {
  const LawPage({super.key});

  @override
  State<LawPage> createState() => _LawPageState();
}

class _LawPageState extends State<LawPage> {
  final CollectionReference<Map<String, dynamic>> _lawCollection =
      FirebaseFirestore.instance.collection('laws');

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
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          children: [
            // Search Field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search laws...',
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
                stream: _lawCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: const Text('Loading...'));
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final laws = snapshot.data?.docs ?? [];
                  // Filter laws based on search query
                  final filteredLaws =
                      _searchQuery.isEmpty
                          ? laws
                          : laws.where((law) {
                            final data = law.data();
                            final title =
                                (data['title'] ?? '').toString().toLowerCase();
                            final description =
                                (data['description'] ?? '')
                                    .toString()
                                    .toLowerCase();
                            return title.contains(_searchQuery) ||
                                description.contains(_searchQuery);
                          }).toList();

                  if (filteredLaws.isEmpty) {
                    return Center(
                      child: Text(
                        'No data found.',
                        style: TextStyle(fontFamily: 'Inter Italic'),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredLaws.length,
                    itemBuilder: (context, index) {
                      final law = filteredLaws[index];
                      final data = law.data();
                      final title =
                          ((data['title'] ?? '').toString().toUpperCase())
                              .trim();
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: const Icon(Icons.gavel, size: 40),
                            title: Text(
                              title,
                              style: const TextStyle(fontFamily: 'Inter Bold'),
                            ),
                            tilePadding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            childrenPadding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Text(
                                  data['description'] ?? '',
                                  style: const TextStyle(
                                    fontFamily: 'Inter Italic',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
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
    );
  }
}
