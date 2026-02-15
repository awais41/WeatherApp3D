import 'package:flutter/material.dart';

import 'home_page_state.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onViewReport;
  final VoidCallback onOpenLocation;
  final VoidCallback onOpenSettings;

  const HomePage({
    super.key,
    required this.onViewReport,
    required this.onOpenLocation,
    required this.onOpenSettings,
  });

  @override
  State<HomePage> createState() => HomePageState();
}
