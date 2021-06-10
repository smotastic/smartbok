import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:smartbok/copyWith/annotations.dart';
import 'package:smartbok/core/generator_helper.dart';
import 'package:source_gen/source_gen.dart';

class CopyWithGenerator extends GeneratorForAnnotation<CopyWith> {
  @override
  String generateForAnnotatedElement(
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

  /// Generates the copyWith Method
  Method _generateCopyWith(ClassElement element) {
    return Method((b) => b //
      ..name = '\$copyWith' //
      ..body = _generateBody(element)
      ..optionalParameters
          .addAll(element.fields.map((e) => _generateParameter(e)))
      ..returns = refer(element.displayName));
  }

  /// Generates an optional method parameter for the copyWithMethod.
  ///
  /// The given [FieldElement] acts as the name, and the type of the resulting [Parameter].
  /// The parameter is always named, and optional
  Parameter _generateParameter(FieldElement e) {
    return Parameter((b) => b
      ..named = true
      ..name = e.name
      ..type = refer('${e.type.element!.displayName}?'));
  }

  /// Generates the body for the copyWith Method.
  ///
  /// First creates a new instance of the current model.
  /// The positional and named arguments of the default constructor are then set, by assigning them a ifThen Expression, using [_generateIfThenExpression].
  /// If there are any non final parameters, which are not present in the constructor, they'll be set after initializing the instance.
  Code _generateBody(ClassElement element) {
    final usedParameters = <String>[];
    final positionalArgs = <Expression>[];
    final namedArgs = <String, Expression>{};

    GenHelper.findDefaultConstructor(element).parameters.forEach((element) {
      final assignment = _generateIfThenExpression(element);
      if (element.isNamed) {
        namedArgs.putIfAbsent(element.name, () => assignment);
      } else {
        positionalArgs.add(assignment);
      }
      usedParameters.add(element.name);
    });

    final className = element.displayName.toLowerCase();
    final blockBuilder = BlockBuilder()
      ..addExpression(refer(element.displayName)
          .newInstance(positionalArgs, namedArgs)
          .assignFinal(className));

    element.fields
        .where((element) => !element.isFinal)
        .where((element) => !usedParameters.contains(element.name))
        .map((e) => refer(className)
            .property(e.name)
            .assign(_generateIfThenExpression(e)))
        .forEach((exp) => blockBuilder.addExpression(exp));

    blockBuilder.addExpression(refer(className).returned);
    return blockBuilder.build();
  }

  Expression _generateIfThenExpression(Element element) {
    return refer('${element.name}').ifNullThen(refer('this.${element.name}'));
  }
}
