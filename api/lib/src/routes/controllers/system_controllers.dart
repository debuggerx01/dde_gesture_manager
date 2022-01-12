import 'dart:async';

import 'package:angel3_framework/angel3_framework.dart';
import 'package:dde_gesture_manager_api/apis.dart';
import 'package:dde_gesture_manager_api/src/models/app_version.dart';
import 'controller_extensions.dart';

Future configureServer(Angel app) async {
  app.get(
    Apis.system.appVersion,
    (req, res) async {
      var appVersionQuery = AppVersionQuery();
      appVersionQuery.orderBy(AppVersionFields.versionCode, descending: true);
      return appVersionQuery.getOne(req.queryExecutor).then((value) => AppVersionResp(
            versionName: value.value.versionName,
            versionCode: value.value.versionCode,
          ));
    },
  );
}
