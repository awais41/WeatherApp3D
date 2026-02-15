import 'package:equatable/equatable.dart';

export 'city_query_changed.dart';
export 'city_query_debounced.dart';
export 'city_search_cleared.dart';
export 'city_selected.dart';

abstract class CitySearchEvent extends Equatable {
  const CitySearchEvent();

  @override
  List<Object?> get props => [];

  @override
  String toString() => '$runtimeType(props: $props)';
}
