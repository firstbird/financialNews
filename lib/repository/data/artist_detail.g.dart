// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArtistDetailAdapter extends TypeAdapter<ArtistDetail> {
  @override
  final int typeId = 1;

  @override
  ArtistDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArtistDetail(
      hotSongs: (fields[0] as List).cast<Track>(),
      more: fields[1] as bool,
      artist: fields[2] as Artist,
    );
  }

  @override
  void write(BinaryWriter writer, ArtistDetail obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.hotSongs)
      ..writeByte(1)
      ..write(obj.more)
      ..writeByte(2)
      ..write(obj.artist);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtistDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ArtistAdapter extends TypeAdapter<Artist> {
  @override
  final int typeId = 1;

  @override
  Artist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Artist(
      name: fields[0] as String,
      id: fields[1] as int,
      publishTime: fields[2] as int,
      image1v1Url: fields[3] as String,
      picUrl: fields[4] as String,
      albumSize: fields[5] as int,
      mvSize: fields[6] as int,
      musicSize: fields[7] as int,
      followed: fields[8] as bool,
      briefDesc: fields[9] as String,
      alias: (fields[10] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Artist obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.publishTime)
      ..writeByte(3)
      ..write(obj.image1v1Url)
      ..writeByte(4)
      ..write(obj.picUrl)
      ..writeByte(5)
      ..write(obj.albumSize)
      ..writeByte(6)
      ..write(obj.mvSize)
      ..writeByte(7)
      ..write(obj.musicSize)
      ..writeByte(8)
      ..write(obj.followed)
      ..writeByte(9)
      ..write(obj.briefDesc)
      ..writeByte(10)
      ..write(obj.alias);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtistDetail _$ArtistDetailFromJson(Map<String, dynamic> json) => ArtistDetail(
      hotSongs: (json['hotSongs'] as List<dynamic>)
          .map((e) => Track.fromJson(e as Map<String, dynamic>))
          .toList(),
      more: json['more'] as bool,
      artist: Artist.fromJson(json['artist'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ArtistDetailToJson(ArtistDetail instance) =>
    <String, dynamic>{
      'hotSongs': instance.hotSongs,
      'more': instance.more,
      'artist': instance.artist,
    };

Artist _$ArtistFromJson(Map<String, dynamic> json) => Artist(
      name: json['name'] as String,
      id: json['id'] as int,
      publishTime: json['publishTime'] as int,
      image1v1Url: json['image1v1Url'] as String,
      picUrl: json['picUrl'] as String,
      albumSize: json['albumSize'] as int,
      mvSize: json['mvSize'] as int,
      musicSize: json['musicSize'] as int,
      followed: json['followed'] as bool,
      briefDesc: json['briefDesc'] as String,
      alias: (json['alias'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ArtistToJson(Artist instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'publishTime': instance.publishTime,
      'image1v1Url': instance.image1v1Url,
      'picUrl': instance.picUrl,
      'albumSize': instance.albumSize,
      'mvSize': instance.mvSize,
      'musicSize': instance.musicSize,
      'followed': instance.followed,
      'briefDesc': instance.briefDesc,
      'alias': instance.alias,
    };
