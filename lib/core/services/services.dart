import 'package:get_it/get_it.dart';



final sl = GetIt.instance;
void setup() {

  // Dio instance registration
  // sl.registerLazySingleton<Dio>(
  //         () => Dio(BaseOptions(baseUrl: EndPoint.baseUrl))
  //       ..interceptors.add(LogInterceptor(
  //         request: true,
  //         requestHeader: true,
  //         requestBody: true,
  //         responseHeader: true,
  //         responseBody: true,
  //         error: true,
  //       )));


  // sl.registerLazySingleton<DioConsumer>(() => DioConsumer(dio: sl<Dio>()));
  // sl.registerLazySingleton<ApiConsumer>(() => sl<DioConsumer>());





}