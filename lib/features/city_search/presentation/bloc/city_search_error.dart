import 'city_search_state.dart';

class CitySearchError extends CitySearchState {
  final String message;

  const CitySearchError(this.message);

  @override
  List<Object?> get props => [message];
}
