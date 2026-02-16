import 'package:dio/dio.dart';
import '../config/constants.dart';
import '../models/user_model.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _api = ApiService.instance;
  final StorageService _storage = StorageService();

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      final response = await _api.post(ApiEndpoints.register, data: {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      });

      final data = response.data;
      final token = data['token'] ?? data['data']?['token'];
      final userData = data['user'] ?? data['data']?['user'];

      if (token != null) await _storage.saveToken(token);
      if (userData != null) {
        final user = User.fromJson(userData);
        await _storage.saveUser(user);
        return {'success': true, 'user': user};
      }
      return {'success': true};
    } on DioException catch (e) {
      return {'success': false, 'error': _api.extractError(e)};
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _api.post(ApiEndpoints.login, data: {
        'email': email,
        'password': password,
      });

      final data = response.data;
      final token = data['token'] ?? data['data']?['token'];
      final userData = data['user'] ?? data['data']?['user'];

      if (token != null) await _storage.saveToken(token);
      if (userData != null) {
        final user = User.fromJson(userData);
        await _storage.saveUser(user);
        return {'success': true, 'user': user};
      }
      return {'success': true};
    } on DioException catch (e) {
      return {'success': false, 'error': _api.extractError(e)};
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _api.get(ApiEndpoints.profile);
      final userData = response.data['data'] ?? response.data['user'] ?? response.data;
      final user = User.fromJson(userData);
      await _storage.saveUser(user);
      return {'success': true, 'user': user};
    } on DioException catch (e) {
      return {'success': false, 'error': _api.extractError(e)};
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      final response = await _api.put(ApiEndpoints.profile, data: {
        'first_name': firstName,
        'last_name': lastName,
        if (phone != null) 'phone': phone,
      });
      final userData = response.data['data'] ?? response.data['user'] ?? response.data;
      final user = User.fromJson(userData);
      await _storage.saveUser(user);
      return {'success': true, 'user': user};
    } on DioException catch (e) {
      return {'success': false, 'error': _api.extractError(e)};
    }
  }

  Future<void> logout() async {
    await _storage.clearAll();
  }

  Future<User?> getStoredUser() async {
    return await _storage.getUser();
  }

  Future<bool> isLoggedIn() async {
    return await _storage.hasToken();
  }
}
