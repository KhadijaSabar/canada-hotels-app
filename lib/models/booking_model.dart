class Booking {
  final int id;
  final int userId;
  final int roomId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numberOfGuests;
  final double totalPrice;
  final String status;
  final String? specialRequests;
  final DateTime createdAt;
  final BookingRoom? room;
  final BookingHotel? hotel;

  Booking({
    required this.id,
    required this.userId,
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfGuests,
    required this.totalPrice,
    required this.status,
    this.specialRequests,
    required this.createdAt,
    this.room,
    this.hotel,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['user_id'],
      roomId: json['room_id'],
      checkInDate: DateTime.parse(json['check_in_date']),
      checkOutDate: DateTime.parse(json['check_out_date']),
      numberOfGuests: json['number_of_guests'],
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0,
      status: json['status'],
      specialRequests: json['special_requests'],
      createdAt: DateTime.parse(json['created_at']),
      room: json['room'] != null ? BookingRoom.fromJson(json['room']) : null,
      hotel: json['hotel'] != null ? BookingHotel.fromJson(json['hotel']) : null,
    );
  }

  int get numberOfNights => checkOutDate.difference(checkInDate).inDays;

  bool get isCancellable =>
      status == 'pending' || status == 'confirmed';

  bool get isPast => checkOutDate.isBefore(DateTime.now());

  bool get isUpcoming =>
      checkInDate.isAfter(DateTime.now()) && status != 'cancelled';

  String get statusLabel {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'cancelled':
        return 'Cancelled';
      case 'completed':
        return 'Completed';
      default:
        return status;
    }
  }
}

class BookingRoom {
  final int id;
  final String name;
  final String type;
  final String? imageUrl;

  BookingRoom({
    required this.id,
    required this.name,
    required this.type,
    this.imageUrl,
  });

  factory BookingRoom.fromJson(Map<String, dynamic> json) {
    return BookingRoom(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      imageUrl: json['image_url'],
    );
  }
}

class BookingHotel {
  final int id;
  final String name;
  final String city;
  final String country;
  final String? imageUrl;

  BookingHotel({
    required this.id,
    required this.name,
    required this.city,
    required this.country,
    this.imageUrl,
  });

  factory BookingHotel.fromJson(Map<String, dynamic> json) {
    return BookingHotel(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      country: json['country'],
      imageUrl: json['image_url'],
    );
  }
}
