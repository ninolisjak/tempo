import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/archive_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/compose_screen.dart';
import 'screens/feed_screen.dart';
import 'screens/song_search_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

/// Feed ⇄ Camera → Song → Compose → Feed, and Feed ⇄ Archive.
abstract final class Routes {
  static const feed = '/';
  static const camera = '/camera';
  static const song = '/song';
  static const compose = '/compose';
  static const archive = '/archive';
}

class TempoApp extends StatefulWidget {
  const TempoApp({super.key});

  @override
  State<TempoApp> createState() => _TempoAppState();
}

class _TempoAppState extends State<TempoApp> {
  final _state = AppState();

  late final _router = GoRouter(
    initialLocation: Routes.feed,
    routes: [
      GoRoute(
        path: Routes.feed,
        builder: (context, _) => FeedScreen(
          onPost: () => context.push(Routes.camera),
          onArchive: () => context.push(Routes.archive),
        ),
      ),
      GoRoute(
        path: Routes.camera,
        builder: (context, _) => CameraScreen(
          onClose: () => context.go(Routes.feed),
          onCapture: () => context.push(Routes.song),
        ),
      ),
      GoRoute(
        path: Routes.song,
        builder: (context, _) => SongSearchScreen(
          onRetake: () => context.pop(),
          onNext: () => context.push(Routes.compose),
        ),
      ),
      GoRoute(
        path: Routes.compose,
        builder: (context, _) => ComposeScreen(
          onBack: () => context.pop(),
          onShare: () {
            _state.publish();
            context.go(Routes.feed);
          },
        ),
      ),
      GoRoute(
        path: Routes.archive,
        builder: (context, _) => ArchiveScreen(onBack: () => context.pop()),
      ),
    ],
  );

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'tempo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: _router,
      // The scope has to sit below the Navigator so route builders can reach
      // it — MaterialApp.router builds its own, so wrap here rather than above.
      builder: (context, child) =>
          AppStateScope(notifier: _state, child: child!),
    );
  }
}
