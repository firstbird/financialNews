import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../../model/user.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];

}
///验证当前登录状态
class LoggedState extends AuthenticationEvent {}
///更新用户信息到本地文件
class LoggedIn extends AuthenticationEvent {
  final User user;

  LoggedIn({required this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'LoggedIn { token: $user }';
}
///注销登录
class LoggedOut extends AuthenticationEvent {
  const LoggedOut();
}
///登录验证
class LoginButtonPressed extends AuthenticationEvent{
  final String mobile;
  final String password;
  ///短信验证码
  final String vcode;
  ///验证类型,1密码 2验证码
  final int type;
  ///图片验证码
  final String captchaVerification;
  final String country;

  const LoginButtonPressed({
    required this.mobile,
    required this.password,
    required this.vcode,
    required this.type,
    required this.captchaVerification,
    required this.country
  });
  @override
  List<Object> get props => [mobile, password, vcode, type, captchaVerification, country];

  @override
  String toString() =>
      'LoginButtonPressed { username: $mobile, password: $password, vode: $vcode, $type }';
}
///支付宝登录
class LoginAli extends AuthenticationEvent {
  const LoginAli();
}
///微信登录
class LoginWeiXin extends AuthenticationEvent {
  final String auth_code;
  const LoginWeiXin({required this.auth_code});
}
///ios登录
class LoginIos extends AuthenticationEvent {
  final String identityToken;
  final String iosuserid;
  const LoginIos({required this.identityToken,  required this.iosuserid});
}
///更新照片
class UpdateImagePressed extends AuthenticationEvent{
  final User user;
  final String imgpath;
  final String serverimgpath;


  const UpdateImagePressed({
    required this.user,
    required this.imgpath,
    this.serverimgpath = ""

  });
  @override
  List<Object> get props => [user, imgpath, serverimgpath];

  @override
  String toString() =>
      'LoginButtonPressed { user: $user, imgpath: $imgpath, serverimgpath: $serverimgpath }';
}

///更新Education image
class UpdateEducationImagePressed extends AuthenticationEvent{
  final User user;
  final String imgpath;
  final String serverimgpath;


  const UpdateEducationImagePressed({
    required this.user,
    required this.imgpath,
    this.serverimgpath = ""

  });
  @override
  List<Object> get props => [user, imgpath, serverimgpath];

  @override
  String toString() =>
      'UpdateEducationImagePressed { user: $user, imgpath: $imgpath, serverimgpath: $serverimgpath }';
}

///更新Education image
class UpdateEarningImagePressed extends AuthenticationEvent{
  final User user;
  final String imgpath;
  final String serverimgpath;


  const UpdateEarningImagePressed({
    required this.user,
    required this.imgpath,
    this.serverimgpath = ""

  });
  @override
  List<Object> get props => [user, imgpath, serverimgpath];

  @override
  String toString() =>
      'UpdateEarningImagePressed { user: $user, imgpath: $imgpath, serverimgpath: $serverimgpath }';
}

///更新昵称
class UpdateUserNamePressed extends AuthenticationEvent{
  final User user;
  final String username;

  const UpdateUserNamePressed({
    required this.user,
    required this.username
  });
  @override
  List<Object> get props => [user, username];

  @override
  String toString() =>
      'UpdateUserNamePressed { user: $user, imgpath: $username }';
}

///更新身高
class UpdateUserHeightPressed extends AuthenticationEvent{
  final User user;
  final int height;

  const UpdateUserHeightPressed({
    required this.user,
    required this.height
  });
  @override
  List<Object> get props => [user, height];

  @override
  String toString() =>
      'UpdateUserHeightPressed { user: $user, height: $height }';
}
///更新所在地
class UpdateUserLocationPressed extends AuthenticationEvent{
  final User user;
  final String province;
  final String city;

  const UpdateUserLocationPressed({
    required this.user,
    required this.province,
    required this.city,
  });
  @override
  List<Object> get props => [user, province, city];

  @override
  String toString() =>
      'UpdateUserLocationPressed { user: $user, province: $province, city: $city }';
}

///更新职业
class UpdateCareerPressed extends AuthenticationEvent{
  final User user;
  final String career;

  const UpdateCareerPressed({
    required this.user,
    required this.career,
  });
  @override
  List<Object> get props => [user, career];

  @override
  String toString() =>
      'UpdateCareerPressed { user: $user, career: $career }';
}

///更新职业
class UpdateEducationPressed extends AuthenticationEvent{
  final User user;
  final String education;

  const UpdateEducationPressed({
    required this.user,
    required this.education,
  });
  @override
  List<Object> get props => [user, education];

  @override
  String toString() =>
      'UpdateEducationPressed { user: $user, education: $education }';
}

///更新收入
class UpdateEarningPressed extends AuthenticationEvent{
  final User user;
  final String earning;

  const UpdateEarningPressed({
    required this.user,
    required this.earning,
  });
  @override
  List<Object> get props => [user, earning];

  @override
  String toString() =>
      'UpdateEarningPressed { user: $user, education: $earning }';
}

///更新密码
class UpdateUserPasswordPressed extends AuthenticationEvent{
  final User user;
  final String password;

  const UpdateUserPasswordPressed({
    required this.user,
    required this.password,
  });
  @override
  List<Object> get props => [user, password];

  @override
  String toString() =>
      'UpdateUserNamePressed { user: $user, password: $password }';
}
///更新性别
class UpdateUserSexPressed extends AuthenticationEvent{
  final User user;
  final String sex;

  const UpdateUserSexPressed({
    required this.user,
    required this.sex,
  });
  @override
  List<Object> get props => [user, sex];

  @override
  String toString() =>
      'UpdateUserNamePressed { user: $user, password: $sex }';
}
///更新生日
class UpdateUserBirthdayPressed extends AuthenticationEvent{
  final User user;
  final String birthday;

  const UpdateUserBirthdayPressed({
    required this.user,
    required this.birthday,
  });
  @override
  List<Object> get props => [user, birthday];

  @override
  String toString() =>
      'UpdateUserNamePressed { user: $user, password: $birthday }';
}
///更新个人简介
class UpdateUserSignaturePressed extends AuthenticationEvent{
  final User user;
  final String signature;

  const UpdateUserSignaturePressed({
    required this.user,
    required this.signature,
  });
  @override
  List<Object> get props => [user, signature];

  @override
  String toString() =>
      'UpdateUserNamePressed { user: $user, password: $signature }';
}
//更新定位
class UpdateLocation extends AuthenticationEvent{
  final String locationCode;
  final String locationName;

  const UpdateLocation({
    required this.locationCode,
    required this.locationName,
  });
  @override
  List<Object> get props => [locationCode, locationName];

  @override
  String toString() =>
      'UpdateLocation { locationCode: $locationCode, locationName: $locationName }';
}

///更新个人爱好
class UpdateUserInterest extends AuthenticationEvent{
  final User user;
  final String interest;

  const UpdateUserInterest({
    required this.user,
    required this.interest,
  });
  @override
  List<Object> get props => [user, interest];

  @override
  String toString() =>
      'UpdateUserInterest { user: $user, password: $interest }';
}

///主动刷新
///个人主页默认为保存状态，需手动下拉刷新更新数据
class Refresh extends AuthenticationEvent{

}

class initUpdate extends AuthenticationEvent{

}

///主动刷新
///个人主页默认为保存状态，需手动下拉刷新更新数据
class Refresh1 extends AuthenticationEvent{

}
