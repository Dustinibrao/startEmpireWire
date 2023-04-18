import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WatchPage extends StatefulWidget {
  const WatchPage({Key? key}) : super(key: key);

  @override
  _WatchPageState createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  // Variable to store the list of podcasts
  List<Podcast> podcasts = [];

  // Flag to determine if the API call is in progress
  bool isLoading = true;

  // Flag to determine if an error occurred during the API call
  bool hasError = false;

  // Video player controller
  late VideoPlayerController? _controller;

  // Function to fetch the podcasts from the API
  Future<void> fetchPodcasts() async {
    try {
      final response = await http.get(
        Uri.parse("https://startempirewire.com/wp-json/wp/v2/podcast"),
      );

      print('Response status code: ${response.statusCode}');
      print('Response message: ${response.reasonPhrase}');
      print('Response body: ${response.body}');

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
        print('Error fetching podcasts: ${response.statusCode}');
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } catch (e) {
      print('Error fetching podcasts: $e');
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
                        _controller = VideoPlayerController.network(
                            podcast.podcastVideoUrl)
                          ..initialize().then((_) {
                            setState(() {});
                            _controller?.play();
                          });
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 200,
                                    child: _controller!.value.isInitialized
                                        ? AspectRatio(
                                            aspectRatio:
                                                _controller!.value.aspectRatio,
                                            child: VideoPlayer(_controller!),
                                          )
                                        : Container(),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        _controller?.pause();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ).then((_) {
                          _controller?.pause();
                          _controller?.dispose();
                          _controller = null;
                        });
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

// Model class for the podcast
class Podcast {
  final int id;
  final String title;
  final String link;
  final String featuredImageUrl;
  final String podcastVideoUrl;
  final VideoPlayerController controller;

  Podcast({
    required this.id,
    required this.title,
    required this.link,
    required this.featuredImageUrl,
    required this.podcastVideoUrl,
    required this.controller,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    final controller = VideoPlayerController.network(json['link']);
    return Podcast(
      id: int.parse(json['id'].toString()),
      title: json['title']['rendered'] ?? 'No title available',
      link: json['link'] ?? '',
      featuredImageUrl: json['episode_featured_image'] ?? '',
      podcastVideoUrl: json['acf']['podcast_video'] ?? '',
      controller: controller,
    );
  }
}
