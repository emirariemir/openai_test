import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:openai_test/constants.dart';
import 'package:openai_test/message_bubble.dart';
import 'package:http/http.dart' as http;

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

  Future<String> getResponse(String input) async {
    const apiKey = "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";
    var url = Uri.https("api.openai.com", "/v1/completions");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $apiKey'},
      body: jsonEncode({'model': 'text-davinci-003', 'prompt': input, 'temparature': 0, 'max_token': 2000, 'top_p': 1, 'frequency_penalty': 0.0, 'presence_penalty': 0.0}),
    );

    Map<String, dynamic> respond = jsonDecode(response.body);
    return respond['choices'][0]['text'];
  }

  void animScrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
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
                onPressed: () {
                  setState(() {
                    messages.add(
                      MessageBubble(text: controller.text, messageFrom: MessageFrom.user),
                    );
                    isGptTexting = true;
                  });

                  var userText = controller.text;

                  controller.clear();

                  Future.delayed(Duration(milliseconds: 60)).then(
                    (value) => animScrollDown(),
                  );

                  getResponse(userText).then((value) {
                    setState(() {
                      messages.add(
                        MessageBubble(text: value, messageFrom: MessageFrom.openai),
                      );
                    });
                  });

                  Future.delayed(Duration(milliseconds: 60)).then((value) => animScrollDown());
                },
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
        var ms = messages[index];
        return MessageBubbleWidget(
          text: ms.text,
          from: ms.messageFrom,
        );
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
    // BUILD HERE!
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
          Expanded(child: buildChatWidget()),
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
                  margin: const EdgeInsets.only(right: 10),
                  child: const CircleAvatar(
                    backgroundColor: kMainColor,
                    child: Icon(
                      Icons.android,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const CircleAvatar(
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
                padding: const EdgeInsets.all(8),
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
