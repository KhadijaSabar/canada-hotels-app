import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../models/hotel_model.dart';
import 'star_rating.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;
  final VoidCallback onTap;

  const HotelCard({super.key, required this.hotel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: SizedBox(
                height: 180,
                width: double.infinity,
                child: hotel.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: hotel.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: const Color(0xFFEDE0E0),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.primaryRed.withOpacity(0.1),
                          child: const Icon(
                            Icons.hotel,
                            size: 48,
                            color: AppColors.primaryRed,
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.primaryRed.withOpacity(0.1),
                        child: const Icon(
                          Icons.hotel,
                          size: 48,
                          color: AppColors.primaryRed,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          hotel.name,
                          style: const TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ),
                      StarRating(stars: hotel.stars, size: 14),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: AppColors.warmGrey,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        hotel.location,
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
                      if (hotel.averageRating != null)
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 14, color: Color(0xFFFFBB00)),
                            const SizedBox(width: 3),
                            Text(
                              hotel.averageRating!.toStringAsFixed(1),
                              style: const TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkGrey,
                              ),
                            ),
                            if (hotel.reviewCount != null)
                              Text(
                                ' (${hotel.reviewCount})',
                                style: const TextStyle(
                                  fontFamily: 'Georgia',
                                  fontSize: 12,
                                  color: AppColors.warmGrey,
                                ),
                              ),
                          ],
                        )
                      else
                        const SizedBox(),
                      if (hotel.rooms != null && hotel.rooms!.isNotEmpty)
                        Row(
                          children: [
                            const Text(
                              'from ',
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 12,
                                color: AppColors.warmGrey,
                              ),
                            ),
                            Text(
                              currencyFormat.format(hotel.minPrice),
                              style: const TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryRed,
                              ),
                            ),
                            const Text(
                              '/night',
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 12,
                                color: AppColors.warmGrey,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
