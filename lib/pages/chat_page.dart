import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatPage> {
  Uuid uuid = const Uuid();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  String _test = "";
  bool _isLoading = false;

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage myMessage = ChatMessage(
      id: uuid.v4(),
      text: text,
      sender: 'Me',
      isMe: true,
    );
    setState(() {
      _messages.insert(0, myMessage);
      _test = _test + text;
    });
    _startStream(text);
  }

  Future<void> _startStream(String content) async {
    const mbti = 'INFP';
    const url = '/api/v1/gpt';

    try {
      setState(() {
        _isLoading = true;
      });

      final response = await Dio().get<ResponseBody>(
        url,
        queryParameters: {'mbti': mbti, 'content': content},
        options: Options(responseType: ResponseType.stream),
      );

      // Stream을 받아서 UTF8로 디코딩
      final reader = response.data!.stream;
      const decoder = Utf8Decoder();

      var message = '';
      var uuidTemp = uuid.v4();
      _messages.insert(
        0,
        ChatMessage(
          id: uuidTemp,
          text: message,
          sender: 'You',
          isMe: false,
        ),
      );
      await for (final chunk in reader) {
        final text = decoder.convert(chunk);
        final lines = const LineSplitter().convert(text);
        for (var line in lines) {
          final Map<String, dynamic> decoded = jsonDecode(line);
          final tempMessage = decoded['message'] as String;
          var foundItem = _messages.firstWhere((item) => item.id == uuidTemp);
          foundItem.text = foundItem.text + tempMessage;
        }
      }
      setState(() {
        //_currentMessage = ""; // 누적된 메시지 초기화
      });

      // 스크롤을 맨 아래로 이동
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
                onSubmitted: _handleSubmitted,
              ),
            ),
            Text(_test),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chat App'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          )
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({super.key, required this.id, required this.text, required this.sender, required this.isMe});

  final String id;
  String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: <Widget>[
          if (isMe)
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(sender[0])),
            ),
          if (!isMe)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(sender, style: Theme.of(context).textTheme.titleMedium),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(text),
                ),
              ],
            ),
          if (isMe)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(sender, style: Theme.of(context).textTheme.titleMedium),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(text),
                ),
              ],
            ),
          if (!isMe)
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: CircleAvatar(child: Text(sender[0])),
            ),
        ],
      ),
    );
  }
}
