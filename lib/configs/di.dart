import 'package:audioplayers/audioplayers.dart';
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
import '../ui/screens/notifications/bloc/notifications_bloc.dart';
import '../utils/local_notifications_tools.dart';
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

    // Blocs
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

    sl.registerFactory(
      () => NotificationsBloc(
        localNotificationsTools: sl(),
      ),
    );

    // Repositories
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
    // Data sources
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

    // Tools
    sl.registerLazySingleton<Dio>(
      () => WritingTutorDio(
        connectivity: Connectivity(),
      ).dio,
    );

    sl.registerLazySingleton<LocalNotificationsTools>(
      () => LocalNotificationsTools(),
    );

    final appHive = AppHive();
    await appHive.init();
    sl.registerLazySingleton<AppHive>(
      () => appHive,
    );

    sl.registerLazySingleton<AudioPlayer>(
      () => AudioPlayer(),
    );
  }
}
