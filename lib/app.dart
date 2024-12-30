import 'package:flutter/material.dart';

import 'navigation/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final fontFamily = 'SF Pro Display';
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        textTheme: TextTheme().apply(fontFamily: fontFamily),
      ),
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        textTheme: TextTheme().apply(fontFamily: fontFamily),
      ),
    );
  }
}
