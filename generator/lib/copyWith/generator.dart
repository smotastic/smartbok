import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:smartbok/copyWith/annotations.dart';
import 'package:source_gen/source_gen.dart';

class CopyWithGenerator extends GeneratorForAnnotation<CopyWith> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
          '${element.displayName} is not a class and cannot be annotated with @CopyWith',
          element: element,
          todo: 'Add CopyWith annotation to a class');
    }

    final emitter = DartEmitter();
    return '// it works';
  }
}
