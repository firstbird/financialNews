import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../repository.dart';

part 'play_record.g.dart';

@JsonSerializable()
@HiveType(typeId: 4)
class PlayRecord with EquatableMixin {
  const PlayRecord({
    required this.playCount,
    required this.score,
    required this.song,
  });

  // factory PlayRecord.fromJson(Map<String, dynamic> json) =>
  //     _$PlayRecordFromJson(json);

  @HiveField(0)
  final int playCount;
  @HiveField(1)
  final int score;
  @HiveField(2)
  final Track song;

  // Map<String, dynamic> toJson() => _$PlayRecordToJson(this);

  @override
  List<Object?> get props => [
        playCount,
        score,
        song,
      ];
}
