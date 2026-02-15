import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../../core/widgets/shimmer.dart';
import '../bloc/weather_bloc.dart';
import '../widgets/daily_forecast_list.dart';
import '../widgets/gradient_background.dart';
import '../widgets/hourly_forecast_list.dart';

class ForecastPage extends StatelessWidget {
  const ForecastPage({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).size.width * 0.06;
    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherLoading || state is WeatherInitial) {
                return ListView(
                  padding: const EdgeInsets.only(bottom: 120),
                  children: const [
                    SizedBox(height: 12),
                    Shimmer(
                      width: 200,
                      height: 26,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    SizedBox(height: 8),
                    Shimmer(
                      width: 120,
                      height: 16,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    SizedBox(height: 22),
                    Shimmer(
                      width: double.infinity,
                      height: 110,
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    SizedBox(height: 20),
                    Shimmer(
                      width: double.infinity,
                      height: 86,
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    SizedBox(height: 12),
                    Shimmer(
                      width: double.infinity,
                      height: 86,
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                  ],
                );
              }
              if (state is WeatherError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.white70),
                  ),
                );
              }
              if (state is WeatherLoaded) {
                return ListView(
                  padding: const EdgeInsets.only(bottom: 120),
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      'Forecast report',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      DateFormatters.fullDate(state.lastUpdated),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Today',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    HourlyForecastList(items: state.hourly),
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        Text(
                          'Next forecast',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.textSecondary,
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DailyForecastList(items: state.daily),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
