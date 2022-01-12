import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:dde_gesture_manager_api/src/models/base_model.dart';
import 'package:angel3_migration/angel3_migration.dart';
import 'package:optional/optional.dart';
part 'app_version.g.dart';

@serializable
@orm
abstract class _AppVersion extends BaseModel {
  @SerializableField(isNullable: false)
  @Column(isNullable: false)
  String? get versionName;

  @SerializableField(isNullable: false)
  @Column(isNullable: false)
  int? get versionCode;
}

@serializable
@Orm(tableName: 'app_versions', generateMigrations: false)
abstract class _AppVersionResp {
  @SerializableField(isNullable: false)
  String? get versionName;

  @SerializableField(isNullable: false)
  int? get versionCode;
}