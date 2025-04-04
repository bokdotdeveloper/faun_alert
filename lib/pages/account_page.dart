import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

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
                        title: "Notifications",
                        icon: Icons.notifications_none_rounded),
                    const _CustomListTile(
                        title: "Security Status",
                        icon: CupertinoIcons.lock_shield),
                  ],
                ),
                const Divider(),
                const _SingleSection(
                  title: "Organization",
                  children: [
                    _CustomListTile(
                        title: "Profile", icon: Icons.person_outline_rounded),
                    _CustomListTile(
                        title: "Messaging", icon: Icons.message_outlined),
                    _CustomListTile(
                        title: "Calling", icon: Icons.phone_outlined),
                    _CustomListTile(
                        title: "People", icon: Icons.contacts_outlined),
                    _CustomListTile(
                        title: "Calendar", icon: Icons.calendar_today_rounded)
                  ],
                ),
                const Divider(),
                _SingleSection(
                  children: [
                    _CustomListTile(
                        title: "Help & Feedback",
                        icon: Icons.help_outline_rounded),
                    _CustomListTile(
                        title: "About", icon: Icons.info_outline_rounded),
                    _CustomListTile(
                        title: "Sign out", icon: Icons.exit_to_app_rounded, onTap: _signOut),
                        
                  ],
                ),
            ],
          ),
        )
      ),
    );
  }
}




class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  const _CustomListTile(
      {Key? key, required this.title, required this.icon, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: onTap,
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

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
        Column(
          children: children,
        ),
      ],
    );
  }
}