import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation/app_router.dart';
import 'ui/screens/settings/bloc/settings_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final fontFamily = 'SF Pro Display';
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        var snapshot = state.settingsSnapshot;
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          theme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(snapshot.seek),
              brightness: Brightness.light,
            ),
            textTheme: TextTheme().apply(fontFamily: fontFamily),
          ),
          darkTheme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(snapshot.seek),
              brightness: Brightness.dark,
            ),
            textTheme: TextTheme().apply(fontFamily: fontFamily),
          ),
          themeMode: ThemeMode.values[snapshot.themeMode],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(const SettingsEvent.getSettings());
  }
}
