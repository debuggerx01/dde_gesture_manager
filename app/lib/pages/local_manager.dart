import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/content_layout.provider.dart';
import 'package:dde_gesture_manager/models/local_schemes_provider.dart';
import 'package:dde_gesture_manager/models/scheme.dart';
import 'package:dde_gesture_manager/models/scheme.provider.dart';
import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:dde_gesture_manager/widgets/dde_button.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:uuid/uuid.dart';

class LocalManager extends StatefulWidget {
  const LocalManager({
    Key? key,
  }) : super(key: key);

  @override
  State<LocalManager> createState() => _LocalManagerState();
}

class _LocalManagerState extends State<LocalManager> {
  late ScrollController _scrollController;
  String? _hoveringItem;
  late String _selectedItem;

  @override
  void initState() {
    super.initState();

    /// todo: load from sp
    _selectedItem = Uuid.NAMESPACE_NIL;
    _scrollController = ScrollController();
  }

  Color _getItemBackgroundColor(int index, String itemId) {
    Color _color = index % 2 == 0 ? context.t.scaffoldBackgroundColor : context.t.backgroundColor;
    if (itemId == _hoveringItem) _color = context.t.scaffoldBackgroundColor;
    if (itemId == _selectedItem) _color = context.read<SettingsProvider>().currentActiveColor;
    return _color;
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
                                    context.read<SchemeProvider>().copyFrom(localSchemes[index].scheme);
                                    setState(() {
                                      _selectedItem = localSchemes[index].scheme.id!;
                                    });
                                    context.read<GesturePropProvider>().copyFrom(GestureProp.empty());
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    onEnter: (_) {
                                      setState(() {
                                        _hoveringItem = localSchemes[index].scheme.id!;
                                      });
                                    },
                                    child: Container(
                                      color: _getItemBackgroundColor(index, localSchemes[index].scheme.id!),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 6, right: 12.0),
                                        child: DefaultTextStyle(
                                          style: context.t.textTheme.bodyText2!.copyWith(
                                            color:
                                                _selectedItem == localSchemes[index].scheme.id! ? Colors.white : null,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(localSchemes[index].scheme.name ?? ''),
                                              Text('456'),
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
                        Container(height: 5),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              DButton.add(enabled: true),
                              DButton.delete(enabled: _selectedItem != Uuid.NAMESPACE_NIL),
                              DButton.duplicate(enabled: _selectedItem != Uuid.NAMESPACE_NIL),
                              DButton.apply(enabled: _selectedItem != Uuid.NAMESPACE_NIL),
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
