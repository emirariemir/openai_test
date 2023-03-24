import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openai_test/constants.dart';
import 'package:openai_test/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late bool isGptTexting;

  TextEditingController controller = TextEditingController();

  ScrollController scrollController = ScrollController();

  final List<MessageBubble> messages = [];

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
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: const TextField(
                  decoration: InputDecoration.collapsed(hintText: 'Enter your text here'),
                ),
              ),
            ),
            Visibility(
              visible: !isGptTexting,
              child: IconButton(
                padding: const EdgeInsets.symmetric(vertical: 15),
                color: Colors.white,
                onPressed: () {},
                icon: const Icon(Icons.send),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView buildChatWidget() {
    return ListView.builder(
      itemCount: messages.length,
      controller: scrollController,
      itemBuilder: (context, index) {
        return MessageBubble();
      },
    );
  }

  Padding buildProgressIndicator() {
    return const Padding(
      padding: EdgeInsets.all(10),
      child: CircularProgressIndicator(
        color: kMainColor,
        backgroundColor: kBackgroundColor,
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
