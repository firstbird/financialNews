// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persistence_player_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersistencePlayerState _$PersistencePlayerStateFromJson(
        Map<String, dynamic> json) =>
    PersistencePlayerState(
      volume: (json['volume'] as num).toDouble(),
      playingTrack: json['playingTrack'] == null
          ? null
          : Track.fromJson(json['playingTrack'] as Map<String, dynamic>),
      playingList:
          TrackList.fromJson(json['playingList'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PersistencePlayerStateToJson(
        PersistencePlayerState instance) =>
    <String, dynamic>{
      'volume': instance.volume,
      'playingTrack': instance.playingTrack,
      'playingList': instance.playingList,
    };
