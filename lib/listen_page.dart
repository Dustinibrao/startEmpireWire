import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:miniplayer/miniplayer.dart';
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
  int? loadingIndex; // Index of the episode currently loading

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
        });
      }
    } catch (e) {
      // Handle the error, for example, by displaying an error message
      print('Error fetching episodes: $e');
    } finally {
      setState(() {
        isLoading =
            false; // Set isLoading to false regardless of success or error
      });
    }
  }

  Duration? lastPosition;

  void playAudio(String audioUrl, int index) async {
    try {
      final episode = episodes[index];

      // Set the playback position if available
      final lastPlaybackPosition = episode.playbackPosition;
      if (lastPlaybackPosition != null) {
        await audioPlayer.seek(lastPlaybackPosition);
      }

      setState(() {
        loadingIndex = index; // Set loading state for the pressed episode
      });

      await audioPlayer.setUrl(
        audioUrl,
        preload: true,
      );

      await audioPlayer.play();

      setState(() {
        currentIndex = index;
        isPlayingList[index] = true;
        loadingIndex = null; // Clear loading state
      });
    } catch (e) {
      setState(() {
        loadingIndex = null; // Clear loading state in case of error
      });
      // Handle error
    }
  }

  void pauseAudio(int index) async {
    final position = await audioPlayer.position;
    await audioPlayer.pause();
    setState(() {
      currentIndex = index;
      isPlayingList[index] = false;
      episodes[index].playbackPosition = position;
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
                final isLoadingEpisode = loadingIndex == index;

                return Column(
                  children: [
                    ListTile(
                      title: Text(episode.title),
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
                            width: 100,
                            height: 120,
                            child: Image.network(
                              episode.thumbnailUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              formatDurationFromString(episode.durationString),
                              style: const TextStyle(
                                backgroundColor: Colors.black45,
                                color: Colors.white,
                                fontSize: 14.0,
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
                          : isLoadingEpisode
                              ? const CircularProgressIndicator() // Show loading indicator
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
                                progress = progress.clamp(0.0,
                                    1.0); // Ensure the progress is within the valid range
                              }

                              return Slider(
                                value: progress,
                                onChanged: (value) {
                                  if (duration != null &&
                                      duration.inMilliseconds > 0) {
                                    final seekTo = duration * value;
                                    audioPlayer.seek(seekTo);
                                  }
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
  Duration playbackPosition;

  Episode({
    required this.title,
    required this.thumbnailUrl,
    required this.publishedDate,
    required this.audioUrl,
    required this.durationString,
    this.playbackPosition = Duration.zero,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    final playbackPositionInSeconds = json['meta']['playback_position'] ?? 0;
    final playbackPosition = Duration(seconds: playbackPositionInSeconds);

    return Episode(
      title: json['title']['rendered'] ?? 'No title available',
      thumbnailUrl: json['episode_featured_image'] ?? '',
      publishedDate: json['date'] ?? '',
      audioUrl: json['player_link'] ?? '',
      durationString: json['meta']['duration'] ?? '0:00',
      playbackPosition: playbackPosition,
    );
  }
}
