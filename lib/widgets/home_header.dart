import 'package:flutter/material.dart';
import '../app/theme/app_theme.dart';

class HomeHeader extends StatelessWidget {
  final String profileImageUrl;
  final String selectedGender;
  final VoidCallback? onProfileTap;
  final VoidCallback? onGenderTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onCartTap;
  final int notificationCount;
  final int cartCount;

  const HomeHeader({
    super.key,
    required this.profileImageUrl,
    required this.selectedGender,
    this.onProfileTap,
    this.onGenderTap,
    this.onNotificationTap,
    this.onCartTap,
    this.notificationCount = 0,
    this.cartCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Profile Image
        GestureDetector(
          onTap: onProfileTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(profileImageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // Gender Selector Dropdown
        GestureDetector(
          onTap: onGenderTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedGender,
                  style: const TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.textPrimaryColor,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        // Notification & Shopping Bag Icons
        Row(
          children: [
            // Notification Bell
            GestureDetector(
              onTap: onNotificationTap,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_none_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  if (notificationCount > 0)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$notificationCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Shopping Bag (Cart)
            GestureDetector(
              onTap: onCartTap,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  if (cartCount > 0)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$cartCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
