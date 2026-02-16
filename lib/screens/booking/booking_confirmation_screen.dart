import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/primary_button.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final int bookingId;

  const BookingConfirmationScreen({super.key, required this.bookingId});

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState
    extends State<BookingConfirmationScreen> {
  final _dateFormat = DateFormat('MMM dd, yyyy');
  final _currencyFormat =
      NumberFormat.currency(symbol: '\$', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final booking =
        Provider.of<BookingProvider>(context, listen: false).currentBooking;

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your reservation has been successfully placed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 14,
                  color: AppColors.warmGrey,
                ),
              ),
              const SizedBox(height: 32),
              if (booking != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    children: [
                      _infoRow('Booking ID', '#${booking.id}'),
                      const Divider(height: 24),
                      if (booking.hotel != null)
                        _infoRow('Hotel', booking.hotel!.name),
                      if (booking.room != null)
                        _infoRow('Room', booking.room!.name),
                      const Divider(height: 24),
                      _infoRow('Check-in',
                          _dateFormat.format(booking.checkInDate)),
                      _infoRow('Check-out',
                          _dateFormat.format(booking.checkOutDate)),
                      _infoRow('Guests', '${booking.numberOfGuests}'),
                      const Divider(height: 24),
                      _infoRow(
                        'Total',
                        _currencyFormat.format(booking.totalPrice),
                        isHighlight: true,
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              PrimaryButton(
                label: 'View My Bookings',
                onPressed: () => context.go('/my-bookings'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/home'),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    color: AppColors.warmGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontSize: 14,
              color: AppColors.warmGrey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: isHighlight ? 16 : 14,
              fontWeight:
                  isHighlight ? FontWeight.w700 : FontWeight.w600,
              color: isHighlight ? AppColors.primaryRed : AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }
}
