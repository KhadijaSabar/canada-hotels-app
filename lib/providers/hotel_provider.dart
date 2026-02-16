import 'package:flutter/foundation.dart';
import '../models/hotel_model.dart';
import '../services/hotel_service.dart';

class HotelProvider extends ChangeNotifier {
  final HotelService _hotelService = HotelService();

  List<Hotel> _hotels = [];
  List<Hotel> _searchResults = [];
  Hotel? _selectedHotel;
  List<dynamic> _destinations = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;

  String? _filterCity;
  String? _filterCountry;
  int? _filterMinStars;
  double? _filterMaxPrice;
  String? _sortBy;

  List<Hotel> get hotels => _hotels;
  List<Hotel> get searchResults => _searchResults;
  Hotel? get selectedHotel => _selectedHotel;
  List<dynamic> get destinations => _destinations;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  bool get hasActiveFilters =>
      _filterCity != null ||
      _filterCountry != null ||
      _filterMinStars != null ||
      _filterMaxPrice != null;

  Future<void> loadHotels() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _hotelService.getHotels(
      city: _filterCity,
      country: _filterCountry,
      minStars: _filterMinStars,
      maxPrice: _filterMaxPrice,
      sortBy: _sortBy,
    );

    if (result['success']) {
      _hotels = result['hotels'];
    } else {
      _errorMessage = result['error'];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchHotels(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    final result = await _hotelService.searchHotels(query);

    if (result['success']) {
      _searchResults = result['hotels'];
    }

    _isSearching = false;
    notifyListeners();
  }

  Future<void> loadHotelById(int id) async {
    _isLoading = true;
    _selectedHotel = null;
    _errorMessage = null;
    notifyListeners();

    final result = await _hotelService.getHotelById(id);

    if (result['success']) {
      _selectedHotel = result['hotel'];
    } else {
      _errorMessage = result['error'];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadDestinations() async {
    final result = await _hotelService.getDestinations();
    if (result['success']) {
      _destinations = result['destinations'];
      notifyListeners();
    }
  }

  void applyFilters({
    String? city,
    String? country,
    int? minStars,
    double? maxPrice,
    String? sortBy,
  }) {
    _filterCity = city;
    _filterCountry = country;
    _filterMinStars = minStars;
    _filterMaxPrice = maxPrice;
    _sortBy = sortBy;
    loadHotels();
  }

  void clearFilters() {
    _filterCity = null;
    _filterCountry = null;
    _filterMinStars = null;
    _filterMaxPrice = null;
    _sortBy = null;
    loadHotels();
  }

  void clearSearch() {
    _searchResults = [];
    _isSearching = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
