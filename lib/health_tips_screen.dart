import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HealthTipsScreen extends StatefulWidget {
  final String? catBreed;

  const HealthTipsScreen({Key? key, this.catBreed}) : super(key: key);

  @override
  State<HealthTipsScreen> createState() => _HealthTipsScreenState();
}
class _HealthTipsScreenState extends State<HealthTipsScreen> {
  List<String> _tips = [];
  String _currentTip = "Loading tips...";
  bool _isLoading = true;
  bool _isBreedSpecific = false;
  String? _displayedBreed;

  @override
  void initState() {
    super.initState();
    _fetchTips();
  }

  Future<void> _fetchTips() async {
    try {
      final breedParam = widget.catBreed != null
          ? Uri.encodeComponent(widget.catBreed!.toLowerCase().trim())
          : '';

      final response = await http.get(
        Uri.parse('http://meowtrack.atwebpages.com/get_tips.php?breed=$breedParam'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            _tips = List<String>.from(data['tips']);
            _isBreedSpecific = data['isBreedSpecific'] ?? false;
            _displayedBreed = widget.catBreed;

            if (_tips.isNotEmpty) {
              _getRandomTip();
            } else {
              _currentTip = "No tips available for ${widget.catBreed ?? 'cats'}";
            }
            _isLoading = false;
          });
          return;
        }
      }
      setState(() {
        _currentTip = "No tips available for ${widget.catBreed ?? 'cats'}";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _currentTip = "Failed to load tips. Please try again.";
        _isLoading = false;
      });
    }
  }

  void _getRandomTip() {
    if (_tips.isEmpty) return;

    final random = Random();
    setState(() {
      _currentTip = _tips[random.nextInt(_tips.length)];
      // Check if the tip is breed-specific (you might need to adjust this logic)
      _isBreedSpecific = widget.catBreed != null &&
          _currentTip.toLowerCase().contains(widget.catBreed!.toLowerCase());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.catBreed != null
            ? "${widget.catBreed} Health Tips"
            : "Cat Health Tips"),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.health_and_safety,
                size: 100, color: Colors.deepPurple),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : Text(
              _currentTip,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (_isBreedSpecific)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "(Breed-specific tip)",
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.deepPurple[400],
                  ),
                ),
              ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _getRandomTip,
              icon: const Icon(Icons.refresh),
              label: const Text("New Tip"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}