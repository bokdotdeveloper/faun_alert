import 'package:faun_alert/pages/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  final VoidCallback goToSignup;
  const Signin({Key? key, required this.goToSignup}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  // text field controllers for email and password
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  // function to handle sign in logic
  Future signIn() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      // Attempt to sign in with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // If successful, navigate to the next screen or show a success message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sign-in successful!')));
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      String errorMessage;
      if (e.code == 'invalid-credential') {
        errorMessage = 'Invalid email / password. Please try again.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else {
        errorMessage = 'An error occurred. Please try again.';
      }

      // Show the error message in a SnackBar or AlertDialog
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      // Handle any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred.')),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                    'Welcome to Faun Alert',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Please sign in to continue',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  const SizedBox(height: 40),
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
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () => {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ForgotPassword();
                          }
                        ))
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: signIn,
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Sign In',
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
                        "Don't have an account?",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: widget.goToSignup,
                        child: Text(
                          "Sign up here",
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
