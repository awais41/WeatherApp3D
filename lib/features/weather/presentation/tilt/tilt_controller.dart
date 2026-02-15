import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

class TiltController {
  final ValueNotifier<double> xOffset = ValueNotifier<double>(0);

  StreamSubscription<AccelerometerEvent>? _sub;
  double _filtered = 0.0;
  double _maxOffset = 40.0;

  void start() {
    try {
      _sub = accelerometerEventStream().listen(
        (event) {
          final raw = -event.x * 5.5;
          _filtered = (_filtered * 0.75) + (raw * 0.25);
          final next = _filtered.clamp(-_maxOffset, _maxOffset).toDouble();
          if (xOffset.value != next) {
            xOffset.value = next;
          }
        },
        onError: (_) {
          xOffset.value = 0;
        },
        cancelOnError: false,
      );
    } catch (_) {
      xOffset.value = 0;
    }
  }

  void setMaxOffset(double value) {
    _maxOffset = value;
    xOffset.value = xOffset.value.clamp(-_maxOffset, _maxOffset).toDouble();
  }

  void dispose() {
    _sub?.cancel();
    xOffset.dispose();
  }
}
