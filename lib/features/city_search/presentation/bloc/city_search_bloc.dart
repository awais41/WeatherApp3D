import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/search_city.dart';
import 'city_search_event.dart';
import 'city_search_state.dart';

class CitySearchBloc extends Bloc<CitySearchEvent, CitySearchState> {
  final SearchCity searchCity;
  Timer? _debounce;

  CitySearchBloc({required this.searchCity})
    : super(const CitySearchInitial()) {
    on<CityQueryChanged>(_onCityQueryChanged);
    on<CityQueryDebounced>(_onCityQueryDebounced);
    on<CitySearchCleared>(_onCitySearchCleared);
    on<CitySelected>(_onCitySelected);
  }

  @override
  void onEvent(CitySearchEvent event) {
    super.onEvent(event);
    AppLogger.log('[BLOC EVENT] CitySearch event received: $event');
  }

  Future<void> _onCityQueryChanged(
    CityQueryChanged event,
    Emitter<CitySearchState> emit,
  ) async {
    final query = event.query.trim();
    _debounce?.cancel();

    if (query.length < 2) {
      _emitLogged(emit, const CitySearchInitial());
      return;
    }

    _debounce = Timer(
      const Duration(milliseconds: 350),
      () => add(CityQueryDebounced(query)),
    );
  }

  Future<void> _onCityQueryDebounced(
    CityQueryDebounced event,
    Emitter<CitySearchState> emit,
  ) async {
    _emitLogged(emit, const CitySearchLoading());
    final result = await searchCity(event.query);
    result.fold(
      (failure) => _emitLogged(emit, CitySearchError(failure.message)),
      (results) {
        if (results.isEmpty) {
          _emitLogged(emit, const CitySearchEmpty('No results'));
          return;
        }
        _emitLogged(emit, CitySearchLoaded(results));
      },
    );
  }

  Future<void> _onCitySearchCleared(
    CitySearchCleared event,
    Emitter<CitySearchState> emit,
  ) async {
    _debounce?.cancel();
    _emitLogged(emit, const CitySearchInitial());
  }

  Future<void> _onCitySelected(
    CitySelected event,
    Emitter<CitySearchState> emit,
  ) async {
    AppLogger.log('[BLOC EVENT] City selected: ${event.city}');
  }

  void _emitLogged(Emitter<CitySearchState> emit, CitySearchState state) {
    AppLogger.log('[BLOC STATE] CitySearch emitting: $state');
    emit(state);
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
