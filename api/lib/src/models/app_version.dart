import 'package:angel3_serialize/angel3_serialize.dart';
part 'app_version.g.dart';

@serializable
abstract class _AppVersion {
  @SerializableField(isNullable: false)
  String? get versionName;

  @SerializableField(isNullable: false)
  int? get versionCode;
}