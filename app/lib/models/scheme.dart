import 'dart:convert';

import 'package:dde_gesture_manager/builder/provider_annotation.dart';
import 'package:dde_gesture_manager/extensions.dart';
import 'package:dde_gesture_manager/extensions/compare_extension.dart';
import 'package:dde_gesture_manager/utils/helper.dart';
import 'package:uuid/uuid.dart';

typedef OnEditEnd(GestureProp prop);

class _TreeNode<T> {
  late List<T> nodes;

  bool get fullFiled => nodes.every((element) => (element as _TreeNode).fullFiled);

  T get availableNode => nodes.firstWhere((element) => !(element as _TreeNode).fullFiled);
}

class GestureDirectionNode extends _TreeNode {
  GestureDirection direction;
  bool available = true;

  GestureDirectionNode({required this.direction});

  @override
  get fullFiled => !available;

  get availableNode => null;
}

class SchemeGestureNode extends _TreeNode<GestureDirectionNode> {
  Gesture type;

  SchemeGestureNode({required this.type}) {
    switch (type) {
      case Gesture.tap:
        nodes = [GestureDirectionNode(direction: GestureDirection.none)];
        break;
      case Gesture.swipe:
        nodes = [
          GestureDirectionNode(direction: GestureDirection.up),
          GestureDirectionNode(direction: GestureDirection.down),
          GestureDirectionNode(direction: GestureDirection.left),
          GestureDirectionNode(direction: GestureDirection.right),
        ];
        break;
      case Gesture.pinch:
        nodes = [
          GestureDirectionNode(direction: GestureDirection.pinch_in),
          GestureDirectionNode(direction: GestureDirection.pinch_out),
        ];
    }
  }
}

class SchemeTreeNode extends _TreeNode<SchemeGestureNode> {
  int fingers;

  SchemeTreeNode({required this.fingers});

  @override
  List<SchemeGestureNode> nodes = [
    SchemeGestureNode(type: Gesture.tap),
    SchemeGestureNode(type: Gesture.swipe),
    SchemeGestureNode(type: Gesture.pinch),
  ];
}

class SchemeTree extends _TreeNode<SchemeTreeNode> {
  @override
  List<SchemeTreeNode> nodes = [
    SchemeTreeNode(fingers: 3),
    SchemeTreeNode(fingers: 4),
    SchemeTreeNode(fingers: 5),
  ];

  @override
  String toString() => '''
  3:
    tap:  ${nodes[0].nodes[0].nodes[0].available}
    swipe:
      ↑:  ${nodes[0].nodes[1].nodes[0].available}
      ↓:  ${nodes[0].nodes[1].nodes[1].available}
      ←:  ${nodes[0].nodes[1].nodes[2].available}
      →:  ${nodes[0].nodes[1].nodes[3].available}
    pinch:
      in: ${nodes[0].nodes[2].nodes[0].available}
      out:${nodes[0].nodes[2].nodes[1].available}
      
  4:
    tap:  ${nodes[1].nodes[0].nodes[0].available}
    swipe:
      ↑:  ${nodes[1].nodes[1].nodes[0].available}
      ↓:  ${nodes[1].nodes[1].nodes[1].available}
      ←:  ${nodes[1].nodes[1].nodes[2].available}
      →:  ${nodes[1].nodes[1].nodes[3].available}
    pinch:
      in: ${nodes[1].nodes[2].nodes[0].available}
      out:${nodes[1].nodes[2].nodes[1].available}
      
  5:
    tap:  ${nodes[2].nodes[0].nodes[0].available}
    swipe:
      ↑:  ${nodes[2].nodes[1].nodes[0].available}
      ↓:  ${nodes[2].nodes[1].nodes[1].available}
      ←:  ${nodes[2].nodes[1].nodes[2].available}
      →:  ${nodes[2].nodes[1].nodes[3].available}
    pinch:
      in: ${nodes[2].nodes[2].nodes[0].available}
      out:${nodes[2].nodes[2].nodes[1].available}
  ''';
}

@ProviderModel(copyable: true)
class Scheme {
  @ProviderModelProp()
  String? id;

  @ProviderModelProp()
  bool? fromMarket;

  @ProviderModelProp()
  bool? uploaded;

  @ProviderModelProp()
  String? name;

  @ProviderModelProp()
  String? description;

  @ProviderModelProp()
  List<GestureProp>? gestures;

  bool get readOnly => uploaded == true || fromMarket == true || id == Uuid.NAMESPACE_NIL;

  Scheme.parse(scheme) {
    if (scheme is String) scheme = json.decode(scheme);
    assert(scheme is Map);
    id = scheme['id'] ?? Uuid().v1();
    fromMarket = scheme['fromMarket'] ?? false;
    uploaded = scheme['uploaded'] ?? false;
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
    this.gestures = [];
    this.fromMarket = false;
    this.uploaded = false;
    this.name = 'new xxx';
  }

  SchemeTree buildSchemeTree() {
    var schemeTree = SchemeTree();
    this.gestures!.forEach((gesture) {
      var schemeTreeNode = schemeTree.nodes.firstWhere((ele) => ele.fingers == gesture.fingers);
      var schemeGestureNode = schemeTreeNode.nodes.firstWhere((element) => element.type == gesture.gesture);
      schemeGestureNode.nodes.firstWhere((element) => element.direction == gesture.direction).available = false;
    });
    return schemeTree;
  }

  Map toJson() => {
        'id': id,
        'fromMarket': fromMarket,
        'uploaded': uploaded,
        'name': name,
        'desc': description,
        'gestures': gestures,
      };
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

  Map toJson() => {
        'id': id,
        'gesture': H.getGestureName(gesture),
        'direction': H.getGestureDirectionName(direction),
        'fingers': fingers,
        'type': H.getGestureTypeName(type),
        'command': command,
        'remark': remark,
      };

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
