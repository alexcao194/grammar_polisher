import '../data_sources/assets_data.dart';
import '../data_sources/local_data.dart';
import '../models/word.dart';

abstract interface class OxfordWordsRepository {
  Future<void> initData();
  List<Word> getAllOxfordWords();
}

class OxfordWordsRepositoryImpl implements OxfordWordsRepository {
  final AssetsData _assetsData;
  final LocalData _localData;

  OxfordWordsRepositoryImpl({
    required AssetsData assetsData,
    required LocalData localData,
  }) : _assetsData = assetsData,
       _localData = localData;

  @override
  Future<void> initData() async {
    final currentWords = _localData.getWords();
    if (currentWords.isNotEmpty) return;
    final words = await _assetsData.getAllOxfordWords();
    await _localData.saveWords(words);
  }

  @override
  List<Word> getAllOxfordWords() => _localData.getWords();
}