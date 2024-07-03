import 'package:flutter/material.dart';
import 'package:somebti_front/components/list_item.dart';
import 'package:somebti_front/constants/mbti_constant.dart';

class DirectMessagePage extends StatelessWidget {
  const DirectMessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: const Text('User Name'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Add edit functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: '검색',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: MbtiConstant.types.map(
                (type) {
                  return ListItem(
                    name: type,
                    message: "${MbtiConstant.descriptions[type]} · 1시간 ",
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
