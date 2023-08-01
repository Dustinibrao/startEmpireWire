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
  int?
      currentIndex; // Track the index of the currently playing or paused podcast

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
        currentIndex =
            index; // Set currentIndex to the index of the currently playing podcast.
        isPlayingList[index] = true;
      });
    } catch (e) {
      // Handle error
    }
  }

  void pauseAudio(int index) async {
    await audioPlayer.pause();
    setState(() {
      currentIndex =
          index; // Set currentIndex to the index of the paused podcast.
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
          : ListView.separated(
              itemCount: episodes.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final episode = episodes[index];
                final isPlaying = isPlayingList[index];

                // Inside the itemBuilder in the ListView.separated
                return Column(
                  children: [
                    ListTile(
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
                    ),
                    if (currentIndex ==
                        index) // Show the progress indicator only for the currently playing or paused podcast
                      SizedBox(
                        height:
                            8, // Set the desired height of the progress indicator
                        child: StreamBuilder<Duration?>(
                          stream: audioPlayer.positionStream,
                          builder: (context, snapshot) {
                            final position = snapshot.data ?? Duration.zero;
                            final duration = audioPlayer.duration;

                            double progress = 0.0;
                            if (duration != null &&
                                duration.inMilliseconds > 0) {
                              progress = position.inMilliseconds /
                                  duration.inMilliseconds;
                            }

                            return Slider(
                              value: progress,
                              onChanged: (value) {
                                final seekTo = duration! * value;
                                audioPlayer.seek(seekTo);
                              },
                              activeColor: const Color(0xffff6a6f),
                              inactiveColor: Colors.black,
                            );
                          },
                        ),
                      ),
                  ],
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
