import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/models/example.dart';
import '../../data/models/sense.dart';
import '../../data/models/word.dart';

class AppHive {
  static const String wordKey = 'word';

  Box<Word> get wordBox => Hive.box<Word>(wordKey);

  init() async {
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);

    Hive.registerAdapter(ExampleAdapter());
    Hive.registerAdapter(SenseAdapter());
    Hive.registerAdapter(WordAdapter());

    await Hive.openBox<Word>(wordKey);
  }
}