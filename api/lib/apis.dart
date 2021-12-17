class Apis {
  static final system = SystemApis();
}

class SystemApis {
  static final String _path = '/system';
  String get appVersion => _path + '/app-version';
}