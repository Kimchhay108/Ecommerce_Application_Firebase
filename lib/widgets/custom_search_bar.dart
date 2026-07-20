import 'package:flutter/material.dart';
import '../app/theme/app_theme.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String hintText;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextEditingController? controller;

  const CustomSearchBar({
    super.key,
    this.onChanged,
    this.hintText = 'Search',
    this.readOnly = false,
    this.onTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.search,
              color: AppTheme.textPrimaryColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: IgnorePointer(
                ignoring: readOnly,
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  readOnly: readOnly,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
