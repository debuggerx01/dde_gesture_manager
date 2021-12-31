import 'dart:async';
import 'dart:convert';

import 'package:angel3_auth/angel3_auth.dart';
import 'package:angel3_framework/angel3_framework.dart';
import 'package:dde_gesture_manager_api/apis.dart';
import 'package:dde_gesture_manager_api/models.dart';
import 'package:dde_gesture_manager_api/src/routes/controllers/middlewares.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:uuid/uuid.dart';

import 'controller_extensions.dart';

Future configureServer(Angel app) async {
  app.post(Apis.auth.loginOrSignup, (req, res) async {
    var userParams = UserSerializer.fromMap(req.bodyAsMap);
    userParams.password = req.bodyAsMap[UserFields.password];
    var userQuery = UserQuery();
    userQuery.where?.email.equals(userParams.email ?? '');
    var user = await userQuery.getOne(req.queryExecutor);

    if (user.isEmpty) {
      String accessKey = Uuid().v1();

      await req.cache
          .withPrefix('sign_up:')[accessKey]
          .set(json.encode({'email': userParams.email, 'password': userParams.password}), Duration(minutes: 30));
      var smtpConfig = app.configuration['smtp'];
      var smtpServer =
          SmtpServer(smtpConfig['host'], ssl: true, username: smtpConfig['username'], password: smtpConfig['password']);
      var message = Message()
        ..from = Address(smtpConfig['username'])
        ..recipients.add(userParams.email)
        ..subject = '确认注册'
        ..html = await app.viewGenerator!(
          'confirm_sign_up.html',
          {
            "confirm_url": Uri(
              scheme: Apis.apiScheme,
              host: Apis.apiHost,
              port: Apis.apiPort,
              path: Apis.auth.confirmSignup(accessKey: accessKey.param),
            ),
          },
        );

      send(message, smtpServer);
      return res.notFound();
    } else if (user.value.password != userParams.password) {
      return res.unauthorized();
    } else if (user.value.blocked == true) {
      return res.forbidden();
    } else {
      var angelAuth = req.container!.make<AngelAuth>();
      await angelAuth.loginById(user.value.id!, req, res);
      var authToken = req.container!.make<AuthToken>();
      authToken.payload[UserFields.password] = user.value.secret(app.configuration['password_salt']);
      var serializedToken = authToken.serialize(angelAuth.hmac);
      return res.json(LoginSuccess(token: serializedToken));
    }
  });

  app.get(Apis.auth.confirmSignup.route, (req, res) async {
    var accessKey = req.params['accessKey'];
    var cache = req.cache.withPrefix('sign_up:');
    var signupInfo = await cache[accessKey].get();
    if (signupInfo != null && signupInfo is String && signupInfo.isNotEmpty) {
      var decodedSignupInfo = json.decode(signupInfo);
      var userQuery = UserQuery();
      userQuery.values.copyFrom(User(
        email: decodedSignupInfo[UserFields.email],
        password: decodedSignupInfo[UserFields.password],
      ));
      await userQuery.insert(req.queryExecutor);
      cache[accessKey].purge();
      return res.render('sign_up_result.html', {'success': true});
    }
    return res.render('sign_up_result.html', {'success': false});
  });

  app.get(
    Apis.auth.status,
    chain(
      [
        jwtMiddleware(),
        (req, res) => req.user.blocked == false ? res.noContent() : res.forbidden(),
      ],
    ),
  );
}
