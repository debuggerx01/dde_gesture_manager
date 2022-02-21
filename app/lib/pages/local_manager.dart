import 'package:collection/collection.dart';
import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/configs.provider.dart';
import 'package:dde_gesture_manager/models/content_layout.provider.dart';
import 'package:dde_gesture_manager/models/local_schemes.dart';
import 'package:dde_gesture_manager/models/local_schemes_provider.dart';
import 'package:dde_gesture_manager/models/scheme.dart';
import 'package:dde_gesture_manager/models/scheme.provider.dart';
import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:dde_gesture_manager/utils/apply_scheme_interface.dart';
import 'package:dde_gesture_manager/widgets/dde_button.dart';
import 'package:dde_gesture_manager_api/models.dart' show SchemeForDownload;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uuid/uuid.dart';

class LocalManager extends StatefulWidget {
  const LocalManager({
    Key? key,
  }) : super(key: key);

  @override
  State<LocalManager> createState() => LocalManagerState();
}

class LocalManagerState extends State<LocalManager> {
  late ScrollController _scrollController;
  String? _hoveringItemPath;
  late String _selectedItemPath;

  @override
  void initState() {
    super.initState();

    _selectedItemPath = '';
    _scrollController = ScrollController();

    context.read<LocalSchemesProvider>().schemeEntries.then((_) {
      var localSchemes = context.read<LocalSchemesProvider>().schemes ?? [];
      var appliedSchemeId = context.read<ConfigsProvider>().appliedSchemeId;
      var appliedScheme = localSchemes.firstWhereOrNull((ele) => ele.scheme.id == appliedSchemeId);
      if (appliedScheme != null) {
        setState(() {
          _selectedItemPath = appliedScheme.path;
        });
        _handleItemClick(context, appliedScheme);
      }
    });
  }

  Color _getItemBackgroundColor(int index, String itemPath) {
    Color _color = index % 2 == 0 ? context.t.scaffoldBackgroundColor : context.t.backgroundColor;
    if (itemPath == _hoveringItemPath) _color = context.t.dialogBackgroundColor;
    if (itemPath == _selectedItemPath) _color = context.read<SettingsProvider>().currentActiveColor;
    return _color;
  }

  Icon _getItemIcon(Scheme scheme) {
    if (scheme.id == Uuid.NAMESPACE_NIL) return Icon(Icons.restore_rounded, size: 22);
    if (scheme.fromMarket == true) return Icon(Icons.local_grocery_store_rounded, size: 20);
    if (scheme.uploaded == true) return Icon(Icons.cloud_done_rounded, size: 18);
    return Icon(Icons.person_rounded, size: 22);
  }

  void _handleItemClick(BuildContext context, LocalSchemeEntry localScheme) {
    context.read<SchemeProvider>().copyFrom(localScheme.scheme);
    setState(() {
      _selectedItemPath = localScheme.path;
    });
    context.read<GesturePropProvider>().copyFrom(GestureProp.empty());
  }

  Future addLocalScheme(BuildContext context, [SchemeForDownload? downloadedScheme = null]) async {
    var localSchemesProvider = context.read<LocalSchemesProvider>();
    var newSchemes = [...?localSchemesProvider.schemes];
    var newEntry = await localSchemesProvider.create();
    if (downloadedScheme != null) {
      newEntry.scheme
        ..id = downloadedScheme.uuid
        ..name = downloadedScheme.name
        ..description = downloadedScheme.description
        ..uploaded = true
        ..fromMarket = downloadedScheme.shared == true
        ..gestures = (downloadedScheme.gestures ?? []).map(GestureProp.parse).toList();
    }
    newSchemes.add(newEntry);
    localSchemesProvider.setProps(schemes: newSchemes..sort());
    newEntry.save(localSchemesProvider);
    setState(() {
      _selectedItemPath = newEntry.path;
    });
    _handleItemClick(context, newEntry);
  }

  @override
  Widget build(BuildContext context) {
    var isOpen = context.watch<ContentLayoutProvider>().localManagerOpened == true;
    var localSchemes = context.watch<LocalSchemesProvider>().schemes ?? [];
    return AnimatedContainer(
      duration: mediumDuration,
      curve: Curves.easeInOut,
      width: isOpen ? localManagerPanelWidth : 0,
      child: OverflowBox(
        alignment: Alignment.centerRight,
        maxWidth: localManagerPanelWidth,
        minWidth: localManagerPanelWidth,
        child: Material(
          color: context.t.backgroundColor,
          elevation: isOpen ? 10 : 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: defaultButtonHeight),
                    Flexible(
                      child: Center(
                        child: Text(
                          LocaleKeys.local_manager_title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ).tr(),
                      ),
                    ),
                    DButton(
                      width: defaultButtonHeight - 2,
                      height: defaultButtonHeight - 2,
                      onTap: () => context.read<ContentLayoutProvider>().setProps(localManagerOpened: !isOpen),
                      child: Icon(
                        CupertinoIcons.chevron_left_2,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                controller: _scrollController,
                                itemBuilder: (context, index) => GestureDetector(
                                  onTap: () {
                                    _handleItemClick(context, localSchemes[index]);
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    onEnter: (_) {
                                      setState(() {
                                        _hoveringItemPath = localSchemes[index].path;
                                      });
                                    },
                                    child: Container(
                                      color: _getItemBackgroundColor(index, localSchemes[index].path),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 6, right: 12.0),
                                        child: DefaultTextStyle(
                                          style: context.t.textTheme.bodyText2!.copyWith(
                                            color: _selectedItemPath == localSchemes[index].path ? Colors.white : null,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Opacity(
                                                    opacity: context.watch<ConfigsProvider>().appliedSchemeId ==
                                                            localSchemes[index].scheme.id
                                                        ? 1
                                                        : 0,
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                      child: Icon(Icons.done_rounded, size: 20),
                                                    ),
                                                  ),
                                                  Text(localSchemes[index].scheme.name ?? ''),
                                                ],
                                              ),
                                              _getItemIcon(localSchemes[index].scheme),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                itemCount: localSchemes.length,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              DButton.add(
                                enabled: true,
                                onTap: () async {
                                  await addLocalScheme(context);
                                },
                              ),
                              DButton.delete(
                                enabled: _selectedItemPath.notNull,
                                onTap: () {
                                  var localSchemesProvider = context.read<LocalSchemesProvider>();
                                  var newSchemes = [...?localSchemesProvider.schemes];
                                  var index = newSchemes.indexWhere((element) => element.path == _selectedItemPath);
                                  newSchemes.removeAt(index);
                                  localSchemesProvider.setProps(schemes: newSchemes);
                                  localSchemesProvider.remove(_selectedItemPath);
                                  var newSelectedItem = newSchemes[(index - 1).clamp(1, newSchemes.length)];
                                  setState(() {
                                    _selectedItemPath = newSelectedItem.path;
                                  });
                                  _handleItemClick(context, newSelectedItem);
                                },
                              ),
                              DButton.duplicate(
                                enabled: _selectedItemPath.notNull,
                                onTap: () async {
                                  var localSchemesProvider = context.read<LocalSchemesProvider>();
                                  var newSchemes = [...?localSchemesProvider.schemes];
                                  var index = newSchemes.indexWhere((element) => element.path == _selectedItemPath);
                                  var newEntry = await localSchemesProvider.create();
                                  newEntry.scheme = Scheme.parse(newSchemes[index].scheme.toJson());
                                  newEntry.scheme.id = Uuid().v1();
                                  newEntry.scheme.name = '${newEntry.scheme.name} (${LocaleKeys.str_copy.tr()})';
                                  newEntry.scheme.fromMarket = false;
                                  newEntry.scheme.uploaded = false;
                                  newSchemes.add(newEntry);
                                  localSchemesProvider.setProps(schemes: newSchemes..sort());
                                  setState(() {
                                    _selectedItemPath = newEntry.path;
                                  });
                                  _handleItemClick(context, newEntry);
                                },
                              ),
                              DButton.apply(
                                enabled: true,
                                onTap: () {
                                  var appliedScheme =
                                      localSchemes.firstWhere((ele) => ele.path == _selectedItemPath).scheme;
                                  context.read<ConfigsProvider>().setProps(appliedSchemeId: appliedScheme.id);
                                  SchemeApplyUtil().apply(context, appliedScheme);
                                  Sentry.captureMessage('Scheme applied: [${appliedScheme.name}](${appliedScheme.id})');
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
