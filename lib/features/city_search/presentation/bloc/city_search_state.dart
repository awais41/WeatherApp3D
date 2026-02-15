import 'package:equatable/equatable.dart';

export 'city_search_empty.dart';
export 'city_search_error.dart';
export 'city_search_initial.dart';
export 'city_search_loaded.dart';
export 'city_search_loading.dart';

abstract class CitySearchState extends Equatable {
  const CitySearchState();

  @override
  List<Object?> get props => [];

  @override
  String toString() => '$runtimeType(props: $props)';
}
