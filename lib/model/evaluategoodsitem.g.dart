// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evaluategoodsitem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EvaluateGoodsItem _$EvaluateGoodsItemFromJson(Map<String, dynamic> json) =>
    EvaluateGoodsItem(
      json['evaluateid'] as int?,
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      json['content'] as String?,
      json['likenum'] as int?,
      json['createtime'] as String?,
      json['likeuid'] as int?,
      json['imagepaths'] as String?,
      json['touid'] as int?,
      json['liketype'] as int?,
      json['coverimg'] as String?,
      json['orderid'] as String,
      json['goodpriceid'] as String,
    )..goodsitemcontent = json['goodsitemcontent'] as String?;

Map<String, dynamic> _$EvaluateGoodsItemToJson(EvaluateGoodsItem instance) =>
    <String, dynamic>{
      'evaluateid': instance.evaluateid,
      'user': instance.user,
      'touid': instance.touid,
      'content': instance.content,
      'imagepaths': instance.imagepaths,
      'liketype': instance.liketype,
      'likenum': instance.likenum,
      'likeuid': instance.likeuid,
      'createtime': instance.createtime,
      'goodsitemcontent': instance.goodsitemcontent,
      'coverimg': instance.coverimg,
      'orderid': instance.orderid,
      'goodpriceid': instance.goodpriceid,
    };
