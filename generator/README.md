# smartbok

Dart Annotation Processor for reducing boilerplate code.
Heavily inspired by https://projectlombok.org/

- [Installation](#installation)
- [Usage](#usage)

# Installation

Add smartbok as a dev dependency.

```yaml
dev_dependencies:
  smartbok:
```

Run the generator

```console
dart run build_runner build
flutter packages pub run build_runner build
// or watch
flutter packages pub run build_runner watch
```

# Usage

## CopyWith

Generates an extension for the annotated class, with a generated _$copyWith_ Method.

```dart
// model.dart
@CopyWith
class Model {
    final String text;
    final num number;
    String someText;

    Model(this.text, {this.number});
}
```

```dart
// model.g.dart
extension ModelCopyWithExtension on Model {
  Model $copyWith({String? text, num? number, String? someText}) {
    final model = Model(
        text ?? this.text,
        number: number ?? this.number
    );
    model.someText = someText ?? this.someText;
    return model;
  }
}
```
