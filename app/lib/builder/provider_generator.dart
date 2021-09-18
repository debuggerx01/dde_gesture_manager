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
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    var className = (element as ClassElement).source.shortName;
    List<AnnotationField> fields = [];
    element.fields.forEach((field) {
      var annotation = field.metadata.firstWhereOrNull(
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
    return '''
import 'package:flutter/foundation.dart';
import 'package:dde_gesture_manager/extensions/compare_extension.dart';
import '$className';

class ${element.displayName}Provider extends ${element.displayName} with ChangeNotifier {
  void setProps({
    ${fields.map((f) => '${f.type.endsWith('?') ? '' : 'required '}${f.type} ${f.name},').join('\n')}
  }) {
    bool changed = false;    
    ${fields.map((f) => 'if (${f.name}.diff(this.${f.name})) {this.${f.name} = ${f.name}; changed = true; }').join('\n')}
    if (changed) notifyListeners();
  }
}
    ''';
  }
}
