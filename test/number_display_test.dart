import 'package:test/test.dart';

import 'package:number_display/number_display.dart';

import 'dart:math';

main() {
  group('test', () {
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
      final displayRound = createDisplay(roundingType: RoundingType.round, decimal: 2);
      final displayFloor = createDisplay(roundingType: RoundingType.floor, decimal: 2);
      final displayCeil = createDisplay(roundingType: RoundingType.ceil, decimal: 2);

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

    test('length decimal', () {
      final display = createDisplay(
        length: 6,
        decimal: 10,
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
        decimal: 0,
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
    test('length too short', () {
      final display = createDisplay(
        length: 30,
        decimal: 30,
        separator: false,
      );

      expect(display(0.1 + 0.2), '0.3');
      expect(display(0.9999999999999), '1');
      expect(display(12345678.12345678), '12345678.1235');
      expect(display(44444444444444), '44444444444400');
    });
  });
}
