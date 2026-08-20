import 'package:flutter/foundation.dart';

class AdPresentationState {
  AdPresentationState._();

  static final AdPresentationState instance = AdPresentationState._();

  bool _isPresenting = false;

  bool get isPresenting => _isPresenting;

  void markPresenting() {
    if (_isPresenting) {
      debugPrint(
        'AdPresentationState: markPresenting() called while already presenting — check for a missing markIdle().',
      );
    }
    _isPresenting = true;
    debugPrint('AdPresentationState: now presenting.');
  }

  void markIdle() {
    _isPresenting = false;
    debugPrint('AdPresentationState: now idle.');
  }
}
