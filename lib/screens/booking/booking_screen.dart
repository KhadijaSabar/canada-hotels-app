import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/date_range_selector.dart';
import '../../widgets/guest_counter.dart';

class BookingScreen extends StatefulWidget {
  final int roomId;
  final String hotelName;
  final String roomName;
  final double pricePerNight;

  const BookingScreen({
    super.key,
    required this.roomId,
    required this.hotelName,
    required this.roomName,
    required this.pricePerNight,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _requestsController = TextEditingController();
  final _currencyFormat =
      NumberFormat.currency(symbol: '\$', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().resetBookingForm();
    });
  }

  @override
  void dispose() {
    _requestsController.dispose();
    super.dispose();
  }

  Future<void> _confirmBooking() async {
    final bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);

    if (bookingProvider.checkIn == null || bookingProvider.checkOut == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select check-in and check-out dates'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final available = await bookingProvider.checkAvailability(widget.roomId);
    if (!available) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(bookingProvider.errorMessage ??
                'Room not available for selected dates'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    final success = await bookingProvider.createBooking(
      roomId: widget.roomId,
      specialRequests: _requestsController.text.trim(),
    );

    if (success && mounted) {
      context.go(
          '/booking/confirmation/${bookingProvider.currentBooking!.id}');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(bookingProvider.errorMessage ?? 'Booking failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text('Reserve Room'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, _) {
          final nights = bookingProvider.numberOfNights;
          final totalPrice =
              nights * widget.pricePerNight;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.hotelName,
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 13,
                          color: AppColors.warmGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.roomName,
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_currencyFormat.format(widget.pricePerNight)} / night',
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select Dates',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 12),
                DateRangeSelector(
                  checkIn: bookingProvider.checkIn,
                  checkOut: bookingProvider.checkOut,
                  onDatesSelected: (checkIn, checkOut) {
                    bookingProvider.setDates(checkIn, checkOut);
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Number of Guests',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 12),
                GuestCounter(
                  value: bookingProvider.numberOfGuests,
                  onChanged: bookingProvider.setGuests,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Special Requests',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _requestsController,
                  maxLines: 3,
                  style: const TextStyle(
                      fontFamily: 'Georgia', color: AppColors.darkGrey),
                  decoration: InputDecoration(
                    hintText: 'Any special requests? (optional)',
                    hintStyle: const TextStyle(
                        fontFamily: 'Georgia', color: AppColors.warmGrey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: AppColors.primaryRed, width: 2),
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                  ),
                ),
                if (nights > 0) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5F5),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: AppColors.primaryRed.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_currencyFormat.format(widget.pricePerNight)} x $nights nights',
                              style: const TextStyle(
                                fontFamily: 'Georgia',
                                color: AppColors.mediumGrey,
                              ),
                            ),
                            Text(
                              _currencyFormat.format(totalPrice),
                              style: const TextStyle(
                                fontFamily: 'Georgia',
                                color: AppColors.mediumGrey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: AppColors.divider),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkGrey,
                              ),
                            ),
                            Text(
                              _currencyFormat.format(totalPrice),
                              style: const TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryRed,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                PrimaryButton(
                  label: 'Confirm Reservation',
                  onPressed: _confirmBooking,
                  isLoading: bookingProvider.isLoading ||
                      bookingProvider.isChecking,
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
