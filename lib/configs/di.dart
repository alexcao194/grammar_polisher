import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../data/data_sources/assets_data.dart';
import '../data/data_sources/local_data.dart';
import '../data/data_sources/remote_data.dart';
import '../data/repositories/home_repository.dart';
import '../data/repositories/oxford_words_repository.dart';
import '../ui/screens/home/bloc/home_bloc.dart';
import '../ui/screens/vocabulary/bloc/vocabulary_bloc.dart';
import 'dio/app_dio.dart';
import 'hive/app_hive.dart';

class DI {
  static DI? _instance;

  DI._();

  factory DI() {
    _instance ??= DI._();
    return _instance!;
  }

  final sl = GetIt.instance;

  Future<void> init() async {
    sl.registerFactory(
      () => HomeBloc(
        polisherRepository: sl(),
      ),
    );

    sl.registerLazySingleton<VocabularyBloc>(
      () => VocabularyBloc(
        oxfordWordsRepository: sl(),
      ),
    );

    sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(
        remoteData: sl(),
      ),
    );

    sl.registerLazySingleton<OxfordWordsRepository>(
      () => OxfordWordsRepositoryImpl(
        assetsData: sl(),
        localData: sl(),
      ),
    );

    sl.registerLazySingleton<RemoteData>(
      () => RemoteDataImpl(
        dio: sl(),
      ),
    );

    sl.registerLazySingleton<AssetsData>(
      () => AssetsDataImpl(),
    );

    sl.registerLazySingleton<LocalData>(
      () => HiveDatabase(
        appHive: sl(),
      ),
    );

    sl.registerLazySingleton<Dio>(
      () => WritingTutorDio(
        connectivity: Connectivity(),
      ).dio,
    );

    final appHive = AppHive();
    await appHive.init();
    sl.registerLazySingleton<AppHive>(
      () => appHive,
    );
  }
}
