import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  final user = FirebaseAuth.instance.currentUser!;
  String? firstName;

  @override
  void initState() {
    super.initState();
    _fetchFirstName();
  }

  Future _fetchFirstName() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          firstName = doc.data()?['firstName'] ?? 'User';
        });
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'An error occurred')),
        );
      }
    }
  }

  Future _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login page or perform any other action after sign out
    } catch (e) {
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              _SingleSection(
                title: "General",
                children: [
                  _CustomListTile(
                    title: "Profile",
                    icon: Icons.person_outline_rounded,
                  ),
                ],
              ),
              const Divider(),
              _SingleSection(
                children: [
                  _CustomListTile(
                    title: "Help & Feedback",
                    icon: Icons.help_outline_rounded,
                  ),
                  _CustomListTile(
                    title: "About",
                    icon: Icons.info_outline_rounded,
                  ),
                  _CustomListTile(
                    title: "Sign out",
                    icon: Icons.exit_to_app_rounded,
                    onTap: _signOut,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  const _CustomListTile({required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(title), leading: Icon(icon), onTap: onTap);
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(children: children),
      ],
    );
  }
}
