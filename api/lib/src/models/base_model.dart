import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';

abstract class BaseModel extends Model {
  @SerializableField(isNullable: true)
  @Column(type: ColumnType.json)
  Map<String, dynamic>? get metadata;
}
