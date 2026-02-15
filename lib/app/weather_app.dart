import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/injection_container.dart';
import '../core/theme/app_text_styles.dart';
import '../features/weather/presentation/bloc/weather_bloc.dart';
import 'startup_flow_page.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WeatherBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.transparent,
          textTheme: AppTextStyles.textTheme(),
        ),
        home: const StartupFlowPage(),
      ),
    );
  }
}
