import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoadingDialog = bool Function();
typedef UpdateLoadingdialog = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingDialog close;
  final UpdateLoadingdialog update;

  const LoadingScreenController({
    required this.close,
    required this.update,
  });
}
