import 'package:flutter/material.dart';

extension GetArguments on BuildContext {
  T? getArguments<T>() {
    final modalRoute = ModalRoute.of(this);

    if (modalRoute == null) return null;
    final args = modalRoute.settings.arguments;
    if (args != null && args is T) {
      return args as T;
    }

    return null;
  }
}
