// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      json['reportid'] as String?,
      json['uid'] as int?,
      json['actid'] as String,
      json['createtime'] as String,
      json['updatetime'] as String,
      json['repleycontent'] as String,
      json['reporttype'] as int,
      json['sourcetype'] as int?,
      json['activity'] == null
          ? null
          : Activity.fromJson(json['activity'] as Map<String, dynamic>),
      json['goodPiceModel'] == null
          ? null
          : GoodPiceModel.fromJson(
              json['goodPiceModel'] as Map<String, dynamic>),
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'reportid': instance.reportid,
      'uid': instance.uid,
      'actid': instance.actid,
      'createtime': instance.createtime,
      'updatetime': instance.updatetime,
      'repleycontent': instance.repleycontent,
      'reporttype': instance.reporttype,
      'sourcetype': instance.sourcetype,
      'activity': instance.activity,
      'goodPiceModel': instance.goodPiceModel,
      'user': instance.user,
    };
