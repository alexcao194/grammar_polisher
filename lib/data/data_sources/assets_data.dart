import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/word.dart';

abstract interface class AssetsData {
  Future<List<Word>> getOxfordWordsByLetter(String letter);
  Future<List<Word>> getAllOxfordWords();
}

class AssetsDataImpl implements AssetsData {
  @override
  Future<List<Word>> getOxfordWordsByLetter(String letter) async {
    final path = 'assets/json/oxford_words/$letter.json';
    final jsonString = await rootBundle.loadString(path);
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Word.fromJson(json)).toList();
  }

  @override
  Future<List<Word>> getAllOxfordWords() async {
    final List<String> letters = 'abcdefghijklmnopqrstuvwxyz'.split('');
    final List<Word> words = [];
    for (final letter in letters) {
      final List<Word> wordsByLetter = await getOxfordWordsByLetter(letter);
      words.addAll(wordsByLetter);
    }
    return words;
  }
}