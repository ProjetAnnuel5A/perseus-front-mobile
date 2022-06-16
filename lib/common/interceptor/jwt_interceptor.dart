import 'package:dio/dio.dart';

class CustomInterceptors extends Interceptor {
  CustomInterceptors(this._jwt);

  final String _jwt;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');

    options.headers['Authorization'] = 'Bearer $_jwt';
    return super.onRequest(options, handler);
  }
}
