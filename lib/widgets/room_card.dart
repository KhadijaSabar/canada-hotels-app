import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../models/hotel_model.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final String hotelName;
  final VoidCallback onBook;

  const RoomCard({
    super.key,
    required this.room,
    required this.hotelName,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (room.imageUrl != null)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: room.imageUrl!,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.primaryRed.withOpacity(0.07),
                    child: const Icon(Icons.bed_outlined,
                        size: 40, color: AppColors.primaryRed),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        room.name,
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: room.isAvailable
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        room.isAvailable ? 'Available' : 'Full',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 10,
                          color: room.isAvailable
                              ? AppColors.success
                              : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  room.description,
                  style: const TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 12,
                    color: AppColors.warmGrey,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person_outline,
                        size: 14, color: AppColors.warmGrey),
                    const SizedBox(width: 4),
                    Text(
                      'Up to ${room.capacity} guests',
                      style: const TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 12,
                        color: AppColors.warmGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currencyFormat.format(room.pricePerNight),
                          style: const TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryRed,
                          ),
                        ),
                        const Text(
                          'per night',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 11,
                            color: AppColors.warmGrey,
                          ),
                        ),
                      ],
                    ),
                    if (room.isAvailable)
                      ElevatedButton(
                        onPressed: onBook,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
