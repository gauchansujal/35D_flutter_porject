import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.lock, color: Colors.white),
          title: Text("Change Password", style: TextStyle(color: Colors.white)),
        ),
        ListTile(
          leading: Icon(Icons.notifications, color: Colors.white),
          title: Text("Notifications", style: TextStyle(color: Colors.white)),
        ),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.white),
          title: Text("Logout", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
