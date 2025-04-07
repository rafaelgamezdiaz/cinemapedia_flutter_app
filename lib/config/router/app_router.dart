import 'package:cinemapedia/presentation/screens/movies/video_fullscreen_player.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [
    GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIdex = int.parse(state.pathParameters['page'] ?? '0');
        if (pageIdex < 0 || pageIdex > 2) {
          return const HomeScreen(pageIndex: 0);
        }
        return HomeScreen(pageIndex: pageIdex);
      },
      routes: [
        GoRoute(
          path: 'movie/:movieId',
          name: MovieScreen.name,
          builder: (context, state) {
            final movieId = state.pathParameters['movieId'] ?? 'no-id';
            return MovieScreen(movieId: movieId);
          },
        ),
      ],
    ),

    GoRoute(
      path: '/fullscreen-player/:youtubeId', // Ruta absoluta
      name: VideoFullscreenPlayerScreen.name,
      builder: (context, state) {
        final youtubeId = state.pathParameters['youtubeId'] ?? 'no-id';

        if (youtubeId == 'no-id') {
          return const Scaffold(
            body: Center(child: Text('Error: ID de video inválido')),
          );
        }

        final startAt = state.extra as Duration? ?? Duration.zero;
        return VideoFullscreenPlayerScreen(
          youtubeId: youtubeId,
          startAt: startAt,
        );
      },
    ),

    GoRoute(path: '/', redirect: (_, __) => '/home/0'),
  ],
);
