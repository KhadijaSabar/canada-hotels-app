import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/hotel/hotel_detail_screen.dart';
import '../screens/booking/booking_screen.dart';
import '../screens/booking/booking_confirmation_screen.dart';
import '../screens/booking/my_bookings_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String hotelDetail = '/hotel/:id';
  static const String booking = '/booking/:roomId';
  static const String bookingConfirmation = '/booking/confirmation/:bookingId';
  static const String myBookings = '/my-bookings';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';

  static GoRouter router(BuildContext context) {
    return GoRouter(
      initialLocation: splash,
      redirect: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final isAuthenticated = authProvider.isAuthenticated;
        final isOnAuthRoute = state.matchedLocation == login ||
            state.matchedLocation == register ||
            state.matchedLocation == splash;

        if (!isAuthenticated && !isOnAuthRoute) {
          return login;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: register,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/hotel/:id',
          builder: (context, state) {
            final hotelId = int.parse(state.pathParameters['id']!);
            return HotelDetailScreen(hotelId: hotelId);
          },
        ),
        GoRoute(
          path: '/booking/:roomId',
          builder: (context, state) {
            final roomId = int.parse(state.pathParameters['roomId']!);
            final extras = state.extra as Map<String, dynamic>?;
            return BookingScreen(
              roomId: roomId,
              hotelName: extras?['hotelName'] ?? '',
              roomName: extras?['roomName'] ?? '',
              pricePerNight: (extras?['pricePerNight'] ?? 0).toDouble(),
            );
          },
        ),
        GoRoute(
          path: '/booking/confirmation/:bookingId',
          builder: (context, state) {
            final bookingId = int.parse(state.pathParameters['bookingId']!);
            return BookingConfirmationScreen(bookingId: bookingId);
          },
        ),
        GoRoute(
          path: myBookings,
          builder: (context, state) => const MyBookingsScreen(),
        ),
        GoRoute(
          path: profile,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: editProfile,
          builder: (context, state) => const EditProfileScreen(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Page not found: ${state.error}'),
        ),
      ),
    );
  }
}
