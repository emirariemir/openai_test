import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Widget buildTextField() {
    return Container(
      color: const Color.fromARGB(255, 204, 215, 236),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Expanded(
              child: TextField(
                decoration: InputDecoration.collapsed(hintText: 'Enter your text here'),
              ),
            ),
            IconButton(
              padding: const EdgeInsets.symmetric(vertical: 15),
              onPressed: () {},
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildChatWidget() {
    return Expanded(
      child: Container(
        color: Color.fromARGB(255, 240, 183, 179),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 222, 235, 207),
        title: Text('OpenAI Test'),
      ),
      body: Column(
        children: [
          buildChatWidget(),
          buildTextField(),
        ],
      ),
    );
  }
}
