import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListItem extends StatelessWidget {
  final String name;
  final String message;

  const ListItem({super.key, required this.name, required this.message});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.pink[50],
      splashColor: Colors.pink[50],
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Text(name),
        subtitle: Text(
          message,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: const Icon(Icons.camera_alt_outlined),
      ),
      onTap: () {
        context.push('/chat');
      },
    );
  }
}
