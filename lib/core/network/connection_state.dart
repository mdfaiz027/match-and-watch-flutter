import 'package:flutter/foundation.dart';

class ConnectionNotifier extends ValueNotifier<bool> {
  int _activeRetries = 0;
  ConnectionNotifier() : super(false);

  void startRetrying() {
    _activeRetries++;
    if (!value) value = true;
  }

  void stopRetrying() {
    if (_activeRetries > 0) {
      _activeRetries--;
    }
    if (_activeRetries == 0 && value) {
      value = false;
    }
  }

  /// Force reset if needed (e.g. on logout or app reset)
  void reset() {
    _activeRetries = 0;
    value = false;
  }
}

final connectionNotifier = ConnectionNotifier();
