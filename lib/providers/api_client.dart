import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  // Gunakan 10.0.2.2 untuk Emulator Android bawaan, ganti ke 127.0.0.1 jika via Web/Chrome
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Dio get dio {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));

    // Interceptor otomatis menyisipkan Token Bearer Sanctum ke setiap request API
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));

    return dio;
  }
}