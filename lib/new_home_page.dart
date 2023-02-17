import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variable to store the list of podcasts
  List<Podcast> podcasts = [];

  // Function to fetch the podcasts from the API
  Future<void> fetchPodcasts() async {
    final response = await http
        .get(Uri.parse("https://startempirewire.com/wp-json/wp/v2/podcast"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      setState(() {
        podcasts = data.map((podcast) => Podcast.fromJson(podcast)).toList();
      });
    } else {
      throw Exception("Failed to load podcasts");
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
      body: ListView.builder(
        itemCount: podcasts.length,
        itemBuilder: (context, index) {
          final podcast = podcasts[index];
          return ListTile(
            leading: Image.network(
              podcast.thumbnail,
              width: 50,
              height: 50,
            ),
            title: Text(podcast.title),
            subtitle: Text(podcast.description),
            onTap: () {
              // Navigate to the podcast detail page
            },
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
  final String description;
  final String thumbnail;

  Podcast(
      {required this.id,
      required this.title,
      required this.description,
      required this.thumbnail});

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      thumbnail: json["thumbnail"],
    );
  }
}
