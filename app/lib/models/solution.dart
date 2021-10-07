import 'dart:convert';

import 'package:dde_gesture_manager/builder/provider_annotation.dart';
import 'package:dde_gesture_manager/utils/helper.dart';

@ProviderModel()
class Solution {
  @ProviderModelProp()
  String? name;

  @ProviderModelProp()
  String? description;

  @ProviderModelProp()
  List<GestureProp>? gestures;

  Solution.parse(solution) {
    if (solution is String) solution = json.decode(solution);
    assert(solution is Map);
    name = solution['name'];
    description = solution['desc'];
    gestures = (solution['gestures'] as List? ?? []).map<GestureProp>((ele) => GestureProp.parse(ele)).toList();
  }
}

enum Gesture {
  swipe,
  tap,
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

@ProviderModel()
class GestureProp {
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

  @override
  bool operator ==(Object other) =>
      other is GestureProp &&
      other.gesture == this.gesture &&
      other.direction == this.direction &&
      other.fingers == this.fingers;

  @override
  String toString() {
    return 'GestureProp{gesture: $gesture, direction: $direction, fingers: $fingers, type: $type, command: $command, remark: $remark}';
  }

  GestureProp.parse(props) {
    if (props is String) props = json.decode(props);
    assert(props is Map);
    gesture = H.getGestureByName(props['gesture']);
    direction = H.getGestureDirectionByName(props['direction']);
    fingers = props['fingers'];
    type = H.getGestureTypeByName(props['type']);
    command = props['command'];
    remark = props['remark'];
  }
}
