import 'dart:convert';

import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:angel3_orm/angel3_orm.dart';
import 'package:dde_gesture_manager_api/src/models/base_model.dart';
import 'package:optional/optional.dart';
import 'package:crypto/crypto.dart';

part 'user.g.dart';

@serializable
@orm
abstract class _User extends BaseModel {
  @Column(isNullable: false, indexType: IndexType.unique)
  @SerializableField(isNullable: false)
  String? get email;

  @Column(isNullable: false, length: 64)
  @SerializableField(isNullable: true, exclude: true)
  String? get password;

  @Column(isNullable: false)
  @SerializableField(defaultValue: false)
  bool? get blocked;

  String secret(String salt) => base64.encode(Hmac(sha256, salt.codeUnits).convert((password ?? '').codeUnits).bytes);
}
