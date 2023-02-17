import 'package:flutter/material.dart';

class EpisodeDetails extends StatelessWidget {
  final Map<String, dynamic> episode;

  const EpisodeDetails({Key? key, required this.episode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(episode['title']['rendered']),
      ),
      body: Column(
        children: [
          Image.network(episode['featured_image_src']),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(episode['content']['rendered']),
          ),
        ],
      ),
    );
  }
}
