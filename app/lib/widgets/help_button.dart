import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager_api/apis.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(Apis.appManualUrl(kIsWeb))) {
          await launch(Apis.appManualUrl(kIsWeb));
        }
      },
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
