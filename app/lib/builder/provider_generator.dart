import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:dde_gesture_manager/builder/provider_annotation.dart';
import 'package:source_gen/source_gen.dart';
import 'package:collection/collection.dart';

class AnnotationField {
  String name;
  String type;

  AnnotationField(this.name, this.type);
}

class ProviderGenerator extends GeneratorForAnnotation<ProviderModel> {
  var _preClassName;

  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    var className = (element as ClassElement).source.shortName;
    var needImports = className != _preClassName;
    _preClassName = className;
    List<AnnotationField> fields = [];
    element.fields.forEach((field) {
      var annotation = field.metadata.firstWhereOrNull(
              (m) => m.computeConstantValue()?.type?.getDisplayString(withNullability: true) == 'ProviderModelProp') ??
          field.getter?.metadata.firstWhereOrNull(
              (m) => m.computeConstantValue()?.type?.getDisplayString(withNullability: true) == 'ProviderModelProp');
      if (annotation != null)
        fields.add(
          AnnotationField(
            field.displayName,
            field.type.getDisplayString(
              withNullability: annotation.computeConstantValue()?.getField('nullable')?.toBoolValue() ?? true,
            ),
          ),
        );
    });
    return [
      _genImports(className, needImports),
      _genClassDefine(element.displayName),
      _genNamedConstructors(element.constructors, element.displayName),
      _genCopyFunc(element.displayName, fields, annotation.read('copyable').boolValue),
      _genSetPropsFunc(fields),
    ].whereNotNull();
  }
}

String? _genImports(String className, bool needImports) => needImports
    ? '''
import 'package:flutter/foundation.dart';
import 'package:dde_gesture_manager/extensions/compare_extension.dart';
import '$className';
'''
    : null;

String _genClassDefine(String displayName) => '''
class ${displayName}Provider extends $displayName with ChangeNotifier {
''';

String? _genNamedConstructors(List<ConstructorElement> constructors, String displayName) {
  String _genCallSuperParamStr(ParameterElement param) => param.isNamed ? '${param.name}: ${param.name}' : param.name;
  List<String> _constructors = [];
  if (constructors.length > 0) {
    constructors.forEach((constructor) {
      if (constructor.name.length > 0) {
        var params = constructor.getDisplayString(withNullability: true).split('$displayName.${constructor.name}').last;
        _constructors.add('''
  ${displayName}Provider.${constructor.name}${params.replaceAll('dynamic ', '')}
      : super.${constructor.name}(${constructor.parameters.map(_genCallSuperParamStr).join(',')});
  ''');
      }
    });
  }
  return _constructors.length > 0 ? _constructors.join('\n') : null;
}

String? _genCopyFunc(String displayName, List<AnnotationField> fields, bool copyable) {
  if (!copyable) return null;
  return '''
  void copyFrom(${displayName} other) {
    bool changed = false;    
    ${fields.map((f) => 'if (other.${f.name} != this.${f.name}) {this.${f.name} = other.${f.name}; changed = true; }').join('\n')}
    if (changed) notifyListeners();
  }
  ''';
}

String _genSetPropsFunc(List<AnnotationField> fields) => '''
  void setProps({
    ${fields.map((f) => '${f.type.endsWith('?') ? '' : 'required '}${f.type} ${f.name},').join('\n')}
  }) {
    bool changed = false;    
    ${fields.map((f) => 'if (${f.name}.diff(this.${f.name})) {this.${f.name} = ${f.name}; changed = true; }').join('\n')}
    if (changed) notifyListeners();
  }
}
    ''';
