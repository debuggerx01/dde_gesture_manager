import 'package:angel3_serialize/angel3_serialize.dart';

part 'login_success.g.dart';

@serializable
class _LoginSuccess {
  @SerializableField(isNullable: false)
  String? token;
}