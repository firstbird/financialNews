// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 6;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int,
      userId: fields[1] as String,
      profileImageUrl: fields[2] as String,
      username: fields[3] as String,
      passwd: fields[4] as String,
      email: fields[5] as String,
      lastLogin: fields[6] as String,
      issuperuser: fields[7] as bool,
      firstName: fields[8] as String,
      lastName: fields[9] as String,
      isactive: fields[10] as bool,
      dateJoined: fields[11] as String,
      about: fields[12] as String,
      userLevel: fields[13] as int,
      lft: fields[14] as int,
      parentId: fields[15] as int,
      userRight: fields[16] as int,
      treeId: fields[17] as int,
      usedInvitationId: fields[18] as String,
      mobile: fields[19] as String,
      gender: fields[20] as int,
      zoneCode: fields[21] as String,
      region: fields[22] as String,
      vipType: fields[23] as int,
      tagIndex: fields[24] as String,
      followers: fields[25] as int,
      followed: fields[26] as bool,
      backgroundUrl: fields[27] as String,
      featureSignature: fields[28] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(29)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.profileImageUrl)
      ..writeByte(3)
      ..write(obj.username)
      ..writeByte(4)
      ..write(obj.passwd)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.lastLogin)
      ..writeByte(7)
      ..write(obj.issuperuser)
      ..writeByte(8)
      ..write(obj.firstName)
      ..writeByte(9)
      ..write(obj.lastName)
      ..writeByte(10)
      ..write(obj.isactive)
      ..writeByte(11)
      ..write(obj.dateJoined)
      ..writeByte(12)
      ..write(obj.about)
      ..writeByte(13)
      ..write(obj.userLevel)
      ..writeByte(14)
      ..write(obj.lft)
      ..writeByte(15)
      ..write(obj.parentId)
      ..writeByte(16)
      ..write(obj.userRight)
      ..writeByte(17)
      ..write(obj.treeId)
      ..writeByte(18)
      ..write(obj.usedInvitationId)
      ..writeByte(19)
      ..write(obj.mobile)
      ..writeByte(20)
      ..write(obj.gender)
      ..writeByte(21)
      ..write(obj.zoneCode)
      ..writeByte(22)
      ..write(obj.region)
      ..writeByte(23)
      ..write(obj.vipType)
      ..writeByte(24)
      ..write(obj.tagIndex)
      ..writeByte(25)
      ..write(obj.followers)
      ..writeByte(26)
      ..write(obj.followed)
      ..writeByte(27)
      ..write(obj.backgroundUrl)
      ..writeByte(28)
      ..write(obj.featureSignature);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      userId: json['userId'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      username: json['username'] as String,
      passwd: json['passwd'] as String,
      email: json['email'] as String,
      lastLogin: json['lastLogin'] as String,
      issuperuser: json['issuperuser'] as bool,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      isactive: json['isactive'] as bool,
      dateJoined: json['dateJoined'] as String,
      about: json['about'] as String,
      userLevel: json['userLevel'] as int,
      lft: json['lft'] as int,
      parentId: json['parentId'] as int,
      userRight: json['userRight'] as int,
      treeId: json['treeId'] as int,
      usedInvitationId: json['usedInvitationId'] as String,
      mobile: json['mobile'] as String,
      gender: json['gender'] as int,
      zoneCode: json['zoneCode'] as String,
      region: json['region'] as String,
      vipType: json['vipType'] as int,
      tagIndex: json['tagIndex'] as String,
      followers: json['followers'] as int,
      followed: json['followed'] as bool,
      backgroundUrl: json['backgroundUrl'] as String,
      featureSignature: json['featureSignature'] as String,
    )..isShowSuspension = json['isShowSuspension'] as bool;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'isShowSuspension': instance.isShowSuspension,
      'id': instance.id,
      'userId': instance.userId,
      'profileImageUrl': instance.profileImageUrl,
      'username': instance.username,
      'passwd': instance.passwd,
      'email': instance.email,
      'lastLogin': instance.lastLogin,
      'issuperuser': instance.issuperuser,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'isactive': instance.isactive,
      'dateJoined': instance.dateJoined,
      'about': instance.about,
      'userLevel': instance.userLevel,
      'lft': instance.lft,
      'parentId': instance.parentId,
      'userRight': instance.userRight,
      'treeId': instance.treeId,
      'usedInvitationId': instance.usedInvitationId,
      'mobile': instance.mobile,
      'gender': instance.gender,
      'zoneCode': instance.zoneCode,
      'region': instance.region,
      'vipType': instance.vipType,
      'tagIndex': instance.tagIndex,
      'followers': instance.followers,
      'followed': instance.followed,
      'backgroundUrl': instance.backgroundUrl,
      'featureSignature': instance.featureSignature,
    };
