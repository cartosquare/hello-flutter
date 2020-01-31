import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

void main() => runApp(LogoApp());

class LogoApp extends StatefulWidget {
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      // animation = Tween<double>(begin: 0, end: 300).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      })
      ..addStatusListener((status) => print('$status'));
    controller.forward();
  }

  // using AnimationBuilder
  // @override
  // Widget build(BuildContext context) => GrowTransition(
  //       child: LogoWidget(),
  //       animation: animation,
  //     );

  // Using AnimationWidget
  @override
  Widget build(BuildContext context) => AnimatedLogo(animation: animation,);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  static final _opacityTween = Tween<double>(begin: 0.1, end: 1);
  static final _sizeTween = Tween<double>(begin: 0, end: 300);

  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
        child: Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: _sizeTween.evaluate(animation),
        width: _sizeTween.evaluate(animation),
        child: FlutterLogo(),
      ),
    ));
  }
}

class LogoWidget extends StatelessWidget {
  // leave out the height and width so it fills the animating parent
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: FlutterLogo(),
      );
}

class GrowTransition extends StatelessWidget {
  GrowTransition({this.child, this.animation});

  final Widget child;
  final Animation<double> animation;

  static final _sizeTween = Tween<double>(begin: 0, end: 300);

  Widget build(BuildContext context) => Center(
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) => Container(
            height: _sizeTween.evaluate(animation),
            width: _sizeTween.evaluate(animation),
            child: child,
          ),
          child: child,
        ),
      );
}
