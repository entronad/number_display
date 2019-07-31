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
  placeholder = placeholder.substring(0, min(length, placeholder.length));

  if (value == null || !value.isFinite) {
    return placeholder;
  }

  final valueStr = value.toString();
  final negative = RegExp(r'^-?').stringMatch(valueStr) ?? '';
  final integer = RegExp(r'\d+').stringMatch(valueStr) ?? '';
  final localeInt = integer.replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );
  final deciRaw = RegExp(r'(?<=\.)\d+$').stringMatch(valueStr) ?? '';
  final deci = deciRaw
    .substring(0, min(decimal, deciRaw.length))
    .replaceAll(RegExp(r'0+$'), '');

  int currentLen = negative.length + localeInt.length + 1 + deci.length;
  String deciShow;
  if (comma && currentLen <= length) {
    deciShow = deci.replaceAll(RegExp(r'0+$'), '');
    return '${negative}${localeInt}${deciShow == '' ? '' : '.'}${deciShow}';
  }

  int space = length - negative.length - integer.length;
  if (space >= 2) {
    deciShow = deci.substring(0, min(space - 1, deci.length)).replaceAll(RegExp(r'0+$'), '');
    return '${negative}${integer}${deciShow == '' ? '' : '.'}${deciShow}';
  }
  if (space >= 0) {
    return '${negative}${integer}';
  }

  final sections = localeInt.split(',');
  if (sections.length > 1) {
    final mainSection = sections[0];
    final tailSection = sections.sublist(1).join();
    const units = ['k', 'M', 'G', 'T', 'P'];
    final unit = units[sections.length - 2];
    space = length - negative.length - mainSection.length - 1;
    if (space >= 2) {
      final tailShow = tailSection.substring(0, min(space - 1, tailSection.length)).replaceAll(RegExp(r'0+$'), '');
      return '${negative}${mainSection}${tailShow == '' ? '' : '.'}${tailShow}${unit}';
    }
    if (space >= 0) {
      return '${negative}${mainSection}${unit}';
    }
  }

  throw Exception('length: ${length} is too small');
};
