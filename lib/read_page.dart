import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReadPage extends StatefulWidget {
  const ReadPage({super.key});

  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  // Variable to store the list of articles
  List<Article> articles = [];

  // Function to fetch the articles from the API
  Future<void> fetchArticles() async {
    final response = await http
        .get(Uri.parse("https://startempirewire.com/wp-json/wp/v2/podcast"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      setState(() {
        articles = data.map((article) => Article.fromJson(article)).toList();
      });
    } else {
      throw Exception("Failed to load articles");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchArticles();
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
        title: const Text("Read"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return ListTile(
            title: Text(article.title),
            subtitle: Text(article.description),
            onTap: () {
              // Navigate to the article detail page
            },
          );
        },
      ),
    );
  }
}

// Model class for the article
class Article {
  final int id;
  final String title;
  final String description;

  Article({required this.id, required this.title, required this.description});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json["id"],
      title: json["title"],
      description: json["description"],
    );
  }
}
