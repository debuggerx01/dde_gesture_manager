import 'package:angel3_configuration/angel3_configuration.dart';
import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_migration_runner/angel3_migration_runner.dart';
import 'package:angel3_migration_runner/postgres.dart';
import 'package:angel3_orm_postgres/angel3_orm_postgres.dart';
import 'package:dde_gesture_manager_api/models.dart';
import 'package:dde_gesture_manager_api/src/config/plugins/orm.dart';
import 'package:dde_gesture_manager_api/src/models/download_history.dart';
import 'package:dde_gesture_manager_api/src/models/like_record.dart';
import 'package:file/local.dart';
import 'package:logging/logging.dart';

late Map configuration;

void main(List<String> args) async {
  // Enable the logging
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((rec) {
    print('${rec.time}: ${rec.level.name}: ${rec.loggerName}: ${rec.message}');

    if (rec.error != null) {
      print(rec.error);
      print(rec.stackTrace);
    }
  });

  var fs = LocalFileSystem();
  configuration = await loadStandaloneConfiguration(fs);
  var connection = await connectToPostgres(configuration);
  var migrationRunner = PostgresMigrationRunner(connection, migrations: [
    UserMigration(),
    UserSeed(),
    SchemeMigration(),
    DownloadHistoryMigration(),
    LikeRecordMigration(),
    AppVersionMigration(),
  ]);
  await runMigrations(migrationRunner, args);
}

class UserSeed extends Migration {
  @override
  void up(Schema schema) async {
    await doUserSeed();
  }

  @override
  void down(Schema schema) async {}
}

Future doUserSeed() async {
  var connection = await connectToPostgres(configuration);
  await connection.open();
  var executor = PostgreSqlExecutor(connection);
  var userQuery = UserQuery();
  userQuery.where?.email.equals('admin@admin.com');
  var one = await userQuery.getOne(executor);
  if (one.isEmpty) {
    userQuery = UserQuery();
    userQuery.values.copyFrom(User(
      email: 'admin@admin.com',
      password: '1234567890',
    ));
    return userQuery.insert(executor).then((value) => connection.close());
  }
  return connection.close();
}

class AppVersionSeed extends Migration {
  @override
  void up(Schema schema) async {
    await doAppVersionSeed();
  }

  @override
  void down(Schema schema) async {}
}

Future doAppVersionSeed() async {
  var connection = await connectToPostgres(configuration);
  await connection.open();
  var executor = PostgreSqlExecutor(connection);
  var appVersionQuery = AppVersionQuery();
  var one = await appVersionQuery.getOne(executor);
  if (one.isEmpty) {
    appVersionQuery = AppVersionQuery();
    appVersionQuery.values.copyFrom(AppVersion(
      versionCode: 1,
      versionName: '1.0.0',
    ));
    return appVersionQuery.insert(executor).then((value) => connection.close());
  }
  return connection.close();
}
