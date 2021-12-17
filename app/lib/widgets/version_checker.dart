import 'dart:convert';

import 'package:dde_gesture_manager/extensions.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:dde_gesture_manager_api/apis.dart';
import 'package:dde_gesture_manager_api/models.dart';

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: TextButton(
              child: Text(LocaleKeys.version_check_update).tr(),
              onPressed: () {
                http.get(Uri.parse('http://127.0.0.1:3000' + Apis.system.appVersion)).then((value) {
                  var appVersion = AppVersionSerializer.fromMap(json.decode(value.body));
                  appVersion.versionName.sout();
                  appVersion.versionCode.sout();
                  appVersion.sout();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
