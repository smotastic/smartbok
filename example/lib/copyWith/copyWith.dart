import 'package:smartbok/copyWith/annotations.dart';

part 'copyWith.g.dart';

@CopyWith()
class Model {
  final String text;
  final num number;
  String? someText;
  String? someConstructorText;

  Model(this.text, this.someConstructorText, {required this.number});
}
