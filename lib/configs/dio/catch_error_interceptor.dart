import 'package:dio/dio.dart';

class CatchErrorInterceptor extends Interceptor {

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data['error'] != null) {
      return handler.reject(DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: response.data['error'],
      ));
    }

    if (response.data['result']['needToLogin'] == true) {
      return handler.reject(DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Oops! You have run out of free usage attempts. Please come back tomorrow.',
      ));
    }

    return handler.next(response);
  }
}
