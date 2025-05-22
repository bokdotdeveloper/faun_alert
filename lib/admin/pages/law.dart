import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faun_alert/admin/law/add_law.dart';
import 'package:faun_alert/admin/law/edit_law.dart';
import 'package:flutter/material.dart';

class Law extends StatefulWidget {
  const Law({super.key});

  @override
  State<Law> createState() => _LawState();
}

class _LawState extends State<Law> {
  final CollectionReference<Map<String, dynamic>> _lawCollection =
      FirebaseFirestore.instance.collection('laws');

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                return AddLaw();
              },
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.gavel),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim().toLowerCase();
                  });
                },
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
                                  (data['title'] ?? '')
                                      .toString()
                                      .toLowerCase();
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
                          shadowColor: Colors.lightGreen,
                          surfaceTintColor: Colors.lightGreen,
                          margin: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Theme(
                            data: Theme.of(
                              context,
                            ).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              leading: const Icon(Icons.gavel, size: 40),
                              title: Text(
                                title,
                                style: const TextStyle(
                                  fontFamily: 'Inter Bold',
                                ),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
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
                                                (context) => EditLaw(
                                                  lawId: law.id,
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
                                                title: const Text(
                                                  'Delete Data',
                                                ),
                                                content: const Text(
                                                  'Are you sure you want to delete this data? This action cannot be undone.',
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
                                        await _lawCollection
                                            .doc(law.id)
                                            .delete();
                                      },
                                    ),
                                  ],
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
      ),
    );
  }
}
