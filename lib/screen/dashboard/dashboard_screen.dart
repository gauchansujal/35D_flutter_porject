import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/dashboard/profile_screen.dart';
import 'package:flutter_application_1/screen/dashboard/setting_screen.dart';
import 'package:flutter_application_1/screen/dashboard/widgets/bike_card.dart';
import 'package:flutter_application_1/screen/dashboard/widgets/bike_search.dart';
import 'package:flutter_application_1/screen/dashboard/widgets/header_widget.dart';
import 'package:flutter_application_1/screen/dashboard/widgets/quick_access.dart';

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
        onTap: (index) => setState(() => _currentIndex = index),
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

  Widget _getBody() {
    switch (_currentIndex) {
      case 1:
        return const ProfilePage();
      case 2:
        return const SettingPage();
      default:
        return const HomePage();
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWidget(),
          SizedBox(height: 20),
          QuickAccess(),
          SizedBox(height: 20),
          BikeSearch(),
          SizedBox(height: 20),
          BikeCard(),
        ],
      ),
    );
  }
}
