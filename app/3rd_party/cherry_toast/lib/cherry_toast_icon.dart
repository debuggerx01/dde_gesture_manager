import 'package:cherry_toast/resources/constants.dart';
import 'package:flutter/material.dart';

class CherryToatIcon extends StatefulWidget {
  ///the color that will be applied on the circle behind the icon
  ///(required)
  final Color color;

  ///The toast icon widget (required)
  ///
  final IconData icon;

  ///the size of the icon (required)
  ///
  final double iconSize;

  ///the icon color (required)
  final Color iconColor;

  ///define wether the animation will be applied on the icon or not
  ///
  final bool enableAnimation;

  CherryToatIcon(
      {required this.color,
      required this.icon,
      required this.iconSize,
      required this.iconColor,
      required this.enableAnimation});

  @override
  _CherryToatIconState createState() => _CherryToatIconState();
}

class _CherryToatIconState extends State<CherryToatIcon>
    with TickerProviderStateMixin {
  late Animation _heartAnimation;
  late AnimationController _heartAnimationController;

  @override
  void initState() {
    super.initState();
    if (this.widget.enableAnimation) {
      _heartAnimationController = AnimationController(
          vsync: this, duration: Duration(milliseconds: 1200));
      _heartAnimation = Tween(
              begin: this.widget.iconSize * 0.7,
              end: this.widget.iconSize * 0.95)
          .animate(CurvedAnimation(
              curve: Curves.bounceOut, parent: _heartAnimationController));

      _heartAnimationController.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _heartAnimationController.repeat();
        }
      });
      _heartAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DEFAULT_ICON_LAYOUT_SIZE,
      height: DEFAULT_ICON_LAYOUT_SIZE,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: this.widget.color.withAlpha(20)),
      child: Center(
          child: this.widget.enableAnimation
              ? AnimatedBuilder(
                  builder: (context, child) {
                    return Icon(this.widget.icon,
                        size: this._heartAnimation.value,
                        color: this.widget.iconColor);
                  },
                  animation: this._heartAnimationController,
                )
              : Icon(this.widget.icon,
                  size: this.widget.iconSize, color: this.widget.iconColor)),
    );
  }

  @override
  void dispose() {
    if (this.widget.enableAnimation) {
      _heartAnimationController.dispose();
    }
    super.dispose();
  }
}
