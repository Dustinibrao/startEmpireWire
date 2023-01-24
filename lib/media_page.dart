import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  late Future<List<String>> _images;

  @override
  void initState() {
    super.initState();
    _images = fetchImages();
  }

  Future<List<String>> fetchImages() async {
    var response =
        await http.get(Uri.parse('https://biasb.in/wp-json/wp/v2/media'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<String> images = [];
      for (var i = 0; i < data.length; i++) {
        images.add(data[i]['source_url'].toString());
      }
      return images;
    } else {
      throw Exception('Failed to fetch images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<String>>(
          future: _images,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Image.network(snapshot.data![index]);
                },
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
