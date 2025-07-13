

import 'package:dio/dio.dart';

import 'end_point.dart';



class DioHelper{

  static late Dio dio;
  static init()
  {
    dio=Dio(BaseOptions(baseUrl:Endpoints.baseUrl,
    receiveDataWhenStatusError: true,
      headers: {
        'Accept': 'application/json',
        'Accept-Language': 'ar',
        'Authorization':"Basic MGVkMTllYTU5YTg2MzdjNjpVM0F1TnEwdWVoRlZXQkNEaE9JSUEwYTB5d3pOV1dJcE50Qk9pZ0xMVVM4PQ=="
        // 'Content-Type': 'multipart/form-data',

     }


    ));

  }

  static Future<Response>getData({required String url,Map<String,dynamic>? query})async
  {

   return await dio.get(url,queryParameters: query);
  }

  static Future<Response>postData({required String url, dynamic data, String?token })async
  {

    return   dio.post(url,data: data);
  }

  static Future<Response>putData({required String url,dynamic data,String?token })async
  {

    return   dio.put(url,data: data);
  }
  static Future<Response>deleteData({required String url})async
  {

    return dio.delete(url);
  }
}