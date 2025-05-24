import 'package:faun_alert/admin/user/add_user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:async';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  Timer? _debounce;

  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('users');

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
                return AddUser();
              },
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.person_add),
      ),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Notification bell on the right
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
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search user...',
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
                  stream: _usersCollection.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: const Text('Loading...'));
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    final users = snapshot.data?.docs ?? [];
                    if (users.isEmpty) {
                      return const Text('No animals found.');
                    }
                    final filteredUsers =
                        _searchQuery.isEmpty
                            ? users
                            : users.where((user) {
                              final data = user.data();
                              return (data['firstname'] ?? '').toString().toLowerCase().contains(_searchQuery) ||
                                  (data['lastname'] ?? '').toString().toLowerCase().contains(_searchQuery) ||
                                  (data['email'] ?? '').toString().toLowerCase().contains(_searchQuery);
                            }).toList();

                    if (filteredUsers.isEmpty) {
                      return Center(
                        child: Text(
                          'No data found.',
                          style: TextStyle(fontFamily: 'Inter Italic'),
                        ),
                      );
                    }
                    return ListView.builder(
                       shrinkWrap: true,
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final users = filteredUsers[index];
                        final data = users.data();
                        final fullName =
                            ((data['firstname'] ?? '')
                                        .toString()
                                        .toUpperCase() +
                                    " " +
                                    (data['lastname'] ?? '')
                                        .toString()
                                        .toUpperCase())
                                .trim();
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6.0),
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(fullName),
                            subtitle: Text(data['email'] ?? ''),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
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
                                await _usersCollection.doc(users.id).delete();

                                try {
                                  final HttpsCallable callable =
                                      FirebaseFunctions.instance.httpsCallable(
                                        'usersDeleteUser',
                                      );
                                  await callable.call({'uid': data['uid']});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'User deleted from Auth and Firestore',
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Failed to delete user from Auth: $e',
                                      ),
                                    ),
                                  );
                                  print('Error deleting user from Auth: $e');
                                }
                              },
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
