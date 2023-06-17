// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skuspecs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Skuspecs _$SkuspecsFromJson(Map<String, dynamic> json) => Skuspecs(
      json['specsid'] as String,
      json['goodpriceid'] as String,
      json['spdata'] as String,
      (json['cost'] as num).toDouble(),
      json['pic'] as String,
    );

Map<String, dynamic> _$SkuspecsToJson(Skuspecs instance) => <String, dynamic>{
      'specsid': instance.specsid,
      'goodpriceid': instance.goodpriceid,
      'spdata': instance.spdata,
      'cost': instance.cost,
      'pic': instance.pic,
    };
