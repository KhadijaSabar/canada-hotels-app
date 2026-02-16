import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking_model.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _dateFormat = DateFormat('MMM dd, yyyy');
  final _currencyFormat =
      NumberFormat.currency(symbol: '\$', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().loadMyBookings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _cancelBooking(int bookingId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Cancel Booking',
          style: TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to cancel this booking?',
          style: TextStyle(fontFamily: 'Georgia'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No',
                style: TextStyle(color: AppColors.warmGrey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, Cancel',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success =
          await context.read<BookingProvider>().cancelBooking(bookingId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Booking cancelled'
                : 'Failed to cancel booking'),
            backgroundColor:
                success ? AppColors.success : AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryRed,
          unselectedLabelColor: AppColors.warmGrey,
          indicatorColor: AppColors.primaryRed,
          labelStyle: const TextStyle(
              fontFamily: 'Georgia', fontWeight: FontWeight.w700),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, _) {
          if (bookingProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryRed),
            );
          }

          final upcoming = bookingProvider.bookings
              .where((b) => b.isUpcoming)
              .toList();
          final past = bookingProvider.bookings
              .where((b) => b.isPast && b.status != 'cancelled')
              .toList();
          final cancelled = bookingProvider.bookings
              .where((b) => b.status == 'cancelled')
              .toList();

          return RefreshIndicator(
            color: AppColors.primaryRed,
            onRefresh: () => bookingProvider.loadMyBookings(),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBookingList(upcoming, showCancel: true),
                _buildBookingList(past),
                _buildBookingList(cancelled),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookingList(List<Booking> bookings,
      {bool showCancel = false}) {
    if (bookings.isEmpty) {
      return const Center(
        child: Text(
          'No bookings found',
          style: TextStyle(
              fontFamily: 'Georgia', color: AppColors.warmGrey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      booking.hotel?.name ?? 'Hotel',
                      style: const TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    _buildStatusBadge(booking.status),
                  ],
                ),
                if (booking.room != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    booking.room!.name,
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 13,
                      color: AppColors.warmGrey,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                const Divider(height: 1, color: AppColors.divider),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Check-in',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 11,
                              color: AppColors.warmGrey,
                            ),
                          ),
                          Text(
                            _dateFormat.format(booking.checkInDate),
                            style: const TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Check-out',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 11,
                              color: AppColors.warmGrey,
                            ),
                          ),
                          Text(
                            _dateFormat.format(booking.checkOutDate),
                            style: const TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _currencyFormat.format(booking.totalPrice),
                      style: const TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ],
                ),
                if (showCancel && booking.isCancellable) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _cancelBooking(booking.id),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        'Cancel Booking',
                        style: TextStyle(fontFamily: 'Georgia'),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'confirmed':
        color = AppColors.success;
        break;
      case 'pending':
        color = AppColors.warning;
        break;
      case 'cancelled':
        color = AppColors.error;
        break;
      default:
        color = AppColors.warmGrey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
