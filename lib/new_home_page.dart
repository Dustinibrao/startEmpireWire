import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:testing/screens/tap_animation.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PodcastHomePage extends StatefulWidget {
  @override
  _PodcastHomePageState createState() => _PodcastHomePageState();
}

class _PodcastHomePageState extends State<PodcastHomePage> {
  late Future<Podcast> _topStoryPodcast;
  late Future<List<Article>> _articles;
  late Future<Podcast> _newPodcast;

  @override
  void initState() {
    super.initState();
    _topStoryPodcast = fetchTopStoryPodcast();
    _articles = fetchArticles();
    _newPodcast = fetchNewPodcast();
  }

  Future<Podcast> fetchTopStoryPodcast() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://startempirewire.com/wp-json/wp/v2/podcast?_limit=1&_sort=id:desc'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        final podcast = Podcast.fromJson(data[0] as Map<String, dynamic>);
        return podcast;
      } else {
        throw Exception('Failed to fetch top story podcast');
      }
    } catch (e) {
      throw Exception('Failed to fetch top story podcast');
    }
  }

  Future<List<Article>> fetchArticles() async {
    try {
      final response = await http.get(
        Uri.parse('https://startempirewire.com/wp-json/wp/v2/posts?_limit=5'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        final articles = data
            .map((article) => Article.fromJson(article as Map<String, dynamic>))
            .toList();

        // Fetch the author names using the author IDs from the separate endpoint
        await fetchAuthorsForArticles(articles);

        return articles;
      } else {
        throw Exception('Failed to fetch articles');
      }
    } catch (e) {
      throw Exception('Failed to fetch articles');
    }
  }

// Function to fetch the author names using the author IDs for articles
  Future<void> fetchAuthorsForArticles(List<Article> articles) async {
    // Similar to fetchAuthors() function in your first code snippet
    try {
      final List<int> authorIds =
          articles.map((article) => article.authorId).toList();
      final uniqueAuthorIds = authorIds.toSet().toList();

      for (int authorId in uniqueAuthorIds) {
        final response = await http.get(
          Uri.parse(
              "https://startempirewire.com/wp-json/wp/v2/users/$authorId"),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body) as Map<String, dynamic>;
          final String authorName = data['name'] ?? 'No author name available';

          // Update the article with the author name
          articles
              .where((article) => article.authorId == authorId)
              .forEach((article) {
            article.authorName = authorName;
          });
        } else {
          print('Failed to fetch author details for author ID: $authorId');
        }
      }
    } catch (e) {
      print('Failed to fetch authors: $e');
    }
  }

  Future<Podcast> fetchNewPodcast() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://startempirewire.com/wp-json/wp/v2/podcast?_limit=1&_sort=id:desc'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        final podcast = Podcast.fromJson(data[0] as Map<String, dynamic>);
        return podcast;
      } else {
        throw Exception('Failed to fetch new podcast');
      }
    } catch (e) {
      throw Exception('Failed to fetch new podcast');
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

  TextEditingController emailController = TextEditingController();
  bool showMailingListForm = true;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _submitMailingListForm(String email) async {
    print('Submitted email: $email');
    setState(() {
      showMailingListForm = false;
    });
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: FutureBuilder<Podcast>(
          future: _topStoryPodcast,
          builder: (context, topStorySnapshot) {
            if (topStorySnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (topStorySnapshot.hasError) {
              return const Center(
                child: Text('Failed to load top story podcast'),
              );
            } else if (topStorySnapshot.hasData) {
              final topStoryPodcast = topStorySnapshot.data!;

              return FutureBuilder<List<Article>>(
                future: _articles,
                builder: (context, articleSnapshot) {
                  if (articleSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (articleSnapshot.hasError) {
                    return const Center(
                      child: Text('Failed to load articles'),
                    );
                  } else if (articleSnapshot.hasData) {
                    final articles = articleSnapshot.data!;

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
                                  color: Color(0xffff6a6f),
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Watch ',
                                  ),
                                  TextSpan(
                                    text: 'Top Story',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showVideoDialog(
                                  context, topStoryPodcast.videoUrl);
                            },
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 210,
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        topStoryPodcast.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          color: Colors.black45,
                                          child: Text(
                                            formatDuration(
                                              topStoryPodcast.duration,
                                            ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ListTile(
                                  title: Text(topStoryPodcast.title),
                                  onTap: () {
                                    showVideoDialog(
                                        context, topStoryPodcast.videoUrl);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffff6a6f),
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Read ',
                                  ),
                                  TextSpan(
                                    text: 'Featured Articles',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                articles.length > 5 ? 5 : articles.length,
                            itemBuilder: (context, index) {
                              final article = articles[index];
                              return TapAnimationWidget(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ArticleDetailsPage(
                                                article: article),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    leading: Image.network(
                                      article.thumbnailUrl,
                                      width: 100,
                                      height: 100,
                                    ),
                                    title: Text(article.title),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ArticleDetailsPage(
                                                  article: article),
                                        ),
                                      );
                                    },
                                  ));
                            },
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffff6a6f),
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Watch New ',
                                  ),
                                  TextSpan(
                                    text: 'Podcast',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FutureBuilder<Podcast>(
                            future: _newPodcast,
                            builder: (context, newPodcastSnapshot) {
                              if (newPodcastSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (newPodcastSnapshot.hasError) {
                                return const Center(
                                  child: Text('Failed to load new podcast'),
                                );
                              } else if (newPodcastSnapshot.hasData) {
                                final newPodcast = newPodcastSnapshot.data!;
                                return GestureDetector(
                                  onTap: () {
                                    showVideoDialog(
                                        context, newPodcast.videoUrl);
                                  },
                                  child: Column(
                                    children: [
                                      ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                        leading: Container(
                                          width: 104,
                                          height: 102,
                                          child: Stack(
                                            children: [
                                              Image.network(
                                                newPodcast.imageUrl,
                                                fit: BoxFit.cover,
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                right: 4,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  color: Colors.black54,
                                                  child: Text(
                                                    formatDuration(
                                                        newPodcast.duration),
                                                    style: const TextStyle(
                                                      // fontWeight:
                                                      //     FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: Text(
                                            newPodcast.title,
                                            // style: const TextStyle(
                                            //     fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        onTap: () {
                                          showVideoDialog(
                                              context, newPodcast.videoUrl);
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: Text('No new podcast found'),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffff6a6f),
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Subscribe to Our Mailing List',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                TextField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your email',
                                  ),
                                  autofocus: false,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    _submitMailingListForm(
                                        emailController.text);
                                  },
                                  child: const Text('Subscribe'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text('No articles found'),
                    );
                  }
                },
              );
            } else {
              return const Center(
                child: Text('No top story podcast found'),
              );
            }
          },
        ),
      ),
    );
  }
}

class Podcast {
  final String title;
  final String host;
  final String imageUrl;
  final String videoUrl;
  final Duration duration;

  Podcast({
    required this.title,
    required this.host,
    required this.imageUrl,
    required this.videoUrl,
    required this.duration,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      title: json['title']['rendered'] ?? 'No title available',
      host: json['host'] ?? 'No host available',
      imageUrl: json['episode_featured_image'] ?? 'No image available',
      videoUrl: json['acf']['podcast_video'] ?? '',
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

class ArticleDetailsPage extends StatelessWidget {
  final Article article;

  const ArticleDetailsPage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Author: ${article.authorName}',
                style: const TextStyle(), // You can style this as needed
              ),
              const SizedBox(height: 8),
              Html(data: article.content),
            ],
          ),
        ),
      ),
    );
  }
}

class Article {
  final String title;
  final String content;
  final String thumbnailUrl;
  final int authorId;
  String authorName; // Make sure this is included

  Article({
    required this.title,
    required this.content,
    required this.thumbnailUrl,
    required this.authorId,
    required this.authorName,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title']['rendered'] ?? 'No title available',
      content: json['content']['rendered'] ?? '',
      thumbnailUrl: json['jetpack_featured_media_url'] ?? '',
      authorId: int.parse(json['author'].toString()),
      authorName: '', // Initialize the author name as an empty string
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PodcastHomePage(),
  ));
}
