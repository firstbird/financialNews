import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'track.dart';

import 'user.dart';

part 'news_detail.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class NewsDetail with EquatableMixin {
  NewsDetail({
    required this.id,
    required this.creator,
    required this.coverImageUrl,
    required this.subscribed,
    required this.subscribedCount,
    required this.shareCount,
    required this.readCount,
    required this.text,
    required this.title,
    required this.commentCount,
    required this.createTime,
  });

  factory NewsDetail.fromJson(Map<String, dynamic> json) =>
      _$PlaylistDetailFromJson(json);

  @HiveField(0)
  final int id;

  @HiveField(1)
  final User creator;

  @HiveField(2)
  final String coverImageUrl;

  @HiveField(3)
  final bool subscribed;

  @HiveField(4)
  final int subscribedCount;

  @HiveField(5)
  final int shareCount;

  @HiveField(6)
  final int readCount;

  @HiveField(7)
  final String text;

  @HiveField(8)
  final String title;

  @HiveField(9)
  final int commentCount;

  @HiveField(10)
  final DateTime createTime;

  @override
  List<Object?> get props => [
        id,
        creator,
        coverImageUrl,
        subscribed,
        subscribedCount,
        shareCount,
        readCount,
        text,
        title,
        commentCount,
        createTime,
      ];

  Map<String, dynamic> toJson() => _$PlaylistDetailToJson(this);

  NewsDetail copyWith({
    List<Track>? tracks,
    User? creator,
    String? coverUrl,
    int? trackCount,
    bool? subscribed,
    int? subscribedCount,
    int? shareCount,
    int? playCount,
    int? trackUpdateTime,
    String? name,
    String? description,
    int? commentCount,
    List<int>? trackIds,
    DateTime? createTime,
  }) {
    return NewsDetail(
      id: id,
      creator: creator ?? this.creator,
      coverImageUrl: coverUrl ?? this.coverImageUrl,
      subscribed: subscribed ?? this.subscribed,
      subscribedCount: subscribedCount ?? this.subscribedCount,
      shareCount: shareCount ?? this.shareCount,
      readCount: playCount ?? this.readCount,
      text: name ?? this.text,
      title: description ?? this.title,
      commentCount: commentCount ?? this.commentCount,
      createTime: createTime ?? this.createTime,
    );
  }
}
