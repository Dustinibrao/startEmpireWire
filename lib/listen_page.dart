import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListenPage extends StatefulWidget {
  const ListenPage({super.key});

  @override
  _ListenPageState createState() => _ListenPageState();
}

class _ListenPageState extends State<ListenPage> {
  // A list to store the podcasts
  List<Podcast> podcasts = [];

  // A function to fetch the podcasts from the API
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Listen"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: podcasts.length,
        itemBuilder: (context, index) {
          final podcast = podcasts[index];
          return ListTile(
            title: Text(podcast.title),
            subtitle: Text(podcast.description),
            onTap: () {
              // Navigate to the podcast player screen
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
  final String audioUrl;

  Podcast({
    required this.id,
    required this.title,
    required this.description,
    required this.audioUrl,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      audioUrl: json["audio_url"],
    );
  }
}
