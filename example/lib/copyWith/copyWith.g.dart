// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'copyWith.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension ModelCopyWithExtension on Model {
  Model $copyWith(
      {String? text,
      num? number,
      String? someText,
      String? someConstructorText}) {
    final model = Model(
        text ?? this.text, someConstructorText ?? this.someConstructorText,
        number: number ?? this.number);
    model.someText = someText ?? this.someText;
    return model;
  }
}
