class Hotel {
  final int id;
  final String name;
  final String description;
  final String address;
  final String city;
  final String country;
  final int stars;
  final List<String> amenities;
  final double? latitude;
  final double? longitude;
  final String? imageUrl;
  final double? averageRating;
  final int? reviewCount;
  final List<Room>? rooms;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    required this.country,
    required this.stars,
    required this.amenities,
    this.latitude,
    this.longitude,
    this.imageUrl,
    this.averageRating,
    this.reviewCount,
    this.rooms,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      stars: json['stars'],
      amenities: json['amenities'] != null
          ? List<String>.from(json['amenities'])
          : [],
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      imageUrl: json['image_url'],
      averageRating: json['average_rating'] != null
          ? double.tryParse(json['average_rating'].toString())
          : null,
      reviewCount: json['review_count'],
      rooms: json['rooms'] != null
          ? (json['rooms'] as List).map((r) => Room.fromJson(r)).toList()
          : null,
    );
  }

  String get location => '$city, $country';

  double get minPrice {
    if (rooms == null || rooms!.isEmpty) return 0;
    return rooms!
        .map((r) => double.tryParse(r.pricePerNight.toString()) ?? 0)
        .reduce((a, b) => a < b ? a : b);
  }
}

class Room {
  final int id;
  final int hotelId;
  final String name;
  final String description;
  final String type;
  final int capacity;
  final double pricePerNight;
  final int availableRooms;
  final String? imageUrl;
  final List<String> amenities;

  Room({
    required this.id,
    required this.hotelId,
    required this.name,
    required this.description,
    required this.type,
    required this.capacity,
    required this.pricePerNight,
    required this.availableRooms,
    this.imageUrl,
    required this.amenities,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      hotelId: json['hotel_id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      capacity: json['capacity'],
      pricePerNight: double.tryParse(json['price_per_night'].toString()) ?? 0,
      availableRooms: json['available_rooms'],
      imageUrl: json['image_url'],
      amenities: json['amenities'] != null
          ? List<String>.from(json['amenities'])
          : [],
    );
  }

  bool get isAvailable => availableRooms > 0;
}
