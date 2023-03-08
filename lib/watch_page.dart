import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
                      return ListTile(
                        contentPadding: EdgeInsets.all(8.0),
                        leading: Container(
                          width: 100.0,
                          height: 100.0,
                          child: podcast.featuredImageUrl != null
                              ? Image.network(
                                  podcast.featuredImageUrl,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        title: Text(
                          podcast.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          // Navigate to the podcast video player
                        },
                      );
                    },
                  ));
  }
}

// Model class for the podcast
class Podcast {
  final int id;
  final String title;
  final String link;
  final String imageUrl;
  final String featuredImageUrl;

  Podcast({
    required this.id,
    required this.title,
    required this.link,
    required this.imageUrl,
    required this.featuredImageUrl,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      id: int.parse(json['id'].toString()),
      title: json['title']['rendered'] ?? 'No title available',
      link: json['link'] ?? '',
      imageUrl: json['featured_image_url'] ?? '',
      featuredImageUrl: json['episode_featured_image'] ?? '',
    );
  }
}
