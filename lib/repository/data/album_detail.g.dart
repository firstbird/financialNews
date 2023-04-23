// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlbumDetailAdapter extends TypeAdapter<AlbumDetail> {
  @override
  final int typeId = 0;

  @override
  AlbumDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlbumDetail(
      album: fields[0] as Album,
      tracks: (fields[1] as List).cast<Track>(),
    );
  }

  @override
  void write(BinaryWriter writer, AlbumDetail obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.album)
      ..writeByte(1)
      ..write(obj.tracks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlbumDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumDetail _$AlbumDetailFromJson(Map<String, dynamic> json) => AlbumDetail(
      album: Album.fromJson(json['album'] as Map<String, dynamic>),
      tracks: (json['tracks'] as List<dynamic>)
          .map((e) => Track.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AlbumDetailToJson(AlbumDetail instance) =>
    <String, dynamic>{
      'album': instance.album,
      'tracks': instance.tracks,
    };

Album _$AlbumFromJson(Map<String, dynamic> json) => Album(
      name: json['name'] as String,
      id: json['id'] as int,
      briefDesc: json['briefDesc'] as String,
      publishTime: DateTime.parse(json['publishTime'] as String),
      company: json['company'] as String,
      picUrl: json['picUrl'] as String,
      description: json['description'] as String,
      artist: ArtistMini.fromJson(json['artist'] as Map<String, dynamic>),
      paid: json['paid'] as bool,
      onSale: json['onSale'] as bool,
      size: json['size'] as int,
      liked: json['liked'] as bool,
      commentCount: json['commentCount'] as int,
      likedCount: json['likedCount'] as int,
      shareCount: json['shareCount'] as int,
    );

Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'briefDesc': instance.briefDesc,
      'publishTime': instance.publishTime.toIso8601String(),
      'company': instance.company,
      'picUrl': instance.picUrl,
      'description': instance.description,
      'artist': instance.artist,
      'paid': instance.paid,
      'onSale': instance.onSale,
      'size': instance.size,
      'liked': instance.liked,
      'commentCount': instance.commentCount,
      'likedCount': instance.likedCount,
      'shareCount': instance.shareCount,
    };
