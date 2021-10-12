import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';

class DButton extends StatefulWidget {
  final double width;
  final double height;
  final Widget child;
  final GestureTapCallback? onTap;

  const DButton({
    Key? key,
    required this.width,
    this.height = defaultButtonHeight,
    required this.child,
    this.onTap,
  }) : super(key: key);

  factory DButton.add({
    Key? key,
    required enabled,
    GestureTapCallback? onTap,
    height = defaultButtonHeight * .7,
    width = defaultButtonHeight * .7,
  }) =>
      DButton(
          key: key,
          width: width,
          height: height,
          onTap: onTap,
          child: Tooltip(
            child: Opacity(opacity: enabled ? 1 : 0.4, child: const Icon(Icons.add, size: 18)),
            message: LocaleKeys.operation_add.tr(),
          ));

  factory DButton.delete({
    Key? key,
    required enabled,
    GestureTapCallback? onTap,
    height = defaultButtonHeight * .7,
    width = defaultButtonHeight * .7,
  }) =>
      DButton(
          key: key,
          width: width,
          height: height,
          onTap: onTap,
          child: Tooltip(
            child: Opacity(opacity: enabled ? 1 : 0.4, child: const Icon(Icons.remove, size: 18)),
            message: LocaleKeys.operation_delete.tr(),
          ));

  factory DButton.apply({
    Key? key,
    required enabled,
    GestureTapCallback? onTap,
    height = defaultButtonHeight * .7,
    width = defaultButtonHeight * .7,
  }) =>
      DButton(
          key: key,
          width: width,
          height: height,
          onTap: onTap,
          child: Tooltip(
            child: Opacity(opacity: enabled ? 1 : 0.4, child: const Icon(Icons.check, size: 18)),
            message: LocaleKeys.operation_apply.tr(),
          ));

  factory DButton.duplicate({
    Key? key,
    required enabled,
    GestureTapCallback? onTap,
    height = defaultButtonHeight * .7,
    width = defaultButtonHeight * .7,
  }) =>
      DButton(
          key: key,
          width: width,
          height: height,
          onTap: onTap,
          child: Tooltip(
            child: Opacity(opacity: enabled ? 1 : 0.4, child: const Icon(Icons.copy_rounded, size: 18)),
            message: LocaleKeys.operation_duplicate.tr(),
          ));

  @override
  State<DButton> createState() => _DButtonState();
}

class _DButtonState extends State<DButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: GlassContainer(
        width: widget.width,
        height: widget.height,
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(_hovering ? 0.1 : 0.15), Colors.white.withOpacity(0.1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderColor: Color(0xff565656),
        borderWidth: 1,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        child: MouseRegion(
          onEnter: (event) => setState(() {
            _hovering = true;
          }),
          onExit: (event) => setState(() {
            _hovering = false;
          }),
          cursor: SystemMouseCursors.click,
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}
