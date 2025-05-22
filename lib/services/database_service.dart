import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = 'users';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DatabaseService();

  Future<void> createUser(
    String uid,
    String email,
    String firstName,
    String middleName,
    String lastName,
    String role,
    String password,
  ) async {
    try {
      await _firestore.collection(USER_COLLECTION).doc(uid).set({
        'uid': uid,
        'email': email,
        'first_name': firstName,
        'middle_name': middleName,
        'last_name': lastName,
        'role': role,
        'password': password,
      });
    } catch (e) {
      print('Error creating user: $e');
    }
  }
}
