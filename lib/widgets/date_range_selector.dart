import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';

class DateRangeSelector extends StatelessWidget {
  final DateTime? checkIn;
  final DateTime? checkOut;
  final void Function(DateTime checkIn, DateTime checkOut) onDatesSelected;

  const DateRangeSelector({
    super.key,
    required this.checkIn,
    required this.checkOut,
    required this.onDatesSelected,
  });

  Future<void> _selectDates(BuildContext context) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: (checkIn != null && checkOut != null)
          ? DateTimeRange(start: checkIn!, end: checkOut!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryRed,
              onPrimary: AppColors.white,
              onSurface: AppColors.darkGrey,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryRed,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (range != null) {
      onDatesSelected(range.start, range.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return GestureDetector(
      onTap: () => _selectDates(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: (checkIn != null)
                ? AppColors.primaryRed
                : AppColors.divider,
            width: checkIn != null ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CHECK-IN',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.warmGrey,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    checkIn != null ? dateFormat.format(checkIn!) : 'Select date',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: checkIn != null
                          ? AppColors.darkGrey
                          : AppColors.warmGrey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: AppColors.divider,
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CHECK-OUT',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.warmGrey,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    checkOut != null
                        ? dateFormat.format(checkOut!)
                        : 'Select date',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: checkOut != null
                          ? AppColors.darkGrey
                          : AppColors.warmGrey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.calendar_month_outlined,
              color: AppColors.primaryRed,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
