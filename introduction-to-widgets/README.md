# Introduction to widgets

## Hello world

最小的 `Flutter` 程序通过在 `runApp()` 函数中传入一个 `widget`。

```dart
import 'package:flutter/material.dart';

void main() {
  runApp()(
    Center(
      child: Text(
        'Hello, world!',
        textDirection: TextDirection.ltr,
      ),
    ),
  );
}
```

`runApp()`函数接收给定的 `Widget`，并使该 `widget` 成为控件树的根控件。在这个例子中，控件树由两个控件组成，分别使`Centr`控件以及它的子控件，`Text` 控件。Flutter 框架会强制让根控件覆盖整个屏幕，也就是说，`Hello World` 这个文字会覆盖整个屏幕。文字的方向需要在文字控件中进行指定，否则会报错。但是如果使用`MaterialApp`控件的话，控件会帮我们设置文字的方向。

## Basaic Widgets

`Flutter`自带了一整套的强大的基础控件，其中最常用到的有：

`Text`

文本控件用来在应用程序中创建不同风格的文字

`Row,Column`

行和列两个控件的设计是基于`flexbox`模型设计的，用来创建水平和垂直方向的灵活的排版。

`Stack`

栈控件是基于绝对定位模型设计的，与创建水平或者垂直的线性排版不同，栈控件用来按照绘制顺序堆叠控件。通过在栈的子控件上使用`Positioned`控件，可以设置子控件相对于栈的位置，比如距离栈的`top`、`rigt`、`bottom`或者`left edge`的位置。

`Container`

容器控件用来创建一个可视化的矩形元素。容器控件可以使用`BoxDecoration`控件进行装饰，比如设置背景、边框或者阴影。容器控件可以有 marging、padding以及大小的约束。另外，容器控件还可以用一个matrix进行三维空间上的变换。

下面是一个简单的例子：

```dart
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  MyAppBar({this.title});

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(color: Colors.blue[500]),
      // Row is a horizontal, linear layout
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'Nivagation menu',
            onPressed: null, // null disables the button
          ),
          // Expanded expands its child to fill the available space
          Expanded(
            child: title,
          ),
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          ),
        ],
      ),
    );
  }
}

class MyScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece of paper on which the UI appears
    return Material(
      // Column is a vertical, linear layout.
      child: Column(
        children: <Widget>[
          MyAppBar(
            title: Text('Example title',
                style: Theme.of(context).primaryTextTheme.title,
          ),
          ),
          Expanded(
            child: Center(
              child: Text('Hello, world!'),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      title: 'My app',
      home: MyScaffold(),
    ),
  );
}
```

请确保`pubspec.yaml`配置文件有如下的配置，以确保应用程序可以使用预定义的[`Material icons`](https://design.google.com/icons/).

```
flutter:
  users-material-design: true
```
许多`Material Design`的控件需要继承主题数据，因此需要在`MaterialApp`中使用才能正常展示，

`MyAppBar`控件创建了一个56个像素高、左右两边padding 为8个像素的容器。在容器内部，`MyAppBar`控件使用行控件去排布它的子控件。子控件中，位于中间的`Text`控件被一个`Expanded`控件包裹，顾名思义，`Expanded`控件可以填充父控件中没有被其它子控件占据的所有空间。你可以设置多个`Expanded`控件，并通过设置`flex`参数控制它们占据可用空间的比例。

`MyScaffold`控件通过一个列控件来排布其子控件。在列的顶部是`MyAppBar`控件，这个控件接收一个`Text`控件作为标题的输入。把一个控件作为一个参数传递给另一个控件是一个强大的技术，这可以让你创建通用的控件，然后在通过各种方式被复用。最后，`MyScaffold`控件通过使用`Expanded`控件去包裹一个居中的`Text`控件来填充其内部剩余的空间。

## Using Material Components

`Flutter`提供了遵循`Material Design`原则的许多控件来帮助你创建应用程序。一个`Material app`通常开始于`MaterialApp`控件，该控件在程序的开始处创建了一些很有用的控件，包括用来管理路由的`Navigator`控件。使用`MaterialApp`控件是完全可选的，但是确实一个好的实践。

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Turial',
      home: TutorialHome(),
    ),
  );
}

class TutorialHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          tooltip: 'Navigation menu',
          onPressed: null,
        ),
        title: Text('Example title'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          )
        ],
      ),
      // body is the majority of the screen.
      body: Center(
        child: Text('Hello, world!'),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add', // used by assistive technologies
        child: Icon(Icons.add),
        onPressed: null,
      ),
    );
  }
}
```
这个例子使用`AppBar`和`Scaffold`控件替代了上个例子里的`MyAppBar`和`MyScaffold`控件，因此这个例子更像`Material Design`的风格了，比如，应用栏自带一个阴影，并且应用标题能够正确地继承主题样式。这个例子另外还加了一个浮动的响应按钮。

注意到`Scaffold`控件接收许多命名参数，控件通过命名参数传递，然后在`Scaffold`的排版中进行排布。同样地，`AppBar`控件也让你可以通过参数传递`leading`控件、`actions`控件等。这种模式重复在`flutter`框架中出现，你在设计自己的控件的时候也可以考虑使用这种模式。

## Handing gestures

大多数的应用程序都包括用户和系统的交互。创建一个交互应用程序的第一步就是检测用户的手势。下面的例子通过创建一个简单的`button`来展示如何创建手势：

```dart
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('MyButton was tapped!');
      },
      child: Container(
        height: 36.0,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.lightGreen[500],
        ),
        child: Center(
          child: Text('Engage',
          textDirection: TextDirection.ltr,),
        ),
      ),
    );
  }
}

void main(List<String> args) {
  runApp(
    MyButton()
  );
}
```

`GestureDector`这个控件在界面上看不到，但是可以检测用户的手势。当用户点击`Container`容器的时候，`GestureDector`这个控件就会调用`onTap()`这个回调。在这个例子里当用户点击屏幕时，程序会在控制台上打印信息。你可以使用`GestureDector`这个控件来检测各种输入手势，包括点击、拖拽、放缩等。

许多控件都使用一个`GestureDector`控件来为其它控件提供额外的手势回调，比如，`IconButton`、`RaisedButton`以及`FloatingActionButton`控件都包含`onPress()`这个点击回调。

## Changing widgets in response to input

到目前为止，我们只讲到了无状态的控件。有状态的控件从它的父控件中接收参数，并存储到标记为`final`的成员变量中。当一个控件被创建，即调用`build()`时，它会使用这些存储的信息去生成参数，来构造出新的控件。

为了建立更复杂的用户体验，比如，对于用户的输入有更有趣的反映，应用程序通常会携带状态。`Flutter`使用`StatefulWidgets`来实现这个想法。`StatefulWidgets`是一种知道如何生成`State`对象的特殊控件，`State`控件则被用来携带状态。考虑下面的这个例子：

```dart
class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        RaisedButton(
          onPressed: _increment,
          child: Text('Increment'),
        ),
        Text('Count: $_counter'),
      ],
    );
  }
}
```

你可能在想为什么`StatefulWidget`和`State`要分开为两个对象。在`Flutter`中，这两类对象有不同的生命周期。`Widgets`是临时对象，用来展示当前程序所处状态。而`State`则多次调用`build()`之间是保持存在的，这样才能实现存储信息的作用。

上面这个例子接受用户的输入，并直接把输入应用到了它的`build()`方法里。在更复杂的应用中，控件里面的不同部分可能负责不同的功能，比如，一个控件可能表示一个复杂的用户界面，用来手机特定的信息，比如日期或者为止。另一个控件可能使用这些信息来改变整体的表现。

在`Flutter`中，改变的通知是在控件继承树中通过回调函数的方式从下往上传递的，而当前的状态的信息则是从上往下流入用于呈现的无状态控件。这两种信息流动的公共父控件就是`State`控件。下面稍微复杂些的例子展示了这是如何工作的：

```dart
class CounterDisplay extends StatelessWidget {
  CounterDisplay({this.count});

  final int count;

  @overrie
  Widget build(BuildContext context) {
    return Text('Count: $count');
  }
}

class CounterIncrementor extends StatelessWidget {
  CounterIncrementor({this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      child: Text('Increment'),
    );
  }
}

class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  void _increment() {
    setState(() {
      ++_counter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      CounterIncrementor(onPressed: _increment),
      CounterDisplay(count: _counter),
    ]);
  }
}
```

注意到上面这个例子创建了两个无状态的控件，完全分开了展示`counter(CounterDisplay)`以及改变`counter(CounterIncrementor)`这两个逻辑。尽管最终的结果和之前的例子是一样的，但是分开这两个逻辑以后，单个控件的封装更为灵活，并且父控件可以保持简洁。


## Bring it all together

现在用一个更加复杂的例子来总结：一个假想的购物程序，可以展示各种待售的商品以及购物车。首先我们从定义用来呈现商品的类开始：`ShoppingListItem`:

```dart
class Product {
  const Product({this.name});
  final String name;
}

typedef void CartChangedCallback(Product product, bool inCart);

class ShoppingListItem extends StatelessWidget {
  ShoppingListItem({Product product, this.inCart, this.onCartChanged})
      : product = product,
        super(key: ObjectKey(product));

  final Product product;
  final bool inCart;
  final CartChangedCallback onCartChanged;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different parts of the tree
    // can have different themes.  The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return inCart ? Colors.black54 : Theme.of(context).primaryColor;
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (!inCart) return null;

    return TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onCartChanged(product, inCart);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(product.name[0]),
      ),
      title: Text(product.name, style: _getTextStyle(context)),
    );
  }
}
```
`ShoopingListItem`控件遵循无状态控件的通用模式。它将从构造函数接收到的值存储在`final`成员变量中，并在`build()`函数中进行使用。比如，`inCart`布尔值控制两种视觉展现切换：一个使用当前主题的主要颜色，另一种使用灰色。

当用户点击列表，控件不会直接更改它的`inCart`属性。相反，控件会调用它从父控件中接收到的`onCartChanged`这个函数。这种模式让我们可以在更高层次的控件中存储状态，从而使得状态可以保持存在的时间更长。在极端情况下，传给`runApp()`函数的控件持有的状态可以在整个应用程序生命周期中保持存在。

当父控件接收到`onCartChanged`回调，它会更新内部的状态，从而触发父控件根据新的`inCart`值重建一个新的`ShoopingListItem`实例。尽管重新创建，但是这个操作是很便宜的，因为框架会比较新创建的控件和旧控件之间的区别，只会应用不同的部分在底层的`RenderObject`对象上。

下面是父控件存储可改变状态的代码：

```dart
class ShoppingList extends StatefulWidget {
  ShoppingList({Key key, this.products}) : super(key: key);

  final List<Product> products;

  // The framework calls createState the first time a widget appears at a given
  // location in the tree. If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework re-uses the State object
  // instead of creating a new State object.

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  Set<Product> _shoppingCart = Set<Product>();

  void _handleCartChanged(Product product, bool inCart) {
    setState(() {
      // When a user changes what's in the cart, you need to change
      // _shoppingCart inside a setState call to trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      if (!inCart)
        _shoppingCart.add(product);
      else
        _shoppingCart.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: widget.products.map((Product product) {
          return ShoppingListItem(
            product: product,
            inCart: _shoppingCart.contains(product),
            onCartChanged: _handleCartChanged,
          );
        }).toList(),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Shopping App',
    home: ShoppingList(
      products: <Product>[
        Product(name: 'Eggs'),
        Product(name: 'Flour'),
        Product(name: 'Chocolate chips'),
      ],
    ),
  ));
}
```

`ShoppingList`类继承自`StatefulWidget`，这意味着该控件将存储可更改的状态。当`ShoppingList`控件第一次被插入到UI树中时，框架会调用`createState()`方法在UI树的这个位置去创建一个全新的`_ShoppingListState`实例（注意到状态的子类一般会以下划线开头命名，用来表明这是私有的实现细节）。当控件的父控件重建时，父控件会创建一个新的`ShoppingList`实例，但是框架可以重用已经存在于UI树中的`_ShoppingListState`实例，而不是再调用一次`createState`。

`_ShoppingListState`可以使用`widget`属性来获取当前`ShoppingList`的属性。如果父控件重建并创建了一个新的`ShoppingList`，那么`_ShoppingListState`就会用新的控件值进行重建。如果你想要`widget`属性发生变化的时候收到通知，可以重载`didUpdateWidget()`函数，这个函数会把旧的控件传入，好让你和新的当前控件进行比较。

在处理`onCartChanged`回调的时候，`_ShoppingListState`会通过在`_shoppingCart`中添加或者移除一个商品来改变内部的状态。为了让框架知道它的内部状态已经改变，控件把这些更新都封装在`setState()`这个函数中。调用`setState()`会把这个控件标记为不干净的，并会在下一次应用需要更新屏幕时，安排这个控件进行重建。如果你改变控件内部的状态时忘记调用`setState()`,那框架是不会知道你的控件已经不干净了，并且也不会调用控件的`build()`函数，这就意味着用户界面不会随着内部状态的改变而更新。通过用这种方式来管理状态，你不需要单独写代码来创建和更新子控件，相反，你只需要实现`build()`函数即可，这个函数可以帮你解决这些问题。


## Responding to widget lifecycle events

在对`StatefulWidget`对象调用完`createState()`之后，框架会把状态对象插入到UI树中，并调用状态对象的`initState()`函数。`State`的子类可以重载`initState`函数去做一些初始化工作。比如，重载`initState`去配置动画或者订阅平台的服务。在实现`initState`的时候首先要调用`super.initState`。

当一个状态对象要销毁时，框架会调用状态对象的`dispose()`函数。重载这个函数可以做一些清理工作。比如，清除计时器或者取消订阅平台的服务。在实现`dispose`函数的时候通常在最后要调用`super.dispose`。

## Keys

在控件进行重建时，框架使用`Keys`去控制控件和哪些控件是匹配的。默认情况下，框架会根据`runtimeType`和视图中展现的顺序，把当前以及之前的控件进行匹配。有了`Keys`，框架就会要求两个控件有相同的`key`值以及相同的`runtimeType`。

`Keys`在控件会创建多个相同类型的实例时非常有用。比如，`ShoppingList`控件会建立许多`ShoppingListItem`实例去填充它的可视化区域：

* 如果没有键值，那么当前创建的第一个元素永远和之前创建的第一个元素同步，即使，语义上来说，第一个列表中的元素被滑动出了屏幕，在屏幕上不可见。

* 通过给列表中的元素赋予一个语义上的键值，那么列表可以更加高效，因为框架会同步相同语义键值的元素，因此会出现类似的视觉效果。同时，这意味着状态会关联到相同的语义元素，而非关联到当前视图的相同位置。

## Global Keys

框架使用全局键值来唯一辨别子控件。全局键值必须是全局唯一的，而不像局部键值只需要在兄弟子控件之间保持唯一。因为全局键值的唯一性，可以用来获取一个控件的对应状态。

