import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import 'connectivity_interceptor.dart';
import 'logging_interceptor.dart';
import 'catch_error_interceptor.dart';

export 'connectivity_interceptor.dart';
export 'logging_interceptor.dart';
export 'catch_error_interceptor.dart';

abstract class AppDio {
  Dio? _dio;

  Dio get dio {
    _dio ??= _get();
    return _dio!;
  }

  Dio _get();
}

class WritingTutorDio extends AppDio {
  final int _connectTimeout = 60000;
  final int _receiveTimeout = 60000;
  final Connectivity _connectivity;

  WritingTutorDio({
    required Connectivity connectivity,
  }) : _connectivity = connectivity;

  @override
  Dio _get() {
    return Dio()
      ..options = BaseOptions(
        baseUrl: const String.fromEnvironment("BASE_URL"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: Duration(milliseconds: _connectTimeout),
        receiveTimeout: Duration(milliseconds: _receiveTimeout),
      )
      ..interceptors.addAll([
        LoggingInterceptor(),
        ConnectivityInterceptor(
          connectivity: _connectivity,
        ),
        CatchErrorInterceptor(),
      ]);
  }
}
