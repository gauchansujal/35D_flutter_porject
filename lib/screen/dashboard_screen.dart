import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: SafeArea(child: _getBody()),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF0B1220),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white60,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  // 🔹 Switch pages
  Widget _getBody() {
    switch (_currentIndex) {
      case 1:
        return _profilePage();
      case 2:
        return _settingsPage();
      default:
        return _homePage();
    }
  }

  // 🔹 Home Page
  Widget _homePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_header(), const SizedBox(height: 20), _quickAccess()],
      ),
    );
  }

  // 🔹 Profile Page
  Widget _profilePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
          SizedBox(height: 12),
          Text("John Doe", style: TextStyle(color: Colors.white, fontSize: 18)),
          SizedBox(height: 6),
          Text("john@example.com", style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  // 🔹 Settings Page
  Widget _settingsPage() {
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

  // 🔹 Header
  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF3B4EFF), Color(0xFF1B2B8F)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.pedal_bike, color: Colors.white, size: 28),
              SizedBox(height: 6),
              Text(
                "Bike Rental",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // 🔹 Quick Access
  Widget _quickAccess() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Quick Access", style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _iconBox(Icons.verified_user, Colors.indigo),
            _iconBox(Icons.person, Colors.green),
            _iconBox(Icons.description, Colors.orange),
            _iconBox(Icons.wallet, Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _iconBox(IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(icon, color: Colors.white, size: 40),
    );
  }
}
