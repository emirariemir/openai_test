import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openai_test/constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late bool isGptTexting;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    isGptTexting = false;
  }

  Widget buildTextField() {
    return Container(
      color: kMainColor,
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
              color: Colors.white,
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
        color: kBackgroundColor,
      ),
    );
  }

  Padding buildProgressIndicator() {
    return const Padding(
      padding: EdgeInsets.all(10),
      child: CircularProgressIndicator(
        color: Colors.lightGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: const Text(
          'OpenAI Test',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          buildChatWidget(),
          Visibility(
            visible: isGptTexting,
            child: buildProgressIndicator(),
          ),
          buildTextField(),
        ],
      ),
    );
  }
}
