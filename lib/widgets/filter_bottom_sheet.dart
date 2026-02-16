import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/hotel_provider.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int? _selectedStars;
  double? _maxPrice;
  final _priceController = TextEditingController();

  final List<Map<String, dynamic>> _starOptions = [
    {'label': '5 Stars', 'value': 5},
    {'label': '4+ Stars', 'value': 4},
    {'label': '3+ Stars', 'value': 3},
  ];

  void _applyFilters() {
    context.read<HotelProvider>().applyFilters(
          minStars: _selectedStars,
          maxPrice: _maxPrice,
        );
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _selectedStars = null;
      _maxPrice = null;
      _priceController.clear();
    });
    context.read<HotelProvider>().clearFilters();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Hotels',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkGrey,
                ),
              ),
              TextButton(
                onPressed: _clearFilters,
                child: const Text(
                  'Clear all',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    color: AppColors.warmGrey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Star Rating',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.darkGrey,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: _starOptions.map((option) {
              final isSelected = _selectedStars == option['value'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStars =
                        isSelected ? null : option['value'] as int;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryRed
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryRed
                          : AppColors.divider,
                    ),
                  ),
                  child: Text(
                    option['label'] as String,
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.mediumGrey,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            'Max Price per Night',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.darkGrey,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            style: const TextStyle(
                fontFamily: 'Georgia', color: AppColors.darkGrey),
            onChanged: (value) {
              setState(() {
                _maxPrice = double.tryParse(value);
              });
            },
            decoration: InputDecoration(
              hintText: 'e.g. 500',
              hintStyle: const TextStyle(
                  fontFamily: 'Georgia', color: AppColors.warmGrey),
              prefixText: '\$ ',
              prefixStyle: const TextStyle(
                  fontFamily: 'Georgia', color: AppColors.darkGrey),
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
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
