import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/gradient_background.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: Center(
          child: Text(
            'Settings',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
