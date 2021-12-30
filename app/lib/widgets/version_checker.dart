import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/http/api.dart';
import 'package:dde_gesture_manager/utils/notificator.dart';
import 'package:dde_gesture_manager_api/apis.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionChecker extends StatelessWidget {
  const VersionChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      initialData: null,
      builder: (context, snapshot) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (snapshot.hasData && snapshot.data != null)
            Text(
              '${LocaleKeys.version_current.tr()} : ${snapshot.data?.version ?? ''}',
            ),
          if (!kIsWeb)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: TextButton(
                child: Text(LocaleKeys.version_check_update).tr(),
                onPressed: () {
                  Api.checkAppVersion().then((value) {
                    if (value != null && (value.versionCode ?? 0) > int.parse(snapshot.data?.buildNumber ?? '0')) {
                      Notificator.showConfirm(
                        title: LocaleKeys.info_new_version_title.tr(namedArgs: {'version': '${value.versionName}'}),
                        description: LocaleKeys.info_new_version_description_for_manual.tr(),
                      ).then((value) async {
                        if (value == CustomButton.positiveButton) {
                          if (await canLaunch(Apis.appNewVersionUrl)) {
                            await launch(Apis.appNewVersionUrl);
                          }
                        }
                      });
                    } else {
                      Notificator.info(context, title: LocaleKeys.info_new_version_title_already_latest.tr());
                    }
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
