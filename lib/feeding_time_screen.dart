import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FeedingTimeScreen extends StatefulWidget {
  const FeedingTimeScreen({Key? key}) : super(key: key);

  @override
  State<FeedingTimeScreen> createState() => _FeedingTimeScreenState();
}

class _FeedingTimeScreenState extends State<FeedingTimeScreen> {
  TextEditingController _feedingTimeController = TextEditingController();
  List<String> feedingTimes = [];

  @override
  void initState() {
    super.initState();
    _loadFeedingTimes();
  }

  void _loadFeedingTimes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    setState(() {
      feedingTimes = prefs.getStringList('feeding_times_$userId') ?? [];
    });
  }

  void _saveFeedingTimes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    prefs.setStringList('feeding_times_$userId', feedingTimes);

    if (userId != null) {
      final response = await http.post(
        Uri.parse('http://meowtrack.atwebpages.com/save_feeding_times.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'user_id': userId,
          'feeding_time1': feedingTimes.isNotEmpty ? feedingTimes[0] : null,
          'feeding_time2': feedingTimes.length > 1 ? feedingTimes[1] : null,
          'feeding_time3': feedingTimes.length > 2 ? feedingTimes[2] : null,
          'feeding_time4': feedingTimes.length > 3 ? feedingTimes[3] : null,
        }),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        if (res['status'] == 'Success') {
          print("✅ Feeding times saved to DB");
        } else {
          print("❌ DB Error: ${res['error']}");
        }
      } else {
        print("❌ Server error saving feeding times");
      }
    }
  }

  void _addFeedingTime(TimeOfDay time) {
    final formattedTime = '${time.hour}:${time.minute}';
    setState(() {
      feedingTimes.add(formattedTime);
      _saveFeedingTimes();
    });
  }

  void _resetFeedingTimes() {
    setState(() {
      feedingTimes.clear();
      _saveFeedingTimes();
    });
  }

  Future<void> _selectFeedingTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      _addFeedingTime(selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feeding Time"),
        centerTitle: true,
        backgroundColor: Colors.pink[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              child: Lottie.asset(
                'assets/animations/feeding_animation.json',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.white);
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectFeedingTime(context),
              child: const Text('Select Feeding Time'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[200],
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: feedingTimes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(feedingTimes[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          feedingTimes.removeAt(index);
                          _saveFeedingTimes();
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _resetFeedingTimes,
              child: const Text('Reset Feeding Times'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[200],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}