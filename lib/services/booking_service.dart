import 'package:dio/dio.dart';
import '../config/constants.dart';
import '../models/booking_model.dart';
import 'api_service.dart';

class BookingService {
  final ApiService _api = ApiService.instance;

  Future<Map<String, dynamic>> createBooking({
    required int roomId,
    required DateTime checkIn,
    required DateTime checkOut,
    required int numberOfGuests,
    String? specialRequests,
  }) async {
    try {
      final response = await _api.post(ApiEndpoints.bookings, data: {
        'room_id': roomId,
        'check_in_date': checkIn.toIso8601String().split('T')[0],
        'check_out_date': checkOut.toIso8601String().split('T')[0],
        'number_of_guests': numberOfGuests,
        if (specialRequests != null && specialRequests.isNotEmpty)
          'special_requests': specialRequests,
      });

      final data = response.data;
      final bookingData = data['data'] ?? data['booking'] ?? data;
      final booking = Booking.fromJson(bookingData);

      return {'success': true, 'booking': booking};
    } on DioException catch (e) {
      return {'success': false, 'error': _api.extractError(e)};
    }
  }

  Future<Map<String, dynamic>> getMyBookings() async {
    try {
      final response = await _api.get(ApiEndpoints.bookings);
      final data = response.data;
      final bookingsList = data['data'] ?? data['bookings'] ?? data;

      final bookings = (bookingsList as List)
          .map((b) => Booking.fromJson(b))
          .toList();

      return {'success': true, 'bookings': bookings};
    } on DioException catch (e) {
      return {'success': false, 'error': _api.extractError(e)};
    }
  }

  Future<Map<String, dynamic>> getBookingById(int id) async {
    try {
      final response = await _api.get('${ApiEndpoints.bookings}/$id');
      final data = response.data;
      final bookingData = data['data'] ?? data['booking'] ?? data;
      final booking = Booking.fromJson(bookingData);

      return {'success': true, 'booking': booking};
    } on DioException catch (e) {
      return {'success': false, 'error': _api.extractError(e)};
    }
  }

  Future<Map<String, dynamic>> cancelBooking(int id) async {
    try {
      await _api.patch('${ApiEndpoints.bookings}/$id/cancel');
      return {'success': true};
    } on DioException catch (e) {
      return {'success': false, 'error': _api.extractError(e)};
    }
  }

  Future<Map<String, dynamic>> checkAvailability({
    required int roomId,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    try {
      final response = await _api.get(
        ApiEndpoints.availability,
        params: {
          'room_id': roomId,
          'check_in_date': checkIn.toIso8601String().split('T')[0],
          'check_out_date': checkOut.toIso8601String().split('T')[0],
        },
      );
      final data = response.data;
      return {
        'success': true,
        'available': data['available'] ?? data['data']?['available'] ?? true,
      };
    } on DioException catch (e) {
      return {'success': false, 'error': _api.extractError(e)};
    }
  }
}
