import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class BottomNavIcon extends StatelessWidget {
  final IconData icon;
  final int index;
  final bool isActive;
  final ValueChanged<int> onTap;

  const BottomNavIcon({
    super.key,
    required this.icon,
    required this.index,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => onTap(index),
      radius: 24,
      child: Icon(
        icon,
        color: isActive ? AppColors.accent : AppColors.textSecondary,
        size: 26,
      ),
    );
  }
}
