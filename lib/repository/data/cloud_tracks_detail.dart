import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import 'track.dart';

part 'cloud_tracks_detail.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class CloudTracksDetail {
  CloudTracksDetail({
    required this.tracks,
    required this.size,
    required this.maxSize,
    required this.trackCount,
  });

  // factory CloudTracksDetail.fromJson(Map<String, dynamic> json) =>
  //     _$CloudTracksDetailFromJson(json);

  @HiveField(0)
  final List<Track> tracks;
  @HiveField(1)
  final int size;
  @HiveField(2)
  final int maxSize;
  @HiveField(3)
  final int trackCount;

  // Map<String, dynamic> toJson() => _$CloudTracksDetailToJson(this);
}
