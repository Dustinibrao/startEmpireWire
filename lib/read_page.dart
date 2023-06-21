import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

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
        Uri.parse("https://startempirewire.com/wp-json/wp/v2/posts"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;

        setState(() {
          posts = data
              .map((post) => Post.fromJson(post as Map<String, dynamic>))
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
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                      title: Text(post.title),
                      subtitle: Html(data: post.excerpt),
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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

  Post({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: int.parse(json['id'].toString()),
      title: json['title']['rendered'] ?? 'No title available',
      excerpt: json['excerpt']['rendered'] ?? 'No excerpt available',
      content: json['content']['rendered'] ?? 'No content available',
    );
  }
}
