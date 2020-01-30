# Navigation and routing <!-- omit in toc -->

## 目录 <!-- omit in toc -->
- [Navigator class](#navigator-class)
  - [Using the Navigator](#using-the-navigator)
    - [Displaying a full-screen route](#displaying-a-full-screen-route)
    - [Using named navigator routes](#using-named-navigator-routes)
    - [Routes can return a value](#routes-can-return-a-value)
    - [Popup routes](#popup-routes)
    - [Custom routes](#custom-routes)
    - [Nesting Navigators](#nesting-navigators)
    - [Real World Example](#real-world-example)
- [Cookbook Recipes](#cookbook-recipes)
  - [Navigate to a new screen and back](#navigate-to-a-new-screen-and-back)
  - [Navigate with named routes](#navigate-with-named-routes)
  - [Send data to a new screen](#send-data-to-a-new-screen)
  - [Pass arguments to a named route](#pass-arguments-to-a-named-route)
  - [Return data from a screen](#return-data-from-a-screen)
  - [Animating a widget across screens](#animating-a-widget-across-screens)

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

## Cookbook Recipes
### Navigate to a new screen and back

绝大多数应用程序都包含多个页面来展示不同类型的信息。比如，一个应用可能有一个程序来展示商品。当用户点击商品的图片时，会弹出一个新的页面来展示商品的详细信息。

在安卓里，一个路由（`route`）相当于一个活动（`Activity`）。在iOS里，一个路由相当于一个`ViewController`。在`Flutter`里，一个路由就只是一个控件。

使用`Navigator`来导航到一个新的路由。下面的例子使用下面的步骤来在不同的路由之间切换：

1. 创建两个路由
2. 使用`Navigator.push()`导航到第二个路由
3. 使用`Navigator.pop()`返回到第一个路由

#### 1. Create two routes <!-- omit in toc -->

首先，创建两个路由。这个简单的例子里，每个路由都只包含两个按钮，点击第一个路由的按钮导航到第二个路由，点击第二个路由的按钮返回到第一个路由。

首先，创建界面结构：

```dart
class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Open route'),
          onPressed: () {
            // Navigate to second route when tapped.
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWeidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
```

#### 2. Navigate to the second route using Navigator.push() <!-- omit in toc -->

可以使用`Navigator.push()`方法来切换到一个新的路由。那么路由从哪里来呢？你可以创建自己的路由，或是使用`MaterialPageRoute`，后者会使用一个平台相关的动画来进行切换，会很方便。

在第一个路由的`build()`函数里，更新`onPressed()`函数的回调：

```dart
onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(buidler: (context) => SecondRoute()),
  );
}
```

#### 3. Return to the first route using Navigator.pop() <!-- omit in toc -->

如何关闭第二个路由以返回第一个路由呢？通过使用`Navigator.pop()`方法。这个方法从当前导航条的栈中移除当前路由。

为了实现返回原来路由的功能，在第二个路由中更新`onPressed()`回调：

```dart
onPressed: () {
  Navigator.pop(context);
}
```

### Navigate with named routes

#### 1. Create two screens <!-- omit in toc -->

```dart
class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Launch screen'),
          onPressed: () {
            // Navigate to the second screen when tapped.
          },
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first screen when tapped.
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
```

#### 2. Define the routes <!-- omit in toc -->

```dart
MaterialApp(
  // Start the app with the "/" named route. In this case, the app starts
  // on the FirstScreen widget.
  initialRoute: '/',
  routes: {
    // When navigating to the "/" route, build the FirstScreen widget.
    '/': (context) => FirstScreen(),
    // When navigating to the "/second" route, build the SecondScreen widget.
    '/second': (context) => SecondScreen(),
  },
);
```

> 警告：`home`属性不能和`initialRoute`属性一起使用。


#### 3. Navigate to the second screen <!-- omit in toc -->

```dart
// Within the `FirstScreen` widget
onPressed: () {
  // Navigate to the second screen using a named route.
  Navigator.pushNamed(context, '/second');
}
```

#### 4. Return to the first screen <!-- omit in toc -->

```dart
// Within the SecondScreen widget
onPressed: () {
  // Navigate back to the first screen by popping the current route
  // off the stack.
  Navigator.pop(context);
}
```

### Send data to a new screen

Often, you not only want to navigate to a new screen, but also pass data to the screen as well. For example, you might want to pass information about the item that’s been tapped.

Remember: Screens are just widgets. In this example, create a list of todos. When a todo is tapped, navigate to a new screen (widget) that displays information about the todo. This recipe uses the following steps:

1. Define a todo class.
2. Display a list of todos.
3. Create a detail screen that can display information about a todo.
4. Navigate and pass data to the detail screen.


#### 1. Define a todo class <!-- omit in toc -->

```dart
class Todo {
  final String title;
  final String description;

  Todo(this.title, this.description);
}
```

#### 2. Create a list of todos <!-- omit in toc -->

##### Generate the list of todos <!-- omit in toc -->

```dart
final todos = List<Todo>.generate(
  20,
  (i) => Todo(
    'Todo $i',
    'A description of what needs to be done for Todo $i',
  ),
);
```

##### Display the list of todos using a ListView <!-- omit in toc -->

```dart
ListView.builder(
  itemCount: todos.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(todos[index].title),
    );
  },
);
```

#### 3. Create a detail screen to display information about a todo <!-- omit in toc -->

```dart
class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo.
  final Todo todo;

  // In the constructor, require a Todo.
  DetailScreen({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(todo.description),
      ),
    );
  }
}
```

#### 4. Navigate and pass data to the detail screen <!-- omit in toc -->

```dart
ListView.builder(
  itemCount: todos.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(todos[index].title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(todo: todos[index]),
          ),
        ),
      },
    );
  }
)
```

### Pass arguments to a named route

#### 1. Define the arguments you need to pass <!-- omit in toc -->

```dart
// You can pass any object to the arguments parameter.
// In this example, create a class that contains a customizable
// title and message.
class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}
```
#### 2. Create a widget that extracts the arguments <!-- omit in toc -->

下一步，创建一个控件来提取和展示`title`和`message`信息。可以使用`ModalRoute.of()`方法来获取`ScreenArgument`参数，这个函数返回当前路由以及路由参数。

```dart
// A widget that extracts the necessary arguments from the ModalRoute.
class ExtractArgumentsScreen extends StatelessWidget {
  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute settings
    // and cast them as ScreenArguments.
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: Center(
        child: Text(args.message),
      ),
    );
  }
}
```

#### 3. Register the widget in the routes table <!-- omit in toc -->

下面，添加一个路由配置到`MaterialApp`里。路由定义了路由名称和路由对象的匹配。

```dart
MaterialApp(
  routes: {
    ExtractArgumentsScreen.routeName: (context) => ExtractArgumentsScreen(),
  }
)
```

#### 4. Navigate to the widget <!-- omit in toc -->

最后，当用户点击时使用`Navigator.pushNamed()`方法来导航到`ExtractArgumentsScreen`，通过`arguments`属性来传递参数给路由。

```dart
// A button that navigates to a named route.
// The named route extracts the arguments by itself.
RaisedButton(
  child: Text("Navigate to screen that extracts arguments"),
  onPressed: () {
    Navigator.pushNamed(
      context,
      ExtractArgumentsScreen.routeName,
      arguments: ScreenArguments(
        'Extract Arguments screen',
        'This message is extracted in the build method.',
      ),
    );
  },
),
```

#### Alternatively, extract the arguments using `onGenerateRoute` <!-- omit in toc -->

除了直接在控件内部直接获取参数，你还可以在`onGenerateRoute()`函数里面提取参数，再传递给控件。

```dart
MaterialApp(
  // Provide a function to handle named routes.
  // Use this function to identify the named route being pushed,
  // and create the correct screen.
  onGenerateRoute: (settings) {
    // If you push the PassArguments route
    if (settings.name == PassArgumentsScreen.routeName) {
      // Cast the arguments to the corrent type
      final ScreenArguments args = settings.arguments;

      // Then, extract the required data from the arguements
      // and pass the data to the correct screen.
      return MaterialPageRoute(
        builder: (context) {
          return PassArgumentsScreen(
            title: args.title,
            message: args.message,
          );
        },
      );
    }
  },
);
```

### Return data from a screen

#### 1. Define the home screen <!-- omit in toc -->

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Returning Data Demo'),
      ),
      // create the selection button widget in the next step.
      body: Center(child: SelectionButton()),
    );
  }
}
```

#### 2. Add a button that launches the selection screen <!-- omit in toc -->

```dart
class SelectionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        _navigateAndDisplaySelection(context);
      },
      child: Text('Pick an option, any option'),
    );
  }

  // A method that launches the SelectionScreen and awaits the 
  // result from Navigator.pop
  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after
    // calling Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectionScreen()),
    );
  }
}
```

#### 3. Show the selection screen with two buttons <!-- omit in toc -->

```dart
class SelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick an option'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
                  // Pop here with "Yep" ...
                },
                child: Text('Yep'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
                  // Pop here with "Nope" ...
                },
                child: Text('Nope.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### 4. When a button is tapped, close the selection screen <!-- omit in toc -->

##### Yep button <!-- omit in toc -->

```dart
RaisedButton(
  onPressed: () {
    Navigator.pop(context, 'Yep!');
  },
  child: Tet('Yep!'),
);
```

##### Nope button <!-- omit in toc -->

```dart
RaisedButton(
  onPressed: () {
    Navigator.pop(context, 'Nope.');
  },
  child: Tet('Nope'),
);
```

#### 5. Show a snackbar on the home screen with the selection <!-- omit in toc -->

```dart
_navigateAndDisplaySelection(BuildContext context) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SelectionScreen()),
  );

  // After the Selection Screen returns a result, hide any previous snackbars
  // and show the new result.
  Scaffold.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text("$result")));
}
```

### Animating a widget across screens

#### 1. Create two screens showing the same image <!-- omit in toc -->

```dart
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            cotext,
            MaterialPageRoute(
              builder: (_) {
                return DetailScreen();
              },
            ),
          );
        },
        child: Image.network('https://picsum.photos/250?image=9',),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Image.network('https://picsum.photos/250?image=9'),
        ),
      ),
    );
  }
}
```

#### 2. Add a `Hero` widget to the first screen <!-- omit in toc -->

为了使用一个动画来把两个页面连到一起，把两个页面的图片控件用`Hero`控件包裹起来。这个控件需要两个参数：

`tag`： 一个用来区分`Hero`对象的标签，两个页面上的标签必须一致。

`child`: 在不同页面连接动画的控件。

```dart
Hero(
  tag: 'imageHero',
  child: Image.network('https://pcisum.photos/250?image=9',),
);
```

#### 3. Add a `Hero` widget to the second screen <!-- omit in toc -->

```dart
Hero(
  tag: 'imageHero',
  child: Image.network('https://pcisum.photos/250?image=9',),
);
```