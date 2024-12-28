import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../configs/hive/hive_types.dart';

part 'generated/example.freezed.dart';

part 'generated/example.g.dart';

@freezed
@HiveType(typeId: HiveTypes.example)
class Example with _$Example {
  const factory Example({
    @HiveField(0) @Default("") String cf,
    @HiveField(1) @Default("") String x,
  }) = _Example;

  factory Example.fromJson(Map<String, dynamic> json) => _$ExampleFromJson(json);
}