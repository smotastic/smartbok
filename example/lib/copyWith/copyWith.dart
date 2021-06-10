import 'package:smartbok/copyWith/annotations.dart';

part 'copyWith.g.dart';

@CopyWith()
class Model {
  final String text;
  final num number;

  Model(this.text, {required this.number});
}
