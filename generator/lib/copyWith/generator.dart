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

    final extension = Extension((b) => b //
      ..name = '${element.displayName}CopyWithExtension'
      ..on = refer(element.displayName)
      ..methods.add(_generateCopyWith(element)));

    final emitter = DartEmitter();
    return '${extension.accept(emitter)}';
  }

  Method _generateCopyWith(ClassElement element) {
    return Method((b) => b //
      ..name = '\$copyWith' //
      ..body = _generateBody(element)
      ..optionalParameters
          .addAll(element.fields.map((e) => _generateParameter(e)))
      ..returns = refer(element.displayName));
  }

  Parameter _generateParameter(FieldElement e) {
    return Parameter((b) => b
      ..named = true
      ..name = e.name
      ..type = refer('${e.type.element!.displayName}?'));
  }

  Code _generateBody(ClassElement element) {
    final blockBuilder = BlockBuilder();
    // final output = Output(positionalArgs, {namedArgs});
    final constructor = _findDefaultConstructor(element);
    final positionalArgs = <Expression>[];
    final namedArgs = <String, Expression>{};
    constructor.parameters.forEach((element) {
      final expression = refer('${element.name} ?? this.${element.name}');
      if (element.isNamed) {
        namedArgs.putIfAbsent(element.name, () => expression);
      } else {
        // positional
        positionalArgs.add(expression);
      }
    });
    final copyWithExpression = refer(element.displayName)
        .newInstance(positionalArgs, namedArgs)
        .returned;
    blockBuilder.addExpression(copyWithExpression);
    return blockBuilder.build();
  }

  ConstructorElement _findDefaultConstructor(ClassElement outputClass) {
    return outputClass.constructors
        .where((element) => !element.isFactory)
        .first;
  }
}
