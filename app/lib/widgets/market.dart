import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/http/api.dart';
import 'package:dde_gesture_manager/models/local_schemes_provider.dart';
import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:dde_gesture_manager/widgets/dde_button.dart';
import 'package:dde_gesture_manager_api/models.dart';
import 'package:flutter/material.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:markdown_editor_ot/markdown_editor.dart';
import 'package:numeral/numeral.dart';
import 'package:collection/collection.dart';

enum MarketSortType {
  recommend,
  updated,
  likes,
  downloads,
}

class MarketWidget extends StatefulWidget {
  const MarketWidget({Key? key}) : super(key: key);

  @override
  _MarketWidgetState createState() => _MarketWidgetState();
}

class _MarketWidgetState extends State<MarketWidget> {
  List<MarketSchemeTransMetaData> _schemes = [];
  bool _hasMore = true;
  int _currentPage = 0;
  MarketSortType _type = MarketSortType.recommend;
  String? _selected;
  String? _hovering;
  List<int> _likedSchemes = [];

  @override
  void initState() {
    super.initState();
    if (context.hasToken)
      Api.userLikes().then((value) {
        if (mounted && value != null)
          setState(() {
            _likedSchemes = value;
          });
      });
    Api.marketSchemes(type: _type, page: _currentPage).then((value) {
      if (mounted && value != null)
        setState(() {
          _schemes = value.items;
          _selected = value.items.isNotEmpty ? value.items.first.uuid : null;
          _hasMore = value.hasMore;
        });
    });
  }

  Color _getItemBackgroundColor(int index, String? schemeId) {
    Color _color = index % 2 == 0 ? context.t.scaffoldBackgroundColor : context.t.backgroundColor;
    if (schemeId == _hovering) _color = context.t.dialogBackgroundColor;
    if (schemeId == _selected) _color = context.read<SettingsProvider>().currentActiveColor;
    return _color;
  }

  _refreshList() {
    Future.delayed(const Duration(milliseconds: 100), () {
      Api.marketSchemes(type: _type, page: 0).then((value) {
        if (mounted && value != null)
          setState(() {
            _schemes = value.items;
            _hasMore = value.hasMore;
            _selected = value.items.first.uuid;
          });
      });
    });
  }

  _getMoreSchemes() {
    'try to fetch page: ${_currentPage + 1}'.sout();
    if (_hasMore)
      Api.marketSchemes(type: _type, page: ++_currentPage).then((value) {
        if (mounted && value != null)
          setState(() {
            _schemes.addAll(value.items);
            _hasMore = value.hasMore;
          });
      });
  }

  @override
  Widget build(BuildContext context) {
    var currentSelectedScheme = _schemes.firstWhereOrNull((e) => e.uuid == _selected);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MarketSortType.recommend,
              MarketSortType.updated,
              MarketSortType.likes,
              MarketSortType.downloads,
            ]
                .map(
                  (e) => Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _type = e;
                            _refreshList();
                          });
                        },
                        child: Center(
                          child: Text(
                            '${LocaleKeys.market_sort_types}.${e.name}'.tr(),
                            style: _type == e ? TextStyle(fontWeight: FontWeight.bold, fontSize: 15) : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: .3,
                      color: context.t.dividerColor,
                    ),
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1, vertical: 2),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        if (index == _schemes.length - 1) _getMoreSchemes();
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selected = _schemes[index].uuid;
                            });
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_) {
                              setState(() {
                                _hovering = _schemes[index].uuid;
                              });
                            },
                            child: Container(
                              color: _getItemBackgroundColor(index, _schemes[index].uuid),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 6, right: 12.0),
                                child: DefaultTextStyle(
                                  style: context.t.textTheme.bodyText2!.copyWith(
                                    color: _selected == _schemes[index].uuid ? Colors.white : null,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(_schemes[index].name ?? ''),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 50,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: AutoSizeText(
                                                '${numeral(_schemes[index].downloads ?? 0, fractionDigits: 1)}'
                                                    .padLeft(5),
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.file_download,
                                            size: 18,
                                          ),
                                          SizedBox(
                                            width: 50,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: AutoSizeText(
                                                '${numeral(_schemes[index].likes ?? 0, fractionDigits: 1)}'.padLeft(5),
                                              ),
                                            ),
                                          ),
                                          Icon(
                                              _likedSchemes.contains(_schemes[index].id)
                                                  ? Icons.thumb_up
                                                  : Icons.thumb_up_off_alt,
                                              size: 17),
                                        ]
                                            .map((e) => Padding(
                                                  padding: const EdgeInsets.only(right: 3),
                                                  child: e,
                                                ))
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: _schemes.length,
                    ),
                  ),
                ),
              ),
              Container(height: 10),
              Flexible(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: .3,
                      color: context.t.dividerColor,
                    ),
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: MdPreview(
                      text: _schemes.firstWhereOrNull((e) => e.uuid == _selected)?.description ?? '',
                      widgetImage: (imageUrl) => CachedNetworkImage(
                        imageUrl: imageUrl,
                        placeholder: (context, url) => const SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                      onTapLink: H.launchURL,
                      textStyle: context.t.textTheme.bodyText2,
                      onCodeCopied: () {},
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DButton.like(
                enabled: context.watchHasToken,
                onTap: () {
                  bool liked = _likedSchemes.contains(currentSelectedScheme!.id!);
                  Api.likeScheme(schemeId: currentSelectedScheme.uuid!, isLike: !liked).then((value) {
                    if (value) {
                      setState(() {
                        if (liked) {
                          _likedSchemes.remove(currentSelectedScheme.id);
                          currentSelectedScheme.likes = currentSelectedScheme.likes! - 1;
                        } else {
                          _likedSchemes.add(currentSelectedScheme.id!);
                          currentSelectedScheme.likes = currentSelectedScheme.likes! + 1;
                        }
                      });
                    }
                  });
                },
              ),
              DButton.download(
                enabled: (context.watch<LocalSchemesProvider>().schemes ?? []).every((e) => e.scheme.id != _selected),
                onTap: () {
                  Api.downloadScheme(schemeId: currentSelectedScheme!.uuid!).then((value) {
                    if (value != null) {
                      H.handleDownloadScheme(context, value);
                      setState(() {
                        currentSelectedScheme.downloads = currentSelectedScheme.downloads! + 1;
                      });
                    }
                  });
                },
              ),
            ]
                .map((e) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: e,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
