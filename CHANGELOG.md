## 1.0.0

**2019-02-07**

* Init this package.

## 1.0.1

**2019-02-07**

* Add some documents.

## 2.0.0

**2019-07-30**

- Simplify APIs, details in README.md.
- Optimize performance.
- Add unit test.
- Remove decimal trailing zeros.

## 2.0.1

**2019-07-31**

- Enlarge SDK requirement to ">=2.1.0 <3.0.0".

## 2.1.0

**2019-12-05**

- Add feature: roundingType. Now you can set the way to round the decimal in 'round', 'floor' or 'ceil', witch default to 'round'.
- When the length is too small, number-display will return the origin value as a string, instead of throwing an error.
- Change param decimal name to 'precision', and default to equal to param length, witch means no additional limit.
- Change param comma name to 'separator'.

## 2.1.2

**2019-12-07**

- Change back param precision name to 'decimal', to avoid confusion with the common 'toPrecision' meaning.
- Add inner precision limit to avoid float error.

## 2.1.3

**2020-01-07**

- Update license to 2020.
- Omit type annotations for local variables in line 73, 79.

## 2.1.4

**2020-01-08**

- Update readme.