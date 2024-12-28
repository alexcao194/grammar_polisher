import '../../configs/hive/app_hive.dart';
import '../models/word.dart';

abstract interface class LocalData {
  Future<void> saveWords(List<Word> words);

  List<Word> getWords();
}

class HiveDatabase implements LocalData {
  final AppHive _appHive;

  HiveDatabase({
    required AppHive appHive,
  }) : _appHive = appHive;

  @override
  List<Word> getWords() {
    return _appHive.wordBox.values.toList();
  }

  @override
  Future<void> saveWords(List<Word> words) async {
    await _appHive.wordBox.clear();
    await _appHive.wordBox.addAll(words);
  }
}