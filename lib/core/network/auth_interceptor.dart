import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  static const String requiresAuthKey = 'requiresAuth';
  static const String _clientCredentials =
    'Basic MGVkMTllYTU5YTg2MzdjNjpVM0F1TnEwdWVoRlZXQkNEaE9JSUEwYTB5d3pOV1dJcE50Qk9pZ0xMVVM4PQ==';
 //test
//'Basic ZTBjOWRlMWIyZGUyNmZlMjpnOEV0eXg4VFU1Nzl2RHhKemFOMWxvM3I0NitXSkx2cWIvSU1ZZElVUkhNPQ==';
  const AuthInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = _clientCredentials;
    options.headers['Accept-Language'] ??= 'ar';
    handler.next(options);
  }
}
