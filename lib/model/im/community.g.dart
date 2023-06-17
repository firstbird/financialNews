// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Community _$CommunityFromJson(Map<String, dynamic> json) => Community(
      json['cid'] as String,
      json['communityname'] as String,
      json['categoryid'] as int,
      json['province'] as String,
      json['city'] as String,
      json['joinrule'] as String,
      json['notice'] as String,
      json['clubicon'] as String,
      json['grade'] as String,
      json['score'] as String,
      json['status'] as String,
      (json['star'] as num).toDouble(),
      json['limitnum'] as int,
      json['membernum'] as int,
      json['username'] as String,
      json['uid'] as int,
      json['activitynum'] as int,
      json['activityimages'] as String,
      json['evaluatenum'] as int,
    )..members = (json['members'] as List<dynamic>?)
        ?.map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$CommunityToJson(Community instance) => <String, dynamic>{
      'cid': instance.cid,
      'communityname': instance.communityname,
      'uid': instance.uid,
      'categoryid': instance.categoryid,
      'province': instance.province,
      'city': instance.city,
      'joinrule': instance.joinrule,
      'notice': instance.notice,
      'clubicon': instance.clubicon,
      'grade': instance.grade,
      'score': instance.score,
      'username': instance.username,
      'members': instance.members,
      'status': instance.status,
      'star': instance.star,
      'limitnum': instance.limitnum,
      'membernum': instance.membernum,
      'activitynum': instance.activitynum,
      'activityimages': instance.activityimages,
      'evaluatenum': instance.evaluatenum,
    };
