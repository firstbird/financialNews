import 'package:azlistview/azlistview.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
@HiveType(typeId: 6)
class User extends ISuspensionBean with EquatableMixin {
  User({
      required this.id,
      required this.userId,
      required this.profileImageUrl,
      required this.username,
      required this.passwd,
      required this.email,
      required this.lastLogin,
      required this.issuperuser,
      required this.firstName,
      required this.lastName,
      required this.isactive,
      required this.dateJoined,
      required this.about,
      required this.userLevel,
      required this.lft,
      required this.parentId,
      required this.userRight,
      required this.treeId,
      required this.usedInvitationId,
      required this.mobile,
      required this.gender,
      required this.zoneCode,
      required this.region,
      required this.vipType,
      required this.tagIndex,
      required this.followers,
      required this.followed,
      required this.backgroundUrl,
      required this.featureSignature
  });

  @HiveField(0)
  final int id;
  @HiveField(1)
  final String userId;// todo mzl contact
  @HiveField(2)
  final String profileImageUrl;// todo mzl contact
  @HiveField(3)
  final String username;
  @HiveField(4)
  final String passwd;
  @HiveField(5)
  final String email;
  @HiveField(6)
  final String lastLogin;
  @HiveField(7)
  final bool issuperuser;
  @HiveField(8)
  final String firstName;
  @HiveField(9)
  final String lastName;
  @HiveField(10)
  final bool isactive;
  @HiveField(11)
  final String dateJoined;
  @HiveField(12)
  final String about;
  @HiveField(13)
  final int userLevel;
  @HiveField(14)
  final int lft;
  @HiveField(15)
  final int parentId;
  @HiveField(16)
  final int userRight;
  @HiveField(17)
  final int treeId;
  @HiveField(18)
  final String usedInvitationId;
  @HiveField(19)
  final String mobile;
  @HiveField(20)
  final int gender;
  @HiveField(21)
  final String zoneCode; // todo mzl contact
  @HiveField(22)
  final String region; // todo mzl contact
  @HiveField(23)
  final int vipType; // todo mzl contact
  @HiveField(24)
  final String tagIndex;
  @HiveField(25)
  final int followers;
  @HiveField(26)
  final bool followed;
  @HiveField(27)
  final String backgroundUrl;
  @HiveField(28)
  final String featureSignature;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [
          id,
          userId,
          profileImageUrl,
          username,
          passwd,
          email,
          lastLogin,
          issuperuser,
          firstName,
          lastName,
          isactive,
          dateJoined,
          about,
          userLevel,
          lft,
          parentId,
          userRight,
          treeId,
          usedInvitationId,
          mobile,
          gender,
          zoneCode,
          region,
          vipType,
          tagIndex,
          followers,
          followed,
          backgroundUrl,
          featureSignature
      ];

  @override
  String getSuspensionTag() => tagIndex;
}
