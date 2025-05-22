import 'package:faun_alert/admin/user/add_user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
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
        backgroundColor: Colors.lightGreen,
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
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _usersCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final users = snapshot.data?.docs ?? [];
                if (users.isEmpty) {
                  return const Text('No users found.');
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final data = user.data();
                    final fullName =
                        ((data['firstname'] ?? '').toString().toUpperCase() +
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
                                            () =>
                                                Navigator.of(context).pop(true),
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                            );
                            if (confirm != true) return;

                            // Delete from Firestore
                            await _usersCollection.doc(user.id).delete();

                            try {
                              final HttpsCallable callable = FirebaseFunctions
                                  .instance
                                  .httpsCallable('usersDeleteUser');
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
        ),
      ),
    );
  }
}
