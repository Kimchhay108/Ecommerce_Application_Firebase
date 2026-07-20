import 'package:flutter/material.dart';
import '../app/theme/app_theme.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.title,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.60,
            ),
          ),
        ],
      ),
    );
  }
}
