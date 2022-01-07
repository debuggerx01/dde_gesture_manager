import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:dde_gesture_manager_api/src/models/base_model.dart';
import 'package:angel3_migration/angel3_migration.dart';
import 'package:optional/optional.dart';

part 'download_history.g.dart';

@serializable
@orm
abstract class _DownloadHistory extends BaseModel {
  @Column(isNullable: false, indexType: IndexType.standardIndex)
  @SerializableField(isNullable: false)
  int? get uid;

  @Column(isNullable: false, indexType: IndexType.standardIndex)
  @SerializableField(isNullable: false)
  int? get schemeId;
}