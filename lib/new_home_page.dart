import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
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
        final articles =
            data.map((article) => Article.fromJson(article)).toList();

        return articles;
      } else {
        throw Exception('Failed to fetch articles');
      }
    } catch (e) {
      throw Exception('Failed to fetch articles');
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
  bool showMailingListForm = true; // Always show the mailing list form

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _submitMailingListForm(String email) async {
    // Implement your logic to handle the mailing list form submission
    // You can use the 'email' parameter to get the entered email value
    // For example, you can use 'email' to send a request to your backend API
    print('Submitted email: $email');

    // You can use the Mailchimp API to add the email to your mailing list
    // For example:
    // final apiKey = 'YOUR_MAILCHIMP_API_KEY';
    // final serverPrefix = 'YOUR_MAILCHIMP_SERVER_PREFIX';
    // final audienceId = 'YOUR_MAILCHIMP_AUDIENCE_ID';

    // final response = await http.post(
    //   Uri.https(
    //     '$serverPrefix.api.mailchimp.com',
    //     '/3.0/lists/$audienceId/members',
    //     {'email_address': email, 'status': 'subscribed'},
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Authorization': 'apikey $apiKey',
    //     },
    //   ),
    // );

    // if (response.statusCode == 200) {
    //   print('Subscribed successfully!');
    // } else {
    //   print('Failed to subscribe. Status code: ${response.statusCode}');
    // }

    // Once the user has successfully subscribed, hide the mailing list form
    setState(() {
      showMailingListForm = false;
    });
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
                                  child: Image.network(
                                    topStoryPodcast.imageUrl,
                                    fit: BoxFit.cover,
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
                              return ListTile(
                                leading: Image.network(
                                  article.thumbnailUrl,
                                  width: 100,
                                  height: 100,
                                ),
                                title: Text(article.title),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: SingleChildScrollView(
                                          child: Html(
                                            data: article.content,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Close'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
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
                          ListTile(
                            leading: Image.network(
                              topStoryPodcast.imageUrl,
                              width: 100,
                              height: 100,
                            ),
                            title: Text(topStoryPodcast.title),
                            onTap: () {
                              showVideoDialog(
                                  context, topStoryPodcast.videoUrl);
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

class Article {
  final String title;
  final String content;
  final String thumbnailUrl;

  Article({
    required this.title,
    required this.content,
    required this.thumbnailUrl,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title']['rendered'] ?? 'No title available',
      content: json['content']['rendered'] ?? '',
      thumbnailUrl: json['jetpack_featured_media_url'] ?? '',
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PodcastHomePage(),
  ));
}
