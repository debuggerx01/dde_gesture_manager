import 'dart:io';

import 'package:angel3_framework/angel3_framework.dart';
import 'package:angel3_orm/angel3_orm.dart' as orm;

extension ResponseNoContent on ResponseContext {
  noContent() {
    statusCode = HttpStatus.noContent;
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
