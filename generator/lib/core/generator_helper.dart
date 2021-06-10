import 'package:analyzer/dart/element/element.dart';

abstract class GenHelper {
  /// Finds the default constructor of a given [ClassElement]
  static ConstructorElement findDefaultConstructor(ClassElement outputClass) {
    return outputClass.constructors
        .where((element) => !element.isFactory)
        .first;
  }
}
