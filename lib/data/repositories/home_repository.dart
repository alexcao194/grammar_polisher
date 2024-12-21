import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/failure.dart';
import '../data_sources/remote_data.dart';
import '../models/check_grammar_result.dart';
import '../models/check_level_result.dart';
import '../models/check_score_result.dart';
import '../models/detect_gpt_result.dart';
import '../models/improve_writing_result.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, ImproveWritingResult>> improveWriting(String text);
  Future<Either<Failure, CheckGrammarResult>> checkGrammar(String text);
  Future<Either<Failure, DetectGptResult>> detectGpt(String text);
  Future<Either<Failure, CheckLevelResult>> checkLevel(String text);
  Future<Either<Failure, CheckScoreResult>> checkScore({required String text, required String type});
}

class HomeRepositoryImpl implements HomeRepository {
  final RemoteData _remoteData;

  HomeRepositoryImpl({required RemoteData remoteData}) : _remoteData = remoteData;

  @override
  Future<Either<Failure, ImproveWritingResult>> improveWriting(String text) async {
    try {
      final result = await _remoteData.improveWriting(text);
      return Right(result);
    } on DioException catch (e) {
      return Left(Failure(message: e.message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, CheckGrammarResult>> checkGrammar(String text) async {
    try {
      final result = await _remoteData.checkGrammar(text);
      return Right(result);
    } on DioException catch (e) {
      return Left(Failure(message: e.message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, DetectGptResult>> detectGpt(String text) async {
    try {
      final result = await _remoteData.detectGpt(text);
      return Right(result);
    } on DioException catch (e) {
      return Left(Failure(message: e.message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, CheckLevelResult>> checkLevel(String text) async {
    try {
      final result = await _remoteData.checkLevel(text);
      return Right(result);
    } on DioException catch (e) {
      return Left(Failure(message: e.message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, CheckScoreResult>> checkScore({required String text, required String type}) async {
    try {
      final result = await _remoteData.checkScore(text: text, type: type);
      return Right(result);
    } on DioException catch (e) {
      return Left(Failure(message: e.message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(Failure());
    }
  }
}