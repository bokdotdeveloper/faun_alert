import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController middlenameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();

  String generateTempPassword({int length = 8}) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(length, (index) {
      final rand = DateTime.now().microsecondsSinceEpoch + index;
      return chars[(rand % chars.length)];
    }).join();
  }

  Future signUp() async {
    String email = emailController.text.trim();

    try {
      if (!isEmailValid(email)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid email address')),
          );
        }
        return;
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: generateTempPassword(),
        );

        // Call the method to add user details to the database
        await addUserDetails(
          firstnameController.text.trim(),
          middlenameController.text.trim(),
          lastnameController.text.trim(),
          emailController.text.trim(),
        );

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('User added successfully!')));
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message.toString())));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred.')),
        );
      }
    }
  }

  bool isEmailValid(String email) {
    // Add your email validation logic here
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email); // Example regex
  }


  Future addUserDetails(
    String firstname,
    String middlename,
    String lastname,
    String email
  ) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid, // Explicitly store the UID as a field
        'firstname': firstname,
        'middlename': middlename,
        'lastname': lastname,
        'email': email,
        'role': 'user', // Default role
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
          'User Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Image.asset(
            'assets/AppLogo.png', // Ensure the path is correct
            height: 40, // Adjust height as needed
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
                  controller: firstnameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
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
                  controller: middlenameController,
                  decoration: InputDecoration(
                    labelText: 'Middle Name',
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
                  controller: lastnameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
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
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
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
                  onTap: (){
                    signUp();
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
            ],
          ),
        ),
      ),
    );
  }
}
