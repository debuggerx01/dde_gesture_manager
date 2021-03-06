import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';

class DButton extends StatefulWidget {
  final double width;
  final double height;
  final Widget child;
  final GestureTapCallback? onTap;
  final EdgeInsets? padding;
  final Color? activeBorderColor;

  const DButton({
    Key? key,
    required this.width,
    this.height = defaultButtonHeight,
    required this.child,
    this.onTap,
    this.padding,
    this.activeBorderColor,
  }) : super(key: key);

  factory DButton.add({
    Key? key,
    required bool enabled,
    GestureTapCallback? onTap,
    height = defaultButtonHeight * .7,
    width = defaultButtonHeight * .7,
  }) =>
      DButton(
          key: key,
          width: width,
          height: height,
          onTap: enabled ? onTap : null,
          child: Tooltip(
            child: Opacity(opacity: enabled ? 1 : 0.4, child: const Icon(Icons.add, size: 18)),
            message: LocaleKeys.operation_add.tr(),
          ));

  factory DButton.delete({
    Key? key,
    required bool enabled,
    GestureTapCallback? onTap,
    height = defaultButtonHeight * .7,
    width = defaultButtonHeight * .7,
  }) =>
      DButton(
          key: key,
          width: width,
          height: height,
          onTap: enabled ? onTap : null,
          child: Tooltip(
            child: Opacity(opacity: enabled ? 1 : 0.4, child: const Icon(Icons.remove, size: 18)),
            message: LocaleKeys.operation_delete.tr(),
          ));

  factory DButton.apply({
    Key? key,
    required bool enabled,
    GestureTapCallback? onTap,
    height = defaultButtonHeight * .7,
    width = defaultButtonHeight * .7,
  }) =>
      DButton(
          key: key,
          width: width,
          height: height,
          onTap: enabled ? onTap : null,
          child: Tooltip(
            child: Opacity(opacity: enabled ? 1 : 0.4, child: const Icon(Icons.check, size: 18)),
            message: LocaleKeys.operation_apply.tr(),
          ));

  factory DButton.duplicate({
    Key? key,
    required bool enabled,
    GestureTapCallback? onTap,
    height = defaultButtonHeight * .7,
    width = defaultButtonHeight * .7,
  }) =>
      DButton(
          key: key,
          width: width,
          height: height,
          onTap: enabled ? onTap : null,
          child: Tooltip(
            child: Opacity(opacity: enabled ? 1 : 0.4, child: const Icon(Icons.copy_rounded, size: 18)),
            message: LocaleKeys.operation_duplicate.tr(),
          ));

  factory DButton.paste({
    Key? key,
    required bool enabled,
    GestureTapCallback? onTap,
    height = defaultButtonHeight * .7,
    width = defaultButtonHeight * .7,
  }) =>
      DButton(
          key: key,
          width: width,
          height: height,
          onTap: enabled ? onTap : null,
          child: Tooltip(
            child: Opacity(opacity: enabled ? 1 : 0.4, child: const Icon(Icons.paste_rounded, size: 18)),
            message: LocaleKeys.operation_paste.tr(),
          ));

  factory DButton.logout({
    Key? key,
    required bool enabled,
    GestureTapCallback? onTap,
    height = defaultButtonHeight,
    width = defaultButtonHeight,
  }) =>
      DButton(
          key: key,
          width: width,
          height: height,
          onTap: enabled ? onTap : null,
          child: Tooltip(
            child: Opacity(opacity: enabled ? 1 : 0.4, child: const Icon(Icons.logout_rounded, size: 20)),
            message: LocaleKeys.operation_logout.tr(),
          ));

  factory DButton.upload({
    Key? key,
    required bool enabled,
    GestureTapCallback? onTap,
    height = defaultButtonHeight,
    width = defaultButtonHeight,
  }) =>
      DButton(
          key: key,
          width: width,
          height: height,
          onTap: enabled ? onTap : null,
          child: Tooltip(
            child: Opacity(opacity: enabled ? 1 : 0.4, child: const Icon(Icons.cloud_upload, size: 20)),
            message: LocaleKeys.operation_upload.tr(),
          ));

  factory DButton.download({
    Key? key,
    required bool enabled,
    GestureTapCallback? onTap,
    height = defaultButtonHeight * .7,
    width = defaultButtonHeight * .7,
  }) =>
      DButton(
          key: key,
          width: width,
          height: height,
          onTap: enabled ? onTap : null,
          child: Tooltip(
            child: Opacity(opacity: enabled ? 1 : 0.4, child: const Icon(Icons.file_download, size: 18)),
            message: LocaleKeys.operation_download.tr(),
          ));

  factory DButton.share({
    Key? key,
    required bool enabled,
    GestureTapCallback? onTap,
    height = defaultButtonHeight * .7,
    width = defaultButtonHeight * .7,
  }) =>
      DButton(
          key: key,
          width: width,
          height: height,
          onTap: enabled ? onTap : null,
          child: Tooltip(
            child: Opacity(opacity: enabled ? 1 : 0.4, child: const Icon(Icons.share, size: 18)),
            message: LocaleKeys.operation_share.tr(),
          ));

  factory DButton.like({
    Key? key,
    required bool enabled,
    GestureTapCallback? onTap,
    height = defaultButtonHeight * .7,
    width = defaultButtonHeight * .7,
  }) =>
      DButton(
          key: key,
          width: width,
          height: height,
          onTap: enabled ? onTap : null,
          child: Tooltip(
            child: Opacity(opacity: enabled ? 1 : 0.4, child: const Icon(Icons.thumb_up, size: 16)),
            message: LocaleKeys.operation_like.tr(),
          ));

  factory DButton.dropdown({
    Key? key,
    width = 60.0,
    height = kMinInteractiveDimension * .86,
    padding: const EdgeInsets.only(left: 15),
    required enabled,
    required DropdownButton child,
  }) =>
      DButton(
        key: key,
        width: width,
        height: height,
        padding: padding,
        child: child,
      );

  @override
  State<DButton> createState() => _DButtonState();
}

class _DButtonState extends State<DButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.child is DropdownButton ? (widget.child as DropdownButton).onTap : widget.onTap,
      child: GlassContainer(
        padding: widget.padding,
        width: widget.width,
        height: widget.height,
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(_hovering ? 0.1 : 0.15), Colors.white.withOpacity(0.1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderColor: _hovering && widget.onTap != null
            ? (widget.activeBorderColor ?? context.watch<SettingsProvider>().currentActiveColor)
            : Color(0xff565656),
        borderWidth: 2,
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
