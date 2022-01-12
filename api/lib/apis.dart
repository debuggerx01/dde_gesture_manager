class Apis {
  static const apiScheme = 'http';
  static const apiHost = 'home.debuggerx.com';
  static const apiPort = 30000;

  static const appNewVersionUrl = 'https://www.debuggerx.com';

  static final system = SystemApis();
  static final auth = AuthApis();
  static final scheme = SchemeApis();
}

class AuthApis {
  static final String path = '/auth';

  String get loginOrSignup => [path, 'login_or_signup'].joinPath();

  String confirmSignup({required StringParam accessKey}) => [path, 'confirm_sign_up', accessKey].joinPath();

  String get status => [path, 'status'].joinPath();
}

class SystemApis {
  static final String path = '/system';

  String get appVersion => [path, 'app-version'].joinPath();
}

class SchemeApis {
  static final String path = '/scheme';

  String get upload => [path, 'upload'].joinPath();

  String markAsShared({required StringParam schemeId}) => [path, 'mark_as_shared', schemeId].joinPath();

  String user({required StringParam type}) => [path, 'user', type].joinPath();

  String market({required StringParam type, required IntParam page, required IntParam pageSize}) => [path, 'market', type, page, pageSize].joinPath();

  String download({required StringParam schemeId}) => [path, 'download', schemeId].joinPath();

  String like({required StringParam schemeId, required StringParam isLike}) => [path, 'like', schemeId, isLike].joinPath();

  String get userLikes => [path, 'user-likes'].joinPath();
}

final _paramsMap = {
  'BoolParam': BoolParam.nameOnRoute,
  'IntParam': IntParam.nameOnRoute,
  'DoubleParam': DoubleParam.nameOnRoute,
  'StringParam': StringParam.nameOnRoute,
};

extension JoinPath on List {
  joinPath() => join('/');
}

extension RouteUrl on Function {
  String get route {
    var funStr = toString();
    funStr = funStr.replaceAll(RegExp(r'.+\(\{'), ' ').replaceAll(RegExp(r'\}\).+'), ' ').replaceAll(' required ', '');
    var parts = funStr.split(',');
    Map<Symbol, dynamic> params = {};
    for (var part in parts) {
      var p = part.trim().split(' ');
      params[Symbol(p.last)] = (_paramsMap[p.first] as Function).call(p.last);
    }
    return Function.apply(this, [], params);
  }
}

class BoolParam {
  final bool val;
  String? name;

  BoolParam(this.val);

  BoolParam.nameOnRoute(this.name) : val = true;

  @override
  String toString() => name == null ? val.toString() : 'bool:$name';
}

class IntParam {
  final int val;
  String? name;

  IntParam(this.val);

  IntParam.nameOnRoute(this.name) : val = 0;

  @override
  String toString() => name == null ? val.toString() : 'int:$name';
}

class DoubleParam {
  final double val;
  String? name;

  DoubleParam(this.val);

  DoubleParam.nameOnRoute(this.name) : val = 0;

  @override
  String toString() => name == null ? val.toString() : 'double:$name';
}

class StringParam {
  final String val;
  String? name;

  StringParam(this.val);

  StringParam.nameOnRoute(this.name) : val = '';

  @override
  String toString() => name == null ? val.toString() : ':$name';
}

extension BoolParamExt on bool {
  BoolParam get param => BoolParam(this);
}

extension IntParamExt on int {
  IntParam get param => IntParam(this);
}

extension DoubleParamExt on double {
  DoubleParam get param => DoubleParam(this);
}

extension StringParamExt on String {
  StringParam get param => StringParam(this);
}
