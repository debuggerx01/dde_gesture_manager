import 'dart:convert';

import 'package:angel3_framework/angel3_framework.dart';
import 'package:logging/logging.dart';
import 'package:neat_cache/neat_cache.dart';

Future<void> configureServer(Angel app) async {
  final _log = Logger('RedisPlugin');

  if (app.container == null) {
    _log.severe('Angel3 container is null');
    throw StateError('Angel.container is null. All authentication will fail.');
  }
  var appContainer = app.container!;
  final cache = RedisCache(app.configuration);
  appContainer.registerSingleton(cache);
}

class RedisCache {
  late Cache cache;

  RedisCache(Map config) {
    var redisConfig = config['redis'] as Map? ?? {};

    final cacheProvider = Cache.redisCacheProvider(
      Uri(
        scheme: 'redis',
        host: redisConfig['host'],
        port: redisConfig['port'],
        userInfo: redisConfig['password'],
      ),
      commandTimeLimit: const Duration(seconds: 1),
    );
    cache = Cache(cacheProvider).withCodec(utf8);
  }
}
