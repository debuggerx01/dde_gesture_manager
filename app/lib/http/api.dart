import 'dart:convert';
import 'dart:io';

import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/constants/sp_keys.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/scheme.dart' as AppScheme;
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:dde_gesture_manager/utils/notificator.dart';
import 'package:dde_gesture_manager/widgets/market.dart';
import 'package:dde_gesture_manager/widgets/me.dart';
import 'package:dde_gesture_manager_api/apis.dart';
import 'package:dde_gesture_manager_api/models.dart';
import 'package:http/http.dart' as http;

typedef T BeanBuilder<T>(Map res);

typedef T HandleRespBuild<T>(http.Response resp);

typedef int GetStatusCodeFunc(Map resp);

int getStatusCodeFunc(Map resp) => resp["statusCode"] as int;

BeanBuilder<List<T>> listRespBuilderWrap<T>(BeanBuilder<T> builder) =>
    (Map resp) => (resp['list'] as List).map<T>((e) => builder(e)).toList();

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

  static HandleRespBuild<T?> _handleRespBuild<T>(BeanBuilder<T> builder) => (http.Response resp) {
        if (builder is GetStatusCodeFunc) return builder({"statusCode": resp.statusCode});
        T? res;
        try {
          if (resp.statusCode != HttpStatus.ok && resp.bodyBytes.length == 0)
            throw HttpErrorCode(resp.statusCode, message: 'No resp body');
          var decodeBody = json.decode(utf8.decode(resp.bodyBytes));
          res = decodeBody is Map ? builder(decodeBody) : builder({'list': decodeBody});
        } catch (e) {
          e.sout();
          throw HttpErrorCode(resp.statusCode, message: resp.body);
        }
        return res;
      };

  static Future<T?> _get<T>(
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
          HttpHeaders.contentTypeHeader: ContentType.json.toString(),
        }..addAll(
            ignoreToken ? {} : {HttpHeaders.authorizationHeader: 'Bearer ${H().sp.getString(SPKeys.accessToken)}'}),
      )
          .then<T?>(
        _handleRespBuild<T>(builder),
        onError: (e) {
          if (ignoreErrorHandle)
            throw e;
          else
            _handleHttpError(e);
        },
      );

  static Future<T?> _post<T>(
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
          HttpHeaders.contentTypeHeader: ContentType.json.toString(),
        }..addAll(
            ignoreToken ? {} : {HttpHeaders.authorizationHeader: 'Bearer ${H().sp.getString(SPKeys.accessToken)}'}),
      )
          .then<T?>(
        _handleRespBuild<T>(builder),
        onError: (e) {
          if (ignoreErrorHandle)
            throw e;
          else
            _handleHttpError(e);
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
          UserFields.password: User(email: email, password: password).secret('dgm_password'),
        },
        ignoreToken: true,
      );

  static Future<AppVersion?> checkAppVersion({ignoreErrorHandle = false}) => _get<AppVersion?>(
        Apis.system.appVersion,
        AppVersionSerializer.fromMap,
        ignoreToken: true,
        ignoreErrorHandle: ignoreErrorHandle,
      );

  static Future<bool> checkAuthStatus() => _get<int>(Apis.auth.status, getStatusCodeFunc, ignoreErrorHandle: true)
      .then((value) => value == HttpStatus.noContent);

  static Future<UploadRespStatus> uploadScheme({required AppScheme.Scheme scheme, required bool share}) => _post(
        Apis.scheme.upload,
        getStatusCodeFunc,
        body: SchemeSerializer.toMap(
          Scheme(
            name: scheme.name,
            uuid: scheme.id,
            description: scheme.description,
            gestures: scheme.gestures,
            shared: share,
          ),
        ),
      ).then((value) {
        switch (value) {
          case HttpStatus.noContent:
            return UploadRespStatus.done;
          case HttpStatus.locked:
            return UploadRespStatus.name_occupied;
          case HttpStatus.unprocessableEntity:
          default:
            return UploadRespStatus.error;
        }
      });

  static Future<List<SimpleSchemeTransMetaData>?> userSchemes({required SchemeListType type}) =>
      _get(Apis.scheme.user(type: type.name.param), listRespBuilderWrap(SimpleSchemeTransMetaDataSerializer.fromMap));

  static Future<bool> likeScheme({required String schemeId, required bool isLike}) => _get(
              Apis.scheme.like(schemeId: schemeId.param, isLike: StringParam(isLike ? 'like' : 'unlike')),
              getStatusCodeFunc)
          .then((value) {
        return value == HttpStatus.noContent;
      });

  static Future<SchemeForDownload?> downloadScheme({required String schemeId}) => _get(
        Apis.scheme.download(schemeId: schemeId.param),
        SchemeForDownloadSerializer.fromMap,
      );

  static Future<MarketSchemeTransMetaDataResp?> marketSchemes(
          {required MarketSortType type, required int page, int pageSize = 30}) =>
      _get(
        Apis.scheme.market(type: type.name.param, page: page.param, pageSize: pageSize.param),
        MarketSchemeTransMetaDataResp.fromMap,
      );

  static Future<List<int>?> userLikes() => _get(
        Apis.scheme.userLikes,
        (e) => (e['list'] as List).cast<int>(),
      );
}

class MarketSchemeTransMetaDataResp {
  bool hasMore;
  List<MarketSchemeTransMetaData> items;

  MarketSchemeTransMetaDataResp.fromMap(Map map)
      : hasMore = map['hasMore'],
        items = (map['items'] as List)
            .map<MarketSchemeTransMetaData>((e) => MarketSchemeTransMetaDataSerializer.fromMap(e))
            .toList();
}
