# Navigation and routing

## Navigator class

许多应用程序在控件树的顶端有一个导航条，用来展示访问历史，通常最近访问的页面会在之前访问页面之上。使用这个模式可以让导航条从一个页面切换到另一个页面。另外，导航条还可以用来展示一个对话框。

### Using the Navigator

移动应用通常通过全屏的元素来展示内容，称为`screens`或者`pages`。在`Flutter`这些元素被称为`routes`，通过`Navigator`这个控件进行管理。这个控件管理着一个栈的`Route`对象，并提供方法来管理栈，比如`Navigator.push`以及`Navigator.pop`。

当你的用户界面放到这个栈中时，用户可以导航回到之前的界面。在特定的平台上，比如安卓，系统UI会提供一个返回按钮允许你导航到之前的界面中。在一些没有内置导航机制的平台上，使用`AppBar`（通常在`Scaffold.appBar`属性中使用）可以自动添加一个返回按钮。

#### Displaying a full-screen route

尽管你可以直接创建一个导航条，通常情况下你会使用`WidgetsApp`或者`MaterialApp`控件提供的导航条。你可以通过`Navigator.of`的方式来引用导航条。

`MaterialApp`是设置导航条的最简单方式。`MaterialApp`的主页就是导航条的页面栈的最底部的路由。这也是当程序启动时你看到的页面：

```dart
void main() {
  runApp(MaterialApp(home: MyAppHome()));
}
```

为了往栈中添加一个新的路由，你可以创建一个`MaterialPageRoute`的实例，这个实例有一个`builder`函数，用来创建你想在屏幕上展示的任何东西。比如：

```dart
Navigator.push(context, MaterialPageRoute<void>(
  builder: (BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Page')),
      body: Center(
        child: FlatButton(
          child: Text('POP').
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  },
));
```
这个路由使用一个`builder`函数，而不是一个子控件来定义控件，因为控件需要在不同的上下文中被创建和重建，这取决于控件是被推入还是弹出栈。

就像你看到的，新的路由可以使用`pop`函数被弹出，显示应用的主页：

```dart
Navigator.pop(context);
```

通常在使用`Scaffod`的时候不需要提供一个控件来推出路由，因为`Scaffold`会自动在`AppBar`中添加一个返回按钮。在安卓系统中，系统会添加这个按钮。

#### Using named navigator routes

移动应用通常管理这大量的路由，因此使用名字来引用路由通常更加简单，这个名字通常是一个类似路径的结构（比如，`/a/b/c`）。应用的主页的路由默认命名为`/`。

`MaterialApp`可以使用一个`Map<String, WidgetBuilder>`对象来创建。这个Map可以匹配路由名称到创建这个路由的`builder`函数。`MaterialApp`使用这个map来在`onGenerateRoute`回调中创建相应的页面。

```dart
void main() {
  runApp(MaterialApp(
    home: MyAppHome(), // becomes the route named '/'`
    routes: <String, WidgetBuilder> {
      '/a': (BuildContext context) => MyPage(title: 'page A'),
      '/b': (BuildContext context) => MyPage(title: 'page B'),
      '/c': (BuildContext context) => MyPage(title: 'page C'),
    },
  ));
}
```

通过名字来展示路由：

```dart
Navigator.pushNamed(context, '/b');
```

#### Routes can return a value

当一个路由被展示，向用户询问一个值，这个值可以通过`pop`方法的返回参数获取。

展示路由的函数会返回一个`Future`对象。当路由被弹出时，这个对象被赋值，并且`Future`对象的值是`pop`函数的`result`参数。

比如，如果我们想要让用户去点击OK来确认一个操作，我们可以`await``Navigator.push`函数的结果：

```dart
bool value = await Navigator.push(context, MaterialPageRoute<bool>(
  builder: (BuildContext context) {
    return Center(
      child: GestureDetector(
        child: Text('OK'),
        onTap: () {
          Navigator.pop(context, true);
        },
      ),
    );
  }
))
```

如果一个路由被用来返回一个值，那么这个路由的类型参数必须和`pop`返回值的类型匹配。这也就是为什么在上面的例子中使用`MaterialPageRoute<bool>`而不是使用`MaterialPageRoute<void>`。

#### Popup routes

路由不需要占据全部的屏幕。`PopupRoute`s 使用一个`ModalRoute.barrierColor`，可以使当前屏幕部分透明。弹出式路由是模态的，因为它阻止了和下面控件的交互。

下面是一些创建和显示弹出式路由的函数，比如：`showDialog`, `showMenu`以及`showModalBottomSheet`。这些函数向之前所说的，返回一个`Future`对象。调用者可以等待返回的值来采取相应的行为。

也有一些创建弹出式路由的函数，比如`PopupMenuButton`以及`DropdownButton`，这些控件创建`PopupRoute`类的子类，并且使用`Navigator`类的`push`和`pop`函数来展示和隐藏它们。

#### Custom routes

你可以基于路由控件库来创建自己的子类，比如`PopupRoute`,`ModalRoute`或者`PageRoute`，来控制路由显示动画、模态框的颜色和行为以及其它路由特性。

 `PageRouteBuilder`类使得通过回调函数自定义路由变得可能。下面是一个例子，显示了当路由显示或者消失时旋转并淡出子控件。这个控件并没有阻挡整个屏幕，因为设置了`opaque: false`，就像弹出式路由那样。

 ```dart
Navigator.push(context, PageRouteBuilder(
  opaque: false,
  pageBuilder: (BuildContext context, _, __) {
    return Center(child: Text('My PageRoute'));
  },
  transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: RotationTransition(
        turns: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
        child: child,
      ),
    );
  }
));
 ```

 上面的路由由两部分组成，页面以及转场动画。 页面成为了传给`transitionsBuilder`函数的`child`参数的子控件。通常页面只会创建一次，因为它依赖于动画参数（在这个例子里使用`_`和`__`隐藏）。转场控件在这个过程中在每一帧中被创建。

 #### Nesting Navigators

 一个应用可以使用多于一个导航条。在一个导航里面内置另一个导航可以用开创建内部的跳转，比如tab切换，用户注册等其它可以代表你整个应用程序的某一个独立子部分的逻辑。

 #### Real World Example

 这是一个标准的`iOS`应用来使用tab导航，每个tab保留着自己的导航历史。因此，每个tab都有自己的`Navigator`，创造了一种“并行导航”的效果。

除了tab的并行导航，还可以打开一个全屏的页面完全覆盖tab。比如，一个登陆流程或者一个警告对话框。因此，在tab导航之上，必须有一个“根”导航。所以，每一个tab导航实际上是内嵌于唯一的根导航之下的。

内嵌的tab导航位于`WidgetApp`以及`CupertinoTabView`，所以你不需要担心它，这也是真实导航条的使用方式。

下面的例子展示了如何使用一个内嵌的导航来提供一个独立的用户注册逻辑。

尽管这个例子使用两个导航条来展示内嵌导航的使用，一个类似的方式也可以只使用一个单独的导航条。

```dart
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Code Sample for Navigator',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      // MaterialApp contains our top-level Navigator
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        '/signup': (BuildContext context) => SignUpPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyText1,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/signup');
        },
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Text('Home Page'),
        ),
      ),
    );
  }
}

class CollectPersonalInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyText1,
      child: GestureDetector(
        onTap: () {
          // This moves from the personal info page to the credentials page,
          // replacing this page with that one.
          Navigator.of(context)
              .pushReplacementNamed('signup/choose_credentials');
        },
        child: Container(
          color: Colors.lightBlue,
          alignment: Alignment.center,
          child: Text('Collect Persional Info Page'),
        ),
      ),
    );
  }
}

class ChooseCredentialsPage extends StatelessWidget {
  const ChooseCredentialsPage({
    this.onSignupComplete,
  });

  final VoidCallback onSignupComplete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSignupComplete,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText1,
        child: Container(
          color: Colors.pinkAccent,
          alignment: Alignment.center,
          child: Text('Choose Credentials Page'),
        ),
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SignUpPage builds its own Navigator which ends up being a nested
    // Navigator in our app.
    return Navigator(
      initialRoute: 'signup/personal_info',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'signup/personal_info':
            // Assume CollectPernalInfoPage colects personal info and then
            //m navigates to 'signup/choose_credentials'.
            builder = (BuildContext _) => CollectPersonalInfoPage();
            break;
          case 'signup/choose_credentials':
            // Assume ChooseCredentialsPage collects new credentials and then
            // invokes 'onSignupComplete()'.
            builder = (BuildContext _) => ChooseCredentialsPage(
                  onSignupComplete: () {
                    // Redefencing Navigator.of(context) from here refers to the
                    // top level Navigator because SignUpPage is above the nested
                    // Navigator that is creatd. Therefore, this pop()
                    // will pop the entire "sign up" journey and return to the "/"
                    // route, AKA HomePage.
                    Navigator.of(context).pop();
                  },
                );
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
```

`Navigator.of`会得到当前`BuildContext`的祖先导航。确保在计划的`Navigator`下提供一个`BuildContext`，特别是在一个很大的`build`函数内部，这里内嵌的导航被创建。`Builder`控件可以被用来获取控件子树中特定位置的`BuildContext`。