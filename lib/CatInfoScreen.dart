import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'DashboardScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CatInfoScreen extends StatefulWidget {
  final bool prefilled;
  final String? catName;
  final String? catAge;
  final String? catBreed;
  final String? catColor;
  final double catWeight;

  const CatInfoScreen({
    super.key,
    this.prefilled = false,
    this.catName,
    this.catAge,
    this.catBreed,
    this.catColor,
    required this.catWeight,
  });


  @override
  State<CatInfoScreen> createState() => _CatInfoScreenState();
}

class _CatInfoScreenState extends State<CatInfoScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _colorController;
  late String _selectedBreed;
  late String _catType;


  final List<String> _breeds = [
    'Persian',
    'Chinchilla',
    'Siamese',
    'Maine Coon',
    'Ragdoll',
    'British Shorthair',
    'Sphynx',
    'Bengal',
    'Scottish Fold',
  ];

  @override
  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.prefilled ? widget.catName : '');
    _ageController = TextEditingController(text: widget.prefilled ? widget.catAge : '');
    _colorController = TextEditingController(text: widget.prefilled ? widget.catColor ?? '' : '');

    if (widget.prefilled && widget.catBreed != null && _breeds.contains(widget.catBreed)) {
      _selectedBreed = widget.prefilled && widget.catBreed != null && _breeds.contains(widget.catBreed)
          ? widget.catBreed!
          : 'Persian';
          _catType = 'Indoor';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _saveInfo() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      String name = _nameController.text;
      String age = _ageController.text;
      String breed = _selectedBreed;
      String color = _colorController.text;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        throw Exception("User not logged in");
      }

      // Save to local storage
      await prefs.setString('catName', name);
      await prefs.setString('catAge', age);
      await prefs.setString('catBreed', breed);
      await prefs.setString('catColor', color);

      // Save to backend
      final response = await http.post(
        Uri.parse('http://meowtrack.atwebpages.com/update_user_info.php'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          'user_id': userId,
          'cat_name': name,
          'cat_age': age,
          'cat_breed': breed,
          'cat_color': color,
          'cat_weight': widget.catWeight,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          Navigator.pop(context); // Dismiss loading
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(

                catName: name,
                catAge: age,
                catBreed: breed,
                catColor: color,
                catWeight: widget.catWeight,
              ),
            ),
          );
        } else {
          throw Exception(data['message'] ?? "Failed to save data");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      Navigator.pop(context); // Dismiss loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
      print("Save error: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome to MeowTrack!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink[200],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Lottie.asset('assets/animations/cat_intro_animation.json', height: 200),
            const SizedBox(height: 20),
            const Text(
              'Cat Info',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                filled: true,
                fillColor: Colors.blueGrey[50],
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: 'Age',
                filled: true,
                fillColor: Colors.blueGrey[50],
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _selectedBreed,
              items: _breeds
                  .map((breed) => DropdownMenuItem(
                value: breed,
                child: Text(breed),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBreed = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Breed',
                filled: true,
                fillColor: Colors.blueGrey[50],
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _colorController,
              decoration: InputDecoration(
                labelText: 'Color',
                filled: true,
                fillColor: Colors.blueGrey[50],
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Type:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text("🏠 Indoor"),
                    value: 'Indoor',
                    groupValue: _catType,
                    onChanged: (value) {
                      setState(() {
                        _catType = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text("🌳 Outdoor"),
                    value: 'Outdoor',
                    groupValue: _catType,
                    onChanged: (value) {
                      setState(() {
                        _catType = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[200],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text('Save Info', style: TextStyle(fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}
