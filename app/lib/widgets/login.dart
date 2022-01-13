import 'dart:io';

import 'package:dde_gesture_manager/constants/sp_keys.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/http/api.dart';
import 'package:dde_gesture_manager/models/configs.provider.dart';
import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:dde_gesture_manager/utils/notificator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({
    Key? key,
  }) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  ValueKey<int> _key = ValueKey(0);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OverflowBox(
        alignment: Alignment.topCenter,
        child: Container(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(
              physics: const NeverScrollableScrollPhysics(),
            ),
            child: FlutterLogin(
              key: _key,
              onLogin: (loginData) async {
                try {
                  var res = await Api.loginOrSignup(email: loginData.name, password: loginData.password);
                  if (res != null && res.token.notNull)
                    context.read<ConfigsProvider>().setProps(accessToken: res.token, email: loginData.name);
                } catch (e) {
                  if (!(e is HttpErrorCode)) return;
                  var code = e.statusCode;
                  if (code == HttpStatus.unauthorized)
                    Notificator.error(
                      context,
                      title: LocaleKeys.info_login_failed_title.tr(),
                      description: LocaleKeys.info_login_failed_description.tr(),
                    );
                  else if (code == HttpStatus.notFound)
                    Notificator.info(
                      context,
                      title: LocaleKeys.info_sign_up_hint_title.tr(),
                      description: LocaleKeys.info_sign_up_hint_description.tr(),
                    );
                  else if (code == HttpStatus.forbidden)
                    Notificator.info(
                      context,
                      title: LocaleKeys.info_user_blocked_hint_title.tr(),
                      description: LocaleKeys.info_user_blocked_hint_description.tr(),
                    );
                  else
                    throw e;
                }
                return null;
              },
              onSubmitAnimationCompleted: () {
                var token = H().sp.getString(SPKeys.accessToken);
                if (token.isNull)
                  setState(() {
                    _key = ValueKey(_key.value + 1);
                  });
                else if (context.read<ConfigsProvider>().accessToken != token)
                  context
                      .read<ConfigsProvider>()
                      .setProps(accessToken: token, email: H().sp.getString(SPKeys.loginEmail));
              },
              onRecoverPassword: (_) => null,
              hideForgotPasswordButton: true,
              disableCustomPageTransformer: true,
              messages: LoginMessages(
                userHint: LocaleKeys.me_login_email_hint.tr(),
                passwordHint: LocaleKeys.me_login_password_hint.tr(),
                loginButton: LocaleKeys.me_login_login_or_signup.tr(),
              ),
              userValidator: (value) {
                if (FlutterLogin.defaultEmailValidator(value) != null) {
                  return LocaleKeys.me_login_email_error_hint.tr();
                }
                return null;
              },
              passwordValidator: (value) {
                if (value!.isEmpty || value.length < 8 || value.length > 16) {
                  return LocaleKeys.me_login_password_hint.tr();
                }
                return null;
              },
              theme: LoginTheme(
                pageColorDark: Colors.transparent,
                pageColorLight: Colors.transparent,
                primaryColor: context.watch<SettingsProvider>().currentActiveColor,
                footerBackgroundColor: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
