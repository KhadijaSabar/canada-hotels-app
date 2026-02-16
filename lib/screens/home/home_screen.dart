import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/hotel_provider.dart';
import '../../widgets/hotel_card.dart';
import '../../widgets/shimmer_card.dart';
import '../../widgets/filter_bottom_sheet.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  bool _isSearchMode = false;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HotelProvider>().loadHotels();
      context.read<HotelProvider>().loadDestinations();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        setState(() => _isSearchMode = true);
        context.read<HotelProvider>().searchHotels(query);
      } else {
        setState(() => _isSearchMode = false);
        context.read<HotelProvider>().clearSearch();
      }
    });
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${user?.firstName ?? 'Guest'}',
                            style: const TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 13,
                              color: AppColors.warmGrey,
                            ),
                          ),
                          const Text(
                            'Find your stay',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkGrey,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => context.go('/profile'),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.primaryRed,
                            borderRadius: BorderRadius.circular(21),
                          ),
                          child: Center(
                            child: Text(
                              user?.firstName.isNotEmpty == true
                                  ? user!.firstName[0].toUpperCase()
                                  : 'G',
                              style: const TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          style: const TextStyle(
                            fontFamily: 'Georgia',
                            color: AppColors.darkGrey,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search hotels, cities...',
                            hintStyle: const TextStyle(
                              fontFamily: 'Georgia',
                              color: AppColors.warmGrey,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColors.warmGrey,
                              size: 20,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear,
                                        color: AppColors.warmGrey, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _isSearchMode = false);
                                      context
                                          .read<HotelProvider>()
                                          .clearSearch();
                                    },
                                  )
                                : null,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: AppColors.divider),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: AppColors.divider),
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
                      ),
                      const SizedBox(width: 10),
                      Consumer<HotelProvider>(
                        builder: (context, hotels, _) {
                          return GestureDetector(
                            onTap: _showFilters,
                            child: Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: hotels.hasActiveFilters
                                    ? AppColors.primaryRed
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: hotels.hasActiveFilters
                                      ? AppColors.primaryRed
                                      : AppColors.divider,
                                ),
                              ),
                              child: Icon(
                                Icons.tune,
                                color: hotels.hasActiveFilters
                                    ? AppColors.white
                                    : AppColors.warmGrey,
                                size: 20,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<HotelProvider>(
                builder: (context, hotelProvider, _) {
                  if (hotelProvider.isLoading || hotelProvider.isSearching) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: 4,
                      itemBuilder: (_, __) => const ShimmerCard(),
                    );
                  }

                  final hotels = _isSearchMode
                      ? hotelProvider.searchResults
                      : hotelProvider.hotels;

                  if (hotels.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.hotel_outlined,
                            size: 64,
                            color: AppColors.divider,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _isSearchMode
                                ? 'No hotels found'
                                : 'No hotels available',
                            style: const TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 16,
                              color: AppColors.warmGrey,
                            ),
                          ),
                          if (hotelProvider.hasActiveFilters) ...[
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () =>
                                  hotelProvider.clearFilters(),
                              child: const Text('Clear filters'),
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.primaryRed,
                    onRefresh: () => hotelProvider.loadHotels(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: hotels.length,
                      itemBuilder: (context, index) {
                        return HotelCard(
                          hotel: hotels[index],
                          onTap: () =>
                              context.go('/hotel/${hotels[index].id}'),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) {
          setState(() => _selectedTab = index);
          switch (index) {
            case 0:
              break;
            case 1:
              context.go('/my-bookings');
              break;
            case 2:
              context.go('/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
