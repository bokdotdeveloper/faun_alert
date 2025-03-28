import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  final VoidCallback gotToSignin;
  const Signup({super.key, required this.gotToSignin});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // text field controllers for email and password
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController middlenameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final FocusNode firstnameFocusNode = FocusNode();
  final FocusNode middlenameFocusNode = FocusNode();
  final FocusNode lastnameFocusNode = FocusNode();

  Future signUp() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      if (!isEmailValid(email)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid email address')),
          );
        }
        return;
      } else if (!isPasswordValid(password)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password must be at least 6 characters'),
            ),
          );
        }
        return;
      } else if (!isConfirmPasswordValid(
        password,
        confirmPasswordController.text.trim(),
      )) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Passwords do not match')),
          );
        }
        return;
      } else if (password.isEmpty || email.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill in all fields')),
          );
        }
        return;
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Call the method to add user details to the database
        await addUserDetails(
          firstnameController.text.trim(),
          middlenameController.text.trim(),
          lastnameController.text.trim(),
        );

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Sign-up successful!')));
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

  Future addUserDetails(
    String firstname,
    String middlename,
    String lastname,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'firstname': firstname,
        'middlename': middlename,
        'lastname': lastname,
      });
    } on FirebaseFirestore catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  bool isPasswordValid(String password) {
    // Add your password validation logic here
    return password.length >= 6; // Example: minimum length of 6 characters
  }

  bool isEmailValid(String email) {
    // Add your email validation logic here
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email); // Example regex
  }

  bool isConfirmPasswordValid(String password, String confirmPassword) {
    // Add your confirm password validation logic here
    return password == confirmPassword; // Example: passwords must match
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstnameController.dispose();
    middlenameController.dispose();
    lastnameController.dispose();
    firstnameFocusNode.dispose();
    middlenameFocusNode.dispose();
    lastnameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 252, 252, 252),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Sign up to Faun Alert',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Create an account to get started',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),

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
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: signUp,
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: widget.gotToSignin,
                        child: Text(
                          "Sign in here",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
