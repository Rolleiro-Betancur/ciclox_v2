import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Centraliza el log de errores HTTP
    // ignore: avoid_print
    print('[ErrorInterceptor] ${err.response?.statusCode} ${err.requestOptions.path}');
    handler.next(err);
  }
}
