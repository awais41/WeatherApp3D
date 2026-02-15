import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/injection_container.dart';
import '../features/city_search/presentation/bloc/city_search_bloc.dart';
import '../features/weather/presentation/pages/forecast_page.dart';
import '../features/weather/presentation/pages/home_page.dart';
import '../features/weather/presentation/pages/location_page.dart';
import '../features/weather/presentation/pages/settings_page.dart';
import '../features/weather/presentation/widgets/bottom_nav_bar.dart';
import 'app_shell.dart';

class AppShellState extends State<AppShell> {
  int currentIndex = 0;

  void _handleTabChange(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        onViewReport: () => _handleTabChange(1),
        onOpenLocation: () => _handleTabChange(2),
        onOpenSettings: () => _handleTabChange(3),
      ),
      const ForecastPage(),
      BlocProvider(
        create: (_) => sl<CitySearchBloc>(),
        child: LocationPage(
          onCitySelectedNavigateHome: () => _handleTabChange(0),
        ),
      ),
      const SettingsPage(),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: IndexedStack(
              key: ValueKey<int>(currentIndex),
              index: currentIndex,
              children: pages,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavBar(
              currentIndex: currentIndex,
              onTap: _handleTabChange,
            ),
          ),
        ],
      ),
    );
  }
}
