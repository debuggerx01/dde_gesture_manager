import 'dart:async';
import 'package:angel3_framework/angel3_framework.dart';
import 'orm.dart' as orm;
import 'jwt.dart' as jwt;
import 'redis_cache.dart' as redis_cache;

Future configureServer(Angel app) async {
  // Include any plugins you have made here.
  await app.configure(orm.configureServer);
  await app.configure(jwt.configureServer);
  await app.configure(redis_cache.configureServer);
}
