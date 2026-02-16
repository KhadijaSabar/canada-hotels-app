import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.user;

        return Scaffold(
          backgroundColor: AppColors.offWhite,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            title: const Text('Profile'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: AppColors.white,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Text(
                            user?.firstName.isNotEmpty == true
                                ? user!.firstName[0].toUpperCase()
                                : 'G',
                            style: const TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user?.fullName ?? 'Guest',
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '',
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 14,
                          color: AppColors.warmGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildSection(
                  context,
                  children: [
                    _buildTile(
                      icon: Icons.person_outline,
                      label: 'Edit Profile',
                      onTap: () => context.go('/profile/edit'),
                    ),
                    _buildTile(
                      icon: Icons.bookmark_outline,
                      label: 'My Bookings',
                      onTap: () => context.go('/my-bookings'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (user?.phone != null && user!.phone!.isNotEmpty)
                  _buildSection(
                    context,
                    children: [
                      _buildInfoTile(
                        icon: Icons.phone_outlined,
                        label: 'Phone',
                        value: user.phone!,
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                _buildSection(
                  context,
                  children: [
                    _buildTile(
                      icon: Icons.logout,
                      label: 'Sign Out',
                      isDestructive: true,
                      onTap: () async {
                        await authProvider.logout();
                        if (context.mounted) context.go('/login');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'CanadaHotels v1.0.0',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 12,
                    color: AppColors.warmGrey,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(BuildContext context,
      {required List<Widget> children}) {
    return Container(
      color: AppColors.white,
      child: Column(children: children),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppColors.error : AppColors.darkGrey;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 15,
                  color: color,
                ),
              ),
            ),
            if (!isDestructive)
              const Icon(Icons.chevron_right,
                  color: AppColors.warmGrey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.warmGrey, size: 22),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 11,
                  color: AppColors.warmGrey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 14,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
