import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'CatInfoScreen.dart';
import 'feeding_time_screen.dart';
import 'mood_music_screen.dart';
import 'water_intake_screen.dart';
import 'health_tips_screen.dart';
import 'main.dart';

class DashboardScreen extends StatelessWidget {
  final String catName;
  final String catAge;
  final double catWeight;
  final String catBreed;
  final String catColor;

  const DashboardScreen({
    super.key,
    required this.catName,
    required this.catAge,
    required this.catBreed,
    required this.catColor,
    required this.catWeight,
  });

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MeowTrackApp()),
          (route) => false,
    );
  }

  void _editProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CatInfoScreen(
          prefilled: true,
          catName: catName,
          catAge: catAge,
          catBreed: catBreed,
          catColor: catColor,
          catWeight: catWeight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent[50],
        title: const Text('MeowTrack Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Profile',
            onPressed: () => _editProfile(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Cat Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name: $catName",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Age: $catAge",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Breed: $catBreed",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Animation
                  SizedBox(
                    height: 100,
                    child: Lottie.asset(
                      'assets/animations/dashboard_animation.json',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, color: Colors.red);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Dashboard Options
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildDashboardTile(
                    context,
                    icon: Icons.restaurant_menu,
                    label: "Feeding Time",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FeedingTimeScreen()),
                    ),
                  ),
                  _buildDashboardTile(
                    context,
                    icon: Icons.local_drink,
                    label: "Water Intake",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => WaterIntakeScreen(initialCatWeight: catWeight)),
                    ),
                  ),
                  _buildDashboardTile(
                    context,
                    icon: Icons.music_note,
                    label: "Mood Music",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MoodMusicScreen()),
                    ),
                  ),
                  _buildDashboardTile(
                    context,
                    icon: Icons.health_and_safety,
                    label: "Health Tips",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HealthTipsScreen(catBreed: catBreed)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTile(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.pink[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}