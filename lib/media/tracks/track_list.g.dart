// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackList _$TrackListFromJson(Map<String, dynamic> json) => TrackList._private(
      id: json['id'] as String,
      tracks: (json['tracks'] as List<dynamic>)
          .map((e) => Track.fromJson(e as Map<String, dynamic>))
          .toList(),
      isFM: json['isFM'] as bool,
    );

Map<String, dynamic> _$TrackListToJson(TrackList instance) => <String, dynamic>{
      'id': instance.id,
      'tracks': instance.tracks,
      'isFM': instance.isFM,
    };
