// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) => Subscription(
      json['id'] as int?,
      json['uid'] as int?,
      json['subsid'] as String?,
      json['substime'] as String?,
      json['expiretime'] as String?,
      json['type'] as int?,
    );

Map<String, dynamic> _$SubscriptionToJson(Subscription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'subsid': instance.subsid,
      'substime': instance.substime,
      'expiretime': instance.expiretime,
      'type': instance.type,
    };
