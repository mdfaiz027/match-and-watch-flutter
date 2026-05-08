import 'package:flutter/foundation.dart';

class ConnectionNotifier extends ValueNotifier<bool> {
  ConnectionNotifier() : super(false);

  void setReconnecting(bool value) {
    this.value = value;
  }
}

final connectionNotifier = ConnectionNotifier();
