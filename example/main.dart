import 'package:number_display/number_display.dart';

final display = createDisplay(length: 8);

main(List<String> args) {
  print(display(-254623933.876));    // result: -254.62M
}
