/// Display number smartly within a certain length.
library number_display;

import 'dart:math';

const maxDoubleLength = 16;

enum RoundingType {
  round,
  floor,
  ceil,
}

List<String> _rounding(String intStr, String decimalStr, int decimalLength, RoundingType type) {
  intStr = intStr ?? '';
  if ((decimalStr == null) || (decimalStr == '0')) {
    decimalStr = '';
  }
  if (decimalStr.length <= decimalLength) {
    return [intStr, decimalStr];
  }
  if (intStr.length + decimalLength > maxDoubleLength) {
    return [intStr, decimalStr.substring(0, min(decimalLength, decimalStr.length))];
  }
  decimalLength = max(decimalLength, 0);
  final value = double.parse('$intStr.${decimalStr}e$decimalLength');
  List<String> rstStrs;
  if (type == RoundingType.ceil) {
    rstStrs = (value.ceil() / pow(10, decimalLength)).toString().split('.');
  } else if (type == RoundingType.floor) {
    rstStrs = (value.floor() / pow(10, decimalLength)).toString().split('.');
  } else {
    rstStrs = (value.round() / pow(10, decimalLength)).toString().split('.');
  }
  if (rstStrs.length == 2) {
    if (rstStrs[1] == '0') {
      rstStrs[1] = '';
    }
    return rstStrs;
  }
  return [rstStrs[0], ''];
}

typedef Display = String Function(num value);

Display createDisplay({
  int length = 9,
  int precision,
  String placeholder = '',
  bool separator = true,
  RoundingType roundingType = RoundingType.round,
}) => (num value) {
  precision ??= length;
  placeholder = placeholder.substring(0, min(length, placeholder.length));

  if (value == null || !value.isFinite) {
    return placeholder;
  }

  final valueStr = value.toString();
  final negative = RegExp(r'^-?').stringMatch(valueStr) ?? '';

  var roundingRst = _rounding(
    RegExp(r'\d+').stringMatch(valueStr) ?? '',
    RegExp(r'(?<=\.)\d+$').stringMatch(valueStr) ?? '',
    precision,
    roundingType,
  );
  var integer = roundingRst[0];
  var deci = roundingRst[1];
  final localeInt = integer.replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );

  int currentLen = negative.length + localeInt.length + 1 + deci.length;
  if (separator && currentLen <= length) {
    deci = deci.replaceAll(RegExp(r'0+$'), '');
    return '${negative}${localeInt}${deci == '' ? '' : '.'}${deci}';
  }

  int space = length - negative.length - integer.length;
  if (space >= 0) {
    roundingRst = _rounding(integer, deci, space - 1, roundingType);
    integer = roundingRst[0];
    deci = roundingRst[1].replaceAll(RegExp(r'0+$'), '');
    return '${negative}${integer}${deci == '' ? '' : '.'}${deci}';
  }

  final sections = localeInt.split(',');
  if (sections.length > 1) {
    final mainSection = sections[0];
    final tailSection = sections.sublist(1).join();
    const units = ['k', 'M', 'G', 'T', 'P'];
    final unit = units[sections.length - 2];
    space = length - negative.length - mainSection.length - 1;
    if (space >= 0) {
      roundingRst = _rounding(mainSection, tailSection, space - 1, roundingType);
      final main = roundingRst[0];
      final tail = roundingRst[1].replaceAll(RegExp(r'0+$'), '');
      return '${negative}${mainSection}${tail == '' ? '' : '.'}${tail}${unit}';
    }
  }

  print('number_display: length: ${length} is too small for ${value}');
  return value.toString();
};
