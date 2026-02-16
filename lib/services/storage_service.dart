import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../config/constants.dart';
import '../models/user_model.dart';

class StorageService {
  static StorageService? _instance;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  StorageService._internal();

  factory StorageService() {
    _instance ??= StorageService._internal();
    return _instance!;
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: AppConstants.tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: AppConstants.tokenKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.write(key: AppConstants.userKey, value: userJson);
  }

  Future<User?> getUser() async {
    final userJson = await _storage.read(key: AppConstants.userKey);
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: AppConstants.userKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
