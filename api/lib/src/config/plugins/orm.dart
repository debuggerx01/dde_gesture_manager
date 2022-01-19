import 'dart:async';
import 'dart:io';
import 'package:angel3_framework/angel3_framework.dart';
import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_orm_postgres/angel3_orm_postgres.dart';
import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';

const times = ['', 'st', 'nd', 'rd'];

const retryTimeOut = Duration(seconds: 30);

Future<void> configureServer(Angel app) async {
  final _log = Logger('OrmPlugin');
  late PostgreSQLConnection connection;
  var _startTime = DateTime.now();
  var _retry = 1;
  while (_startTime.difference(DateTime.now()).abs() <= retryTimeOut) {
    try {
      connection = await connectToPostgres(app.configuration);
      await connection.open();
      break;
    } catch (e, st) {
      await connection.close();
      _log.severe(
          'Failed to connect, the $_retry${_retry <= 3 ? times[_retry] : 'th'} retry will do in a second.', e, st);
      sleep(Duration(seconds: 1));
      _retry++;
      if (_startTime.difference(DateTime.now()).abs() > retryTimeOut) rethrow;
    }
  }

  var logger = app.environment.isProduction ? null : app.logger;
  var executor = PostgreSqlExecutor(connection, logger: logger);

  app
    ..container!.registerSingleton<QueryExecutor>(executor)
    ..shutdownHooks.add((_) => connection.close());
}

Future<PostgreSQLConnection> connectToPostgres(Map configuration) async {
  var postgresConfig = configuration['postgres'] as Map? ?? {};
  var connection = PostgreSQLConnection(
      postgresConfig['host'] as String? ?? 'localhost',
      postgresConfig['port'] as int? ?? 5432,
      postgresConfig['database_name'] as String? ??
          Platform.environment['USER'] ??
          Platform.environment['USERNAME'] ??
          '',
      username: postgresConfig['username'] as String?,
      password: postgresConfig['password'] as String?,
      timeZone: postgresConfig['time_zone'] as String? ?? 'UTC',
      timeoutInSeconds: postgresConfig['timeout_in_seconds'] as int? ?? 30,
      useSSL: postgresConfig['use_ssl'] as bool? ?? false);
  return connection;
}
