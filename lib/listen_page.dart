import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(MaterialApp(
    home: ListenPage(),
  ));
}

class ListenPage extends StatefulWidget {
  @override
  _ListenPageState createState() => _ListenPageState();
}

class _ListenPageState extends State<ListenPage> {
  List<Episode> episodes = [];
  bool isLoading = true;
  late AudioPlayer audioPlayer;
  late List<bool> isPlayingList;
  int? currentIndex;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.setAsset('');
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
        currentIndex = index;
        isPlayingList[index] = true;
      });
    } catch (e) {
      // Handle error
    }
  }

  void pauseAudio(int index) async {
    await audioPlayer.pause();
    setState(() {
      currentIndex = index;
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

                return Column(
                  children: [
                    ListTile(
                      title: Text(episode.title),
                      // subtitle: Text(episode.publishedDate),
                      onTap: () {
                        if (isPlaying) {
                          pauseAudio(index);
                        } else {
                          playAudio(episode.audioUrl, index);
                        }
                      },
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 100, // Adjust the width as needed
                            height: 120, // Adjust the height as needed
                            child: Image.network(
                              episode.thumbnailUrl,
                              fit: BoxFit
                                  .cover, // Maintain aspect ratio and crop if necessary
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              formatDurationFromString(episode.durationString),
                              style: const TextStyle(
                                backgroundColor: Colors.black45,
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                    if (currentIndex == index)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: StreamBuilder<Duration?>(
                              stream: audioPlayer.positionStream,
                              builder: (context, snapshot) {
                                final position = snapshot.data ?? Duration.zero;
                                final duration = audioPlayer.duration;

                                final elapsedTime = formatDuration(position);
                                final totalTime = duration != null
                                    ? formatDuration(duration)
                                    : '';

                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(elapsedTime),
                                    Text(totalTime),
                                  ],
                                );
                              },
                            ),
                          ),
                          StreamBuilder<Duration?>(
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
                        ],
                      ),
                  ],
                );
              },
            ),
    );
  }

  String formatDuration(Duration? duration) {
    if (duration == null) {
      return '00:00';
    }

    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String formatDurationFromString(String durationString) {
    final parts = durationString.split(':');
    int minutes = int.parse(parts[0]);
    int seconds = int.parse(parts[1]);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class Episode {
  final String title;
  final String thumbnailUrl;
  final String publishedDate;
  final String audioUrl;
  final String durationString;

  Episode({
    required this.title,
    required this.thumbnailUrl,
    required this.publishedDate,
    required this.audioUrl,
    required this.durationString,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      title: json['title']['rendered'] ?? 'No title available',
      thumbnailUrl: json['episode_featured_image'] ?? '',
      publishedDate: json['date'] ?? '',
      audioUrl: json['player_link'] ?? '',
      durationString: json['meta']['duration'] ??
          '0:00', // Get the duration string from the API response
    );
  }
}
