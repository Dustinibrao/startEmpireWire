import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
                              child: podcast.featuredImageUrl != null
                                  ? Image.network(
                                      podcast.featuredImageUrl,
                                      fit: BoxFit.contain,
                                    )
                                  : const SizedBox.shrink(),
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
}

class Podcast {
  final int id;
  final String title;
  final String link;
  final String featuredImageUrl;
  final String podcastVideoUrl;
  late final VideoPlayerController controller;

  Podcast({
    required this.id,
    required this.title,
    required this.link,
    required this.featuredImageUrl,
    required this.podcastVideoUrl,
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
    );
  }
}
