import 'dart:async';

import 'package:angel3_framework/angel3_framework.dart';
import 'package:dde_gesture_manager_api/apis.dart';
import 'package:dde_gesture_manager_api/src/models/download_history.dart';
import 'package:dde_gesture_manager_api/src/models/like_record.dart';
import 'package:dde_gesture_manager_api/src/models/scheme.dart';
import 'package:dde_gesture_manager_api/src/routes/controllers/middlewares.dart';
import 'package:logging/logging.dart';
import 'controller_extensions.dart';

Future configureServer(Angel app) async {
  final _log = Logger('scheme_controller');

  app.post(
    Apis.scheme.upload,
    chain(
      [
        jwtMiddleware(),
        (req, res) async {
          try {
            var scheme = SchemeSerializer.fromMap(req.bodyAsMap);
            var schemeQuery = SchemeQuery();
            schemeQuery.where!.uuid.equals(scheme.uuid!);
            req.queryExecutor.transaction((tx) async {
              var one = await schemeQuery.getOne(tx);
              schemeQuery = SchemeQuery();
              schemeQuery.values.copyFrom(scheme);
              schemeQuery.values.uid = req.user!.idAsInt;
              if (one.isEmpty) {
                return await schemeQuery.insert(tx);
              } else {
                schemeQuery.whereId = one.value.idAsInt;
                return await schemeQuery.updateOne(tx);
              }
            });
          } catch (e) {
            _log.severe(e);
            return res.unProcessableEntity();
          }
          return res.noContent();
        },
      ],
    ),
  );

  app.post(
    Apis.scheme.markAsShared.route,
    chain(
      [
        jwtMiddleware(),
        (req, res) async {
          var schemeId = req.params['schemeId'];
          var schemeQuery = SchemeQuery();
          schemeQuery.where!.uuid.equals(schemeId);
          schemeQuery.values.shared = true;
          await schemeQuery.updateOne(req.queryExecutor);
          return res.noContent();
        },
      ],
    ),
  );

  app.get(
    Apis.scheme.download.route,
    chain(
      [
        jwtMiddleware(ignoreError: true),
        (req, res) async {
          var schemeQuery = SchemeQuery();
          schemeQuery.where?.uuid.equals(req.params['schemeId']);
          var optionalScheme = await schemeQuery.getOne(req.queryExecutor);
          if (optionalScheme.isNotEmpty) {
            var scheme = optionalScheme.value;
            if (req.user != null) {
              /// 增加用户下载记录
              var downloadHistoryQuery = DownloadHistoryQuery();
              downloadHistoryQuery.where?.uid.equals(req.user!.idAsInt);
              downloadHistoryQuery.where?.schemeId.equals(scheme.idAsInt);
              var notExist = (await downloadHistoryQuery.getOne(req.queryExecutor)).isEmpty;
              if (notExist) {
                downloadHistoryQuery = DownloadHistoryQuery();
                downloadHistoryQuery.values.copyFrom(DownloadHistory(uid: req.user!.idAsInt, schemeId: scheme.idAsInt));
                await downloadHistoryQuery.insert(req.queryExecutor);
              }
            }

            /// 增加方案的下载数量
            schemeQuery = SchemeQuery();
            schemeQuery.whereId = scheme.idAsInt;
            Map<String, dynamic> metadata = Map.from(scheme.metadata!);
            metadata.update('downloads', (value) => ++value, ifAbsent: () => 1);
            schemeQuery.values.metadata = metadata;
            schemeQuery.updateOne(req.queryExecutor);

            return res.json(transSchemeForDownload(scheme));
          }
          return res.notFound();
        },
      ],
    ),
  );

  app.get(
    Apis.scheme.like.route,
    chain(
      [
        jwtMiddleware(),
        (req, res) async {
          bool isLike = req.params['isLike'] == 'like';
          bool needUpdate = true;
          var schemeQuery = SchemeQuery();
          schemeQuery.where?.uuid.equals(req.params['schemeId']);
          var optionalScheme = await schemeQuery.getOne(req.queryExecutor);
          if (optionalScheme.isNotEmpty) {
            var scheme = optionalScheme.value;
            if (req.user != null) {
              /// 增加用户点赞记录
              var likeRecordQuery = LikeRecordQuery();
              likeRecordQuery.where?.uid.equals(req.user!.idAsInt);
              likeRecordQuery.where?.schemeId.equals(scheme.idAsInt);
              var likeRecordCheck = await likeRecordQuery.getOne(req.queryExecutor);
              likeRecordQuery = LikeRecordQuery();
              likeRecordQuery.values
                  .copyFrom(LikeRecord(uid: req.user!.idAsInt, schemeId: scheme.idAsInt, liked: isLike));
              if (likeRecordCheck.isEmpty) {
                likeRecordQuery.insert(req.queryExecutor);
              } else if (likeRecordCheck.value.liked != isLike) {
                likeRecordQuery.whereId = likeRecordCheck.value.idAsInt;
                likeRecordQuery.updateOne(req.queryExecutor);
              } else {
                needUpdate = false;
              }
            }

            if (needUpdate) {
              /// 增加/减少方案的点赞数量
              schemeQuery = SchemeQuery();
              schemeQuery.whereId = scheme.idAsInt;
              Map<String, dynamic> metadata = Map.from(scheme.metadata!);
              metadata.update('likes', (value) => isLike ? ++value : --value, ifAbsent: () => 1);
              schemeQuery.values.metadata = metadata;
              schemeQuery.updateOne(req.queryExecutor);
            }

            return res.noContent();
          }
          return res.notFound();
        },
      ],
    ),
  );

  app.get(
    Apis.scheme.user.route,
    chain(
      [
        jwtMiddleware(),
        (req, res) async {
          var schemeQuery = SimpleSchemeQuery();
          var type = req.params['type'];
          var likeRecordTableName = LikeRecordQuery().tableName;
          schemeQuery.leftJoin(likeRecordTableName, SchemeFields.id, LikeRecordFields.schemeId, alias: 'lr');

          switch (type) {
            case 'uploaded':
              schemeQuery.where!.uid.equals(req.user!.idAsInt);
              break;
            case 'downloaded':
              var downloadHistoryTableName = DownloadHistoryQuery().tableName;
              schemeQuery.leftJoin(downloadHistoryTableName, SchemeFields.id, DownloadHistoryFields.schemeId,
                  alias: 'dh');
              schemeQuery.where!.raw('dh.${DownloadHistoryFields.uid} = ${req.user!.idAsInt}');
              break;
            case 'liked':
              schemeQuery.where!.raw('lr.${LikeRecordFields.uid} = ${req.user!.idAsInt}');
              schemeQuery.where!.raw('lr.${LikeRecordFields.liked} = true');
              break;
            default:
              return res.unProcessableEntity();
          }
          schemeQuery.orderBy('${schemeQuery.tableName}.${SchemeFields.updatedAt}', descending: true);
          return schemeQuery.get(req.queryExecutor).then((value) => value.map(transSimpleSchemeMetaData).toList());
        },
      ],
    ),
  );

  const recommend = "(metadata->'recommends') is null ,(metadata->'recommends')::int";
  const updated = "updated_at";
  const likes = "(metadata->'likes') is null ,(metadata->'likes')::int";
  const downloads = "(metadata->'downloads') is null ,(metadata->'downloads')::int";

  app.get(Apis.scheme.market.route, (req, res) async {
    var schemeQuery = MarketSchemeQuery();
    var type = req.params['type'];
    var page = req.params['page'] as int;
    var pageSize = req.params['pageSize'] as int;
    schemeQuery.where?.shared.equals(true);
    late List<String> orders;

    switch (type) {
      case 'recommend':
        // orders = [recommend, likes, downloads, SchemeFields.id];
        orders = [recommend];
        break;
      case 'updated':
        orders = [updated];
        break;
      case 'likes':
        // orders = [likes, recommend, downloads, SchemeFields.id];
        orders = [likes];
        break;
      case 'downloads':
        // orders = [downloads, recommend, likes, SchemeFields.id];
        orders = [downloads];
        break;
      default:
        return res.unProcessableEntity();
    }
    for (var order in orders) {
      schemeQuery.orderBy(order, descending: true);
    }
    schemeQuery.offset(page * pageSize);
    schemeQuery.limit(pageSize + 1);
    return schemeQuery.get(req.queryExecutor).then((value) {
      var hasMore = value.length > pageSize;
      if (hasMore) value.removeLast();
      return {
        'hasMore': hasMore,
        'items': value.map(transMarketSchemeMetaData).toList(),
      };
    });
  });

  app.get(
    Apis.scheme.userLikes,
    chain(
      [
        jwtMiddleware(),
        (req, res) async => (UserLikesQuery()
              ..where?.uid.equals(req.user!.idAsInt)
              ..where?.liked.equals(true))
            .get(req.queryExecutor)
            .then((value) => value.map((e) => e.id).toList()),
      ],
    ),
  );
}
