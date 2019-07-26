/// Display number smartly within a certain length.
library number_display;

import 'dart:math';

typedef Display = String Function(num value);

Display createDisplay({
  int length = 9,
  int decimal = 2,
  String placeholder = '',
  bool comma = true,
}) => (num value) {
  placeholder = placeholder.substring(0, length);

  if (!value.isFinite) {
    return placeholder;
  }

  final valueStr = value.toString();
};
