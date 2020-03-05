# Dart

## Language Tour

* If you never intend to change a variable, use `final` or `const`, either instead of var or in addition to a type.
* Dart 2.3 introduced the `spread operator (...)` and the `null-aware spread operator (...?)`, which provide a concise way to insert multiple elements into a collection.


```dart
var list = [1, 2, 3];
var list2 = [0, ...list];
assert(list2.length == 4);

var list;
var list2 = [0, ...?list];
assert(list2.length == 1);
```

* Dart 2.3 also introduced `collection if` and `collection for`, which you can use to build collections using conditionals (if) and repetition (for).
* 
```dart
var nav = [
  'Home',
  'Furniture',
  'Plants',
  if (promoActive) 'Outlet'
];

var listOfInts = [1, 2, 3];
var listOfStrings = [
  '#0',
  for (var i in listOfInts) '#$i'
];
assert(listOfStrings[1] == '#1');
```

* When defining a function, use {param1, param2, …} to specify `named parameters`.

```dart
/// Sets the [bold] and [hidden] flags ...
void enableFlags({bool bold, bool hidden}) {...}
```

* `Cascades (..)` allow you to make a sequence of operations on the same object. 

```dart
querySelector('#confirm') // Get an object.
  ..text = 'Confirm' // Use its members.
  ..classes.add('important')
  ..onClick.listen((e) => window.alert('Confirmed!'));
```

* Use a `named constructor` to implement multiple constructors for a class or to provide extra clarity.

```dart
class Point {
  num x, y;

  Point(this.x, this.y);

  // Named constructor
  Point.origin() {
    x = 0;
    y = 0;
  }
}
```

* `Mixins` are a way of reusing a class’s code in multiple class hierarchies.

```dart
class Musician extends Performer with Musical {
  // ···
}

class Maestro extends Person
    with Musical, Aggressive, Demented {
  Maestro(String maestroName) {
    name = maestroName;
    canConduct = true;
  }
}

mixin Musical {
  bool canPlayPiano = false;
  bool canCompose = false;
  bool canConduct = false;

  void entertainMe() {
    if (canPlayPiano) {
      print('Playing piano');
    } else if (canConduct) {
      print('Waving hands');
    } else {
      print('Humming to self');
    }
  }
}
```

## Library tour

### dart:core - numbers, collections, strings and more
`dart:core`库提供很小但是很核心的内置功能。这个库会自动加载到每一个程序中。

* Use `StringBuffer` to programmatically generate a string

* Common collection methods: `isEmpty, isNotEmpty, forEach, map, where, any, every`


## Cheetsheet

### String interpolation

使用`${expression}`来在字符串中放置一个表达式的值。如果表达式是一个变量，那么可以省去`{}`。

### Null-aware operators

`??=`操作符可以用于为可能为`null`的值进行赋值。赋值操作只会在该值为`null`时起作用。

```dart
int a; // The initial value of a is null
a ??= 3;
print(a); // <-- prints 3.

a ??= 5;
print(a); // <-- still prints 3.
```

`??`操作符是一个二元操作符号，当左边的值不为`null`时，返回该值，否则返回操作符右边的值。

```dart
print(1 ?? 3); // <-- prints 1
print(null ?? 12); // <-- prints 12
```

### Conditional property access

为了确保能够获取到一个可能为空的对象的属性，可以在`.`前面加入一个`?`标记：

```dart
myObject?.someProperty
```

上面的代码相当于：

```dart
(myObject != null) ? myObject.someProperty : null
```

`?.`操作可以链式使用：

```dart
myObject?.someProperty?.someMethod()
```
当`someProperty`或者`myObject`为`null`时，上面的代码都会返回`null`。

### Collection literals

dart有内置的对`list`，`maps`和`sets`的支持，可以使用常量来初始化：

```dart
final aListOfString = ['one', 'two', 'three'];
final aSetOfString = {'one', 'two', 'three'};
final aMapOfStringsToInts = {
  'one': 1,
  'two': 2,
  'three': 3,
}
```
上面的变量的类型会被自动推测为：`List<String>`，`Set<String>`和 `Map<String, int>`。

或者你可以自己指定类型：

```dart
final aListOfInts = <int>[];
final aSetOfInts = <int>{};
final aMapOfIntToDouble = <int, double>{};
```

当集合内的元素是子类类型，而你又希望集合是父类的类型时，手动指定类型是很有用的：

```dart
final aListOfBaseType = <BaseType>[SubType(), SubType()];
```

## Effective Dart

### Style

#### Identifiers

* DO name types using UpperCamelCase
* DO name extensions using UpperCamelCase
* DO name libraries, packages, directories, and source files using lowercase_with_underscores
* DO name import prefixes using lowercase_with_underscores
```dart
import 'dart:math' as math;
import 'package:angular_components/angular_components'
    as angular_components;
import 'package:js/js.dart' as js;
```
* DO name other identifiers using lowerCamelCase
* PREFER using lowerCamelCase for constant names
* DO capitalize acronyms and abbreviations longer than two letters like words.

```bash
HttpConnectionInfo
uiHandler
IOStream
HttpRequest
Id
DB
```

* DON'T use a leading underscore for indentifiers that aren't private
* DON'T use prefix letters

#### Ordering

* DO place "dart:" imports before other imports
* DO place "package:" imports before relative imports
* PREFER placing extenal "package:" imports before other imports
* DO specify exports in a seperate section after all imports
* DO sort sections alphabetically
  
#### Formatting

* DO format your code using dartfmt
* CONSIDER changing your code to make it more formatter-friendly
* AVOID line longer than 80 characters
* DO use curly braces for all flow control statements
  
### Documentation

#### Comments

* DO format comments like sentences
* DON'T use block comments for documentation

#### Doc comments

* DO use /// doc comments to document members and types
* PREFER writing doc comments for public APIs
* CONSIDER writing a library-level doc document
* CONSIDER writing doc comments for private APIs
* DO start doc comments with a single-sentence summary
* DO seperate the first sentence of a doc comment into its own paragraph
* AVOID redundancy with the surrounding context
* PREFER starting function or method comments with third-person verbs
* PREFER starting variable, getter, or setter comments with noun phrases
* PREFER starting library or type comments with noun phrases
* CONSIDER including code samples in doc comments
* DO use square brackets in doc comments to refer to in-scope identifiers
* DO use prose to explain parameters, return values, and exceptions
* DO put doc comments before metadata annotations

#### Markdown

* AVOID using markdown excessively
* AVOID using HTML for formatting
* PREFER backtick fences for code blocks

#### Writing

* PREFER brevity
* AVOID abbreviations and acronyms unless they are obvious
* PREFER using "this" instead of "the" to refer to member's instance
  
### Usage

#### Libraries

* DO use strings in part of directives.
* DON’T import libraries that are inside the src directory of another package.
* PREFER relative paths when importing libraries within your own package’s lib directory.
  
#### Booleans

* DO use ?? to convert null to a boolean value.

#### Strings

* DO use adjacent strings to concatenate string literals
* PREFER using interpolation to compose strings and values.
* AVOID using curly braces in interpolation when not needed.

#### Collections

* DO use collection literals when possible.
* DON’T use .length to see if a collection is empty.
* CONSIDER using higher-order methods to transform a sequence.
* AVOID using Iterable.forEach() with a function literal.
* DO use whereType() to filter a collection by type.
* DON’T use cast() when a nearby operation will do.
* AVOID using cast().

#### Functions

* DO use a function declaration to bind a function to a name.
* DON’T create a lambda when a tear-off will do.

#### Parameters

* DO use = to separate a named parameter from its default value.
* DON’T use an explicit default value of null.

#### Variables

* DON’T explicitly initialize variables to null.
* AVOID storing what you can calculate.

#### Memebers
 
* DON’T wrap a field in a getter and setter unnecessarily.
* PREFER using a final field to make a read-only property.
* CONSIDER using => for simple members.
* DON’T use this. except to redirect to a named constructor or to avoid shadowing.
* DO initialize fields at their declaration when possible.

#### Constructors

* DO use initializing formals when possible.
* DON’T type annotate initializing formals.
* DO use ; instead of {} for empty constructor bodies.
* DON’T use new.
* DON’T use const redundantly.

#### Error handling

* AVOID catches without on clauses.
* DON’T discard errors from catches without on clauses.
* DON’T discard errors from catches without on clauses.
* DON’T explicitly catch Error or types that implement it.
* DO use rethrow to rethrow a caught exception.
* DO use rethrow to rethrow a caught exception.

#### Asynchrony

* PREFER async/await over using raw futures.
* DON’T use async when it has no useful effect.
* CONSIDER using higher-order methods to transform a stream.
* AVOID using Completer directly.
* DO test for Future<T> when disambiguating a FutureOr<T> whose type argument could be Object.



