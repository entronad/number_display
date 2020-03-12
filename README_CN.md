> 前端如何友好的展示数值？本文基于实践总结了一些原则，介绍封装的工具库 Number Display ，并分析源码的实现。
>
> Number Display 有适用于 Web 的 JavaScript 版和适用于 Flutter 的 Dart 版。
>
> [JavaScript 版](https://github.com/entronad/number-display)
>
> [Dart 版](https://github.com/entronad/number_display)

在前端开发中，数值展示是一个常见的需求。不同于统计或实验报表对精确性和规范性的注重，前端展示数值时更注重用户友好，让人一眼能感知数字，并且保持页面简洁、整齐。

无论是移动端的 App ，还是管理后台型的页面，或者流行的数据大屏，以下一些需求是展示数值时常常遇到的，具有一定的共性：

- 受布局空间的限制，数值字符串不能超过某个长度
- 不能出现 null 、 NaN 、 undefined 之类的情况，异常时希望有 “--” 之类的占位符
- 数字过大时希望加上千位分隔符 (1,234,222) ，或用数值单位表示 (1.23k)
- 不要出现科学计数法 (1.23e+4)
- 小数末尾不要有一串 0
- 能消除浮点数精度问题

如果能有一个工具函数，只需简单的配置，便可将输入的数值转换成符合要求的字符串就好了，特别是当长度有限时，能自动通过变换单位，压缩小数位的方式确保字符串不溢出长度限制，比如：

```
-254623933.876  =>  -254.62M
-1.2345e+5  =>  -123,450
12.000  => 12 
NaN  =>  --
```

Number Display 就是为这样的需求而创建的：

```
rstStr = display(-254623933.876)    // result: -254.62M
```

# 使用

本着配置和使用分离的原则，Number Display 暴露名为 `createDisplay` 的高阶函数，通过传入参数给 `createDisplay` 进行配置，定制实际组件中析数值的 `display` 函数：

Web 中使用：

```
import createDisplay from 'number-display';

const display = createDisplay({
  length: 8,
  decimal: 0,
});

<div>{display(data)}</div>
```

Flutter 中使用：

```
import 'package:number_display/number_display.dart';

final display = createDisplay(
  length: 8,
  decimal: 0,
);

print(display(data));
```

这样使得实际组件中实用 `display` 的代码更为简洁，且方便批量配置。值得注意的是，在 JavaScript 中配置项是以对象的方式传入， Dart 中是以命名参数的方式传入。

Number Display 的配置项，目前包括以下 5 个：

- `length` ：数值字符串的长度限制。为确保任何数值都可以被压缩，length 最好大于等于5，这样最极端的情况（-123000）也能被压缩到 length 限制以内。
- `decimal` ：最大小数位数。当空间不够时，实际小数位数会比这个值小，另外小数末尾的 0 会去掉.
- `placeholder` ：当值为非法数字时输出的占位符。
- `allowText` ：如果输入不是数字而是一段文本，是否原样输出。Dart 版无此参数。
- `separator` ：千位分隔符。千位分隔符的意义见 [这篇博客](https://www.zhangxinxu.com/wordpress/2017/09/web-page-comma-number/) 。
- `roundingType` ：舍入规则，是四舍五入还是去位还是进位
- `units` ：数值单位

# 限长压缩原则

数值在展示时，会受到组件尺寸的约束。

理论上组件设计尺寸时须考虑到值的范围，但实际不可能沟通的这么完美，保证数值不溢出组件的任务往往还是落到开发。

数值的展示方式可以变通，但绝对不能溢出组件之外，无疑是首要原则。这也正是 Number Display 最主要的功能。当长度不够时，Number Display 按照以下优先级对数值进行压缩：

1. 去掉千位分隔符；
2. 按剩余空间减少小数位数；
3. 采用数值单位 ( k, M, G, T, P ) 压缩整数部分；
4. 按以上步骤，任何数字都可以压缩到5个字符以内，但如果设置的 `length`  小于5并且实际数值过长，将抛出异常；

# 代码实现

Number Display 处理数值的原理最主要是利用正则表达式 ，过程分为以下几步：

**1. 判断合法性**

对于 JavaScript ，由于其类型的灵 (sui) 活 (yi) 性，实际开发中传入的“数值” type 往往既有可能是 number ，也有可能是 string ：

```
if (
  (type !== 'number' && type !== 'string')
  || (type === 'number' && !Number.isFinite(value))
) {
  return placeholder;
}
```

而对于静态类型的 Dart，限定输入参数类型为 num 则是比较常规的做法：

```
if (value == null || !value.isFinite) {
  return placeholder;
}
```

**2. 截取符号、整数、小数部分**

截取一个数值的符号、整数、小数三部分，是依靠字符 "-" 和 "." 进行拆分匹配。借鉴 Ant Design 的 Statistic 组件 [源码](https://github.com/ant-design/ant-design/blob/master/components/statistic/Number.tsx) ，我们利用 JavaScript 中 String.match 函数一次匹配多个模式并返回对应数组的特性，只用一行代码便可同时获取三个部分：

```
const cells = value.match(/^(-?)(\d*)(\.(\d+))?$/);
```

当然 Dart 就没有这种技巧了，三部分要分别匹配获取：

```
final negative = RegExp(r'^-?').stringMatch(valueStr) ?? '';
final integer = RegExp(r'\d+').stringMatch(valueStr) ?? '';
final deciRaw = RegExp(r'(?<=\.)\d+$').stringMatch(valueStr) ?? '';
```

值得一提的是，Dart 语言的正则部分正在逐步完善中，我注意到最近的几个版本更新（2.1-2.4）每次都有正则语法的改动。

**3. 压缩小数部分**

压缩首先会去掉千位分隔符，当空间还不够时，就会按剩余空间缩减小数部分，注意由于小数点必须与小数部分共存亡，剩余空间需要以 0 和 2 两个边界分段，同时在此过程中顺便用正则去除小数末尾的 0：

（以下代码 JavaScript 和 Dart 基本类似，仅以 JavaScript 为例）

```
let space = length - negative.length - int.length;
if (space >= 2) {
  deciShow = deci.slice(0, space - 1).replace(/0+$/, '');
  return `${negative}${int}${deciShow && '.'}${deciShow}`;
}
if (space >= 0) {
  return `${negative}${int}`;
}
```

**4. 压缩整数部分**

如果完全去掉了小数空间仍然不够，就要将整数部分用 k 、 M 等数值单位进行压缩了。之前我们曾给整数部分加上过千位分隔符：

```
const localeInt = int.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
```

这里刚好可以通过分隔段数求得数值单位：

```
const sections = localeInt.split(',');
const units = ['k', 'M', 'G', 'T', 'P'];
const unit = units[sections.length - 2];
```

最后和压缩小数类似，我们要再根据剩余的空间确定转换数值单位后的小数位数：

```
space = length - negative.length - mainSection.length - 1;
if (space >= 2) {
  const tailShow = tailSection.slice(0, space - 1).replace(/0+$/, '');
  return `${negative}${mainSection}${tailShow && '.'}${tailShow}${unit}`;
}
  if (space >= 0) {
  return `${negative}${mainSection}${unit}`;
}
```

# 讨论

数值展示是常常被人忽视的一个点，本身也确实没有什么高深的技术，但如果不思考周全，会带来很多麻烦。

以上总结的需求原则尽量做到共性，实际项目还是会有特殊的需求，因此要尽量做到可配置。Number Display 经历过一次大版本的迭代，对可配置的参数进行了精简，同时出于性能考虑用正则匹配替代了一些循环和判断，希望有需求的读者对功能上提出建议：

[Issues (JavaScript)](https://github.com/entronad/number-display/issues) 

[Issues (Dart)](https://github.com/entronad/number_display) 