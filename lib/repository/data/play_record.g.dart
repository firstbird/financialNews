// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayRecordAdapter extends TypeAdapter<PlayRecord> {
  @override
  final int typeId = 4;

  @override
  PlayRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayRecord(
      playCount: fields[0] as int,
      score: fields[1] as int,
      song: fields[2] as Track,
    );
  }

  @override
  void write(BinaryWriter writer, PlayRecord obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.playCount)
      ..writeByte(1)
      ..write(obj.score)
      ..writeByte(2)
      ..write(obj.song);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayRecord _$PlayRecordFromJson(Map<String, dynamic> json) => PlayRecord(
      playCount: json['playCount'] as int,
      score: json['score'] as int,
      song: Track.fromJson(json['song'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlayRecordToJson(PlayRecord instance) =>
    <String, dynamic>{
      'playCount': instance.playCount,
      'score': instance.score,
      'song': instance.song,
    };
