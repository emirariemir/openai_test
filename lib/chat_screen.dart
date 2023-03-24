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

class MessageBubbleWidget extends StatelessWidget {
  final String text;
  final MessageFrom from;

  const MessageBubbleWidget({super.key, required this.text, required this.from});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(16),
      color: from == MessageFrom.openai ? kMainColor : kBackgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          from == MessageFrom.openai
              ? Container(
                  margin: EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    backgroundColor: kMainColor,
                    child: Icon(
                      Icons.android,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    backgroundColor: kBackgroundColor,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                child: Text(
                  text,
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
