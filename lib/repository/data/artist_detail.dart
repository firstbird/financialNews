import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import 'track.dart';

part 'artist_detail.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class ArtistDetail {
  ArtistDetail({
    required this.hotSongs,
    required this.more,
    required this.artist,
  });

  @HiveField(0)
  final List<Track> hotSongs;

  @HiveField(1)
  final bool more;

  @HiveField(2)
  final Artist artist;
}

@JsonSerializable()
@HiveType(typeId: 1)
class Artist with EquatableMixin {
  Artist({
    required this.name,
    required this.id,
    required this.publishTime,
    required this.image1v1Url,
    required this.picUrl,
    required this.albumSize,
    required this.mvSize,
    required this.musicSize,
    required this.followed,
    required this.briefDesc,
    required this.alias,
  });

  // factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);

  @HiveField(0)
  final String name;
  @HiveField(1)
  final int id;

  @HiveField(2)
  final int publishTime;
  @HiveField(3)
  final String image1v1Url;
  @HiveField(4)
  final String picUrl;

  @HiveField(5)
  final int albumSize;
  @HiveField(6)
  final int mvSize;
  @HiveField(7)
  final int musicSize;

  @HiveField(8)
  final bool followed;

  @HiveField(9)
  final String briefDesc;

  @HiveField(10)
  final List<String> alias;

  @override
  List<Object?> get props => [
        name,
        id,
        publishTime,
        image1v1Url,
        picUrl,
        albumSize,
        mvSize,
        musicSize,
        followed,
        briefDesc,
        alias,
      ];

  static fromJson(Map<String, dynamic> json) {}

  // Map<String, dynamic> toJson() => _$ArtistToJson(this);
}
