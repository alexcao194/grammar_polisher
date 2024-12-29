import '../../configs/hive/app_hive.dart';
import '../models/word.dart';

abstract interface class LocalData {
  Future<void> saveWords(List<Word> words);

  List<Word> getWords();

  Future<void> saveWord(Word word);
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
    await _appHive.wordBox.putAll(
      Map.fromEntries(
        words.map(
          (word) => MapEntry(word.index, word),
        ),
      ),
    );
  }

  @override
  Future<void> saveWord(Word word) {
    return _appHive.wordBox.put(word.index, word);
  }
}