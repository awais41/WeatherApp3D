import 'package:flutter/material.dart';

import 'top_action_button.dart';

class HomeHeaderRow extends StatelessWidget {
  final String cityName;
  final VoidCallback onOpenLocation;
  final VoidCallback onOpenSettings;

  const HomeHeaderRow({
    super.key,
    required this.cityName,
    required this.onOpenLocation,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TopActionButton(icon: Icons.grid_view_rounded, onTap: onOpenLocation),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  cityName,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 26,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        TopActionButton(icon: Icons.more_vert_rounded, onTap: onOpenSettings),
      ],
    );
  }
}
