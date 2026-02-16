import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/hotel_provider.dart';
import '../../models/hotel_model.dart';
import '../../widgets/room_card.dart';
import '../../widgets/star_rating.dart';

class HotelDetailScreen extends StatefulWidget {
  final int hotelId;

  const HotelDetailScreen({super.key, required this.hotelId});

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HotelProvider>().loadHotelById(widget.hotelId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HotelProvider>(
      builder: (context, hotelProvider, _) {
        if (hotelProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primaryRed),
            ),
          );
        }

        final hotel = hotelProvider.selectedHotel;
        if (hotel == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Hotel not found')),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.offWhite,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: AppColors.primaryRed,
                iconTheme: const IconThemeData(color: AppColors.white),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      hotel.imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: hotel.imageUrl!,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(
                                color: AppColors.primaryRed,
                                child: const Icon(Icons.hotel,
                                    size: 80, color: AppColors.white),
                              ),
                            )
                          : Container(
                              color: AppColors.primaryRed,
                              child: const Icon(Icons.hotel,
                                  size: 80, color: AppColors.white),
                            ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black45],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hotel.name,
                                  style: const TextStyle(
                                    fontFamily: 'Georgia',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 14,
                                      color: AppColors.warmGrey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      hotel.location,
                                      style: const TextStyle(
                                        fontFamily: 'Georgia',
                                        fontSize: 13,
                                        color: AppColors.warmGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          StarRating(stars: hotel.stars),
                        ],
                      ),
                      if (hotel.averageRating != null) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryRed,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                hotel.averageRating!.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontFamily: 'Georgia',
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${hotel.reviewCount ?? 0} reviews',
                              style: const TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 13,
                                color: AppColors.warmGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 20),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 16),
                      const Text(
                        'About',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        hotel.description,
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 14,
                          color: AppColors.mediumGrey,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildAmenities(hotel.amenities),
                      const SizedBox(height: 24),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 16),
                      const Text(
                        'Available Rooms',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (hotel.rooms != null && hotel.rooms!.isNotEmpty)
                        ...hotel.rooms!.map((room) => RoomCard(
                              room: room,
                              hotelName: hotel.name,
                              onBook: () {
                                context.go(
                                  '/booking/${room.id}',
                                  extra: {
                                    'hotelName': hotel.name,
                                    'roomName': room.name,
                                    'pricePerNight': room.pricePerNight,
                                  },
                                );
                              },
                            ))
                      else
                        const Center(
                          child: Text(
                            'No rooms available',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: AppColors.warmGrey,
                            ),
                          ),
                        ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAmenities(List<String> amenities) {
    if (amenities.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amenities',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.darkGrey,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: amenities.map((amenity) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.divider),
              ),
              child: Text(
                amenity,
                style: const TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 12,
                  color: AppColors.mediumGrey,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
