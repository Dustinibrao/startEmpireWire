import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(MaterialApp(
    home: WatchPage(),
  ));
}

class WatchPage extends StatefulWidget {
  const WatchPage({Key? key}) : super(key: key);

  @override
  _WatchPageState createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  List<Podcast> podcasts = [];
  bool isLoading = true;
  bool hasError = false;

  Future<void> fetchPodcasts() async {
    try {
      final response = await http.get(
        Uri.parse("https://startempirewire.com/wp-json/wp/v2/podcast"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;

        setState(() {
          podcasts = data
              .map((podcast) =>
                  Podcast.fromJson(podcast as Map<String, dynamic>))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPodcasts();
  }

  @override
  void dispose() {
    // Dispose video player controllers
    for (var podcast in podcasts) {
      podcast.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Watch"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : hasError
              ? const Center(
                  child: Text("Failed to load podcasts"),
                )
              : ListView.separated(
                  itemCount: podcasts.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final podcast = podcasts[index];
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Stack(
                                children: [
                                  YoutubePlayer(
                                    controller: YoutubePlayerController(
                                      initialVideoId:
                                          YoutubePlayer.convertUrlToId(
                                              podcast.podcastVideoUrl)!,
                                      flags: const YoutubePlayerFlags(
                                        autoPlay: true,
                                        mute: false,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(podcast.featuredImageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      color: Colors.black54,
                                      child: Text(
                                        formatDuration(podcast.duration),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            podcast.title,
                            style: Theme.of(context).textTheme.subtitle1,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class Podcast {
  final int id;
  final String title;
  final String link;
  final String featuredImageUrl;
  final String podcastVideoUrl;
  final Duration duration;
  late final VideoPlayerController controller;

  Podcast({
    required this.id,
    required this.title,
    required this.link,
    required this.featuredImageUrl,
    required this.podcastVideoUrl,
    required this.duration,
  }) {
    controller = VideoPlayerController.network(podcastVideoUrl)
      ..initialize().then((_) {
        controller.play();
        controller.setLooping(true);
      });
  }

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      id: int.parse(json['id'].toString()),
      title: json['title']['rendered'] ?? 'No title available',
      link: json['link'] ?? '',
      featuredImageUrl: json['episode_featured_image'] ?? '',
      podcastVideoUrl: json['acf']['podcast_video'] ?? '',
      duration: parseDuration(json['meta']['duration'] ?? '0:00'),
    );
  }

  static Duration parseDuration(String durationString) {
    final parts = durationString.split(':');
    if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]) ?? 0;
      final seconds = int.tryParse(parts[1]) ?? 0;
      return Duration(minutes: minutes, seconds: seconds);
    }
    return Duration.zero;
  }
}
