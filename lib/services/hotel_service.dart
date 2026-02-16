import 'package:dio/dio.dart';
import '../config/constants.dart';
import '../models/hotel_model.dart';
import 'api_service.dart';

class HotelService {
  final ApiService _api = ApiService.instance;

  Future<Map<String, dynamic>> getHotels({
    String? city,
    String? country,
    int? minStars,
    double? maxPrice,
    String? sortBy,
  }) async {
    try {
      final params = <String, dynamic>{};
      if (city != null && city.isNotEmpty) params['city'] = city;
      if (country != null && country.isNotEmpty) params['country'] = country;
      if (minStars != null) params['min_stars'] = minStars;
      if (maxPrice != null) params['max_price'] = maxPrice;
      if (sortBy != null) params['sort'] = sortBy;

      final response = await _api.get(ApiEndpoints.hotels, params: params);
      final data = response.data;
      final hotelsList = data['data'] ?? data['hotels'] ?? data;

      final hotels = (hotelsList as List)
          .map((h) => Hotel.fromJson(h))
          .toList();

      return {'success': true, 'hotels': hotels};
    } on DioException catch (e) {
      return {'success': false, 'error': _api.extractError(e)};
    }
  }

  Future<Map<String, dynamic>> searchHotels(String query) async {
    try {
      final response = await _api.get(
        ApiEndpoints.hotelSearch,
        params: {'q': query},
      );
      final data = response.data;
      final hotelsList = data['data'] ?? data['hotels'] ?? data;

      final hotels = (hotelsList as List)
          .map((h) => Hotel.fromJson(h))
          .toList();

      return {'success': true, 'hotels': hotels};
    } on DioException catch (e) {
      return {'success': false, 'error': _api.extractError(e)};
    }
  }

  Future<Map<String, dynamic>> getHotelById(int id) async {
    try {
      final response = await _api.get('${ApiEndpoints.hotels}/$id');
      final data = response.data;
      final hotelData = data['data'] ?? data['hotel'] ?? data;

      final hotel = Hotel.fromJson(hotelData);
      return {'success': true, 'hotel': hotel};
    } on DioException catch (e) {
      return {'success': false, 'error': _api.extractError(e)};
    }
  }

  Future<Map<String, dynamic>> getDestinations() async {
    try {
      final response = await _api.get(ApiEndpoints.destinations);
      final data = response.data;
      final destinations = data['data'] ?? data['destinations'] ?? data;

      return {'success': true, 'destinations': destinations};
    } on DioException catch (e) {
      return {'success': false, 'error': _api.extractError(e)};
    }
  }
}
