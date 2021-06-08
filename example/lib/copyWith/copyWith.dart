import 'package:smartbok/copyWith/annotations.dart';

part 'copyWith.g.dart';

@CopyWith()
class Copyable {
  final String text;
  final num number;

  Copyable(this.text, this.number);
}
