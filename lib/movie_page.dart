import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// void main() => runApp(PostsPage());

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  // Declare a list to store the posts
  List<dynamic> _movie = [];

  // Function to fetch the posts from the API
  Future<void> _fetchMovie() async {
    // Make the HTTP request
    http.Response response =
        await http.get(Uri.parse("https://biasb.in/wp-json/wp/v2/movie"));

    // Check the status code of the response (200 indicates a successful request)
    if (response.statusCode == 200) {
      // Parse the response body as a list of posts
      List<dynamic> movie = jsonDecode(response.body);

      // Set the posts in the state
      setState(() {
        _movie = movie;
      });
    } else {
      // If the request failed, display an error message
      print('Failed to load Movies');
    }
  }

  @override
  void initState() {
    super.initState();

    // Fetch the posts when the app starts
    _fetchMovie();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Movies'),
        ),
        body: ListView.builder(
          itemCount: _movie.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_movie[index]['title']['rendered']),
            );
          },
        ),
      ),
    );
  }
}
