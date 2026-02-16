import 'package:dio/dio.dart';
import '../config/constants.dart';
import 'storage_service.dart';

class ApiService {
  static ApiService? _instance;
  late final Dio _dio;
  final StorageService _storage = StorageService();

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: AppConstants.connectionTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        handler.next(response);
      },
      onError: (error, handler) {
        handler.next(error);
      },
    ));
  }

  static ApiService get instance {
    _instance ??= ApiService._internal();
    return _instance!;
  }

  Future<Response> get(String path, {Map<String, dynamic>? params}) async {
    return await _dio.get(path, queryParameters: params);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> patch(String path, {dynamic data}) async {
    return await _dio.patch(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }

  String extractError(DioException error) {
    if (error.response?.data != null) {
      final data = error.response!.data;
      if (data is Map && data['message'] != null) {
        return data['message'];
      }
      if (data is Map && data['error'] != null) {
        return data['error'];
      }
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet.';
      case DioExceptionType.connectionError:
        return 'Cannot connect to server. Please try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
