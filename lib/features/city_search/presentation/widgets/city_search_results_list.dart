import 'package:flutter/material.dart';

import '../../domain/entities/city_search_result_entity.dart';
import 'city_search_tile.dart';

class CitySearchResultsList extends StatelessWidget {
  final List<CitySearchResultEntity> results;
  final ValueChanged<CitySearchResultEntity> onSelect;

  const CitySearchResultsList({
    super.key,
    required this.results,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: results.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final city = results[index];
        return CitySearchTile(city: city, onTap: () => onSelect(city));
      },
    );
  }
}
