import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:somebti_front/pages/chat_page.dart';
import 'package:somebti_front/pages/direct_message_page.dart';
import 'package:somebti_front/pages/splash_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashPage();
      },
    ),
    GoRoute(
      path: '/dm',
      // builder: (BuildContext context, GoRouterState state) {
      //   return const DirectMessagePage();
      // },
      pageBuilder: (context, state) {
        final fromPage = state.extra as String?;
        return CustomTransitionPage(
          key: state.pageKey,
          child: const DirectMessagePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (fromPage == '/') {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            } else {
              return child;
            }
          },
        );
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
