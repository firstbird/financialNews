// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud_tracks_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CloudTracksDetailAdapter extends TypeAdapter<CloudTracksDetail> {
  @override
  final int typeId = 2;

  @override
  CloudTracksDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CloudTracksDetail(
      tracks: (fields[0] as List).cast<Track>(),
      size: fields[1] as int,
      maxSize: fields[2] as int,
      trackCount: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CloudTracksDetail obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.tracks)
      ..writeByte(1)
      ..write(obj.size)
      ..writeByte(2)
      ..write(obj.maxSize)
      ..writeByte(3)
      ..write(obj.trackCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CloudTracksDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CloudTracksDetail _$CloudTracksDetailFromJson(Map<String, dynamic> json) =>
    CloudTracksDetail(
      tracks: (json['tracks'] as List<dynamic>)
          .map((e) => Track.fromJson(e as Map<String, dynamic>))
          .toList(),
      size: json['size'] as int,
      maxSize: json['maxSize'] as int,
      trackCount: json['trackCount'] as int,
    );

Map<String, dynamic> _$CloudTracksDetailToJson(CloudTracksDetail instance) =>
    <String, dynamic>{
      'tracks': instance.tracks,
      'size': instance.size,
      'maxSize': instance.maxSize,
      'trackCount': instance.trackCount,
    };
