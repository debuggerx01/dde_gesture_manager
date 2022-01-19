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

@serializable
@Orm(tableName: 'schemes', generateMigrations: false)
abstract class _SimpleScheme {
  @Column()
  int? id;

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

  @SerializableField(isNullable: true)
  @Column(type: ColumnType.json)
  Map<String, dynamic>? get metadata;

  @SerializableField(isNullable: true)
  @Column(expression: 'lr.liked')
  bool? get liked;
}

@serializable
abstract class _SimpleSchemeTransMetaData {
  @SerializableField(isNullable: false)
  int? id;

  @SerializableField(isNullable: false)
  String? get uuid;

  @SerializableField(isNullable: false)
  String? get name;

  @SerializableField(isNullable: false)
  String? description;

  @SerializableField(defaultValue: false, isNullable: false)
  bool? get shared;

  int? get downloads;

  int? get likes;

  bool get liked;
}

SimpleSchemeTransMetaData transSimpleSchemeMetaData(SimpleScheme scheme) => SimpleSchemeTransMetaData(
      id: scheme.id,
      description: scheme.description,
      uuid: scheme.uuid,
      name: scheme.name,
      shared: scheme.shared,
      liked: scheme.liked ?? false,
      likes: scheme.metadata?['likes'] ?? 0,
      downloads: scheme.metadata?['downloads'] ?? 0,
    );

@serializable
abstract class _SchemeForDownload {
  @SerializableField(isNullable: false)
  String? get uuid;

  @SerializableField(isNullable: false)
  String? get name;

  @SerializableField(defaultValue: false, isNullable: false)
  bool? get shared;

  @Column(type: ColumnType.text)
  String? description;

  @SerializableField()
  @DefaultsTo([])
  List? get gestures;
}

SchemeForDownload transSchemeForDownload(Scheme scheme) => SchemeForDownload(
      uuid: scheme.uuid,
      name: scheme.name,
      description: scheme.description,
      gestures: scheme.gestures,
      shared: scheme.shared,
    );

@serializable
@Orm(tableName: 'schemes', generateMigrations: false)
abstract class _MarketScheme {
  @Column()
  int? id;

  @Column(isNullable: false, indexType: IndexType.unique)
  @SerializableField(isNullable: false)
  String? get uuid;

  @Column(isNullable: false)
  @SerializableField(isNullable: false)
  String? get name;

  @Column(type: ColumnType.text)
  String? description;

  @Column(isNullable: false)
  @SerializableField(exclude: true)
  bool? get shared;

  @SerializableField(isNullable: true)
  @Column(type: ColumnType.json)
  Map<String, dynamic>? get metadata;
}

@serializable
abstract class _MarketSchemeTransMetaData {
  @SerializableField(isNullable: false)
  int? id;

  @SerializableField(isNullable: false)
  String? get uuid;

  @SerializableField(isNullable: false)
  String? get name;

  @SerializableField(isNullable: false)
  String? description;

  int? get downloads;

  int? get likes;
}

MarketSchemeTransMetaData transMarketSchemeMetaData(MarketScheme scheme) => MarketSchemeTransMetaData(
      id: scheme.id,
      description: scheme.description,
      uuid: scheme.uuid,
      name: scheme.name,
      likes: scheme.metadata?['likes'] ?? 0,
      downloads: scheme.metadata?['downloads'] ?? 0,
    );
