import 'package:build/build.dart';
import 'package:smartbok/copyWith/generator.dart';
import 'package:source_gen/source_gen.dart';

Builder copyWithBuilder(BuilderOptions options) =>
    SharedPartBuilder([CopyWithGenerator()], 'copyWith');
