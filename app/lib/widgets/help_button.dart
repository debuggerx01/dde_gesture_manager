import 'package:dde_gesture_manager/extensions.dart';
import 'package:flutter/material.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Tooltip(
          message: LocaleKeys.help_tip.tr(),
          child: Row(
            children: [
              Icon(Icons.help_outline, size: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Text(LocaleKeys.help_label).tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
