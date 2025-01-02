import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../configs/di.dart';
import '../ui/screens/home/bloc/home_bloc.dart';
import '../ui/screens/home/home_screen.dart';
import '../ui/screens/home_navigation/home_navigation.dart';
import '../ui/screens/notifications/bloc/notifications_bloc.dart';
import '../ui/screens/notifications/notifications_screen.dart';
import '../ui/screens/review/review_screen.dart';
import '../ui/screens/settings/settings_screen.dart';
import '../ui/screens/vocabulary/bloc/vocabulary_bloc.dart';
import '../ui/screens/vocabulary/vocabulary_screen.dart';

part 'route_paths.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');

  static final router = GoRouter(
    initialLocation: RoutePaths.vocabulary,
    navigatorKey: rootNavigatorKey,
    routes: [
      ShellRoute(
        navigatorKey: homeNavigatorKey,
        builder: (context, state, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => DI().sl<HomeBloc>(),
              ),
              BlocProvider(
                create: (context) => DI().sl<VocabularyBloc>(),
              ),
              BlocProvider(
                create: (context) => DI().sl<NotificationsBloc>(),
              ),
            ],
            child: HomeNavigation(
              child: child,
            ),
          );
        },
        routes: [
          GoRoute(
            path: RoutePaths.home,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: const HomeScreen(),
              );
            },
          ),
          GoRoute(
            path: RoutePaths.notifications,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: const NotificationsScreen(),
              );
            },
          ),
          GoRoute(
            path: RoutePaths.review,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: ReviewScreen(),
              );
            },
          ),
          GoRoute(
            path: RoutePaths.settings,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: const SettingsScreen(),
              );
            },
          ),
          GoRoute(
            path: RoutePaths.vocabulary,
            pageBuilder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final wordId = extra?['wordId'] as int?;
              return NoTransitionPage(
                key: state.pageKey,
                child: VocabularyScreen(wordId: wordId),
              );
            },
          ),
        ],
      )
    ],
  );
}
