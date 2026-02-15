import 'city_search_result_model.dart';

class CitySearchResponseModel {
  final List<CitySearchResultModel>? results;
  final double? generationtimeMs;

  const CitySearchResponseModel({this.results, this.generationtimeMs});

  factory CitySearchResponseModel.fromJson(Map<String, dynamic> json) {
    final rawResults = json['results'];
    final parsedResults = rawResults is List
        ? rawResults
              .whereType<Map<String, dynamic>>()
              .map(CitySearchResultModel.fromJson)
              .toList()
        : null;

    return CitySearchResponseModel(
      results: parsedResults,
      generationtimeMs: (json['generationtime_ms'] as num?)?.toDouble(),
    );
  }

  @override
  String toString() {
    return 'CitySearchResponseModel(results: ${results?.length ?? 0}, '
        'generationtimeMs: $generationtimeMs)';
  }
}
