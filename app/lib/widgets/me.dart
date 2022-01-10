import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/http/api.dart';
import 'package:dde_gesture_manager/models/configs.provider.dart';
import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:dde_gesture_manager/utils/notificator.dart';
import 'package:dde_gesture_manager_api/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';

import 'dde_button.dart';

enum SchemeListType {
  uploaded,
  downloaded,
  liked,
}

class MeWidget extends StatefulWidget {
  const MeWidget({Key? key}) : super(key: key);

  @override
  _MeWidgetState createState() => _MeWidgetState();
}

class _MeWidgetState extends State<MeWidget> {
  List<SimpleSchemeTransMetaData> _schemes = [];
  SchemeListType _type = SchemeListType.uploaded;
  String? _selected;
  String? _hovering;

  @override
  void initState() {
    super.initState();
    Api.userSchemes(type: _type).then((value) {
      if (mounted && value != null)
        setState(() {
          _schemes = value;
          _selected = value.isNotEmpty ? value.first.uuid : null;
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
      Api.userSchemes(type: _type).then((value) {
        if (mounted && value != null)
          setState(() {
            _schemes = value;
          });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentSelectedScheme = _schemes.firstWhereOrNull((e) => e.uuid == _selected);
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.person, size: defaultButtonHeight),
              Flexible(
                child: AutoSizeText(
                  context.watch<ConfigsProvider>().email ?? '',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  maxLines: 1,
                ),
              ),
              DButton.logout(
                enabled: true,
                onTap: () => context.read<ConfigsProvider>().setProps(accessToken: '', email: ''),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3, bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SchemeListType.uploaded,
                SchemeListType.downloaded,
                SchemeListType.liked,
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
                            });
                            Api.userSchemes(type: e).then((value) {
                              if (mounted && value != null)
                                setState(() {
                                  _schemes = value;
                                  _selected = value.first.uuid;
                                });
                            });
                          },
                          child: Center(
                            child: Text(
                              '${LocaleKeys.me_scheme_types}.${e.name}'.tr(),
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
                  itemBuilder: (context, index) => GestureDetector(
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
                                    Text('${_schemes[index].downloads ?? 0}'.padLeft(4)),
                                    Icon(
                                      Icons.file_download,
                                      size: 18,
                                    ),
                                    Text('${_schemes[index].likes ?? 0}'.padLeft(4)),
                                    Icon(_schemes[index].liked == true ? Icons.thumb_up : Icons.thumb_up_off_alt,
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
                  ),
                  itemCount: _schemes.length,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_type == SchemeListType.uploaded)
                  DButton.share(
                    enabled: currentSelectedScheme?.shared == false,
                    onTap: () {
                      Notificator.showConfirm(
                              title: LocaleKeys.info_share_title.tr(),
                              description: LocaleKeys.info_share_description.tr())
                          .then((value) {
                        if (value == CustomButton.positiveButton) {
                          Notificator.success(context, title: LocaleKeys.info_share_success.tr());
                        }
                      });
                    },
                  ),
                DButton.like(
                  enabled: true,
                  onTap: () {
                    Api.likeScheme(schemeId: currentSelectedScheme!.uuid!, isLike: !currentSelectedScheme.liked!)
                        .then((value) {
                      if (value) {
                        _refreshList();
                      }
                    });
                  },
                ),
                DButton.download(
                  enabled: true,
                  onTap: () {
                    Api.downloadScheme(schemeId: currentSelectedScheme!.uuid!).then((value) {
                      value.sout();
                      _refreshList();
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
      ),
    );
  }
}
