import 'package:flutter/material.dart';
import '../config/theme.dart';

class GuestCounter extends StatelessWidget {
  final int value;
  final void Function(int) onChanged;
  final int min;
  final int max;

  const GuestCounter({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.person_outline,
                  size: 20, color: AppColors.mediumGrey),
              SizedBox(width: 10),
              Text(
                'Guests',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 15,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _CounterButton(
                icon: Icons.remove,
                onPressed: value > min ? () => onChanged(value - 1) : null,
              ),
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  '$value',
                  style: const TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGrey,
                  ),
                ),
              ),
              _CounterButton(
                icon: Icons.add,
                onPressed: value < max ? () => onChanged(value + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _CounterButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: onPressed != null
              ? AppColors.primaryRed
              : AppColors.divider,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, size: 18, color: AppColors.white),
      ),
    );
  }
}
