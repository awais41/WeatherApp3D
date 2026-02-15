import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../city_search/domain/entities/city_search_result_entity.dart';
import '../../../city_search/presentation/bloc/city_search_bloc.dart';
import '../../../city_search/presentation/bloc/city_search_event.dart';
import '../../../city_search/presentation/bloc/city_search_state.dart';
import '../../../city_search/presentation/widgets/city_search_results_list.dart';
import '../bloc/weather_bloc.dart';
import '../widgets/gradient_background.dart';
import '../widgets/location_grid_item.dart';
import '../widgets/location_preview_data.dart';
import '../widgets/location_search_bar.dart';
import 'location_page.dart';

class LocationPageState extends State<LocationPage> {
  int selectedIndex = 0;
  final TextEditingController controller = TextEditingController();
  bool hasText = false;

  final List<LocationPreviewData> locations = const [
    LocationPreviewData(
      city: 'California',
      condition: 'Cloudy',
      tempText: '32°',
      weatherId: 802,
      lat: 36.7783,
      lon: -119.4179,
    ),
    LocationPreviewData(
      city: 'Paris',
      condition: 'Lightning',
      tempText: '28°',
      weatherId: 211,
      lat: 48.8566,
      lon: 2.3522,
    ),
    LocationPreviewData(
      city: 'London',
      condition: 'Storm',
      tempText: '24°',
      weatherId: 502,
      lat: 51.5072,
      lon: -0.1276,
    ),
    LocationPreviewData(
      city: 'Milan',
      condition: 'Bright',
      tempText: '33°',
      weatherId: 800,
      lat: 45.4642,
      lon: 9.19,
    ),
  ];

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      final next = controller.text.trim().isNotEmpty;
      if (next != hasText && mounted) {
        setState(() => hasText = next);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).size.width * 0.06;
    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              const SizedBox(height: 12),
              const Text(
                'Pick location',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Find the area or city that you want to know\n the detailed weather info at this time',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              LocationSearchBar(
                controller: controller,
                hasText: hasText,
                isSearching: context.select(
                  (CitySearchBloc bloc) => bloc.state is CitySearchLoading,
                ),
                onChanged: (value) {
                  context.read<CitySearchBloc>().add(CityQueryChanged(value));
                },
                onClear: () {
                  controller.clear();
                  context.read<CitySearchBloc>().add(const CitySearchCleared());
                },
              ),
              const SizedBox(height: 14),
              BlocBuilder<CitySearchBloc, CitySearchState>(
                builder: (context, state) {
                  if (state is CitySearchLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  }
                  if (state is CitySearchLoaded) {
                    return CitySearchResultsList(
                      results: state.results,
                      onSelect: _onCitySelected,
                    );
                  }
                  if (state is CitySearchEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        state.message,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                  if (state is CitySearchError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        state.message,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 18),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: locations.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final item = locations[index];
                  return LocationGridItem(
                    city: item.city,
                    condition: item.condition,
                    tempText: item.tempText,
                    weatherId: item.weatherId,
                    isSelected: index == selectedIndex,
                    onTap: () {
                      setState(() => selectedIndex = index);
                      context.read<WeatherBloc>().add(
                        ChangeLocationEvent(
                          city: item.city,
                          lat: item.lat,
                          lon: item.lon,
                        ),
                      );
                      widget.onCitySelectedNavigateHome();
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _onCitySelected(CitySearchResultEntity city) {
    FocusScope.of(context).unfocus();
    context.read<CitySearchBloc>().add(CitySelected(city));
    context.read<WeatherBloc>().add(
      ChangeLocationEvent(
        city: city.name,
        lat: city.latitude,
        lon: city.longitude,
      ),
    );
    context.read<CitySearchBloc>().add(const CitySearchCleared());
    controller.clear();
    widget.onCitySelectedNavigateHome();
  }
}
