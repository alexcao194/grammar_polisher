import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app.dart';
import 'configs/di.dart';
import 'data/repositories/oxford_words_repository.dart';


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
  runApp(const App());
}