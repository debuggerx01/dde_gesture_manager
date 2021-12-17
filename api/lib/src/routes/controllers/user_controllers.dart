import 'dart:async';
import 'package:angel3_framework/angel3_framework.dart';
import 'package:dde_gesture_manager_api/models.dart';
import 'controller_extensions.dart';

Future configureServer(Angel app) async {
  app.get(
    '/user/int:id',
    (req, res) async {
      var user = await (UserQuery()..where?.metadata.contains({"uid": req.params[UserFields.id]}))
          .getOne(req.queryExecutor);

      return res.json(user.value);
    },
  );
}
