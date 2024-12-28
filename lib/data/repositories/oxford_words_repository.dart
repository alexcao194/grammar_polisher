import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../core/failure.dart';
import '../data_sources/assets_data.dart';
import '../models/word.dart';

abstract interface class OxfordWordsRepository {
  Future<Either<Failure, List<Word>>> getOxfordWordsByLetter(String letter);
  Future<Either<Failure, List<Word>>> getAllOxfordWords();
}

class OxfordWordsRepositoryImpl implements OxfordWordsRepository {
  final AssetsData _assetsData;

  OxfordWordsRepositoryImpl({required AssetsData assetsData}) : _assetsData = assetsData;

  @override
  Future<Either<Failure, List<Word>>> getOxfordWordsByLetter(String letter) async {
    try {
      final result = await _assetsData.getOxfordWordsByLetter(letter);
      return Right(result);
    } catch (e) {
      debugPrint('OxfordWordsRepositoryImpl: getOxfordWordsByLetter: $e');
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, List<Word>>> getAllOxfordWords() async {
    try {
      final result = await _assetsData.getAllOxfordWords();
      return Right(result);
    } catch (e) {
      debugPrint('OxfordWordsRepositoryImpl: getAllOxfordWords: $e');
      return Left(Failure());
    }
  }
}