import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

// void main() {
//   runApp(PodcastApp());
// }

// class PodcastApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Podcast App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ListenPage(),
//     );
//   }
// }

class ListenPage extends StatefulWidget {
  @override
  _ListenPageState createState() => _ListenPageState();
}

class _ListenPageState extends State<ListenPage> {
  List<Episode> episodes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEpisodes();
  }

  Future<void> fetchEpisodes() async {
    try {
      final response = await http.get(
        Uri.parse('https://startempirewire.com/wp-json/wp/v2/podcast'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;

        setState(() {
          episodes = data.map((episode) => Episode.fromJson(episode)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void playAudio(String audioUrl) {
    AudioPlayer audioPlayer = AudioPlayer();
    audioPlayer.play(audioUrl as Source);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: const Text("Listen"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: episodes.length,
              itemBuilder: (context, index) {
                final episode = episodes[index];
                return ListTile(
                  leading: Image.network(episode.thumbnailUrl),
                  title: Text(episode.title),
                  subtitle: Text(episode.publishedDate),
                  onTap: () {
                    // Play the episode audio
                    playAudio(episode.audioUrl);
                  },
                );
              },
            ),
    );
  }
}

class Episode {
  final String title;
  final String thumbnailUrl;
  final String publishedDate;
  final String audioUrl;

  Episode({
    required this.title,
    required this.thumbnailUrl,
    required this.publishedDate,
    required this.audioUrl,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      title: json['title']['rendered'] ?? 'No title available',
      thumbnailUrl: json['episode_featured_image'] ?? '',
      publishedDate: json['date'] ?? '',
      audioUrl: json['audio_file'] ?? '',
    );
  }
}
