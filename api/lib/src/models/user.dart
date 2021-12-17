import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:angel3_orm/angel3_orm.dart';
import 'package:dde_gesture_manager_api/src/models/base_model.dart';
import 'package:optional/optional.dart';
part 'user.g.dart';

@serializable
@orm
abstract class _User extends BaseModel {
  @SerializableField(isNullable: false)
  String? get email;

  @SerializableField(isNullable: false)
  String? get password;

  @SerializableField(isNullable: false)
  String? get token;
}