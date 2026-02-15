import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shimmer.dart';
import '../../domain/entities/hourly_forecast.dart';
import '../../domain/entities/weather.dart';
import '../bloc/weather_bloc.dart';
import '../tilt/tilt_controller.dart';
import '../widgets/extra_weather_info_panel.dart';
import '../widgets/home_header_row.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/metric_row.dart';
import '../widgets/sunrise_sunset_card.dart';
import '../widgets/weather_main_card.dart';
import '../widgets/updating_chip.dart';
import 'home_page.dart';

class HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  late final TiltController _tiltController;
  bool showExtraInfo = false;

  @override
  void initState() {
    super.initState();
    _tiltController = TiltController();
    _tiltController.start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<WeatherBloc>().add(const LoadWeatherByCurrentLocation());
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final isTablet = mediaQuery.size.shortestSide >= 600;
    _tiltController.setMaxOffset((isLandscape || isTablet) ? 28 : 40);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tiltController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).size.width * 0.06;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D0D0D), Color(0xFF121212), Color(0xFF0D0D0D)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: BlocListener<WeatherBloc, WeatherState>(
            listenWhen: (previous, current) {
              final wasShown =
                  previous is WeatherLoaded &&
                  previous.showPermissionDeniedNotice;
              final isShown =
                  current is WeatherLoaded &&
                  current.showPermissionDeniedNotice;
              return isShown && !wasShown;
            },
            listener: (context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Location permission denied. Showing last saved city.',
                  ),
                ),
              );
            },
            child: BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) => _buildBody(state),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(WeatherState state) {
    if (state is WeatherLoading || state is WeatherInitial) {
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: const [
                SizedBox(height: 14),
                Shimmer(
                  width: double.infinity,
                  height: 46,
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                SizedBox(height: 14),
                Shimmer(
                  width: 110,
                  height: 36,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                SizedBox(height: 20),
                Shimmer(
                  width: 250,
                  height: 250,
                  borderRadius: BorderRadius.all(Radius.circular(130)),
                ),
                SizedBox(height: 12),
                Shimmer(
                  width: 130,
                  height: 70,
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                SizedBox(height: 20),
                Shimmer(
                  width: double.infinity,
                  height: 94,
                  borderRadius: BorderRadius.all(Radius.circular(26)),
                ),
                SizedBox(height: 20),
                Shimmer(
                  width: double.infinity,
                  height: 150,
                  borderRadius: BorderRadius.all(Radius.circular(28)),
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
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

    if (state is WeatherLocationRequired) {
      return Center(
        child: Text(
          state.message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 18),
        ),
      );
    }

    if (state is WeatherLoaded) {
      final sunriseSunsetData = _resolveSunriseSunsetData(state.weather);
      return RefreshIndicator(
        onRefresh: () => _onPullToRefresh(state),
        color: Colors.white,
        backgroundColor: AppColors.cardDark,
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            final offset = _scrollController.offset;
            final isScrollingUp =
                notification.direction == ScrollDirection.forward;
            if (isScrollingUp || offset > 160) {
              if (!showExtraInfo) {
                setState(() => showExtraInfo = true);
              }
            } else if (notification.direction == ScrollDirection.reverse &&
                offset < 120) {
              if (showExtraInfo) {
                setState(() => showExtraInfo = false);
              }
            }
            return false;
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    HomeHeaderRow(
                      cityName: state.cityName,
                      onOpenLocation: widget.onOpenLocation,
                      onOpenSettings: widget.onOpenSettings,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: state.isRefreshing
                          ? const Column(
                              key: ValueKey<String>('updating_chip'),
                              children: [
                                SizedBox(height: 12),
                                UpdatingChip(),
                                SizedBox(height: 8),
                              ],
                            )
                          : const SizedBox(
                              key: ValueKey<String>('updating_chip_hidden'),
                              height: 20,
                            ),
                    ),
                    ValueListenableBuilder<double>(
                      valueListenable: _tiltController.xOffset,
                      builder: (context, xOffset, child) {
                        return WeatherMainCard(
                          weather: state.weather,
                          iconOffsetX: xOffset,
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                    MetricRow(
                      windText: '${state.weather.windSpeed.round()} km/h',
                      humidityText: '${state.weather.humidity}%',
                      rainText: _rainText(state.hourly),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Text(
                          'Today',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: Colors.white, fontSize: 26),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: widget.onViewReport,
                          borderRadius: BorderRadius.circular(16),
                          child: Row(
                            children: [
                              Text(
                                '7 days',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 22,
                                    ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.textSecondary,
                                size: 28,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    HourlyForecastList(items: state.hourly),
                    const SizedBox(height: 16),
                    if (sunriseSunsetData != null) ...[
                      const SizedBox(height: 16),
                      SunriseSunsetCard(
                        sunrise: sunriseSunsetData.$1,
                        sunset: sunriseSunsetData.$2,
                        now: sunriseSunsetData.$3,
                        useArc: false,
                        height: 102,
                      ),
                    ],
                    const SizedBox(height: 18),
                    AnimatedSlide(
                      duration: const Duration(milliseconds: 280),
                      offset: showExtraInfo
                          ? Offset.zero
                          : const Offset(0, 0.1),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 280),
                        opacity: showExtraInfo ? 1 : 0,
                        child: ExtraWeatherInfoPanel(weather: state.weather),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  String _rainText(List<HourlyForecast> hourly) {
    if (hourly.isNotEmpty && hourly.first.rainChance != null) {
      return '${(hourly.first.rainChance! * 100).round()}%';
    }
    return '--%';
  }

  Future<void> _onPullToRefresh(WeatherLoaded state) async {
    final bloc = context.read<WeatherBloc>();
    final completer = Completer<void>();
    late final StreamSubscription<WeatherState> subscription;

    subscription = bloc.stream.listen((nextState) {
      if (nextState is WeatherLoaded) {
        if (!nextState.isRefreshing && !completer.isCompleted) {
          completer.complete();
        }
      } else if (!completer.isCompleted) {
        completer.complete();
      }
    });

    bloc.add(
      RefreshWeather(lat: state.lat, lon: state.lon, city: state.cityName),
    );

    try {
      await completer.future.timeout(const Duration(seconds: 20));
    } catch (_) {
      // Timeout fallback to ensure refresh control closes.
    } finally {
      await subscription.cancel();
    }
  }

  (DateTime, DateTime, DateTime)? _resolveSunriseSunsetData(Weather weather) {
    final timeZoneOffsetSeconds = weather.timezoneOffsetSeconds ?? 0;
    final sunriseUtc = weather.sunriseUtcSeconds;
    final sunsetUtc = weather.sunsetUtcSeconds;

    if (sunriseUtc != null && sunsetUtc != null) {
      final sunrise = DateTime.fromMillisecondsSinceEpoch(
        (sunriseUtc + timeZoneOffsetSeconds) * 1000,
        isUtc: true,
      );
      final sunset = DateTime.fromMillisecondsSinceEpoch(
        (sunsetUtc + timeZoneOffsetSeconds) * 1000,
        isUtc: true,
      );
      final now = weather.dtUtcSeconds != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (weather.dtUtcSeconds! + timeZoneOffsetSeconds) * 1000,
              isUtc: true,
            )
          : DateTime.now().toUtc().add(
              Duration(seconds: timeZoneOffsetSeconds),
            );
      return (sunrise, sunset, now);
    }

    if (weather.sunrise != null && weather.sunset != null) {
      final now = DateTime.now();
      return (weather.sunrise!, weather.sunset!, now);
    }

    return null;
  }
}
