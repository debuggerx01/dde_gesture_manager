import 'dart:convert';

import 'package:dde_gesture_manager/builder/provider_annotation.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/extensions/compare_extension.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:uuid/uuid.dart';

typedef OnEditEnd(GestureProp prop);

@ProviderModel(copyable: true)
class Scheme {
  @ProviderModelProp()
  String? id;

  @ProviderModelProp()
  String? name;

  @ProviderModelProp()
  String? description;

  @ProviderModelProp()
  List<GestureProp>? gestures;

  Scheme.parse(scheme) {
    if (scheme is String) scheme = json.decode(scheme);
    assert(scheme is Map);
    id = scheme['id'];
    name = scheme['name'];
    description = scheme['desc'];
    gestures = (scheme['gestures'] as List? ?? []).map<GestureProp>((ele) => GestureProp.parse(ele)).toList()..sort();
  }

  Scheme.systemDefault() {
    this.id = Uuid.NAMESPACE_NIL;
    this.name = LocaleKeys.local_manager_default_scheme_label.tr();
    this.description = LocaleKeys.local_manager_default_scheme_description.tr();
    this.gestures = [];
  }

  Scheme.create({this.name, this.description, this.gestures}) {
    this.id = Uuid().v1();
  }
}

enum Gesture {
  tap,
  swipe,
  pinch,
}

enum GestureDirection {
  up,
  down,
  left,
  right,
  pinch_in,
  pinch_out,
  none,
}

enum GestureType {
  built_in,
  commandline,
  shortcut,
}

@ProviderModel(copyable: true)
class GestureProp implements Comparable {
  @ProviderModelProp()
  String? id;

  @ProviderModelProp()
  Gesture? gesture;

  @ProviderModelProp()
  GestureDirection? direction;

  @ProviderModelProp()
  int? fingers;

  @ProviderModelProp()
  GestureType? type;

  @ProviderModelProp()
  String? command;

  @ProviderModelProp()
  String? remark;

  @ProviderModelProp()
  bool? get editMode => _editMode;

  set editMode(bool? val) {
    _editMode = val ?? false;
    if (val == false) onEditEnd?.call(this);
  }

  OnEditEnd? onEditEnd;

  bool _editMode = false;

  @override
  bool operator ==(Object other) => other is GestureProp && other.id == this.id;

  @override
  String toString() {
    return 'GestureProp{gesture: $gesture, direction: $direction, fingers: $fingers, type: $type, command: $command, remark: $remark}';
  }

  GestureProp.empty() : this.id = Uuid.NAMESPACE_NIL;

  GestureProp.parse(props) {
    if (props is String) props = json.decode(props);
    assert(props is Map);
    id = Uuid().v1();
    gesture = H.getGestureByName(props['gesture']);
    direction = H.getGestureDirectionByName(props['direction']);
    fingers = props['fingers'];
    type = H.getGestureTypeByName(props['type']);
    command = props['command'];
    remark = props['remark'];
  }

  copyFrom(GestureProp prop) {
    this.id = prop.id;
    this.gesture = prop.gesture;
    this.direction = prop.direction;
    this.fingers = prop.fingers;
    this.type = prop.type;
    this.command = prop.command;
    this.remark = prop.remark;
  }

  @override
  int compareTo(other) {
    assert(other is GestureProp);
    if (fingers.diff(other.fingers) && other.fingers != null) return fingers! - other.fingers as int;
    if (gesture.diff(other.gesture) && other.gesture != null) return gesture!.index - other.gesture!.index as int;
    if (direction.diff(other.direction) && other.direction != null)
      return direction!.index - other.direction!.index as int;
    return 0;
  }
}
