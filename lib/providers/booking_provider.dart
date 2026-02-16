import 'package:flutter/foundation.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  final BookingService _bookingService = BookingService();

  List<Booking> _bookings = [];
  Booking? _currentBooking;
  bool _isLoading = false;
  bool _isChecking = false;
  bool _isAvailable = false;
  String? _errorMessage;

  DateTime? _checkIn;
  DateTime? _checkOut;
  int _numberOfGuests = 1;

  List<Booking> get bookings => _bookings;
  Booking? get currentBooking => _currentBooking;
  bool get isLoading => _isLoading;
  bool get isChecking => _isChecking;
  bool get isAvailable => _isAvailable;
  String? get errorMessage => _errorMessage;
  DateTime? get checkIn => _checkIn;
  DateTime? get checkOut => _checkOut;
  int get numberOfGuests => _numberOfGuests;

  int get numberOfNights {
    if (_checkIn == null || _checkOut == null) return 0;
    return _checkOut!.difference(_checkIn!).inDays;
  }

  void setDates(DateTime checkIn, DateTime checkOut) {
    _checkIn = checkIn;
    _checkOut = checkOut;
    notifyListeners();
  }

  void setGuests(int count) {
    _numberOfGuests = count;
    notifyListeners();
  }

  void resetBookingForm() {
    _checkIn = null;
    _checkOut = null;
    _numberOfGuests = 1;
    _isAvailable = false;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> checkAvailability(int roomId) async {
    if (_checkIn == null || _checkOut == null) return false;

    _isChecking = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _bookingService.checkAvailability(
      roomId: roomId,
      checkIn: _checkIn!,
      checkOut: _checkOut!,
    );

    _isChecking = false;

    if (result['success']) {
      _isAvailable = result['available'];
    } else {
      _isAvailable = false;
      _errorMessage = result['error'];
    }

    notifyListeners();
    return _isAvailable;
  }

  Future<bool> createBooking({
    required int roomId,
    String? specialRequests,
  }) async {
    if (_checkIn == null || _checkOut == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _bookingService.createBooking(
      roomId: roomId,
      checkIn: _checkIn!,
      checkOut: _checkOut!,
      numberOfGuests: _numberOfGuests,
      specialRequests: specialRequests,
    );

    if (result['success']) {
      _currentBooking = result['booking'];
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['error'];
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadMyBookings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _bookingService.getMyBookings();

    if (result['success']) {
      _bookings = result['bookings'];
    } else {
      _errorMessage = result['error'];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> cancelBooking(int id) async {
    final result = await _bookingService.cancelBooking(id);

    if (result['success']) {
      final index = _bookings.indexWhere((b) => b.id == id);
      if (index != -1) {
        await loadMyBookings();
      }
      return true;
    } else {
      _errorMessage = result['error'];
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
