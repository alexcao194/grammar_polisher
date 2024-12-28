import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/example.freezed.dart';

part 'generated/example.g.dart';

@freezed
class Example with _$Example {
  const factory Example({
    @Default("") String cf,
    @Default("") String x,
  }) = _Example;

  factory Example.fromJson(Map<String, dynamic> json) => _$ExampleFromJson(json);
}