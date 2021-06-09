import 'package:smartbok/copyWith/annotations.dart';

part 'copyWith.g.dart';

@CopyWith()
class Copyable {
  final String text;
  final num number;

  Copyable(this.text, this.number);
}

extension CopyWitha on Copyable {
  Copyable copyWith({String? text, num? number}) {
    return Copyable(text ?? this.text, number ?? this.number);
  }
}
