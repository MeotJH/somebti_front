import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:somebti_front/pages/chat_page.dart';
import 'package:somebti_front/pages/direct_message_page.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const DirectMessagePage();
      },
    ),
    GoRoute(
      path: '/chat',
      builder: (BuildContext context, GoRouterState state) {
        return const ChatPage();
      },
    ),
  ],
);
