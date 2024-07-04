import 'package:flutter/material.dart';

import 'package:somebti_front/router.dart';

void main() => runApp(const ChatApp());

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sombti',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        primarySwatch: Colors.pink,
        primaryColor: Colors.pink,
        fontFamily: 'NotoSansKR',
      ),
      routerConfig: router,
    );
  }
}
