import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:dde_gesture_manager_api/src/models/base_model.dart';
import 'package:angel3_migration/angel3_migration.dart';
import 'package:optional/optional.dart';

part 'scheme.g.dart';

@serializable
@orm
abstract class _Scheme extends BaseModel {
  @Column(isNullable: false, indexType: IndexType.unique)
  @SerializableField(isNullable: false)
  String? get uuid;

  @Column(isNullable: false)
  @SerializableField(isNullable: false)
  String? get name;

  @Column(isNullable: false, indexType: IndexType.standardIndex)
  @SerializableField(isNullable: true, exclude: true)
  int? uid;

  @Column(type: ColumnType.text)
  String? description;

  @Column(isNullable: false, indexType: IndexType.standardIndex)
  @SerializableField(defaultValue: false, isNullable: false)
  bool? get shared;

  @Column(type: ColumnType.jsonb)
  @SerializableField()
  @DefaultsTo([])
  List? get gestures;
}
