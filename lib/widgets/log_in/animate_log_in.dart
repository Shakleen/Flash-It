import 'package:flash_it/views/home_page.dart';
import 'package:flutter/material.dart';

class AnimateLogIn extends StatelessWidget {
  final AnimationController buttonController;
  final Animation<EdgeInsets> containerCircleAnimation;
  final Animation buttonSqueezeAnimation;
  final Animation buttonZoomOut;
  final String buttonText;

  AnimateLogIn({
    Key key,
    @required this.buttonController,
    @required this.buttonText,
  })  : buttonSqueezeAnimation = Tween<double>(begin: 320.0, end: 70.0).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: Interval(0.0, 0.150),
          ),
        ),
        buttonZoomOut = Tween<double>(begin: 70.0, end: 1000.0).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: Interval(0.550, 0.999, curve: Curves.bounceOut),
          ),
        ),
        containerCircleAnimation = EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 50.0),
          end: const EdgeInsets.only(bottom: 0.0),
        ).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: Interval(0.500, 0.800, curve: Curves.ease),
          ),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    buttonController.addListener(() {
      if (buttonController.isCompleted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return HomePage();
        }));
      }
    });
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }

  Widget _buildAnimation(BuildContext context, Widget child) => Padding(
        padding: _getPadding(),
        child: InkWell(
          onTap: () => _playAnimation(),
          child: Hero(tag: "fade", child: _getChild(context)),
        ),
      );

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
      await buttonController.reverse();
    } on TickerCanceled {}
  }

  double _getWidth() => buttonZoomOut.value == 70
      ? buttonSqueezeAnimation.value
      : buttonZoomOut.value;

  EdgeInsets _getPadding() => buttonZoomOut.value == 70
      ? EdgeInsets.only(bottom: 50.0)
      : containerCircleAnimation.value;

  double _getHeight() => buttonZoomOut.value == 70 ? 60.0 : buttonZoomOut.value;

  BorderRadius _getBorderRadius() => buttonZoomOut.value < 400
      ? BorderRadius.all(const Radius.circular(30.0))
      : BorderRadius.all(const Radius.circular(0.0));

  BoxShape _getBoxShape() =>
      buttonZoomOut.value < 500 ? BoxShape.circle : BoxShape.rectangle;

  Widget _getButtonChild() => buttonSqueezeAnimation.value > 75.0
      ? Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.3,
          ),
        )
      : buttonZoomOut.value < 300.0
          ? CircularProgressIndicator(
              value: null,
              strokeWidth: 1.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : null;

  Container _getChild(BuildContext context) => buttonZoomOut.value <= 300
      ? Container(
          width: _getWidth(),
          height: _getHeight(),
          child: _getButtonChild(),
          alignment: FractionalOffset.center,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: _getBorderRadius(),
          ),
        )
      : Container(
          width: buttonZoomOut.value,
          height: buttonZoomOut.value,
          decoration: BoxDecoration(
            shape: _getBoxShape(),
            color: Theme.of(context).primaryColor,
          ),
        );
}
