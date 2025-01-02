import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return BlocConsumer<SettingsBloc, SettingsState>(
      listenWhen: (previous, current) {
        return previous.settingsSnapshot != current.settingsSnapshot;
      },
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final isLight = state.settingsSnapshot.themeMode == ThemeMode.light.index;
          final isSystemMode = state.settingsSnapshot.themeMode == ThemeMode.system.index;
          Brightness brightness = Brightness.light;
          if (isSystemMode) {
            final systemBrightness = MediaQuery.of(context).platformBrightness;
            brightness = systemBrightness == Brightness.dark ? Brightness.light : Brightness.dark;
          }
          if (isLight) {
            brightness = Brightness.dark;
          }
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: brightness,
            ),
          );
        });
      },
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
