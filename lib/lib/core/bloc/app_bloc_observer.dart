import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/app_logger.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    AppLogger.log('[BLOC EVENT] ${bloc.runtimeType} -> $event');
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    AppLogger.log('[BLOC CHANGE] ${bloc.runtimeType} -> $change');
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    AppLogger.log('[BLOC TRANSITION] ${bloc.runtimeType} -> $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    AppLogger.logError('[BLOC ERROR] ${bloc.runtimeType} -> $error');
    super.onError(bloc, error, stackTrace);
  }
}
