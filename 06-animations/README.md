# Animations  <!-- omit in toc -->

## 目录  <!-- omit in toc -->

- [Animations overview](#animations-overview)
- [Animation class](#animation-class)
  - [addListener](#addlistener)
  - [addStatusListener](#addstatuslistener)
- [AnimationController](#animationcontroller)
- [Tweens](#tweens)
- [Architecture](#architecture)
  - [Scheduler](#scheduler)
  - [Tickers](#tickers)
  - [Simulations](#simulations)
  - [Animatables](#animatables)
    - [Tweens](#tweens-1)
    - [Composing animatables](#composing-animatables)
  - [Curves](#curves)
  - [Animations](#animations)
    - [Composable animations](#composable-animations)
    - [Animation Controllers](#animation-controllers)
    - [Attaching animatables to animations](#attaching-animatables-to-animations)
- [Tutorial](#tutorial)
  - [Essential animation concepts and classes](#essential-animation-concepts-and-classes)
  - [Animation<double>](#animationdouble)
  - [CurvedAnimation](#curvedanimation)
  - [AnimationController](#animationcontroller-1)
  - [Tween](#tween)
- [Implicit animations](#implicit-animations)
- [Hero animations](#hero-animations)
- [Staggered animations](#staggered-animations)

## Animations overview

`Flutter`的动画系统基于`Animation`对象。控件既可以通过监听动画值的变动，在它们的`build`函数中直接使用当前动画值，也可以使用这些动画作为传递给其它控件的更复杂动画的一部分。

## Animation class

动画系统的最主要的部分是`Animation`类。一个动画代表了可以随时间变化的一个特定类型的值。绝大多数带动画效果的控件都会接收一个`Animation`对象作为参数，从这个对象中去监听和读取变化的数值。

### addListener

当动画的值变化时，动画对象会通过`addListener`来通知所有的监听对象。典型地，一个监听动画的`State`对象会在自己的监听回调函数中调用`setState`函数来通知控件系统自己需要根据新的动画值来重建。

这个模式十分普遍，以至于有两个控件可以帮助我们在动画发生变化时重建控件：`AnimatedWidget`和`AnimatedBuilder`。前者对于无状态的动画控件最有用。为了使用`AnimatedWidget`，只要简单地继承它，并实现`build`函数即可。后者，`AnimatedBuilder`，对于更复杂控件最有用。为了使用`AnimatedBuilder`，只要构造一个控件，并把它传入`AnimatedBuilder`的`builder`函数中。

### addStatusListener

动画对象同时也提供一个`AnimationStatus`对象，用来显示动画是如何随时间变化的。当动画的状态发生变化时，动画会通知`addStatusListener`添加的所有对象。通常，动画以`dismissed`状态开始，这表示处于动画的开端。比如，一个从0.0到1.0的动画，当动画值为0.0的时候位于`dismissed`状态。一个动画可能正向进行`forward`（比如从0.0到1.0），也可能反向进行`reverse`（比如从1.0到0.0）。最终，动画会到达终点，也就是到达`completed`状态。

## AnimationController

在创建动画之前，首先要创建一个`AnimationController`，它不仅本身是一个动画，也可以允许你来控制动画。比如，你可以让控制器把动画正向播放或者停止。你也可以使用一个物理模拟来快速播放动画。

一旦你创建了一个动画控制器，你可以开始基于它来创建其它的动画，比如你可以基于初始的动画来创建一个`ReverseAnimation`，类似地，你也可以创建一个`CurvedAnimation`，它的动画值由一个`curve`对象来调节。

## Tweens

为了使动画的值可以不在0.0到1.0之间，你可以使用一个`Tween<T>`对象，它可以在`begin`和`end`值之间进行差值。许多类型都有特定的`Tween`子类，可以提供特定类型的插值。比如，`ColorTween`可以对颜色进行插值。`RectTween`可以对矩形进行插值。你可以通过创建`Tween`的子类，并重载`lerp`函数来定义自己的插值。

对于`tween`来说，它只会定义如何在两个值之间进行插值。为了得到当前动画帧的正确的数值，你需要一个动画对象来确定当前的状态。有两种方式可以结合`tween`和一个动画对象来得到正确的数值：

1. 你可以在动画的当前值`evaluate`。这种方式对于已经监听了动画的控件是十分有用的，因此当动画值变化时可以进行重建。
2. 你可以基于动画进行`animate`。相比于返回一个单独的值，动画对象会返回一个新的动画对象来对`tween`进行插值。这种方式对于你想创建一个新的动画对象给另一个控件是很有用的，

## Architecture

动画实际上是建立在一些基础之上的。

### Scheduler

The SchedulerBinding is a singleton class that exposes the Flutter scheduling primitives.

For this discussion, the key primitive is the frame callbacks. Each time a frame needs to be shown on the screen, Flutter’s engine triggers a “begin frame” callback which the scheduler multiplexes to all the listeners registered using scheduleFrameCallback(). All these callbacks are given the official time stamp of the frame, in the form of a Duration from some arbitrary epoch. Since all the callbacks have the same time, any animations triggered from these callbacks will appear to be exactly synchronised even if they take a few milliseconds to be executed.

### Tickers

The Ticker class hooks into the scheduler’s scheduleFrameCallback() mechanism to invoke a callback every tick.

A Ticker can be started and stopped. When started, it returns a Future that will resolve when it is stopped.

Each tick, the Ticker provides the callback with the duration since the first tick after it was started.

Because tickers always give their elapsed time relative to the first tick after they were started, tickers are all synchronised. If you start three ticks at different times between two frames, they will all nonetheless be synchronised with the same starting time, and will subsequently tick in lockstep.

### Simulations

The Simulation abstract class maps a relative time value (an elapsed time) to a double value, and has a notion of completion.

In principle simulations are stateless but in practice some simulations (for example, BouncingScrollSimulation and ClampingScrollSimulation) change state irreversibly when queried.

There are various concrete implementations of the Simulation class for different effects.

### Animatables

The Animatable abstract class maps a double to a value of a particular type.

Animatable classes are stateless and immutable.


#### Tweens

The Tween abstract class maps a double value nominally in the range 0.0-1.0 to a typed value (e.g. a Color, or another double). It is an Animatable.

It has a notion of an output type (T), a begin value and an end value of that type, and a way to interpolate (lerp) between the begin and end values for a given input value (the double nominally in the range 0.0-1.0).

Tween classes are stateless and immutable.

#### Composing animatables

Passing an Animatable<double> (the parent) to an Animatable’s chain() method creates a new Animatable subclass that applies the parent’s mapping then the child’s mapping.

### Curves

The Curve abstract class maps doubles nominally in the range 0.0-1.0 to doubles nominally in the range 0.0-1.0.

Curve classes are stateless and immutable.


### Animations

The Animation abstract class provides a value of a given type, a concept of animation direction and animation status, and a listener interface to register callbacks that get invoked when the value or status change.

Some subclasses of Animation have values that never change (kAlwaysCompleteAnimation, kAlwaysDismissedAnimation, AlwaysStoppedAnimation); registering callbacks on these has no effect as the callbacks are never called.

The Animation<double> variant is special because it can be used to represent a double nominally in the range 0.0-1.0, which is the input expected by Curve and Tween classes, as well as some further subclasses of Animation.

Some Animation subclasses are stateless, merely forwarding listeners to their parents. Some are very stateful.

#### Composable animations

Most Animation subclasses take an explicit “parent” Animation<double>. They are driven by that parent.

The CurvedAnimation subclass takes an Animation<double> class (the parent) and a couple of Curve classes (the forward and reverse curves) as input, and uses the value of the parent as input to the curves to determine its output. CurvedAnimation is immutable and stateless.

The ReverseAnimation subclass takes an Animation<double> class as its parent and reverses all the values of the animation. It assumes the parent is using a value nominally in the range 0.0-1.0 and returns a value in the range 1.0-0.0. The status and direction of the parent animation are also reversed. ReverseAnimation is immutable and stateless.

The ProxyAnimation subclass takes an Animation<double> class as its parent and merely forwards the current state of that parent. However, the parent is mutable.

The TrainHoppingAnimation subclass takes two parents, and switches between them when their values cross.

#### Animation Controllers

The AnimationController is a stateful Animation<double> that uses a Ticker to give itself life. It can be started and stopped. Each tick, it takes the time elapsed since it was started and passes it to a Simulation to obtain a value. That is then the value it reports. If the Simulation reports that at that time it has ended, then the controller stops itself.

The animation controller can be given a lower and upper bound to animate between, and a duration.

In the simple case (using forward(), reverse(), play(), or resume()), the animation controller simply does a linear interpolation from the lower bound to the upper bound (or vice versa, for the reverse direction) over the given duration.

When using repeat(), the animation controller uses a linear interpolation between the given bounds over the given duration, but does not stop.

When using animateTo(), the animation controller does a linear interpolation over the given duration from the current value to the given target. If no duration is given to the method, the default duration of the controller and the range described by the controller’s lower bound and upper bound is used to determine the velocity of the animation.

When using fling(), a Force is used to create a specific simulation which is then used to drive the controller.

When using animateWith(), the given simulation is used to drive the controller.

These methods all return the future that the Ticker provides and which will resolve when the controller next stops or changes simulation.

#### Attaching animatables to animations

Passing an Animation<double> (the new parent) to an Animatable’s animate() method creates a new Animation subclass that acts like the Animatable but is driven from the given parent.

## Tutorial

### Essential animation concepts and classes

> 重点：
> `Animation`，动画类的核心，用来在动画执行过程中进行插值。
> 一个`Animation`对象知道当前动画的状态（比如，动画什么时候开始、结束、正向或反向执行），但是不知道屏幕上出现了什么东西。
> `AnimationController`类管理`Animation`类。
> `CurvedAnimation`类定义非线性的动画。
> `Tween`类对数据进行插值
> 使用监听器和状态监听器来监控动画的状态变化。


### Animation<double>

在`Flutter`中，一个动画对象对UI一无所知。`Animation`是抽象的类，可以知道当前的动画值以及状态。一个普遍使用的动画类型是`Animation<double>`。

一个`Animation`对象按顺序生成一个范围内的数值的插值。输出的序列剋是线性的、非线性的、跳跃的，或者任何你可以生成的序列。根据`Animation`是如何控制的，动画可以被反向播放，甚至在播放过程中改变播放方向。

`Animation`可以插值除了`double`类型的类型，比如，`Animation<Color>`或者`Animation<Size>`。

一个动画对象有状态属性，属性值可以从`.value`成员变量中读取。

一个`Animation`对象不知道`build()`函数里的绘制逻辑。

### CurvedAnimation

一个`CurvedAnimation`把动画过程定义为一个非线性的曲线。

```dart
animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
```

> 注意：
> `Curves`类定义了许多常用的曲线，或者你可以创建自己的曲线。比如：
```dart
import `dart:math`;

class ShakeCurve extends Curve {
  @override
  double transform(double t) => sin(t * pi * 2);
}
```
> 查阅文档可以得到一个完整的曲线列表（带可视化预览）。

`CurvedAnimation`和`AnimationController`都是`Animation<double>`类型，所以你可以内部交换进行传递。`CurvedAnimation`包裹了它要改变的对象——你不需要继承`AnimationController`类来实现一个曲线。

### AnimationController

`AnimationController`是一个特殊的`Animation`对象，当硬件准备好绘制新帧的时候会生成一个新的动画值。默认下，`AnimationController`在一个给定的时间内，线性地生成0.0到1.0之间的插值。比如，下面的代码生成了一个动画对象，但是还没开始执行：

```dart
controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
```

`AnimationController`继承自`Animation<double>`，所以它可以用于任何需要`Animation`对象的地方。然而，`AnimationController`包含额外的来控制动画的方法。比如，你可以用`.forward()`方法来开始执行一个动画。生成的动画值是和屏幕刷新匹配的，所以典型地，每秒可以生成60个数字。在每个数字生成之后，每个动画对象会调用监听它的对象。为了给每一个子控件创建一个自定义的播放列表，见`RepaintBoundary`。

创建`AnimationController`的时候，你传入了一个`vsync`参数。这个参数用来防止后台动画消耗了大量的资源。你可以使用你的有状态的控件作为vsync，只要把`SingleTickerProviderStateMixin`加入到类定义中即可。你可以参考在Github的[例子](https://github.com/flutter/website/tree/master/examples/animation/animate1/lib/main.dart)。

> 在一些情况下，一个位置可能超过`AnimationController`的0.0-1.0的范围。比如，`fling()`函数允许你提供一个速度、力量来获得一个位置。这个位置可以是任何值，因此可以超出0.0到1.0的范围。

> 一个`CurvedAnimation`也可能超出0.0到1.0的范围，即使`AnimationController`不会。取决于选择的曲线，`CurvedAnimation`的输出可能比输入有更大的范围。比如，橡皮筋曲线会很容易超出或是小于默认的范围。

### Tween

默认情况下，`AnimationController`对象的范围是从0.0到1.0之间。入股你需要一个不同数据类型的不同范围，可以使用`Tween`。比如，下面的`Tween`从-200.0变化到0.0:

```dart
tween = Tween<double>(begin: -200, end: 0);
```

一个`Tween`对象是无状态的，并且只接收begin和end参数。这个对象的唯一工作就是定义从输入范围到输出范围的映射。

`Tween`继承自`Animatable<T>`，而非`Animation<T>`。一个`Animatable`对象，类似于`Animation`对象，但是不用非得输出double值。比如，`ColorTween`定义了在两个颜色之间的插值。

```dart
colorTween = ColorTween(begin: Colors.transparent, end: Colors.black54);
```

一个`Tween`对象并不保存任何状态。相反，它提供一个`evaluate(Animation<double> animation)`方法来对动画的当前值进行函数映射。动画的当前值可以在`.value`方法中获取。这个计算函数还会做一些清理工作，比如确保当动画值是0.0和1.0时，相应的begin和end值会被返回。

#### Tween.animate

使用`Tween`对象的时候，调用它的`animate()`函数，传入动画控制器对象。比如，下面的代码在500ms之内生成0到255之间的整数。

```dart
AnimationController controller = AnimationController(
  duration: const Duration(milliseconds: 500),
  vsync: this,
);
Animation<int> alpha = IntTween(begin: 0, end: 255).animate(controller);
```

> `animate()`函数返回一个`Animation`对象，而不是`Animatable`。

下面的离职展示了一个控制器，一个曲线、和一个`Tween`:

```dart
AnimationController controller = AnimationController(
  duration: const Duration(milliseconds: 500),
  vsync: this
);
final Animation curve = CurvedAnimation(parent: controller, curve: Curves.easeOut);
Animation<int> alpha = IntTween(begin: 0, end: 255).animate(curve);
```

### Animation notifications

一个`Animation`对象可以有`Listener`和`StatusListener`，在`addListener()`和`addStatusListener()`中定义。当动画值改变的时候，`Listener`就会被调用。。最常见的监听者的行为就是去调用`setState()`函数来触发控件重建。

### Animation examples

## Implicit animations

## Hero animations

## Staggered animations
