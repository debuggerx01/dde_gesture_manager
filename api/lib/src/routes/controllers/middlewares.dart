import 'package:angel3_auth/angel3_auth.dart';
import 'package:angel3_framework/angel3_framework.dart';

import 'package:dde_gesture_manager_api/models.dart';
import '../controllers/controller_extensions.dart';

RequestHandler jwtMiddleware({ignoreError = false}) {
  return (RequestContext req, ResponseContext res, {bool throwError = true}) async {
    bool _reject(ResponseContext res, [ignoreError = false]) {
      if (ignoreError) return true;
      if (throwError) {
        res.forbidden();
      }
      return false;
    }

    if (req.container != null) {
      var reqContainer = req.container!;
      if (reqContainer.has<User>() || req.method == 'OPTIONS') {
        return true;
      } else if (reqContainer.has<Future<User>>()) {
        try {
          User user = await reqContainer.makeAsync<User>();
          var authToken = req.container!.make<AuthToken>();
          if (user.secret(req.app!.configuration['password_salt']) != authToken.payload[UserFields.password]) {
            return _reject(res, ignoreError);
          }
        } catch (e) {
          if (ignoreError) return true;
          rethrow;
        }
        return true;
      } else {
        return _reject(res, ignoreError);
      }
    } else {
      return _reject(res, ignoreError);
    }
  };
}
