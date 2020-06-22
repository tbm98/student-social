import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger();

void logs(dynamic message) {
  if (kDebugMode) {
    logger.d(message);
  }
}
