// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Moment _$MomentFromJson(Map<String, dynamic> json) => Moment(
      json['momentid'] as String,
      json['content'] as String,
      json['images'] as String,
      json['createtime'] as String,
      json['commentcount'] as int,
      json['likenum'] as int,
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      json['voice'] as String,
      json['coverimgwh'] as String,
      json['category'] as String,
    )..islike = json['islike'] as bool;

Map<String, dynamic> _$MomentToJson(Moment instance) => <String, dynamic>{
      'momentid': instance.momentid,
      'content': instance.content,
      'images': instance.images,
      'createtime': instance.createtime,
      'commentcount': instance.commentcount,
      'likenum': instance.likenum,
      'voice': instance.voice,
      'coverimgwh': instance.coverimgwh,
      'category': instance.category,
      'user': instance.user,
      'islike': instance.islike,
    };
