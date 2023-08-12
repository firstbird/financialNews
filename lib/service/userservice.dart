import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:tobias/tobias.dart' as tobias;

import '../model/subscription.dart';
import '../model/user.dart';
import '../model/dynamic.dart';
import '../model/im/grouprelation.dart';
import '../model/im/timelinesync.dart';
import '../model/order.dart';
import '../util/imhelper_util.dart';
import '../util/net_util.dart';
import '../util/showmessage_util.dart';
import '../global.dart';

class UserService {
  ImHelper imHelper = new ImHelper();

  //登录
  Future<User?> login(String mobile, String password, String country, String captchaVerification, Function errorCallBack) async {
    User? user = null;
    // var formData = {
    //   "mobile": mobile,
    //   "password": generateMd5(password),
    //   "captchaVerification": captchaVerification
    // });
    var jsonData = {
      "mobile": mobile,
      "password": generateMd5(password),
      "country": country,
      "captchaVerification": captchaVerification
    };
    await NetUtil.getInstance().postJson(jsonData, "/api/user/login", (data){
      if(data["data"] != null && data["data"] != "") {
        try {
          if (data["data"]["user"] == null){
            //启动验证
            print("[userservice] login get data.user null");
            errorCallBack("-8001", ' 登录密码错误或未设置\n请检查或使用验证码登录');
          }
          else if (data["data"]["user"].toString() != "") {
            user = User.fromJson(data["data"]["user"]);
            user!.token = data["data"]["token"].toString();
          }
        }
        catch(e){
          user = null;
          errorCallBack("-8001", '服务器忙请稍后再试');
        }
      }
    }, errorCallBack);

    return user;
  }

  //发送验证码
  Future<bool> sendVCode(String mobile) async {
    bool vsendstatus = false;
    await NetUtil.getInstance().get("/api/user/sendVCode", (Map<String, dynamic> data) {
      vsendstatus = true;
    }, params: {"mobile": mobile}, errorCallBack: errorResponse);
    return vsendstatus;
  }

  //发送验证码
  Future<bool> sendVCodeByUid(int uid, String token) async {
    bool vsendstatus = false;
    await NetUtil.getInstance().get("/api/user/sendVCodeByUid", (Map<String, dynamic> data) {
      vsendstatus = true;
    }, params: {"uid": uid.toString(), "token": token}, errorCallBack: errorResponse);
    return vsendstatus;
  }

  //手机验证登录
  Future<User?> loginMobile(String mobile, String vcode, String country, Function errorCallBack) async {
    User? user = null;
    print("[userservice] loginMobile mobile: ${mobile}, vcode: ${vcode}, country: ${country}");
    // var formData = {
    //   "mobile": mobile,
    //   "vcode": vcode,
    //   "country": country
    // });
    var jsonData = {
      "mobile": mobile,
      "vcode": vcode,
      "country": country
    };
    await NetUtil.getInstance().postJson(jsonData, "/api/user/loginmobile", (data){
      if (data["data"]["user"].toString() != "") {
        user = User.fromJson(data["data"]["user"]);
        user!.token = data["data"]["token"].toString();
      }
    }, errorCallBack);
    return user;
  }

  //微信登录
  Future<User?> loginweixin(String code, Function errorCallBack) async {
    User? user = null;
    var formData = {
      "code": code
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/loginweixin", (data){
      if (data["data"]["user"].toString() != "") {
        user = User.fromJson(data["data"]["user"]);
        user!.token = data["data"]["token"].toString();
      }
    }, errorCallBack);
    return user;
  }
  //ios登录
  Future<User?> loginIos(String identityToken, String iosuserid, Function errorCallBack) async {
    User? user = null;
    var formData = {
      "identityToken": identityToken,
      "iosuserid": iosuserid
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/loginios", (data){
      if (data["data"]["user"].toString() != "") {
        user = User.fromJson(data["data"]["user"]);
        user!.token = data["data"]["token"].toString();
      }
    }, errorCallBack);
    return user;
  }

  //支付宝登录注册
  Future<User?> updateLoginali(String authurl, Function errorCallBack) async {
    User? user = null;
    String auth_code = "";
    if(authurl != null && authurl.isNotEmpty) {
      Map ret = await tobias.aliPayAuth(authurl);
      if(ret != null) {
        if(ret["result"] != null) {
          String responsestr = ret["result"].toString();
          List<String> parms = responsestr.split('&');
          for(int i = 0; i < parms.length; i++){
            if(parms[i].indexOf("auth_code") >= 0) {
              auth_code = parms[i].split('=')[1];
              var formData = {
                "auth_code": auth_code
              };

              await NetUtil.getInstance().postJson(formData, "/AliPay/loginali", (Map<String, dynamic> data) {
                if (data["data"]["user"].toString() != "") {
                  user = User.fromJson(data["data"]["user"]);
                  user!.token = data["data"]["token"].toString();
                }
              }, errorCallBack);
            }
          }
        }
      }
    }

    return user;
  }

  //绑定支付宝账号
  Future<User?> updateAliPay(int uid, String token, String authurl, bool confirm, Function errorCallBack) async {
    User? user = null;
    String auth_code = "";
    if(authurl != null && authurl.isNotEmpty) {
      Map ret = await tobias.aliPayAuth(authurl);
      if(ret != null) {
        if(ret["result"] != null) {
          String responsestr = ret["result"].toString();
          List<String> parms = responsestr.split('&');
          for(int i = 0; i < parms.length; i++){
            if(parms[i].indexOf("auth_code") >= 0) {
              auth_code = parms[i].split('=')[1];
              var formData = {
                "uid": uid,
                "token": token,
                "auth_code": auth_code,
                "confirm": confirm
              };

              await NetUtil.getInstance().postJson(formData, "/AliPay/updateali", (Map<String, dynamic> data) {
                if (data["data"] != "") {
                  user = User.fromJson(data["data"]);
                }
              }, errorCallBack);
            }
          }
        }
      }
    }

    return user;
  }

  //绑定微信账号
  Future<User?> updateWeixin(int uid, String token, String code, bool confirm, Function errorCallBack) async {
    User? user = null;

    var formData = {
      "uid": uid,
      "token": token,
      "code": code,
      "confirm": confirm
    };

    await NetUtil.getInstance().postJson(formData, "/api/user/updateweixin", (Map<String, dynamic> data) {
      if (data["data"] != "") {
        user = User.fromJson(data["data"]);
      }
    }, errorCallBack);

    return user;
  }

  //绑定ios账号
  Future<User?> updateIos(int uid, String token, String identityToken, bool confirm, String iosuserid, Function errorCallBack) async {
    User? user = null;

    var formData = {
      "uid": uid,
      "token": token,
      "identityToken": identityToken,
      "confirm": confirm,
      "iosuserid": iosuserid
    };

    await NetUtil.getInstance().postJson(formData, "/api/user/updateios", (Map<String, dynamic> data) {
      if (data["data"] != "") {
        user = User.fromJson(data["data"]);
      }
    }, errorCallBack);

    return user;
  }

  //获取支付宝用户授权请求
  Future<String> getAliUserAuth() async {
    String authurl = "";
    var formData = {

    };
    await NetUtil.getInstance().postJson(formData, "/AliPay/userauth", (Map<String, dynamic> data) {
      authurl = data["data"];
    }, (code,msg){
      ShowMessage.showToast(msg);
    });

    return authurl;
  }

  //上传设备信息
  Future<bool> updatePushToken(int uid, String token, String brand, String pushtoken,  Function errorCallBack) async {
    bool ret = false;
    var formData = {
      "uid": uid,
      "token": token,
      "brand": brand,
      "pushtoken": pushtoken
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updatePushToken", (data){
      ret = true;
    }, errorCallBack);
    return ret;
  }
  //手机验证码
  Future<bool> verifyVCode(int uid, String token, String vcode, Function errorCallBack) async {
    bool ret = false;
    var formData = {
      "uid": uid,
      "token": token,
      "vcode": vcode
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/verifyVCode", (data){
      ret = true;
    }, errorCallBack);
    return ret;
  }

  //手机验证码
  Future<User?> updateMobile(int uid, String token, String vcode, String mobile, String country, bool confirm, Function errorCallBack) async {
    User? user = null;
    var formData = {
      "uid": uid,
      "token": token,
      "vcode": vcode,
      "mobile": mobile,
      "country": country,
      "confirm": confirm
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updateMobile", (data){
      user = User.fromJson(data["data"]);
    }, errorCallBack);
    return user;
  }

//手机验证码
  Future<bool> userexit(int uid, String token, Function errorCallBack) async {
    bool ret = false;
    var formData = {
      "uid": uid,
      "token": token,
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/userexit", (data){
      ShowMessage.cancel();
      ret = true;
    }, errorCallBack);
    return ret;
  }

  //获取用户信息
  Future<User?> getUserInfo(int uid, Function errorCallBack) async {
    print("[userservice] getUserInfo uid: ${uid}");
    User? user = null;
    // var formData = {
    //   "uid": uid
    // });
    var formData = {
      "uid": uid
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/getuserinfo", (Map<String, dynamic> data) {
      if(data["data"] != null) {
        user = User.fromJson(data["data"]);
        Global.profile.user!.following = user!.following;
        Global.profile.user!.followers = user!.followers;
        Global.saveProfile();
      }
    }, errorResponse);


    return user;
  }

  //更新头像byte
  Future<bool> updateImage(String token, int uid, File myimg) async {
    bool isupdateImage = false;

    var formData = {
      "imagefile": await MultipartFile.fromFile(myimg.path),
      "token": token,
      "uid": uid
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updateImage", (Map<String, dynamic> data) {
      isupdateImage = true;
    }, errorResponse);
    return isupdateImage;
  }

  //更新头像ossurl
  Future<bool> updateImageByUrl(String token, int uid, String imgpath, Function errorCallBack) async {
    bool isupdateImage = false;

    var formData = {
      //"path": await MultipartFile.fromFile(imgpath),
      "path": imgpath,
      "token": token,
      "uid": uid
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updateImage", (Map<String, dynamic> data) {
      isupdateImage = true;
    }, errorCallBack);
    return isupdateImage;
  }

  Future<bool> updateEducationImageByUrl(String token, int uid, String imgpath, Function errorCallBack) async {
    bool isupdateImage = false;

    var formData = {
      //"path": await MultipartFile.fromFile(imgpath),
      "path": imgpath,
      "token": token,
      "uid": uid
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updateEducationImage", (Map<String, dynamic> data) {
      isupdateImage = true;
    }, errorCallBack);
    return isupdateImage;
  }

  Future<bool> updateEarningImageByUrl(String token, int uid, String imgpath, Function errorCallBack) async {
    bool isupdateImage = false;

    var formData = {
      //"path": await MultipartFile.fromFile(imgpath),
      "path": imgpath,
      "token": token,
      "uid": uid
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updateEarningImage", (Map<String, dynamic> data) {
      isupdateImage = true;
    }, errorCallBack);
    return isupdateImage;
  }

  //更新性别
  Future<bool> updateSex(String token, int uid, String sex, Function errorCallBack) async {
    bool isUpdate = false;

    var formData = {
      "token": token,
      "uid": uid,
      "sex": sex
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updateSex", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    return isUpdate;
  }

  //关注话题
  Future<bool> updateSubject(String token, int uid, String subject, Function errorCallBack) async {
    bool isUpdate = false;

    var formData = {
      "token": token,
      "uid": uid,
      "subject": subject
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updateSubject", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    return isUpdate;
  }

  //更新生日
  Future<bool> updateBirthday(String token, int uid, String birthday, Function errorCallBack) async {
    bool isUpdate = false;
    var formData = {
      "token": token,
      "uid": uid,
      "birthday": birthday
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updateBirthday", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    return isUpdate;
  }

  //更新昵称
  Future<bool> updateUserName(String token, int uid, String username, Function errorCallBack) async {
    bool isUpdate = false;
    var formData = {
      "token": token,
      "uid": uid,
      "username": username
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updateUserName", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    return isUpdate;
  }

  //更新身高
  Future<bool> updateUserHeight(String token, int uid, int height, Function errorCallBack) async {
    bool isUpdate = false;
    var formData = {
      "token": token,
      "uid": uid,
      "userheight": height
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updateUserHeight", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    return isUpdate;
  }

  //更新位置
  Future<bool> updateLocation(String token, int uid, String province, String city, Function errorCallBack) async {
    bool isUpdate = false;
    var formData = {
      "token": token,
      "uid": uid,
      "province": province,
      "city": city
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updateLocation", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    return isUpdate;
  }

  //更新职业
  Future<bool> updateCareer(String token, int uid, String career, Function errorCallBack) async {
    bool isUpdate = false;
    var formData = {
      "token": token,
      "uid": uid,
      "career": career,
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updateCareer", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    return isUpdate;
  }

  //更新学历
  Future<bool> updateEducation(String token, int uid, String education, Function errorCallBack) async {
    bool isUpdate = false;
    var formData = {
      "token": token,
      "uid": uid,
      "education": education,
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updateEducation", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    return isUpdate;
  }

  //更新收入
  Future<bool> updateEarning(String token, int uid, String earning, Function errorCallBack) async {
    bool isUpdate = false;
    var formData = {
      "token": token,
      "uid": uid,
      "earning": earning,
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updateEarning", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    return isUpdate;
  }

  //更新个人简介
  Future<bool> updateSignature(String token, int uid, String signature, Function errorCallBack) async {
    bool isUpdate = false;
    var formData = {
      "token": token,
      "uid": uid,
      "signature": signature,
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updateSignature", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    return isUpdate;
  }

  //更新密碼
  Future<bool> updatePassword(String token, int uid, String password, Function errorCallBack) async {
    bool isUpdate = false;
    // var formData = {
    //   "token": token,
    //   "uid": uid,
    //   "password": generateMd5(password),
    // });
    var formData = {
      "token": token,
      "uid": uid,
      "password": generateMd5(password),
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updatePassWord", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    return isUpdate;
  }

  //更新兴趣
  Future<bool> updateInterest(String token, int uid, String interest, Function errorCallBack) async {
    bool isUpdate = false;
    var formData = {
      "token": token,
      "uid": uid,
      "interest": interest,
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updateInterest", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    return isUpdate;
  }


  //更新录音
  Future<bool> updateVoice(String token, int uid, String voice, Function errorCallBack) async {
    bool isUpdate = false;
    var formData = {
      "token": token,
      "uid": uid,
      "voice": voice,
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updateVoice", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    return isUpdate;
  }
  //注销
  Future<bool> deltoken(String token, int uid, Function errorCallBack) async{
    bool isUpdate = false;
    var formData = {
      "token": token,
      "uid": uid,
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/deltoken", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack, isloginOut: true);



    return isUpdate;
  }
  //更新活动不感兴趣用户
  Future<bool> updateNotinteresteduids(String token, int uid, int notinteresteduids, Function errorCallBack) async{
    bool isUpdate = false;
    var formData = {
      "token": token,
      "uid": uid,
      "notinteresteduids": notinteresteduids
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updateNotinteresteduids", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    return isUpdate;
  }
  //更新好价不感兴趣用户
  Future<bool> goodpricenotinteresteduids(String token, int uid, int goodpricenotinteresteduids, Function errorCallBack) async{
    bool isUpdate = false;
    var formData = {
      "token": token,
      "uid": uid,
      "goodpricenotinteresteduids": goodpricenotinteresteduids
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/goodpricenotinteresteduids", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    return isUpdate;
  }
  //更新黑名单
  Future<bool> updateBlacklist(String token, int uid, int blacklist, Function errorCallBack) async{
    bool isUpdate = false;
    var formData = {
      "token": token,
      "uid": uid,
      "blacklist": blacklist
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updateBlacklist", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    return isUpdate;
  }
  //获取不感兴趣列表
  Future<List<int>> getFollow(int uid) async {
    bool ret = false;
    List<int> lists = [];
    var formData = {
      "uid": uid,
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/getFollow", (Map<String, dynamic> data) {
      if(data["data"] != null) {
        for (int i = 0; i < data["data"].length; i++) {
          lists.add(data["data"][i]);
        }
      }
    }, errorResponse, isloginOut: true);
    return lists;
  }
  //获取黑名单列表
  Future<String> isFollowed(int uid, int followed, Function errorCallBack) async{
    String createtime = "";
    var formData = {
      "uid": uid,
      "followed": followed,
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/selFollwerUser", (Map<String, dynamic> data) {
      if(data["data"] != null)
        createtime = data["data"];
    }, errorCallBack, isloginOut: true);
    return createtime;
  }
  //关注
  Future<bool> Follow(String token, int uid, int followed, Function errorCallBack) async{
    bool ret = false;
    var formData = {
      "token": token,
      "uid": uid,
      "followed": followed,
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/follwerCommunity", (Map<String, dynamic> data) {
    if(data["data"] != null)
       ret = true;
    }, errorCallBack, isloginOut: true);
    return ret;
  }
  //取消关注
  Future<bool> cancelFollow(String token, int uid, int followed, Function errorCallBack) async{
    bool ret = false;
    var formData = {
      "token": token,
      "uid": uid,
      "followed": followed,
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/cleanfollwerCommunity", (Map<String, dynamic> data) {
      if(data["data"] != null)
        ret = true;
    }, errorCallBack, isloginOut: true);
    return ret;
  }
  //获取关注的社团
  Future<List<User>> getFollowUsers(int currentIndex, int uid, String token ) async {
    List<User> users = [];
    var formData = {
      "token": token,
      "uid": uid,
      "currentIndex": currentIndex
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/getFollowUsers", (Map<String, dynamic> data) {
      if(data["data"] != null){
        for(int i=0; i<data["data"].length; i++){
          users.add(User.fromJson(data["data"][i]));
        }
      }
    }, errorResponse);
    return users;
  }
  //获取订阅服务
  Future<List<Subscription>> getSubscribes(int currentIndex, int uid, String token, int type) async {
    List<Subscription> users = [];
    var formData = {
      "token": token,
      "uid": uid,
      "currentIndex": currentIndex,
      "type": type
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/getSubscribes", (Map<String, dynamic> data) {
      if(data["data"] != null){
        for(int i=0; i<data["data"].length; i++){
          users.add(Subscription.fromJson(data["data"][i]));
        }
      }
    }, errorResponse);
    return users;
  }
  Future<bool> addSubscribe(int uid, String token, int type) async {
    bool res = false;
    var formData = {
      "token": token,
      "uid": uid,
      "type": type
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/addSubscribe", (Map<String, dynamic> data) {
      if(data["data"] != null){
        res = true;
      }
    }, errorResponse);
    return res;
  }
  //获取我关注的社团，myhome页面中使用只返回5条记录
  Future<List<User>> getFollowUsersInCommunityALL(int currentIndex, int uid, String token ) async {
    List<User> users = [];
    var formData = {
      "token": token,
      "uid": uid,
      "currentIndex": currentIndex
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/getFollowUsersInCommunityALL", (Map<String, dynamic> data) {
      if(data["data"] != null){
        for(int i=0; i<data["data"].length; i++){
          users.add(User.fromJson(data["data"][i]));
        }
      }
    }, errorResponse);
    return users;
  }
  //获取关注的用户和社团
  Future<List<User>> getFollowUsersCommunity(int uid,int currentIndex) async {
    List<User> users = [];
    var formData = {
      "uid": uid,
      "currentIndex": currentIndex
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/getFollowUsersCommunity", (Map<String, dynamic> data) {
      if(data["data"] != null){
        for(int i=0; i<data["data"].length; i++){
          User tem = User.fromJson(data["data"][i]);
          tem.isfollow = true;
          users.add(tem);
        }
      }
    }, errorResponse);
    return users;
  }
  //获取用户粉丝
  Future<List<User>> getFans(int uid, String token, int currentIndex) async {
    bool ret = false;
    List<User> lists = [];
    var formData = {
      "token": token,
      "uid": uid,
      "currentIndex": currentIndex
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/getFansUsers", (Map<String, dynamic> data) {
      if(data["data"] != null) {
        for (int i = 0; i < data["data"].length; i++) {
          lists.add(User.fromJson(data["data"][i]));
        }
      }
    }, errorResponse);
    return lists;
  }
  //获取个人动态
  Future<List<Dynamic>> getUserDynamic(int currentIndex, int uid) async {
    List<Dynamic> dynamics = [];
    var formData = {
      "currentIndex": currentIndex,
      "uid": uid.toString()
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/selUserDynamic", (Map<String, dynamic> data){
      if (data["data"] != null) {
        for(int i=0; i<data["data"].length; i++){
          dynamics.add(Dynamic.fromJson(data["data"][i]));
        }
      }}, errorResponse);
    return dynamics;
  }
  //获取私聊关系
  Future<GroupRelation?> getSingleConversation(String timeline_id, int uid, int touid, String token, Function errorCallBack) async{
    GroupRelation? groupRelation;
    var formData = {
      "token": token,
      "touid": touid,
      "uid": uid,
      "timeline_id": timeline_id
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/getSingleConversation", (Map<String, dynamic> data) {
      groupRelation = GroupRelation.fromJson(data['data']);
    }, errorCallBack);
    return groupRelation;
  }
  //创建私聊关系
  Future<GroupRelation?> joinSingle(String timeline_id, int uid, int touid, String token,
  String captchaVerification, Function errorCallBack, {int isCustomer = 0}) async{
    GroupRelation? groupRelation;
    // var formData = {
    //   "token": token,
    //   "touid": touid,
    //   "uid": uid,
    //   "timeline_id": timeline_id,
    //   "captchaVerification": captchaVerification,
    //   "isCustomer": isCustomer
    // });
    var formData = {
        "token": token,
        "touid": touid,
        "uid": uid,
        "timeline_id": timeline_id,
        "captchaVerification": captchaVerification,
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/joinSingle", (Map<String, dynamic> data) {
      groupRelation = GroupRelation.fromJson(data['data']);
    }, errorCallBack);
    return groupRelation;
  }

  //联系客服
  Future<GroupRelation?> joinSingleCustomer(String timeline_id, int uid, int touid, String token,
      String captchaVerification, Function errorCallBack, {int isCustomer = 0}) async{
    GroupRelation? groupRelation;
    var formData = {
      "token": token,
      "touid": touid,
      "uid": uid,
      "timeline_id": timeline_id,
      "captchaVerification": captchaVerification,
      "isCustomer": 1
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/joinSingle", (Map<String, dynamic> data) async {
      groupRelation = GroupRelation.fromJson(data['data'][0]);
      TimeLineSync timeLineSync = TimeLineSync.fromMapByServer(
          data["data"][1]);
      List<TimeLineSync> timeLineSyncs =  [];
      timeLineSyncs.add(timeLineSync);
      await imHelper.saveMessageCustomer(timeLineSyncs);
    }, errorCallBack);
    return groupRelation;
  }

  String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }


  errorResponse(String statusCode, String msg) {
    if(statusCode == "-9015"){
      //用户不存在
    }
    else
      ShowMessage.showToast(msg);
  }

  //获取用户
  Future<User?> getOtherUser(int otheruid) async {
    print("[userservice] getOtherUser uid: ${otheruid}");
    User? user ;
    // var formData = {
    //   "uid": otheruid,
    // });
    var formData = {
      "uid": otheruid
    };

    await NetUtil.getInstance().postJson(formData, "/api/user/getuserinfo", (Map<String, dynamic> data) {
      if(data["data"] != null) {
        user = User.fromJson(data["data"]);
      }
    }, errorResponse);

    return user;
  }

  //发送加好友请求
  Future<bool> updateMemberJoin(String token, int uid, int touid, String cid,
      String content, int jointype, Function errorCallBack) async {
    bool isUpdate = false;
    var formData = {
      "token": token,
      "uid": uid,
      "touid": touid,
      "content": content,
    };
    await NetUtil.getInstance().postJson(
        formData, "/api/user/updateMemberJoin", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    return isUpdate;
  }

  //分享好友
  Future<bool> updateSharedFriend(String token, int uid, String id, String content, String image,
      String touids, int sharedtype, Function errorCallBack) async {
    bool ret = false;
    var formData = {
      "token": token,
      "uid": uid,
      "contentid": id,
      "touids": touids,
      "sharedtype": sharedtype,
      "content": content,
      "image": image,
      "fromuid": Global.profile.user!.uid,
    };
    await NetUtil.getInstance().postJson(formData, "/api/user/updateSharedFriend", (
        Map<String, dynamic> data) {
      ret = true;
    }, errorCallBack);
    return ret;
  }

  //获取我的订单
  Future<List<Order>> getMyOrder(String token, int uid, Function errorCallBack) async {
    List<Order> orders = [];
    var formData = {
      "token": token,
      "uid": uid,
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/getMyPendingOrder", (
        Map<String, dynamic> data) {
      if (data["data"] != null) {
        for(int i=0; i<data["data"].length; i++){
          orders.add(Order.fromJson(data["data"][i]));
        }
      }
    }, errorCallBack);
    return orders;
  }

  //获取已完成付款的订单
  Future<List<Order>> getMyOrderFinish(String token, int uid, Function errorCallBack) async {
    List<Order> orders = [];
    var formData = {
      "token": token,
      "uid": uid,
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/getMyFinishOrder", (
        Map<String, dynamic> data) {
      if (data["data"] != null) {
        for(int i=0; i<data["data"].length; i++){
          orders.add(Order.fromJson(data["data"][i]));
        }
      }
    }, errorCallBack);
    return orders;
  }

  //获取已退款的订单
  Future<List<Order>> getMyRefundOrder(String token, int uid, Function errorCallBack) async {
    List<Order> orders = [];
    var formData = {
      "token": token,
      "uid": uid,
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/getMyRefundOrder", (
        Map<String, dynamic> data) {
      if (data["data"] != null) {
        for(int i=0; i<data["data"].length; i++){
          orders.add(Order.fromJson(data["data"][i]));
        }
      }
    }, errorCallBack);
    return orders;
  }

  //获取已确认的订单
  Future<List<Order>> getMyConfirmOrder(String token, int uid, Function errorCallBack) async {
    List<Order> orders = [];
    var formData = {
      "token": token,
      "uid": uid,
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/getMyConfirmOrder", (
        Map<String, dynamic> data) {
      if (data["data"] != null) {
        for(int i=0; i<data["data"].length; i++){
          orders.add(Order.fromJson(data["data"][i]));
        }
      }
    }, errorCallBack);
    return orders;
  }
}