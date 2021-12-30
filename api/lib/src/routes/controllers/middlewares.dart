import 'package:angel3_auth/angel3_auth.dart';
import 'package:angel3_framework/angel3_framework.dart';

import 'package:dde_gesture_manager_api/models.dart';

RequestHandler jwtMiddleware() {
  return (RequestContext req, ResponseContext res, {bool throwError = true}) async {
    bool _reject(ResponseContext res) {
      if (throwError) {
        res.statusCode = 403;
        throw AngelHttpException.forbidden();
      } else {
        return false;
      }
    }

    if (req.container != null) {
      var reqContainer = req.container!;
      if (reqContainer.has<User>() || req.method == 'OPTIONS') {
        return true;
      } else if (reqContainer.has<Future<User>>()) {
        User user = await reqContainer.makeAsync<User>();
        var authToken = req.container!.make<AuthToken>();
        if (user.secret(req.app!.configuration['password_salt']) != authToken.payload[UserFields.password]) {
          return _reject(res);
        }
        return true;
      } else {
        return _reject(res);
      }
    } else {
      return _reject(res);
    }
  };
}
