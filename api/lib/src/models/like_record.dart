import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:dde_gesture_manager_api/src/models/base_model.dart';
import 'package:angel3_migration/angel3_migration.dart';
import 'package:optional/optional.dart';

part 'like_record.g.dart';

@serializable
@orm
abstract class _LikeRecord extends BaseModel {
  @Column(isNullable: false, indexType: IndexType.standardIndex)
  @SerializableField(isNullable: false)
  int? get uid;

  @Column(isNullable: false, indexType: IndexType.standardIndex)
  @SerializableField(isNullable: false)
  int? get schemeId;

  @Column(isNullable: false, indexType: IndexType.standardIndex)
  @SerializableField(isNullable: false)
  bool? get liked;
}


@serializable
@Orm(tableName: 'like_records', generateMigrations: false)
abstract class _UserLikes {
  @Column(isNullable: false)
  @SerializableField(isNullable: false)
  int? id;

  @Column(isNullable: false)
  @SerializableField(exclude: true)
  int? get uid;

  @Column(isNullable: false)
  @SerializableField(exclude: true)
  bool? get liked;
}