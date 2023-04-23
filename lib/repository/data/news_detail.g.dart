// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewsDetailAdapter extends TypeAdapter<NewsDetail> {
  @override
  final int typeId = 3;

  @override
  NewsDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewsDetail(
      id: fields[0] as int,
      creator: fields[1] as User,
      coverImageUrl: fields[2] as String,
      subscribed: fields[3] as bool,
      subscribedCount: fields[4] as int,
      shareCount: fields[5] as int,
      readCount: fields[6] as int,
      text: fields[7] as String,
      title: fields[8] as String,
      commentCount: fields[9] as int,
      createTime: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, NewsDetail obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.creator)
      ..writeByte(2)
      ..write(obj.coverImageUrl)
      ..writeByte(3)
      ..write(obj.subscribed)
      ..writeByte(4)
      ..write(obj.subscribedCount)
      ..writeByte(5)
      ..write(obj.shareCount)
      ..writeByte(6)
      ..write(obj.readCount)
      ..writeByte(7)
      ..write(obj.text)
      ..writeByte(8)
      ..write(obj.title)
      ..writeByte(9)
      ..write(obj.commentCount)
      ..writeByte(10)
      ..write(obj.createTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsDetail _$NewsDetailFromJson(Map<String, dynamic> json) => NewsDetail(
      id: json['id'] as int,
      creator: User.fromJson(json['creator'] as Map<String, dynamic>),
      coverImageUrl: json['coverImageUrl'] as String,
      subscribed: json['subscribed'] as bool,
      subscribedCount: json['subscribedCount'] as int,
      shareCount: json['shareCount'] as int,
      readCount: json['readCount'] as int,
      text: json['text'] as String,
      title: json['title'] as String,
      commentCount: json['commentCount'] as int,
      createTime: DateTime.parse(json['createTime'] as String),
    );

Map<String, dynamic> _$NewsDetailToJson(NewsDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creator': instance.creator,
      'coverImageUrl': instance.coverImageUrl,
      'subscribed': instance.subscribed,
      'subscribedCount': instance.subscribedCount,
      'shareCount': instance.shareCount,
      'readCount': instance.readCount,
      'text': instance.text,
      'title': instance.title,
      'commentCount': instance.commentCount,
      'createTime': instance.createTime.toIso8601String(),
    };
