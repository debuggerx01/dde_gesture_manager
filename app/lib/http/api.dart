import 'dart:convert';
import 'dart:io';

import 'package:dde_gesture_manager/constants/sp_keys.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:dde_gesture_manager/utils/notificator.dart';
import 'package:dde_gesture_manager_api/apis.dart';
import 'package:dde_gesture_manager_api/models.dart';
import 'package:http/http.dart' as http;

typedef T BeanBuilder<T>(Map res);

typedef T HandleRespBuild<T>(http.Response resp);

getStatusCodeFunc<int>(Map resp) => resp["statusCode"];

class HttpErrorCode extends Error {
  int statusCode;

  HttpErrorCode(this.statusCode, {this.message});

  String? message;

  @override
  String toString() => '[$statusCode] $message';
}

class Api {
  static _handleHttpError(e) {
    if (e is SocketException) {
      Notificator.error(
        H().topContext,
        title: LocaleKeys.info_server_error_title.tr(),
        description: LocaleKeys.info_server_error_description.tr(),
      );
    } else {
      throw e;
    }
  }

  static HandleRespBuild<T> _handleRespBuild<T>(BeanBuilder<T> builder) => (http.Response resp) {
        if (builder == getStatusCodeFunc) return builder({"statusCode": resp.statusCode});
        T res;
        try {
          res = builder(json.decode(resp.body));
        } catch (e) {
          throw HttpErrorCode(resp.statusCode, message: resp.body);
        }
        return res;
      };

  static Future<T> _get<T>(
    String path,
    BeanBuilder<T> builder, {
    Map<String, dynamic>? queryParams,
    bool ignoreToken = false,
    bool ignoreErrorHandle = false,
  }) =>
      http
          .get(
        Uri(
          scheme: Apis.apiScheme,
          host: Apis.apiHost,
          port: Apis.apiPort,
          queryParameters: queryParams,
          path: path,
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        }..addAll(
            ignoreToken ? {} : {HttpHeaders.authorizationHeader: 'Bearer ${H().sp.getString(SPKeys.accessToken)}'}),
      )
          .then(
        _handleRespBuild<T>(builder),
        onError: (e) {
          if (ignoreErrorHandle)
            throw e;
          else
            return _handleHttpError(e);
        },
      );

  static Future<T> _post<T>(
    String path,
    BeanBuilder<T> builder, {
    Map<String, dynamic>? body,
    bool ignoreToken = false,
    bool ignoreErrorHandle = false,
  }) =>
      http
          .post(
        Uri(
          scheme: Apis.apiScheme,
          host: Apis.apiHost,
          port: Apis.apiPort,
          path: path,
        ),
        body: jsonEncode(body),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: ContentType.json.value,
        }..addAll(
            ignoreToken ? {} : {HttpHeaders.authorizationHeader: 'Bearer ${H().sp.getString(SPKeys.accessToken)}'}),
      )
          .then(
        _handleRespBuild<T>(builder),
        onError: (e) {
          if (ignoreErrorHandle)
            throw e;
          else
            return _handleHttpError(e);
        },
      );

  static Future<LoginSuccess?> loginOrSignup({
    required String email,
    required String password,
  }) =>
      _post<LoginSuccess?>(
        Apis.auth.loginOrSignup,
        LoginSuccessSerializer.fromMap,
        body: {
          UserFields.email: email,
          UserFields.password: password,
        },
        ignoreToken: true,
      );

  static Future<AppVersion?> checkAppVersion({ignoreErrorHandle = false}) => _get<AppVersion?>(
        Apis.system.appVersion,
        AppVersionSerializer.fromMap,
        ignoreToken: true,
        ignoreErrorHandle: ignoreErrorHandle,
      );
}
