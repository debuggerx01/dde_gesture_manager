import 'package:angel3_auth/angel3_auth.dart';
import 'package:angel3_framework/angel3_framework.dart';
import 'package:angel3_orm/angel3_orm.dart' as orm;
import 'package:dde_gesture_manager_api/models.dart';

Future<void> configureServer(Angel app) async {
  var auth = AngelAuth<User>(
    jwtKey: app.configuration['jwt_secret'],
    allowCookie: false,
    deserializer: (p) async => (UserQuery()..where!.id.equals(int.parse(p)))
        .getOne(app.container!.make<orm.QueryExecutor>())
        .then((value) => value.value),
    serializer: (p) => p.id ?? '',
  );
  await auth.configureServer(app);
}
