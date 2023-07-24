import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PodcastHomePage extends StatefulWidget {
  @override
  _PodcastHomePageState createState() => _PodcastHomePageState();
}

class _PodcastHomePageState extends State<PodcastHomePage> {
  late Future<List<Podcast>> _podcasts;

  @override
  void initState() {
    super.initState();
    _podcasts = fetchPodcasts();
  }

  Future<List<Podcast>> fetchPodcasts() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://startempirewire.com/wp-json/wp/v2/podcast?_limit=2&_sort=id:desc'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        final podcasts = data
            .map((podcast) => Podcast.fromJson(podcast as Map<String, dynamic>))
            .toList();

        return podcasts;
      } else {
        throw Exception('Failed to fetch podcasts');
      }
    } catch (e) {
      throw Exception('Failed to fetch podcasts');
    }
  }

  void showVideoDialog(BuildContext context, String videoUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Stack(
            children: [
              YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Podcast>>(
        future: fetchPodcasts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load podcasts'),
            );
          } else if (snapshot.hasData) {
            final podcasts = snapshot.data!;
            final topStoryPodcast = podcasts[0];
            final featuredPodcasts =
                podcasts.sublist(1, 6); // Display 5 featured podcasts
            final newPodcast = podcasts[0]; // Display the new podcast

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'Watch ',
                            style: TextStyle(color: Color(0xffff6a6f)),
                          ),
                          TextSpan(text: 'Top Story'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  GestureDetector(
                    onTap: () {
                      showVideoDialog(context, topStoryPodcast.videoUrl);
                    },
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 210,
                          child: Image.network(
                            topStoryPodcast.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          title: Text(topStoryPodcast.title),
                          // subtitle: Text(topStoryPodcast.host),
                          // trailing: const Icon(Icons.play_circle_filled),
                          onTap: () {
                            showVideoDialog(context, topStoryPodcast.videoUrl);
                          },
                        ),
                      ],
                    ),
                  ),
                  // const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'Watch ',
                            style: TextStyle(color: Color(0xffff6a6f)),
                          ),
                          TextSpan(text: 'Featured'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: featuredPodcasts.length,
                    itemBuilder: (context, index) {
                      final podcast = featuredPodcasts[index];
                      return ListTile(
                        leading: Image.network(
                          podcast.imageUrl,
                          width: 80,
                          height: 80,
                        ),
                        title: Text(podcast.title),
                        // subtitle: Text(podcast.host),
                        trailing: const Icon(Icons.play_circle_filled),
                        onTap: () {
                          showVideoDialog(context, podcast.videoUrl);
                        },
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'New ',
                            style: TextStyle(color: Color(0xffff6a6f)),
                          ),
                          TextSpan(text: 'Podcast'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Image.network(
                      newPodcast.imageUrl,
                      width: 80,
                      height: 80,
                    ),
                    title: Text(newPodcast.title),
                    // subtitle: Text(newPodcast.host),
                    trailing: const Icon(Icons.play_circle_filled),
                    onTap: () {
                      showVideoDialog(context, newPodcast.videoUrl);
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('No podcasts found'),
            );
          }
        },
      ),
    );
  }
}

class Podcast {
  final String title;
  final String host;
  final String imageUrl;
  final String videoUrl;

  Podcast({
    required this.title,
    required this.host,
    required this.imageUrl,
    required this.videoUrl,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      title: json['title']['rendered'] ?? 'No title available',
      host: json['host'] ?? 'No host available',
      imageUrl: json['episode_featured_image'] ?? 'No image available',
      videoUrl: json['acf']['podcast_video'] ?? '',
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PodcastHomePage(),
  ));
}
