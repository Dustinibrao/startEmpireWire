import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({Key? key}) : super(key: key);

  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  // Variable to store the list of posts
  List<Post> posts = [];

  // Flag to determine if the API call is in progress
  bool isLoading = true;

  // Flag to determine if an error occurred during the API call
  bool hasError = false;

  // Function to fetch the posts from the API
  Future<void> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse("https://startempirewire.com/wp-json/wp/v2/posts?_embed"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;

        setState(() {
          posts = data
              .map((post) => Post.fromJson(post as Map<String, dynamic>))
              .toList();
          isLoading = false;
        });

        // Fetch the author names using the author IDs from the separate endpoint
        await fetchAuthors();
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
    fetchPosts();
  }

  // Function to fetch the author names using the author IDs
  Future<void> fetchAuthors() async {
    try {
      final List<int> authorIds = posts.map((post) => post.authorId).toList();
      final uniqueAuthorIds = authorIds.toSet().toList();

      for (int authorId in uniqueAuthorIds) {
        final response = await http.get(
          Uri.parse(
              "https://startempirewire.com/wp-json/wp/v2/users/$authorId"),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body) as Map<String, dynamic>;
          final String authorName = data['name'] ?? 'No author name available';

          // Update the post with the author name
          setState(() {
            posts.where((post) => post.authorId == authorId).forEach((post) {
              post.authorName = authorName;
            });
          });
        } else {
          print('Failed to fetch author details for author ID: $authorId');
        }
      }
    } catch (e) {
      print('Failed to fetch authors: $e');
    }
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
        title: const Text('Read'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : hasError
              ? const Center(
                  child: Text('Failed to load posts'),
                )
              : ListView.separated(
                  itemCount: posts.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return ListTile(
                      leading: Container(
                        width: 100,
                        height: 100,
                        child: CachedNetworkImage(
                          imageUrl: post.thumbnailUrl,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(post.title),
                      subtitle:
                          Text(post.authorName), // Display the author name here
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailsPage(post: post),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

class PostDetailsPage extends StatelessWidget {
  final Post post;

  const PostDetailsPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Author: ${post.authorName}', // Display the author name here
                style: const TextStyle(),
              ),
              const SizedBox(height: 8),
              Html(data: post.content),
            ],
          ),
        ),
      ),
    );
  }
}

// Model class for the post
class Post {
  final int id;
  final String title;
  final String excerpt;
  final String content;
  final String thumbnailUrl;
  int authorId; // Updated to include the author ID
  String authorName; // Updated to include the author name

  Post({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.thumbnailUrl,
    required this.authorId,
    required this.authorName,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: int.parse(json['id'].toString()),
      title: json['title']['rendered'] ?? 'No title available',
      excerpt: json['excerpt']['rendered'] ?? 'No excerpt available',
      content: json['content']['rendered'] ?? 'No content available',
      thumbnailUrl: json['jetpack_featured_media_url']?.toString() ?? '',
      authorId: int.parse(json['author'].toString()),
      authorName: '', // Initialize the author name as an empty string
    );
  }
}
