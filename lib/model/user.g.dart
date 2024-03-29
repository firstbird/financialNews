// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['uid'] as int,
      json['mobile'] as String,
      json['username'] as String,
      json['sex'] as String?,
      json['country'] as String?,
      json['province'] as String?,
      json['city'] as String?,
      json['signature'] as String,
      json['profilepicture'] as String?,
      json['pwerrorcount'] as int?,
      json['birthday'] as String?,
      json['followers'] as int?,
      json['following'] as int?,
      json['updatetime'] as String?,
      json['likenum'] as int?,
      json['token'] as String?,
      json['likeact'] as int?,
      json['collectionact'] as int?,
      json['likecomment'] as int,
      json['likeevaluate'] as int?,
      json['collectionproduct'] as int?,
      json['aliuserid'] as String,
      json['likebug'] as int,
      json['likesuggest'] as int,
      json['likebugcomment'] as int,
      json['likesuggestcomment'] as int,
      json['likegoodpricecomment'] as int,
      json['notinteresteduids'] as String?,
      json['blacklist'] as String?,
      json['goodpricenotinteresteduids'] as String?,
      json['usertype'] as int?,
      json['interest'] as String?,
      json['voice'] as String?,
      json['isNew'] as bool?,
      json['business'] as int,
      json['likemoment'] as int,
      json['likemomentcomment'] as int,
      json['wxuserid'] as String,
      json['iosuserid'] as String,
      json['subject'] as String,
      json['career'] as String,
      json['height'] as int,
      json['education'] as String,
      json['earning'] as String,
      json['earningImage'] as String,
      json['educationImage'] as String,
    )..isfollow = json['isfollow'] as bool;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uid': instance.uid,
      'username': instance.username,
      'sex': instance.sex,
      'country': instance.country,
      'province': instance.province,
      'city': instance.city,
      'signature': instance.signature,
      'profilepicture': instance.profilepicture,
      'pwerrorcount': instance.pwerrorcount,
      'birthday': instance.birthday,
      'followers': instance.followers,
      'following': instance.following,
      'isfollow': instance.isfollow,
      'updatetime': instance.updatetime,
      'likenum': instance.likenum,
      'token': instance.token,
      'likeact': instance.likeact,
      'collectionact': instance.collectionact,
      'likecomment': instance.likecomment,
      'likeevaluate': instance.likeevaluate,
      'collectionproduct': instance.collectionproduct,
      'aliuserid': instance.aliuserid,
      'wxuserid': instance.wxuserid,
      'iosuserid': instance.iosuserid,
      'likebug': instance.likebug,
      'likesuggest': instance.likesuggest,
      'likebugcomment': instance.likebugcomment,
      'likesuggestcomment': instance.likesuggestcomment,
      'likemoment': instance.likemoment,
      'likemomentcomment': instance.likemomentcomment,
      'likegoodpricecomment': instance.likegoodpricecomment,
      'mobile': instance.mobile,
      'notinteresteduids': instance.notinteresteduids,
      'blacklist': instance.blacklist,
      'goodpricenotinteresteduids': instance.goodpricenotinteresteduids,
      'usertype': instance.usertype,
      'interest': instance.interest,
      'voice': instance.voice,
      'isNew': instance.isNew,
      'business': instance.business,
      'subject': instance.subject,
      'career': instance.career,
      'height': instance.height,
      'education': instance.education,
      'earning': instance.earning,
      'educationImage': instance.educationImage,
      'earningImage': instance.earningImage,
    };
