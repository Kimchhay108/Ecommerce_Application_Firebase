import 'package:flutter/material.dart';
import '../app/theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, Icons.home, 0),
            _buildNavItem(Icons.category_outlined, Icons.category, 1),
            _buildNavItem(Icons.local_shipping_outlined, Icons.local_shipping, 2),
            _buildNavItem(Icons.person_outline, Icons.person, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData outlineIcon, IconData filledIcon, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        child: Icon(
          isSelected ? filledIcon : outlineIcon,
          color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
          size: 24,
        ),
      ),
    );
  }
}
