import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class ListenPage extends StatefulWidget {
  @override
  _ListenPageState createState() => _ListenPageState();
}

class _ListenPageState extends State<ListenPage> {
  List<Episode> episodes = [];
  bool isLoading = true;
  late AudioPlayer audioPlayer;
  late List<bool> isPlayingList;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.setAsset(''); // Add an empty asset to initialize the player
    fetchEpisodes();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
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
          isPlayingList = List.generate(episodes.length, (_) => false);
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

  void playAudio(String audioUrl, int index) async {
    try {
      await audioPlayer.setUrl(audioUrl);
      await audioPlayer.play();
      setState(() {
        isPlayingList[index] = true;
      });
    } catch (e) {
      // Handle error
    }
  }

  void pauseAudio(int index) async {
    await audioPlayer.pause();
    setState(() {
      isPlayingList[index] = false;
    });
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
                final isPlaying = isPlayingList[index];

                return ListTile(
                  leading: Image.network(episode.thumbnailUrl),
                  title: Text(episode.title),
                  onTap: () {
                    if (isPlaying) {
                      pauseAudio(index);
                    } else {
                      playAudio(episode.audioUrl, index);
                    }
                  },
                  trailing: isPlaying
                      ? IconButton(
                          icon: const Icon(Icons.pause),
                          onPressed: () {
                            pauseAudio(index);
                          },
                        )
                      : IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () {
                            playAudio(episode.audioUrl, index);
                          },
                        ),
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
      audioUrl: json['player_link'] ?? '',
    );
  }
}
