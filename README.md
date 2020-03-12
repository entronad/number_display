[中文](https://github.com/entronad/number_display/blob/master/README_CN.md) 

# number_display

*Display number smartly within a certain length.*

```
final display = createDisplay(length: 8);

display(-254623933.876)    // result: -254.62M
```

The conversion follow this rules:

- result char length will never overflow length
- replace null, nan or infinity to placeholder
- use locale string with commas ( 1,234,222 ) as possible ( configurable )
- trim number with units ( 1.23k ) when length is limited
- convert scientific notation ( 1.23e+4 ) to friendly form
- when omitting decimals, you can change the rounding type, default to 'round'
- no decimal tailing zeros
- no float error

It also has a [JavaScript version](https://github.com/entronad/number-display)

## Install

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  number_display: # latest version
```

Details see [pub.dev](https://pub.dev/packages/number_display#-installing-tab-)

## Usage

In version 2.\* we only export a `createDisplay` function for users to custom their `display` function. So the real display function has only one input: `value` . This separates the configuration and usage, which is more simple and clear.

```
import 'package:number_display/number_display.dart';

final display = createDisplay(
  length: 8,
  decimal: 0,
);

print(display(data));
```

The complete configuration params are listed in the next [section](#Configurations) .

If the length overflow, the trimming rules in order are:

- omit the locale commas
- slice the decimal by the room left
- trim the integer with number units ( k, M, G, T, P )
- if the `length` is >= 5, any number can be trimmed within it. If it's less than 5 and input number is too long, display will throw an exception.

Conversion examples:

```
createDisplay();

null => ''
double.nan => ''

-123456789.123456789 => '-123.457M'
'123456' => '123,456'
-1.2345e+5 => '-123,450'
```

With some configs:

```
createDisplay(
  separator: false,
  placeholder: '--'
);

null => '--'
123456 => '123456'
```

## Configurations

**length**

( default: 9 )

The max length the result would be. length should no less then 5 so that any number can display ( say -123000 ) after trim.

**decimal**

( default: equals to 'length' )

The max decimal length. Note that this is only a constraint. The final precision will be calculated by length, and less than this param. This param is the same as 'length' by default, witch means no additional limit. There will be no decimal trailing zeros.

**placeholder**

( default: '' )

The result when the input is neither string nor number, or the input is NaN, Infinity or -Infinity. It will be sliced if longer than length param.

**separator**

( default: ',' )

Set the locale string separators ( 1,234,222 ), if there are rooms. Set it to null if you don't need any. Only the first char is kept.

**roundingType**

( default: RoundingType.round )

The rounding type when omitting decimals, enum in RoundingType.round, RoundingType.floor or RoundingType.ceil.

**units**

( default: ['k', 'M', 'G', 'T', 'P'] )

The digit units to use. Only the first char is kept for each unit. If the property is set to null or too short, it will fallback to the default.

## Blogs

[En](https://medium.com/front-end-weekly/displaying-numbers-in-frontend-2336323493c2) 

[中文](https://zhuanlan.zhihu.com/p/85536865) 