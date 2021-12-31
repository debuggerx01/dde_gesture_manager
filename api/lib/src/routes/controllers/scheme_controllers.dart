import 'dart:async';

import 'package:angel3_framework/angel3_framework.dart';
import 'package:dde_gesture_manager_api/apis.dart';
import 'package:dde_gesture_manager_api/src/models/scheme.dart';
import 'package:dde_gesture_manager_api/src/routes/controllers/middlewares.dart';
import 'package:logging/logging.dart';
import 'controller_extensions.dart';

Future configureServer(Angel app) async {
  final _log = Logger('scheme_controller');

  app.post(
    Apis.scheme.upload,
    chain(
      [
        jwtMiddleware(),
        (req, res) async {
          try {
            var scheme = SchemeSerializer.fromMap(req.bodyAsMap);
            var schemeQuery = SchemeQuery();
            schemeQuery.where!.uuid.equals(scheme.uuid!);
            var one = await schemeQuery.getOne(req.queryExecutor);
            schemeQuery = SchemeQuery();
            schemeQuery.values.copyFrom(scheme);
            schemeQuery.values.uid = int.parse(req.user.id!);
            if (one.isEmpty) {
              await schemeQuery.insert(req.queryExecutor);
            } else {
              schemeQuery.whereId = int.parse(one.value.id!);
              await schemeQuery.updateOne(req.queryExecutor);
            }
          } catch (e) {
            _log.severe(e);
            return res.unProcessableEntity();
          }
          return res.noContent();
        },
      ],
    ),
  );

  app.get(
    Apis.scheme.userUploads,
    chain(
      [
        jwtMiddleware(),
        (req, res) async {
          var schemeQuery = SchemeQuery();
          schemeQuery.where!.uid.equals(int.parse(req.user.id!));
          schemeQuery.orderBy(SchemeFields.updatedAt, descending: true);
          return schemeQuery.get(req.queryExecutor).then((value) => value.map((e) => {
            'name': e.name,
            'description': e.description,
          }).toList());
        },
      ],
    ),
  );
}