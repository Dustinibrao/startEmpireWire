import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// void main() => runApp(PostsPage());

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  // Declare a list to store the posts
  List<dynamic> _posts = [];

  // Function to fetch the posts from the API
  Future<void> _fetchPosts() async {
    // Make the HTTP request
    http.Response response =
        await http.get(Uri.parse("https://biasb.in/wp-json/wp/v2/posts"));

    // Check the status code of the response (200 indicates a successful request)
    if (response.statusCode == 200) {
      // Parse the response body as a list of posts
      List<dynamic> posts = jsonDecode(response.body);

      // Set the posts in the state
      setState(() {
        _posts = posts;
      });
    } else {
      // If the request failed, display an error message
      print('Failed to load posts');
    }
  }

  @override
  void initState() {
    super.initState();

    // Fetch the posts when the app starts
    _fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Posts'),
        ),
        body: ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_posts[index]['title']['rendered']),
              // leading: Image.network(_posts[index]['featured_image_src']),
            );
          },
        ),
      ),
    );
  }
}
