import 'dart:async';
import 'package:recipe/service/userservice.dart';
import 'package:recipe/util/token_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/activity.dart';
import '../../service/gpservice.dart';
import '../../model/user.dart';
import '../../util/networkmanager_util.dart';
import '../../global.dart';
import 'user_repository.dart';
import 'event/authentication_event.dart';
import 'state/authentication_state.dart';
export 'event/authentication_event.dart';
export 'state/authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  String errorNetCode = "-9999";
  String errorNet = "网络异常，请再试一下";

  String error = "";
  String errorstatusCode = "";
  final UserRepository userRepository = new UserRepository();
  final ActivityService activityService = ActivityService();
  final UserService _userService = UserService();

  AuthenticationBloc():super(AuthenticationUninitialized()) {
    ///主动刷新
    on<Refresh>((event, emit) async {
        emit(AuthenticationAuthenticated());
    });
    on<Refresh1>((event, emit) async {
      emit(AuthenticationAuthenticated());
    });
    ///信息更新
    on<LoggedIn>((event, emit) async {
      userRepository.persistToken(event.user);
      emit(AuthenticationAuthenticated());
    });
    ///注销登录
    on<LoggedOut>((event, emit) async {
      emit(LoginOuted());
    });
    ///登录按钮
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      print("[login] on LoginButtonPressed event: ${event.props[0]}--${event.props[1]}--${event.props[2]}--${event.props[3]}");
      try {
        User? user = await userRepository.loginToUser(
            mobile: event.props[0].toString(),
            password: event.props[1].toString(),
            vcode: event.props[2].toString(),
            type: event.props[3] as int,
            country: event.country,
            captchaVerification: event.captchaVerification,
            errorCallBack: errorCallBack
        );
        if(user != null) {
          print("[auth] login to user ${user.toString()}");
          await LoginSuccess(user);
          emit(AuthenticationAuthenticated());
        }
        else{
          ///验证未通过
          print("[auth] login to user failed, error: ${error}, errorstatuscode: ${errorstatusCode}");
          emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
        }

      } catch (error) {
        ///验证未通过
        print("[auth] login to user failed with exception, error: ${error}, errorstatuscode: ${errorstatusCode}");
        emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorstatusCode));
      }
    });
    on<LoggedState>((event, emit) async {
      final bool hasToUser = await userRepository.hasToUser();

      if (hasToUser) {
        emit(AuthenticationAuthenticated());
      } else {
        emit(LoginOuted());
      }
    });
    ///支付宝登录
    on<LoginAli>((event, emit) async {
      String authurl = await _userService.getAliUserAuth();
      User? user = await _userService.updateLoginali(authurl, errorCallBack);
      if(user != null){
        await LoginSuccess(user);
        emit(AuthenticationAuthenticated());
      }
    });

    ///微信登录
    on<LoginWeiXin>((event, emit) async {
      User? user = await _userService.loginweixin(event.auth_code, errorCallBack);
      if(user != null){
        await LoginSuccess(user);
        emit(AuthenticationAuthenticated());
      }
    });
    ///ios登录
    on<LoginIos>((event, emit) async {
      User? user = await _userService.loginIos(event.identityToken, event.iosuserid,  errorCallBack);
      if(user != null){
        await LoginSuccess(user);
        emit(AuthenticationAuthenticated());
      }
    });

    ///更新照片
    on<UpdateImagePressed>((event, emit) async {
      try {
        bool ret = await userRepository.updateImage(event.user, event.serverimgpath, errorCallBack);
        if(ret) {
          await userRepository.updateUserPicture(event.user, event.imgpath);
          emit(AuthenticationAuthenticated(isUserImage: true));
        }
        else{
          ///验证未通过
          emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
        }

      } catch (error) {
        ///验证未通过
         emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
      }
    });

    ///更新education认证照片
    on<UpdateEducationImagePressed>((event, emit) async {
      try {
        bool ret = await userRepository.updateEducationImage(event.user, event.serverimgpath, errorCallBack);
        if(ret) {
          // await userRepository.updateUserPicture(event.user, event.imgpath);
          event.user.educationImage = event.imgpath;
          userRepository.persistToken(event.user);
          emit(AuthenticationAuthenticated(isUserImage: true));
        }
        else{
          ///验证未通过
          emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
        }

      } catch (error) {
        ///验证未通过
        emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
      }
    });
    ///更新earning认证照片
    on<UpdateEarningImagePressed>((event, emit) async {
      try {
        bool ret = await userRepository.updateEarningImage(event.user, event.serverimgpath, errorCallBack);
        if(ret) {
          // await userRepository.updateUserPicture(event.user, event.imgpath);
          event.user.earningImage = event.imgpath;
          userRepository.persistToken(event.user);
          emit(AuthenticationAuthenticated(isUserImage: true));
        }
        else{
          ///验证未通过
          emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
        }

      } catch (error) {
        ///验证未通过
        emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
      }
    });
    ///更新昵称
    on<UpdateUserNamePressed>((event, emit) async {
      try {
        bool ret = await userRepository.updateUserName(event.user, event.username, errorCallBack);
        if(ret) {
          event.user.username = event.username;
          userRepository.persistToken(event.user);
          emit(AuthenticationAuthenticated());
        }
        else{
          ///验证未通过
          emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
        }

      } catch (error) {
        ///验证未通过
         emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
      }
    });
    ///更新身高
    on<UpdateUserHeightPressed>((event, emit) async {
      try {
        bool ret = await userRepository.updateUserHeight(event.user, event.height, errorCallBack);
        if(ret) {
          event.user.height = event.height;
          userRepository.persistToken(event.user);
          emit(AuthenticationAuthenticated());
        }
        else{
          ///验证未通过
          emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
        }

      } catch (error) {
        ///验证未通过
        emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
      }
    });
    ///更新个人简介
    // if(event is UpdateUserSignaturePressed){
    on<UpdateUserSignaturePressed>((event, emit) async {
      try {
        bool ret = await userRepository.UpdateUserSignaturePressed(event.user, event.signature, errorCallBack);
        if(ret) {
          event.user.signature = event.signature;
          userRepository.persistToken(event.user);
          emit(AuthenticationAuthenticated());
        }
        else{
          ///验证未通过
          emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
        }

      } catch (error) {
        ///验证未通过
        emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
      }
    });
    ///更新位置
    // if(event is UpdateUserLocationPressed){
    on<UpdateUserLocationPressed>((event, emit) async {
      try {
        bool ret = await userRepository.updateLocation(event.user, event.province, event.city,  errorCallBack);
        if(ret) {
          event.user.province = event.province;
          event.user.city = event.city;
          userRepository.persistToken(event.user);
          emit(AuthenticationAuthenticated());
        }
        else{
          ///验证未通过
          emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
        }

      } catch (error) {
        ///验证未通过
        emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
      }
    });
    /// 更新职业
    on<UpdateCareerPressed>((event, emit) async {
      try {
        bool ret = await userRepository.updateCareer(event.user, event.career,  errorCallBack);
        if(ret) {
          event.user.career = event.career;
          userRepository.persistToken(event.user);
          emit(AuthenticationAuthenticated());
        }
        else{
          ///验证未通过
          emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
        }
      } catch (error) {
        ///验证未通过
        emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
      }
    });
    /// 更新学历
    on<UpdateEducationPressed>((event, emit) async {
      try {
        bool ret = await userRepository.updateEducation(event.user, event.education,  errorCallBack);
        if(ret) {
          event.user.education = event.education;
          userRepository.persistToken(event.user);
          emit(AuthenticationAuthenticated());
        }
        else{
          ///验证未通过
          emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
        }
      } catch (error) {
        ///验证未通过
        emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
      }
    });
    /// 更新收入
    on<UpdateEarningPressed>((event, emit) async {
      try {
        bool ret = await userRepository.updateEarning(event.user, event.earning,  errorCallBack);
        if(ret) {
          event.user.earning = event.earning;
          userRepository.persistToken(event.user);
          emit(AuthenticationAuthenticated());
        }
        else{
          ///验证未通过
          emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
        }
      } catch (error) {
        ///验证未通过
        emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
      }
    });
    ///更新密码
    on<UpdateUserPasswordPressed>((event, emit) async {
      try {
        bool ret = await userRepository.UpdateUserPasswordPressed(event.user, event.password,  errorCallBack);
        if(ret) {
          emit(AuthenticationAuthenticated());
        }
        else{
          ///验证未通过
          emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
        }

      } catch (error) {
        ///验证未通过
        emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
      }
    });
    ///更新性别
    on<UpdateUserSexPressed>((event, emit) async {
      try {
        bool ret = await userRepository.UpdateUserSexPressed(event.user, event.sex,  errorCallBack);
        if(ret) {
          event.user.sex = event.sex;
          userRepository.persistToken(event.user);
          emit(AuthenticationAuthenticated());
        }
        else{
          ///验证未通过
          emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
        }

      } catch (error) {
        ///验证未通过
        emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
      }
    });
    ///更新生日
    on<UpdateUserBirthdayPressed>((event, emit) async {
      try {
        bool ret = await userRepository.UpdateUserBirthdayPressed(event.user, event.birthday,  errorCallBack);
        if(ret) {
          event.user.birthday = event.birthday;
          userRepository.persistToken(event.user);
          emit(AuthenticationAuthenticated());
        }
        else{
          ///验证未通过
          emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
        }

      } catch (error) {
        ///验证未通过
        emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
      }
    });
    ///更新定位
    on<UpdateLocation>((event, emit) async {
      emit(UpdateLocationed(locationName: event.locationName, locationCode: event.locationCode));
    });
    //初始化用户信息更新
    on<initUpdate>((event, emit) async {
      emit(AuthenticationAuthenticated());
    });
    ///更新兴趣
    on<UpdateUserInterest>((event, emit) async {
      try {
        bool ret = await userRepository.UpdateUserInterest(event.user, event.interest, errorCallBack);
        if(ret) {
          event.user.interest = event.interest;
          userRepository.persistToken(event.user);
          emit(AuthenticationAuthenticated());
        }
        else{
          ///验证未通过
          emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
        }

      } catch (error) {
        ///验证未通过
        emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
      }
    });

  }

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event,
      ) async* {
    //主动刷新
    // if(event is Refresh){
    //   emit(AuthenticationAuthenticated();
    //   return;
    // }
    //
    // if(event is Refresh1){
    //   emit(AuthenticationAuthenticated();
    //   return;
    // }

    // if (event is LoggedState) {
    //   final bool hasToUser = await userRepository.hasToUser();
    //
    //   if (hasToUser) {
    //     emit(AuthenticationAuthenticated();
    //   } else {
    //     emit(LoginOuted();
    //   }
    // }
    ///信息更新
    // if (event is LoggedIn) {
    //   userRepository.persistToken(event.user);
    //   emit(AuthenticationAuthenticated();
    // }
    // ///注销登录
    // if (event is LoggedOut) {
    //   emit(LoginOuted();
    // }
    ///登录按钮
    // if(event is LoginButtonPressed) {
    //   // emit(LoginLoading();
    //   try {
    //     User? user = await userRepository.loginToUser(
    //         mobile: event.props[0].toString(),
    //         password: event.props[1].toString(),
    //         vcode: event.props[2].toString(),
    //         type: event.props[3] as int,
    //         country: event.country,
    //         captchaVerification: event.captchaVerification,
    //         errorCallBack: errorCallBack
    //     );
    //     if(user != null) {
    //       await LoginSuccess(user);
    //       emit(AuthenticationAuthenticated();
    //     }
    //     else{
    //       ///验证未通过
    //       emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode);
    //     }
    //
    //   } catch (error) {
    //     ///验证未通过
    //     emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorstatusCode);
    //   }
    // }
    ///支付宝登录
    // if(event is LoginAli){
    //   String authurl = await _userService.getAliUserAuth();
    //   User? user = await _userService.updateLoginali(authurl, errorCallBack);
    //   if(user != null){
    //     await LoginSuccess(user);
    //     emit(AuthenticationAuthenticated();
    //   }
    // }
    // ///微信登录
    // if(event is LoginWeiXin){
    //   User? user = await _userService.loginweixin(event.auth_code, errorCallBack);
    //   if(user != null){
    //     await LoginSuccess(user);
    //     emit(AuthenticationAuthenticated());
    //   }
    // }
    // ///ios登录
    // if(event is LoginIos){
    //   User? user = await _userService.loginIos(event.identityToken, event.iosuserid,  errorCallBack);
    //   if(user != null){
    //     await LoginSuccess(user);
    //     emit(AuthenticationAuthenticated());
    //   }
    // }
    //
    // ///更新照片
    // if(event is UpdateImagePressed){
    //   try {
    //     bool ret = await userRepository.updateImage(event.user, event.serverimgpath, errorCallBack);
    //     if(ret) {
    //       await userRepository.updateUserPicture(event.user, event.imgpath);
    //       emit(AuthenticationAuthenticated(isUserImage: true));
    //     }
    //     else{
    //       ///验证未通过
    //       emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
    //     }
    //
    //   } catch (error) {
    //     ///验证未通过
    //     emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
    //   }
    // }
    // ///更新昵称
    // if(event is UpdateUserNamePressed){
    //   try {
    //     bool ret = await userRepository.updateUserName(event.user, event.username, errorCallBack);
    //     if(ret) {
    //       event.user.username = event.username;
    //       userRepository.persistToken(event.user);
    //       emit(AuthenticationAuthenticated());
    //     }
    //     else{
    //       ///验证未通过
    //       emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
    //     }
    //
    //   } catch (error) {
    //     ///验证未通过
    //     emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
    //   }
    // }
    // ///更新个人简介
    // if(event is UpdateUserSignaturePressed){
    //   try {
    //     bool ret = await userRepository.UpdateUserSignaturePressed(event.user, event.signature, errorCallBack);
    //     if(ret) {
    //       event.user.signature = event.signature;
    //       userRepository.persistToken(event.user);
    //       emit(AuthenticationAuthenticated());
    //     }
    //     else{
    //       ///验证未通过
    //       emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
    //     }
    //
    //   } catch (error) {
    //     ///验证未通过
    //     emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
    //   }
    // }
    // ///更新位置
    // if(event is UpdateUserLocationPressed){
    //   try {
    //     bool ret = await userRepository.updateLocation(event.user, event.province, event.city,  errorCallBack);
    //     if(ret) {
    //       event.user.province = event.province;
    //       event.user.city = event.city;
    //       userRepository.persistToken(event.user);
    //       emit(AuthenticationAuthenticated());
    //     }
    //     else{
    //       ///验证未通过
    //       emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
    //     }
    //
    //   } catch (error) {
    //     ///验证未通过
    //     emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
    //   }
    // }
    // ///更新密码
    // if(event is UpdateUserPasswordPressed){
    //   try {
    //     bool ret = await userRepository.UpdateUserPasswordPressed(event.user, event.password,  errorCallBack);
    //     if(ret) {
    //       emit(AuthenticationAuthenticated());
    //     }
    //     else{
    //       ///验证未通过
    //       emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
    //     }
    //
    //   } catch (error) {
    //     ///验证未通过
    //     emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
    //   }
    // }
    // ///更新性别
    // if(event is UpdateUserSexPressed){
    //   try {
    //     bool ret = await userRepository.UpdateUserSexPressed(event.user, event.sex,  errorCallBack);
    //     if(ret) {
    //       event.user.sex = event.sex;
    //       userRepository.persistToken(event.user);
    //       emit(AuthenticationAuthenticated());
    //     }
    //     else{
    //       ///验证未通过
    //       emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
    //     }
    //
    //   } catch (error) {
    //     ///验证未通过
    //     emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
    //   }
    // }
    // ///更新生日
    // if(event is UpdateUserBirthdayPressed){
    //   try {
    //     bool ret = await userRepository.UpdateUserBirthdayPressed(event.user, event.birthday,  errorCallBack);
    //     if(ret) {
    //       event.user.birthday = event.birthday;
    //       userRepository.persistToken(event.user);
    //       emit(AuthenticationAuthenticated());
    //     }
    //     else{
    //       ///验证未通过
    //       emit(AuthenticationUnauthenticated(error: error, errorstatusCode: errorstatusCode));
    //     }
    //
    //   } catch (error) {
    //     ///验证未通过
    //     emit(AuthenticationUnauthenticated(error: errorNet, errorstatusCode: errorNetCode));
    //   }
    // }
    // ///更新定位
    // if(event is UpdateLocation){
    //   emit(UpdateLocationed(locationName: event.locationName, locationCode: event.locationCode));
    // }
    // //初始化用户信息更新
    // if(event is initUpdate){
    //   emit(AuthenticationAuthenticated());
    // }
  }

  @override
  void onTransition(Transition<AuthenticationEvent, AuthenticationState> transition) {
    //print(transition);
    super.onTransition(transition);
  }

  Future<void> LoginSuccess(User user) async {
    // UserRepository userRepository = new UserRepository();
    // userRepository.persistToken(user);
    print("[auth] loginSuccess, username: ${user.username}");
    //本地无数据就从服务器下载
    userRepository.persistToken(user);

    TokenUtil tokenUtil = new TokenUtil();
    await tokenUtil.getDeviceToken();

    GPService gpService = GPService();
    // UmengCommonSdk.onEvent('bool', {'name':'jack', 'age':18, 'male':true});

    print("[auth] loginSuccess, gpService");
    if(user.likeact! > 0) {
      activityService.getUserLike(user.uid, user.token!); //点赞的活动
    }
    print("[auth] loginSuccess, check likeact done");
    if(user.likebug > 0) {
      activityService.getUserLikeBug(user.uid, user.token!); //点赞的活动
    }

    print("[auth] loginSuccess, check likebug done");
    if(user.likemoment > 0) {
      activityService.getUserLikeMoment(user.uid, user.token!); //点赞的活动
    }

    print("[auth] loginSuccess, check likemoment done");
    if(user.likesuggest > 0) {
      activityService.getUserLikeSuggest(user.uid, user.token!); //点赞的活动
    }
    print("[auth] loginSuccess, check likesuggest done");
    if(user.collectionact! > 0) {
      activityService.getUserCollection(user.uid, user.token!); //收藏的活动
    }
    print("[auth] loginSuccess, check collectionact done");
    if(user.likecomment > 0 || user.likeevaluate! > 0) {
      activityService.getUserComnnentLike(
          user.uid, user.token!, user.likecomment,
          user.likeevaluate!); //获取用户留言和评论的点赞情况comment和evaluate
    }
    print("[auth] loginSuccess, check likecomment and likeevaluate done");
    if(user.likegoodpricecomment  > 0) {
      activityService.getUserGoodPriceComnnentLike(
          user.uid, user.token!, user.likegoodpricecomment); //获取用户留言和评论的点赞情况goodprice
    }
    print("[auth] loginSuccess, check likegoodpricecomment done");
    if(user.likebugcomment > 0 || user.likesuggestcomment > 0 || user.likemomentcomment > 0) {
      activityService.getUserBugAndSuggestAndMomentComnnentLike(
          user.uid, user.token!, user.likebugcomment,
          user.likesuggestcomment,user.likemomentcomment); //获取用户留言和评论的点赞情况comment和evaluate
    }

    print("[auth] loginSuccess, check likebugcomment and likesuggestcomment and likemomentcomment done");
    if(user.collectionproduct! > 0) {
      gpService.getUserGoodPriceCollection(
          user.uid, user.token!); //获取用户收藏的优惠商品
    }
    print("[auth] loginSuccess, check collectionproduct done");
    if(user.notinteresteduids != null && user.notinteresteduids!.isNotEmpty){

    }
    //获取用户的好友
//          CommunityService communityService = CommunityService();
//          await communityService.getMyCommunityListByUser(0, user.uid);
    //我的关注
    print("[auth] loginSuccess, check notinteresteduids done");
    if(user.following! > 0) {
      userRepository.getfollow(user, errorCallBack);
    }
    print("[auth] loginSuccess, check following done");
    //我的不感兴趣,不需要重新获取数据
    if(user.notinteresteduids != null && user.notinteresteduids!.isNotEmpty) {
      await userRepository.updateNotInteresteduids(user, errorCallBack);
    }
    print("[auth] loginSuccess, check noti done");
    //我的好价不感兴趣,不需要重新获取数据
    if(user.goodpricenotinteresteduids != null && user.goodpricenotinteresteduids!.isNotEmpty) {
      await userRepository.updateGoodPriceNotInteresteduids(user, errorCallBack);
    }
    print("[auth] loginSuccess, check goodpricenotinteresteduids done");
    //我的黑名单,不需要重新获取数据
    if(user.blacklist != null && user.blacklist!.isNotEmpty) {
      await userRepository.updateBlacklist(user, errorCallBack);
    }

    NetworkManager.init(user, Global.mainContext!);
    print("[auth] NetworkManager.init done: ${user.username}");

  }

  errorCallBack(String statusCode, String msg) {
    error = msg;
    errorstatusCode = statusCode;
  }
}


