class Apis {
  static const apiScheme = 'http';
  static const apiHost = '127.0.0.1';
  static const apiPort = 3000;

  static const appNewVersionUrl = 'https://www.debuggerx.com';

  static final system = SystemApis();
  static final auth = AuthApis();
}

class AuthApis {
  static final String path = '/auth';

  String get loginOrSignup => [path, 'login_or_signup'].joinPath();

  String confirmSignup({required StringParam accessKey}) => [path, 'confirm_sign_up', accessKey].joinPath();
}

class SystemApis {
  static final String path = '/system';

  String get appVersion => [path, 'app-version'].joinPath();
}

final _paramsMap = {
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

extension IntParamExt on int {
  IntParam get param => IntParam(this);
}

extension DoubleParamExt on double {
  DoubleParam get param => DoubleParam(this);
}

extension StringParamExt on String {
  StringParam get param => StringParam(this);
}
