import 'package:test/test.dart';

import 'package:number_display/number_display.dart';

import 'dart:math';

main() {
  group('test', () {
    test('rounding function', () {
      const maxDoubleLength = 16;
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

      expect(_rounding('123', '456', 2, RoundingType.round), ['123', '46']);
      expect(_rounding('123', '756', 0, RoundingType.round), ['124', '']);
      expect(_rounding('123', '456', 2, RoundingType.round), ['123', '46']);
      expect(_rounding('123', '456', 5, RoundingType.round), ['123', '456']);
      expect(_rounding('123', '9999', 3, RoundingType.round), ['124', '']);
      expect(_rounding('123', '001', 2, RoundingType.round), ['123', '']);
      expect(_rounding('123', '005', 2, RoundingType.round), ['123', '01']);

      expect(_rounding('123', '9999', 3, RoundingType.floor), ['123', '999']);
      expect(_rounding('123', '9999', 0, RoundingType.floor), ['123', '']);
      expect(_rounding('123', '005', 2, RoundingType.floor), ['123', '']);

      expect(_rounding('123', '4501', 2, RoundingType.ceil), ['123', '46']);
      expect(_rounding('123', '4511', 2, RoundingType.ceil), ['123', '46']);
      expect(_rounding('123', '45', 2, RoundingType.ceil), ['123', '45']);
      expect(_rounding('123', '01', 0, RoundingType.ceil), ['124', '']);

      expect(_rounding('123', '756', -1, RoundingType.round), ['124', '']);
      expect(_rounding('123', '9999', -10, RoundingType.floor), ['123', '']);
    });

    test('default display', () {
      final display = createDisplay();

      expect(display(null), '');
      expect(display(double.nan), '');
      expect(display(double.infinity), '');
      expect(display(double.negativeInfinity), '');

      expect(display(-123456789.123456789), '-123.457M');
      expect(display(123456), '123,456');
      expect(display(123.456), '123.456');
      expect(display(123.4), '123.4');
      expect(display(12345678.9), '12345679');

      expect(display(123.0), '123');
      expect(display(123.000), '123');
      expect(display(23.008), '23.008');
      expect(display(1234567.08), '1234567.1');
      expect(display(100000000000), '100G');

      expect(display(-1.2345e+5), '-123,450');
      expect(display(-1.23458e+5), '-123,458');

      expect(display(.34), '0.34');
      expect(display(-.34), '-0.34');
    });

    test('placeholder allowText separator', () {
      final displayRound = createDisplay(roundingType: RoundingType.round, precision: 2);
      final displayFloor = createDisplay(roundingType: RoundingType.floor, precision: 2);
      final displayCeil = createDisplay(roundingType: RoundingType.ceil, precision: 2);

      expect(displayRound(23.008), '23.01');
      expect(displayFloor(23.008), '23');
      expect(displayCeil(23.001), '23.01');
      
      expect(displayRound(-123456789.123456789), '-123.457M');
      expect(displayFloor(-123456789.123456789), '-123.456M');
      expect(displayCeil(-123456189.123456789), '-123.457M');
    });

    test('placeholder allowText separator', () {
      final display = createDisplay(
        separator: false,
        placeholder: '--',
      );

      expect(display(null), '--');
      expect(display(double.nan), '--');

      expect(display(123456), '123456');
    });

    test('placeholder separator', () {
      final display = createDisplay(
        separator: false,
        placeholder: '--',
      );

      expect(display(null), '--');
      expect(display(double.nan), '--');

      expect(display(123456), '123456');
    });

    test('length precision', () {
      final display = createDisplay(
        length: 6,
        precision: 10,
      );

      expect(display(123456), '123456');

      expect(display(1.2222), '1.2222');
      expect(display(-111.2222), '-111.2');

      expect(display(23.008), '23.008');

      final display1 = createDisplay(length: 8);
      expect(display1(-254623933.876), '-254.62M');
    });

    test('int', () {
      final display = createDisplay(
        length: 6,
        precision: 0,
      );

      expect(display(1234.8), '1,235');
      expect(display(123456.8), '123457');
    });

    test('length too short', () {
      final display = createDisplay(
        length: 3,
        placeholder: 'abcdefg',
      );

      expect(display(null), 'abc');
      expect(display(-123456), '-123456');
    });
  });
}
