/// Display number smartly within a certain length.
library number_display;

import 'dart:math';

/// Add commas to [integerStr].
String _commafy(String integerStr) => integerStr.replaceAllMapped(
  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
  (m) => '${m[1]},',
);

/// Retrun Object of [_unitfy].
class UnitfyInfo {
  final String integer;
  final String decimal;
  final String unit;

  UnitfyInfo(this.integer, this.decimal, this.unit);
}

/// Convert [integerStr] to shorter [UnitfyInfo]
/// 
/// [units] the units set to add.
/// [unitsInterval] interval length between units
/// [unitsMaxAccuracy] max accuracy of the result
UnitfyInfo _unitfy(
  String integerStr,
  List<String> units,
  int unitsInterval,
  int unitsMaxAccuracy,
) {
  if (integerStr.length <= unitsInterval) {
    return UnitfyInfo(integerStr, '', '');
  }
  for (var i = 0; i < units.length; i++) {
    if (integerStr.length <= (i + 2) * unitsInterval) {
      final content = (num.parse(integerStr) / pow(10, (i + 1) * unitsInterval)).toString().split('.');
      return UnitfyInfo(content[0], (content[1] != null) ? content[1].substring(0, min(unitsMaxAccuracy, content[1].length)) : '', units[i]);
    }
  }
  return null;
}

/// Display number smartly within a certain length.
/// 
/// [input] input variable
/// [length] max display char length (must >= 4)
/// [maxAccuracy] max decimal accuracy
/// [placeholder] result when non-number
/// [allowText] allow text as results
/// [comma] with commas in results
/// [units] array of number units
/// [unitsInterval] figures of each unit
/// [unitsMaxAccuracy] max decimal accuracy while display with units
String display(
  input,
  int length,
  {
    int maxAccuracy = 2,
    String placeholder = '--',
    bool allowText = true,
    bool comma = true,
    List<String> units = const ['k', 'M', 'G', 'T'],
    int unitsInterval = 3,
    int unitsMaxAccuracy = 4,
  }
) {
  // placeholder must in length
  if (length < placeholder.length) {
    throw Error();
  }

  var inputNum;
  if (input is num) {
    inputNum = input;
  } else if (input is String) {
    try {
      inputNum = num.parse(input);
    } catch (e) {
      return allowText ? input.substring(0, min(length, input.length)) : placeholder;
    }
  } else {
    return placeholder;
  }

  // handle double.nan, double.infinity, double.negativeInfinity
  if (!inputNum.isFinite) {
    return placeholder;
  }

  final inputStr = inputNum.toString();
  final signStr = inputStr.contains('-') ? '-' : '';
  final integerStr = inputStr.split('.')[0].replaceFirst('-', '');
  var decimalStr = '';
  final inputStrList = inputStr.split('.');
  if (inputStrList.length > 1 && inputStrList[1] != '0') {
    decimalStr = inputStrList[1].substring(0, min(maxAccuracy, inputStrList[1].length));
  }
  
  // length min is 4
  final commafyStr = comma ? _commafy(integerStr) : integerStr;
  final commafyMargin = length - signStr.length - commafyStr.length;
  if (commafyMargin >= 2 && decimalStr != '') {
    return '${signStr}${commafyStr}.${decimalStr.substring(0, min(commafyMargin - 1, decimalStr.length))}';
  }
  if (commafyMargin >= 0) {
    return '${signStr}${commafyStr}';
  }

  // unitfy has no decimal
  final unitfyInfo = _unitfy(integerStr, units, unitsInterval, unitsMaxAccuracy);
  if (unitfyInfo == null) {
    return placeholder;
  }
  final unitfyMargin = length - signStr.length - unitfyInfo.integer.length - unitfyInfo.unit.length;
  if (unitfyMargin >= 2 && unitfyInfo.decimal != '') {
    return '${signStr}${unitfyInfo.integer}.${unitfyInfo.decimal.substring(0, min(unitfyMargin - 1, unitfyInfo.decimal.length))}${unitfyInfo.unit}';
  }
  return '${signStr}${unitfyInfo.integer}${unitfyInfo.unit}';
}
