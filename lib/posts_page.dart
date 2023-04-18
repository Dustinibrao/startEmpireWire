// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// // import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'dart:convert';

// class PostsPage extends StatefulWidget {
//   const PostsPage({super.key});

//   @override
//   _PostsPageState createState() => _PostsPageState();
// }

// class _PostsPageState extends State<PostsPage> {
//   List<dynamic> _posts = [];
//   Future<void> _fetchPosts() async {
//     http.Response response =
//         await http.get(Uri.parse("https://biasb.in/wp-json/wp/v2/posts"));

//     if (response.statusCode == 200) {
//       List<dynamic> posts = jsonDecode(response.body);
//       for (var i = 0; i < posts.length; i++) {
//         http.Response authorResponse = await http.get(Uri.parse(
//             "https://biasb.in/wp-json/wp/v2/users/${posts[i]['author']}"));
//         if (authorResponse.statusCode == 200) {
//           posts[i]['author_name'] = jsonDecode(authorResponse.body)['name'];
//         }
//       }
//       setState(() {
//         _posts = posts;
//       });
//     } else {
//       print('Failed to load posts');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     _fetchPosts();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Posts'),
//         ),
//         body: ListView.builder(
//           itemCount: _posts.length,
//           itemBuilder: (context, index) {
//             return InkWell(
//               onTap: () {
//                 // Open the link in a webview within the app
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => WebviewScaffold(
//                     url: _posts[index]['link'],
//                     appBar: AppBar(
//                       title: Text(_posts[index]['title']['rendered']),
//                     ),
//                   ),
//                 ));
//               },
//               child: ListTile(
//                 title: Text(_posts[index]['title']['rendered']),
//                 subtitle: Text("Author: " + _posts[index]['author_name']),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
