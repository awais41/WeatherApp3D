import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'bottom_nav_icon.dart';

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
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.cardDarkAlt.withOpacity(0.5),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BottomNavIcon(
            icon: Icons.home_rounded,
            index: 0,
            isActive: currentIndex == 0,
            onTap: onTap,
          ),
          BottomNavIcon(
            icon: Icons.show_chart_rounded,
            index: 1,
            isActive: currentIndex == 1,
            onTap: onTap,
          ),
          BottomNavIcon(
            icon: Icons.place_rounded,
            index: 2,
            isActive: currentIndex == 2,
            onTap: onTap,
          ),
          BottomNavIcon(
            icon: Icons.settings_rounded,
            index: 3,
            isActive: currentIndex == 3,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
