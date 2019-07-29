import 'package:test/test.dart';

import 'package:number_display/number_display.dart';

main() {
  test('default display', () {
    final display = createDisplay();

    expect(display(null), '');
    expect(display(double.nan), '');
    expect(display(double.infinity), '');
    expect(display(double.negativeInfinity), '');

    expect(display(-123456789.123456789), '-123.456M');
    expect(display(123456), '123,456');
    expect(display(123.456), '123.45');
    expect(display(123.4), '123.4');
    expect(display(12345678.9), '12345678');
    expect(display(123.0), '123.0');
    expect(display(123.000), '123.00');
    expect(display(-1.2345e+5), '-123,450');
    expect(display(.34), '0.34');
    expect(display(-.34), '-0.34');
  });
}
