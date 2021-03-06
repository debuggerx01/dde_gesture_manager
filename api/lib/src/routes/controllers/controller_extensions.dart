import 'dart:io';

import 'package:angel3_framework/angel3_framework.dart';
import 'package:angel3_orm/angel3_orm.dart' as orm;
import 'package:dde_gesture_manager_api/models.dart';
import 'package:dde_gesture_manager_api/src/config/plugins/redis_cache.dart';
import 'package:neat_cache/neat_cache.dart';

extension ResponseNoContent on ResponseContext {
  noContent() {
    statusCode = HttpStatus.noContent;
    return close();
  }

  notFound() {
    statusCode = HttpStatus.notFound;
    return close();
  }

  unauthorized() {
    statusCode = HttpStatus.unauthorized;
    return close();
  }

  forbidden() {
    statusCode = HttpStatus.forbidden;
    return close();
  }

  unProcessableEntity() {
    statusCode = HttpStatus.unprocessableEntity;
    return close();
  }
}

extension QueryWhereId on orm.Query {
  set whereId(int id) {
    (where as dynamic).id.equals(id);
  }
}

extension QueryExecutor on RequestContext {
  orm.QueryExecutor get queryExecutor => container!.make<orm.QueryExecutor>();
}

extension RedisClient on RequestContext {
  Cache get cache => container!.make<RedisCache>().cache;
}

extension JWTUserInstance on RequestContext {
  User? get user {
    try {
      return container!.make<User>();
    } catch (_) {
      return null;
    }
  }
}
