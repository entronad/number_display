# number_display
*Display number smartly within a certain length.*

```
result = display(input, length, ...optionalConfigs)
```

To display data in a width-limited component, this function will smartly help you to convert number to a certain chart length. To be **simple**, **plain**, **flexible** and **accurate**, the conversion follow this rules:

- result chart length will never overflow length
- filter strange inputs ( null/NaN/object ) to placeholder ( -- )
- use locale string with commas ( 1,234,222 ) as possible ( configurable )
- use number with units ( 1.23k ) when length is limited
- NO scientific notation ( 1.23e+4 )
- return input text if allowed

## Usage

```
import 'package:number_display/number_display.dart';

// result = display(input, length, ...optionalConfigs)
// optionalConfigs: {maxAccuracy, placeholder, allowText, comma, units, unitInterval, unitMaxAccuracy}

display(1234.123)                   // 1,234.12
display(1234.123, 4)                // 1.2k
display('1000000000')               // 1G
display(-1.2345e+5)                 // -123,450
display(NaN)                        // --
display('')                         // --
display(new Date())                 // --
display((new Date()).toISOString()) // 2018-09-

display(NaN, 2, {placeholder: '**'})     // **
display(1.22, 8, {maxAccuracy: 0})       // 1.2
display('text', 8, {allowText: false})   // --
display(12345678, 19, {comma: false})    // 12345678

display(1234567867, 8, {unitsMaxAccuracy: 2})                           // 1.23G
display(12345, 4, {units: ['t', 'h', 'k', 'tk'], unitsInterval: 1})     // 1tk
display(123457777, 4, {units: ['t', 'h', 'k', 'tk'], unitsInterval: 1}) // --

```

## Params

**input**

The *thing* you want to display as a number. When it can't be converted to a number, the result would be a *placeholder*.

**length**

( default: 8 )

The max length the result would be. length should no less then 4 so that any number can display ( say -123 ) after trim.

**optionalConfigs**

- **maxAccuracy**

   ( default: 4 )

  The max accuracy. The final accuracy will be calculated by length(of course less than maxAccuracy), so usually you don't need to set this param.

- **placeholder**

  ( default: '--' )

  The result when the input can't be converted to a number. it's length should no more than your length param.

- **allowText**

  ( default: true )

  Allow *Text* ( String that cant convert to number/null/undefined/NaN ) as input and result. If false , result of text will be placeholder.

- **comma**

  ( default: true )

  Whether the locale string has commas ( 1,234,222 ).

- **units**

  (defult: ['k', 'M', 'G', 'T'])

  Units for result number after compressed, start with lowest one, which is for 1*unitInterval compression. If number is greater than the highest unit can display , it will return placeholder.

- **unitInterval**

  (defult: 3)

  The interval figures between each units. If units is defult ['k', 'M', 'G', 'T'], unitInterval should be defult 3.

- **unitMaxAccuracy**

  (defult: 4)

  The max accuracy when displayed with units.

# Change Log

[CHANGELOG.md](CHANGELOG.md)