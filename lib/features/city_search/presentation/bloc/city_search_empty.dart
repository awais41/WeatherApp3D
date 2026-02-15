import 'city_search_state.dart';

class CitySearchEmpty extends CitySearchState {
  final String message;

  const CitySearchEmpty(this.message);

  @override
  List<Object?> get props => [message];
}
