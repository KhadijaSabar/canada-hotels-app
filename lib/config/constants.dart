class AppConstants {
  static const String appName = 'CanadaHotels';
  static const String appTagline = 'Luxury Stays Worldwide';
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  static const int maxGuestsPerRoom = 6;
  static const int minNights = 1;
  static const int maxNights = 30;
  static const int searchDebounceMs = 500;

  static const List<String> starFilters = ['1', '2', '3', '4', '5'];
  static const List<String> sortOptions = [
    'Price: Low to High',
    'Price: High to Low',
    'Rating',
    'Name',
  ];
}

class ApiEndpoints {
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String profile = '/api/auth/profile';
  static const String hotels = '/api/hotels';
  static const String hotelSearch = '/api/hotels/search';
  static const String destinations = '/api/hotels/destinations';
  static const String bookings = '/api/bookings';
  static const String availability = '/api/bookings/availability';
}
