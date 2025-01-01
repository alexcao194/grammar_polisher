import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'app.dart';
import 'configs/di.dart';
import 'data/repositories/oxford_words_repository.dart';
import 'ui/screens/settings/bloc/settings_bloc.dart';
import 'utils/local_notifications_tools.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  await LocalNotificationsTools().initialize();
  await DI().init();
  await DI().sl<OxfordWordsRepository>().initData();
  tz.initializeTimeZones();
  final currentTimeZone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DI().sl<SettingsBloc>(),
        ),
      ],
      child: App(),
    ),
  );
}
