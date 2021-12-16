import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:dde_gesture_manager/constants/constants.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/models/content_layout.provider.dart';
import 'package:dde_gesture_manager/models/local_schemes_provider.dart';
import 'package:dde_gesture_manager/models/scheme.dart';
import 'package:dde_gesture_manager/models/scheme.provider.dart';
import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:dde_gesture_manager/pages/content.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:dde_gesture_manager/utils/keyboard_mapper.dart';
import 'package:dde_gesture_manager/utils/notificator.dart';
import 'package:dde_gesture_manager/widgets/dde_button.dart';
import 'package:dde_gesture_manager/widgets/dde_data_table.dart';
import 'package:dde_gesture_manager/widgets/dde_markdown_field.dart';
import 'package:dde_gesture_manager/widgets/dde_text_field.dart';
import 'package:dde_gesture_manager/widgets/table_cell_shortcut_listener.dart';
import 'package:dde_gesture_manager/widgets/table_cell_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const double _headingRowHeight = 56;
const double _scrollBarWidth = 14;

class GestureEditor extends StatelessWidget {
  const GestureEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var layoutProvider = context.watch<ContentLayoutProvider>();
    var schemeProvider = context.watch<SchemeProvider>();
    final horizontalCtrl = ScrollController();
    final verticalCtrl = ScrollController();

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: context.t.backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: layoutProvider.localManagerOpened == false,
                      child: DButton(
                        width: defaultButtonHeight,
                        onTap: () => H.openPanel(context, PanelType.local_manager),
                        child: Icon(
                          CupertinoIcons.square_list,
                        ),
                      ),
                    ),
                    Text(
                      LocaleKeys.gesture_editor_label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ).tr(),
                    Visibility(
                      visible: layoutProvider.marketOpened == false,
                      child: DButton(
                        width: defaultButtonHeight,
                        onTap: () => H.openPanel(context, PanelType.market),
                        child: Icon(
                          CupertinoIcons.cart,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(height: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      context.read<GesturePropProvider>().setProps(editMode: false);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(defaultBorderRadius),
                        border: Border.all(
                          width: .2,
                          color: context.t.dividerColor,
                        ),
                      ),
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                        return AdaptiveScrollbar(
                          controller: verticalCtrl,
                          underColor: Colors.transparent,
                          sliderDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(_scrollBarWidth / 2),
                            color: Colors.grey.withOpacity(.4),
                          ),
                          sliderActiveDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(_scrollBarWidth / 2),
                            color: Colors.grey.withOpacity(.6),
                          ),
                          position: ScrollbarPosition.right,
                          underSpacing: EdgeInsets.only(top: _headingRowHeight),
                          width: _scrollBarWidth,
                          child: AdaptiveScrollbar(
                            width: _scrollBarWidth,
                            underColor: Colors.transparent,
                            sliderDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(_scrollBarWidth / 2),
                              color: Colors.grey.withOpacity(.4),
                            ),
                            sliderActiveDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(_scrollBarWidth / 2),
                              color: Colors.grey.withOpacity(.6),
                            ),
                            controller: horizontalCtrl,
                            position: ScrollbarPosition.bottom,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: horizontalCtrl,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                child: DDataTable(
                                  showBottomBorder: true,
                                  headingRowHeight: _headingRowHeight,
                                  showCheckboxColumn: true,
                                  headerBackgroundColor: context.t.dialogBackgroundColor,
                                  verticalScrollController: verticalCtrl,
                                  dataRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                                    if (states.contains(MaterialState.hovered)) return context.t.dialogBackgroundColor;
                                    if (states.contains(MaterialState.selected))
                                      return context.read<SettingsProvider>().currentActiveColor;
                                    return null;
                                  }),
                                  columns: [
                                    DDataColumn(label: Text(LocaleKeys.gesture_editor_fingers.tr()), center: true),
                                    DDataColumn(label: Text(LocaleKeys.gesture_editor_gesture.tr()), center: true),
                                    DDataColumn(label: Text(LocaleKeys.gesture_editor_direction.tr()), center: true),
                                    DDataColumn(label: Text(LocaleKeys.gesture_editor_type.tr()), center: true),
                                    DDataColumn(label: Text(LocaleKeys.gesture_editor_command.tr())),
                                    DDataColumn(label: Text(LocaleKeys.gesture_editor_remark.tr())),
                                  ],
                                  rows: _buildDataRows(context, schemeProvider.gestures, schemeProvider.readOnly),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                Builder(builder: (context) {
                  var gesturePropProvider = context.watch<GesturePropProvider>();
                  var copiedGesturePropProvider = context.watch<CopiedGesturePropProvider>();
                  var schemeTree = schemeProvider.buildSchemeTree();
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DButton.add(
                        enabled: !schemeProvider.readOnly && !gesturePropProvider.editMode! && !schemeTree.fullFiled,
                        onTap: () {
                          var schemeProvider = context.read<SchemeProvider>();
                          var newGestures = [
                            ...?schemeProvider.gestures,
                            H.getNextAvailableGestureProp(schemeProvider.buildSchemeTree())!,
                          ]..sort();
                          context.read<SchemeProvider>().setProps(gestures: newGestures);
                          saveGesturesToLocal(context, schemeProvider, newGestures);
                        },
                      ),
                      DButton.delete(
                        enabled: !schemeProvider.readOnly &&
                            gesturePropProvider != GestureProp.empty() &&
                            !gesturePropProvider.editMode!,
                        onTap: () {
                          var schemeProvider = context.read<SchemeProvider>();
                          var index = schemeProvider.gestures?.indexWhere((e) => e.id == gesturePropProvider.id);
                          var newGestures = [
                            ...?schemeProvider.gestures?..removeAt(index!),
                          ];
                          context.read<SchemeProvider>().setProps(gestures: newGestures);
                          if (newGestures.length > 0)
                            gesturePropProvider.copyFrom(
                                newGestures[(index ?? 0) > newGestures.length - 1 ? newGestures.length - 1 : index ?? 0]
                                  ..editMode = false);
                          saveGesturesToLocal(context, schemeProvider, newGestures);
                        },
                      ),
                      DButton.duplicate(
                        enabled: gesturePropProvider != GestureProp.empty() && !gesturePropProvider.editMode!,
                        onTap: () {
                          var schemeProvider = context.read<SchemeProvider>();
                          context.read<CopiedGesturePropProvider>().copyFrom(
                              schemeProvider.gestures!.firstWhere((element) => element.id == gesturePropProvider.id));
                          Notificator.success(
                            context,
                            title: LocaleKeys.info_gesture_prop_duplicated_title.tr(),
                            description: LocaleKeys.info_gesture_prop_duplicated_description.tr(),
                          );
                        },
                      ),
                      DButton.paste(
                        enabled: !schemeProvider.readOnly &&
                            copiedGesturePropProvider != CopiedGesturePropProvider.empty() &&
                            !gesturePropProvider.editMode! &&
                            !schemeTree.fullFiled,
                        onTap: () {
                          var schemeTree = context.read<SchemeProvider>().buildSchemeTree();
                          late GestureProp newGestureProp;
                          if (schemeTree.nodes
                              .firstWhere((e) => e.fingers == copiedGesturePropProvider.fingers)
                              .nodes
                              .firstWhere((e) => e.type == copiedGesturePropProvider.gesture)
                              .nodes
                              .firstWhere((e) => e.direction == copiedGesturePropProvider.direction)
                              .available) {
                            newGestureProp = GestureProp.empty()..copyFrom(copiedGesturePropProvider);
                          } else {
                            newGestureProp = H.getNextAvailableGestureProp(schemeProvider.buildSchemeTree())!;
                            newGestureProp.type = copiedGesturePropProvider.type;
                            newGestureProp.command = copiedGesturePropProvider.command;
                            newGestureProp.remark = copiedGesturePropProvider.remark;
                          }
                          newGestureProp.id = Uuid().v1();
                          var newGestures = [
                            ...?schemeProvider.gestures,
                            newGestureProp,
                          ]..sort();
                          context.read<SchemeProvider>().setProps(gestures: newGestures);
                          saveGesturesToLocal(context, schemeProvider, newGestures);
                        },
                      ),
                    ]
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(top: 3.0, right: 10.0, bottom: 8.0),
                              child: e,
                            ))
                        .toList(),
                  );
                }),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                    border: Border.all(
                      width: .2,
                      color: context.t.dividerColor,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(LocaleKeys.gesture_editor_info_name).tr(),
                            ),
                            Expanded(
                              child: DTextField(
                                initText: schemeProvider.name,
                                readOnly: schemeProvider.readOnly,
                                onComplete: (val) {
                                  val = val.trim();
                                  schemeProvider.setProps(name: val);
                                  var localSchemesProvider = context.read<LocalSchemesProvider>();
                                  if (!localSchemesProvider.schemes!
                                      .where((element) => element.scheme.id != schemeProvider.id)
                                      .every((element) => element.scheme.name != val)) {
                                    Notificator.error(
                                      context,
                                      title: LocaleKeys.info_scheme_name_conflict_title.tr(),
                                      description: LocaleKeys.info_scheme_name_conflict_description.tr(),
                                    );
                                    return false;
                                  }
                                  var localSchemeEntry = localSchemesProvider.schemes!
                                      .firstWhere((ele) => ele.scheme.id == schemeProvider.id);
                                  localSchemeEntry.scheme.name = val;
                                  localSchemeEntry.save(localSchemesProvider);
                                  return true;
                                },
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(LocaleKeys.gesture_editor_info_description).tr(),
                              ),
                            ),
                            Expanded(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minHeight: kMinInteractiveDimension, maxHeight: 300),
                                child: DMarkdownField(
                                  initText: schemeProvider.description,
                                  readOnly: schemeProvider.readOnly,
                                  onComplete: (content) {
                                    content = content.trim();
                                    schemeProvider.setProps(description: content);
                                    var localSchemesProvider = context.read<LocalSchemesProvider>();
                                    var localSchemeEntry = localSchemesProvider.schemes!
                                        .firstWhere((ele) => ele.scheme.id == schemeProvider.id);
                                    localSchemeEntry.scheme.description = content;
                                    localSchemeEntry.save(localSchemesProvider);
                                  },
                                ),
                              ),
                            ),
                          ],
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

List<DDataRow> _buildDataRows(BuildContext context, List<GestureProp>? gestures, bool readOnly) =>
    (gestures ?? []).map((gesture) {
      var gesturePropProvider = context.watch<GesturePropProvider>();
      bool editing = gesturePropProvider == gesture && gesturePropProvider.editMode == true;
      bool selected = gesturePropProvider == gesture && !editing;
      return DDataRow(
        onSelectChanged: (selected) {
          var provider = context.read<GesturePropProvider>();
          if (selected == true) {
            provider.setProps(
              editMode: false,
            );
            Future.microtask(() => provider.setProps(
                  id: gesture.id,
                ));
          } else if (selected == false && !readOnly) {
            provider.onEditEnd = (prop) {
              var schemeProvider = context.read<SchemeProvider>();
              var newGestures = List<GestureProp>.of(schemeProvider.gestures!);
              var index = newGestures.indexWhere((element) => element == prop);
              newGestures[index].copyFrom(prop);
              newGestures.sort();
              context.read<SchemeProvider>().setProps(
                    gestures: newGestures,
                  );
              saveGesturesToLocal(context, schemeProvider, newGestures);
            };
            provider.copyFrom(
              gesture..editMode = true,
            );
          }
        },
        selected: selected,
        cells: editing ? _buildRowCellsEditing(context) : _buildRowCellsNormal(context, selected, gesture),
      );
    }).toList();

void saveGesturesToLocal(BuildContext context, SchemeProvider schemeProvider, List<GestureProp> newGestures) {
  var localSchemesProvider = context.read<LocalSchemesProvider>();
  var localSchemeEntry = localSchemesProvider.schemes!.firstWhere((ele) => ele.scheme.id == schemeProvider.id);
  localSchemeEntry.scheme.gestures = newGestures;
  localSchemeEntry.save(localSchemesProvider);
}

List<DDataCell> _buildRowCellsEditing(BuildContext context) {
  var gesture = context.read<GesturePropProvider>();
  var schemeTree = context.read<SchemeProvider>().buildSchemeTree();
  var availableFingers = schemeTree.nodes.where((node) => !node.fullFiled).map((e) => e.fingers);
  if (!availableFingers.contains(gesture.fingers)) {
    availableFingers = [...availableFingers, gesture.fingers!]..sort();
  }

  var availableGestures = schemeTree.nodes
      .firstWhere((node) => node.fingers == gesture.fingers)
      .nodes
      .where((node) => !node.fullFiled)
      .map((e) => e.type);
  if (!availableGestures.any((type) => type == gesture.gesture)) {
    availableGestures = [...availableGestures, gesture.gesture!]..sort((a, b) => a.index - b.index);
  }

  var availableDirection = schemeTree.nodes
      .firstWhere((node) => node.fingers == gesture.fingers)
      .nodes
      .firstWhere((node) => node.type == gesture.gesture)
      .nodes
      .where((node) => !node.fullFiled)
      .map((e) => e.direction);

  if (!availableDirection.any((direction) => direction == gesture.direction)) {
    availableDirection = [...availableDirection, gesture.direction!]..sort((a, b) => a.index - b.index);
  }

  return [
    DButton.dropdown(
      enabled: true,
      child: DropdownButton<int>(
        icon: Icon(Icons.keyboard_arrow_down_rounded),
        items: availableFingers
            .map(
              (e) => DropdownMenuItem<int>(
                child: Text('$e'),
                value: e,
              ),
            )
            .toList(),
        value: gesture.fingers,
        onChanged: (value) => context.read<GesturePropProvider>().setProps(
              fingers: value,
              editMode: true,
            ),
        isExpanded: true,
      ),
    ),
    DButton.dropdown(
      enabled: true,
      width: 100.0,
      child: DropdownButton<Gesture>(
        icon: Icon(Icons.keyboard_arrow_down_rounded),
        items: availableGestures
            .map(
              (e) => DropdownMenuItem<Gesture>(
                child: Text(
                  '${LocaleKeys.gesture_editor_gestures}.${e.name}',
                  textScaleFactor: .8,
                ).tr(),
                value: e,
              ),
            )
            .toList(),
        value: gesture.gesture,
        onChanged: (value) => context.read<GesturePropProvider>().setProps(
              gesture: value,
              editMode: true,
            ),
        isExpanded: true,
      ),
    ),
    DButton.dropdown(
      enabled: true,
      width: 100.0,
      child: DropdownButton<GestureDirection>(
        icon: Icon(Icons.keyboard_arrow_down_rounded),
        items: availableDirection
            .map(
              (e) => DropdownMenuItem<GestureDirection>(
                child: Text(
                  '${LocaleKeys.gesture_editor_directions}.${H.getGestureDirectionName(e)}',
                  textScaleFactor: .8,
                ).tr(),
                value: e,
              ),
            )
            .toList(),
        value: gesture.direction,
        onChanged: (value) => context.read<GesturePropProvider>().setProps(
              direction: value,
              editMode: true,
            ),
        isExpanded: true,
      ),
    ),
    DButton.dropdown(
      enabled: true,
      width: 100.0,
      child: DropdownButton<GestureType>(
        icon: Icon(Icons.keyboard_arrow_down_rounded),
        items: GestureType.values
            .map(
              (e) => DropdownMenuItem<GestureType>(
                child: Text(
                  '${LocaleKeys.gesture_editor_types}.${e.name}',
                  textScaleFactor: .8,
                ).tr(),
                value: e,
              ),
            )
            .toList(),
        value: gesture.type,
        onChanged: (value) => context.read<GesturePropProvider>().setProps(
              type: value,
              command: '',
              editMode: true,
            ),
        isExpanded: true,
      ),
    ),
    _buildCommandCellsEditing(context),
    TableCellTextField(
      initText: gesture.remark,
      hint: LocaleKeys.gesture_editor_hints_remark.tr(),
      onComplete: (value) => context.read<GesturePropProvider>().setProps(
            remark: value,
            editMode: true,
          ),
    ),
  ].map((e) => DDataCell(e)).toList();
}

Widget _buildCommandCellsEditing(BuildContext context) {
  var gesture = context.read<GesturePropProvider>();
  switch (gesture.type) {
    case GestureType.commandline:
      return TableCellTextField(
        initText: gesture.command,
        hint: LocaleKeys.gesture_editor_hints_command.tr(),
        onComplete: (value) => context.read<GesturePropProvider>().setProps(
              command: value,
              editMode: true,
            ),
      );
    case GestureType.built_in:
      return DButton.dropdown(
        enabled: true,
        width: 250.0,
        child: DropdownButton<String>(
          icon: Icon(Icons.keyboard_arrow_down_rounded),
          items: builtInCommands
              .map(
                (e) => DropdownMenuItem<String>(
                  child: Text(
                    ('${LocaleKeys.built_in_commands}.$e').tr(),
                    textScaleFactor: .8,
                  ),
                  value: ('${LocaleKeys.built_in_commands}.$e').tr(),
                ),
              )
              .toList(),
          value:
              ('${LocaleKeys.built_in_commands}.${(builtInCommands.contains(gesture.command) ? gesture.command : builtInCommands.first)!}')
                  .tr(),
          onChanged: (value) => context.read<GesturePropProvider>().setProps(
                command: value,
                editMode: true,
              ),
          isExpanded: true,
        ),
      );
    case GestureType.shortcut:
      return TableCellShortcutListener(
        width: 250.0,
        initShortcut: gesture.command ?? '',
        onComplete: (value) => context.read<GesturePropProvider>().setProps(
              command: value,
              editMode: true,
            ),
      );
    default:
      throw Exception('Unknown gesture command type.');
  }
}

List<DDataCell> _buildRowCellsNormal(BuildContext context, bool selected, GestureProp gesture) => [
      Center(
        child: Text(
          '${gesture.fingers}',
        ),
      ),
      Center(
        child: Text(
          '${LocaleKeys.gesture_editor_gestures}.${gesture.gesture?.name}',
        ).tr(),
      ),
      Center(
          child: Text(
        '${LocaleKeys.gesture_editor_directions}.${H.getGestureDirectionName(gesture.direction)}',
      ).tr()),
      Center(
          child: Text(
        '${LocaleKeys.gesture_editor_types}.${gesture.type?.name}',
      ).tr()),
      gesture.type == GestureType.shortcut
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: (gesture.command ?? '').split('+').map(
                (e) {
                  var keyNames = getPhysicalKeyNamesByRealName(e);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(defaultBorderRadius / 2),
                        color: context.t.dialogBackgroundColor,
                        border: Border.all(
                          width: 1,
                          color: Color(0xff565656),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          keyNames != null ? keyNames.displayName : LocaleKeys.str_null.tr(),
                          style: TextStyle(
                            color: context.watch<SettingsProvider>().currentActiveColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            )
          : (gesture.type == GestureType.built_in
              ? Text(
                  ('${LocaleKeys.built_in_commands}.${(builtInCommands.contains(gesture.command) ? gesture.command : builtInCommands.first)!}')
                      .tr())
              : Text(
                  gesture.command ?? '',
                )),
      Text(
        gesture.remark ?? '',
      ),
    ]
        .map(
          (ele) => DDataCell(DefaultTextStyle(
              style: context.t.textTheme.bodyText2!.copyWith(
                color: selected ? Colors.white : null,
              ),
              child: ele)),
        )
        .toList();
