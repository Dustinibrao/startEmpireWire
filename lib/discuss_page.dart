import 'package:flutter/material.dart';

class DiscussPage extends StatefulWidget {
  const DiscussPage({super.key});

  @override
  _DiscussPageState createState() => _DiscussPageState();
}

class _DiscussPageState extends State<DiscussPage> {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.insert(0, Message(text: text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discuss"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(10.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Container(
                  child: Text(message.text),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                );
              },
            ),
          ),
          Container(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "Enter your message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text),
                ),
              ),
            ),
            padding: const EdgeInsets.all(10.0),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;

  Message({required this.text});
}
