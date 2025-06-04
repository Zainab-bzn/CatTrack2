import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterIntakeScreen extends StatefulWidget {
  final double initialCatWeight;
  const WaterIntakeScreen({
    super.key,
    this.initialCatWeight = 0.0,
  });

  @override
  State<WaterIntakeScreen> createState() => _WaterIntakeScreenState();
}

class _WaterIntakeScreenState extends State<WaterIntakeScreen> {
  double _waterIntake = 0.0;
  double _catWeight = 0.0;
  final TextEditingController _intakeController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    // Set initial weight if provided
    if (widget.initialCatWeight > 0) {
      _catWeight = widget.initialCatWeight;
      _weightController.text = _catWeight.toString();
      _saveCatWeight(_catWeight);
    }
  }


  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _waterIntake = prefs.getDouble('waterIntake') ?? 0.0;
      _catWeight = prefs.getDouble('catWeight') ?? 0.0;
      _weightController.text = _catWeight > 0 ? _catWeight.toString() : '';

    });
  }

  Future<void> _saveWaterIntake(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _waterIntake += amount;
    });
    await prefs.setDouble('waterIntake', _waterIntake);
  }

  Future<void> _resetWaterIntake() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _waterIntake = 0.0;
    });
    await prefs.setDouble('waterIntake', _waterIntake);
  }

  Future<void> _saveCatWeight(double weight) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _catWeight = weight;
    });
    await prefs.setDouble('catWeight', _catWeight);
  }

  @override
  Widget build(BuildContext context) {
    final double recommendedIntake = _catWeight * 50;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Water Intake',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.blueGrey.shade800,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Lottie.asset(
              'assets/animations/water_animation.json',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 10),
            Text(
              'Total Water Intake: ${_waterIntake.toStringAsFixed(1)} ml',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_catWeight > 0)
              Text(
                'Recommended: ${recommendedIntake.toStringAsFixed(1)} ml/day',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            const SizedBox(height: 20),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Cat Weight (kg)',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                fillColor: Colors.blueGrey,
                filled: true,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final weight = double.tryParse(_weightController.text);
                if (weight != null && weight > 0) {
                  _saveCatWeight(weight);
                  _weightController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white, // <- Make text white
              ),
              child: const Text('Save Weight'),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: _intakeController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Enter water intake (ml)',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                fillColor: Colors.blueGrey,
                filled: true,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final amount = double.tryParse(_intakeController.text);
                    if (amount != null && amount > 0) {
                      _saveWaterIntake(amount);
                      _intakeController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add'),
                ),

                ElevatedButton(
                  onPressed: _resetWaterIntake,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
