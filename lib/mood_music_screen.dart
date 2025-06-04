import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';

class MoodMusicScreen extends StatefulWidget {
  const MoodMusicScreen({super.key});

  @override
  State<MoodMusicScreen> createState() => _MoodMusicScreenState();
}

class _MoodMusicScreenState extends State<MoodMusicScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentMood;

  final Map<String, String> _moodTracks = {
    'Happy': 'music/Happy.mp3',
    'Playful': 'music/Playful.mp3',
    'Sleepy': 'music/Sleepy.mp3',
    'Relaxed': 'music/Relaxed.mp3',
  };

  final Map<String, IconData> _moodIcons = {
    'Happy': Icons.emoji_emotions,
    'Playful': Icons.pets,
    'Sleepy': Icons.bedtime,
    'Relaxed': Icons.spa,
  };

  void _playMood(String mood) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(_moodTracks[mood]!));
    setState(() {
      _currentMood = mood;
    });
  }

  void _stopMusic() async {
    await _audioPlayer.stop();
    setState(() {
      _currentMood = null;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[500],
        title: const Text("Mood Music", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Lottie.asset('assets/animations/musics_animation.json', height: 200),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: _moodTracks.keys.map((mood) {
                return Card(
                  color: Colors.blueGrey,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      _moodIcons[mood],
                      color: Colors.white,
                    ),
                    title: Text(
                      mood,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    trailing: _currentMood == mood
                        ? IconButton(
                      icon: const Icon(Icons.stop, color: Colors.white),
                      onPressed: _stopMusic,
                    )
                        : IconButton(
                      icon:
                      const Icon(Icons.play_arrow, color: Colors.white),
                      onPressed: () => _playMood(mood),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
