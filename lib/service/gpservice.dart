import 'dart:collection';

import 'package:dio/dio.dart';
import '../model/evaluategoodsitem.dart';
import '../util/showmessage_util.dart';
import '../util/imhelper_util.dart';
import '../util/net_util.dart';
import '../model/grouppurchase/goodpice_model.dart';
import '../model/comment.dart';
import '../model/activity.dart';
import '../model/searchresult.dart';
import '../model/grouppurchase/skuspecs.dart';
import '../model/evaluateactivity.dart';

import '../global.dart';

class GPService {
  ImHelper imhelper = new ImHelper();
  //获取热门搜索
  Future<List<SearchResult>> hotsearchProduct() async {
    List<SearchResult> searchResults = [];

    await NetUtil.getInstance().get(
        "/api/grouppurchase/hotsearchProduct", (Map<String, dynamic> data) {
      if (data["data"] != null) {
        for (int i = 0; i < data["data"].length; i++) {
          SearchResult searchResult = SearchResult.fromJson(data["data"][i]);
          searchResults.add(searchResult);
        }
      }
    }, params: {},
        errorCallBack: errorResponse);

    return searchResults;
  }

  //搜索时出现的关键字推荐
  Future<List<SearchResult>> getRecommendSearchProduct(String content,
      Function errorCallBack) async {
    List<SearchResult> searchResults = [];
    var formData = {
      "content": content,
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/getRecommendSearchProduct", (
        Map<String, dynamic> data) {
      if (data["data"] != null) {
        for (int i = 0; i < data["data"].length; i++) {
          SearchResult searchResult = SearchResult.fromJson(data["data"][i]);
          searchResults.add(searchResult);
        }
      }
    }, errorCallBack);

    return searchResults;
  }
  //收藏商品
  Future<bool> updateCollection(int productid, int uid, String token, Function errorCallBack) async{
    bool isUpdate = false;
    var formData = {
      "token": token,
      "productid": productid,
      "uid": uid,
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/updateProductCollection", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);

    await imhelper.saveProductCollectionState(productid, uid);
    return isUpdate;
  }
  //收藏好价优惠
  Future<bool> updateGoodPriceCollection(GoodPiceModel goodPiceModel, int uid, String token, Function errorCallBack) async{
    bool isUpdate = false;
    var formData = {
      "token": token,
      "goodpriceid": goodPiceModel.goodpriceid,
      "uid": uid,
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/updateGoodPriceCollection", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);

    print("[updateGoodPriceCollection] save Goods size: ${1}");
    await imhelper.saveGoodPriceCollectionState(goodPiceModel, uid);
    return isUpdate;
  }
  //获取用户收藏的好价
  Future<List<GoodPiceModel>> getUserGoodPriceCollectionInfo(int currentIndex, int uid, String token) async {
    List<GoodPiceModel> goodPriceList = [];
    await NetUtil.getInstance().get("/api/grouppurchase/getUserGoodPriceCollectionInfo", (Map<String, dynamic> data){
      if (data["data"] != null) {
        for(int i=0; i<data["data"].length; i++){
          goodPriceList.add(GoodPiceModel.fromJson(data["data"][i]));
        }
      }
    },params: {"currentIndex": currentIndex.toString(),"uid": uid.toString(), "token": token}, errorCallBack: errorResponse);
    return goodPriceList;
  }
  //取消收藏
  Future<bool> delCollection(int productid, int uid, String token, Function errorCallBack) async{
    bool isUpdate = false;
    var formData = {
      "token": token,
      "productid": productid,
      "uid": uid,
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/delProductCollection", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    await imhelper.delProductCollectionState(productid, uid);
    return isUpdate;
  }
  //取消优惠收藏
  Future<bool> delGoodPriceCollection(String goodpriceid, int uid, String token, Function errorCallBack) async{
    bool isUpdate = false;
    var formData = {
      "token": token,
      "goodpriceid": goodpriceid,
      "uid": uid,
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/delGoodPriceCollection", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    await imhelper.delGoodPriceCollectionState(goodpriceid, uid);
    return isUpdate;
  }
  //获取用户收藏记录
  Future<Map> getCollectionState(int productid, int uid) async{
    Map<String, bool> ret = HashMap();

    await imhelper.selProductCollectionState(productid, uid, (List<int> productids){
      if(productids.length > 0)
        ret["iscollection"] = true;
      else{
        ret["iscollection"] = false;
      }
    });
    return ret;
  }

  //获取用户好价的收藏记录
  Future<Map> getGoodPriceCollectionState(String goodpriceid, int uid) async{
    Map<String, bool> ret = HashMap();

    await imhelper.selGoodPriceCollectionState(goodpriceid, uid, (List<String> goodpriceids){
      if(goodpriceids.length > 0)
        ret["iscollection"] = true;
      else{
        ret["iscollection"] = false;
      }
    });
    return ret;
  }

  Future<void> getUserGoodPriceCollection(int currentIndex, int uid, String token) async {
    int count = await imhelper.selGoodPriceCollectionStateByUid(uid);
    print("[getUserGoodPriceCollection] uid: ${uid}, count: ${count}");
    if(count <= 0) {
      // var formData = {
      //   "token": token,
      //   "uid": uid,
      // };
      await
      NetUtil.getInstance().get("/api/grouppurchase/getUserGoodPriceCollectionInfo", (Map<String, dynamic> data){
        if (data["data"] != null) {
          for(int i=0; i<data["data"].length; i++){
            GoodPiceModel goodPiceModel =  GoodPiceModel.fromJson(data["data"][i]);
            imhelper.delGoodPriceCollectionState(goodPiceModel.goodpriceid, uid);
            imhelper.saveGoodPriceCollectionState(goodPiceModel, uid);
          }
        }
      },params: {"currentIndex": currentIndex.toString(),"uid": uid.toString(), "token": token}, errorCallBack: errorResponse);
      // NetUtil.getInstance().postJson(
      //     formData, "/api/grouppurchase/getUserGoodPriceCollectionInfo", (
      //     Map<String, dynamic> data) async {
      //   if (data != null) {
      //     if (data["data"] != null) {
      //       print("[getUserGoodPriceCollection] response data size: ${data["data"].length}");
      //       for (int i = 0; i < data["data"].length; i++) {
      //         GoodPiceModel goodPiceModel =  GoodPiceModel.fromJson(data["data"][i]);
      //         await imhelper.delGoodPriceCollectionState(goodPiceModel.goodpriceid, uid);
      //         await imhelper.saveGoodPriceCollectionState(goodPiceModel, uid);
      //       }
      //     }
      //   }
      // }, () {});
    }
  }
  //留言
  Future<int> updateMessage(String goodpriceid, int uid, String token, int touid,  String content, String captchaVerification,Function errorCallBack) async{
    int commentid = 0;

    var formData = {
      "commentid": commentid,
      "token": token,
      "goodpriceid": goodpriceid,
      "uid": uid,
      "touid": touid,
      "content": content,
      "captchaVerification": captchaVerification
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/updatecomment", (Map<String, dynamic> data) {
      commentid = int.parse(data["data"].toString());
    }, errorCallBack);
    return commentid;
  }
  //留言回复
  Future<int> updateCommentReply(int commentid, String goodpriceid, int uid, String token, int touid,  String content, String captchaVerification, Function errorCallBack) async{
    int isret = 0;

    var formData = {
      "commentid": commentid,
      "token": token,
      "goodpriceid": goodpriceid,
      "uid": uid,
      "touid": touid,
      "content": content,
      "captchaVerification": captchaVerification
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/updatecomment", (Map<String, dynamic> data) {
      isret = int.parse(data["data"].toString());
    }, errorCallBack);
    return isret;
  }
  //点赞
  Future<bool> updateCommentLike(int commentid, int uid, String token, int likeuid, String goodpriceid,Function errorCallBack) async{
    bool isUpdate = false;
    var formData = {
      "token": token,
      "commentid": commentid,
      "uid": uid,
      "likeuid": likeuid,
      "goodpriceid": goodpriceid
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/updateCommentLike", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    if(isUpdate) {
      await imhelper.saveGoodPriceCommentState(commentid.toString(), uid);
    }
    return isUpdate;
  }
  //获取留言
  Future<List<Comment>> getCommentList(String goodpriceid, int uid, Function errorCallBack) async {
    List<Comment> listComments = [];
    await NetUtil.getInstance().get("/api/grouppurchase/getcomment", (Map<String, dynamic> data){
      if (data["data"] != null) {
        for(int i=0; i<data["data"].length; i++){
          Comment comment = Comment.fromJson(data["data"][i]);
          listComments.add(comment);
        }
      }
    },params: {"goodpriceid": goodpriceid.toString(), "uid": uid.toString()}, errorCallBack: errorCallBack);

    if(listComments != null && listComments.length > 0) {
      for (int i = 0; i < listComments.length; i++){
        List<String> actid = await imhelper.selGoodPriceCommentState(listComments[i].commentid.toString(),  uid);
        if(actid.length > 0)
          listComments[i].likeuid = uid;
        else{
          listComments[i].likeuid = 0;
        }
      }
    }

    return listComments;
  }
  //取消留言
  Future<bool> delMessage(String token, int uid, int commentid, String goodpriceid, Function errorCallBack) async{
    bool isUpdate = false;
    var formData = {
      "token": token,
      "commentid": commentid,
      "uid": uid,
      "replyid": 0,
      "goodpriceid": goodpriceid
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/delcomment", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    return isUpdate;
  }
  //取消留言里的回复
  Future<bool> delMessageReply(String token, int uid, int replyid, String goodpriceid, Function errorCallBack) async{
    bool isUpdate = false;
    var formData = {
      "token": token,
      "commentid": 0,
      "uid": uid,
      "replyid": replyid,
      "goodpriceid": goodpriceid
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/delcomment", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    return isUpdate;
  }
  //取消点赞
  Future<bool> delCommentLike(int commentid, int uid, String token, int likeuid, Function errorCallBack) async{
    bool isUpdate = false;
    var formData = {
      "token": token,
      "commentid": commentid,
      "likeuid": likeuid,
      "uid": uid,
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/delCommentLike", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    if(isUpdate) {
      await imhelper.delGoodPriceCommentState(commentid.toString(), uid);
    }
    return isUpdate;
  }
  //好价点赞
  Future<bool> updateGoodPriceLike(String goodpriceid, int uid, String token, Function errorCallBack) async{
    bool isUpdate = false;
    var formData = {
      "token": token,
      "goodpriceid": goodpriceid,
      "uid": uid,
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/updateGoodPriceLike", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    if(isUpdate){
      await imhelper.saveGoodPriceState(goodpriceid,  uid, 1);
    }

    return isUpdate;
  }
  //好价取消点赞
  Future<bool> delGoodPriceLike(String goodpriceid, int uid, String token, Function errorCallBack) async{
    bool isUpdate = false;
    var formData = {
      "token": token,
      "goodpriceid": goodpriceid,
      "uid": uid,
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/updateCancelLike", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    if(isUpdate) {
      await imhelper.delGoodPriceState(goodpriceid, uid, 1);
    }
    return isUpdate;
  }
  //好价点不赞
  Future<bool> updateUnLike(String goodpriceid, int uid, String token, Function errorCallBack) async{
    bool isUpdate = false;
    var formData = {
      "token": token,
      "goodpriceid": goodpriceid,
      "uid": uid,
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/updateUnLike", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    if(isUpdate){
      await imhelper.saveGoodPriceState(goodpriceid,  uid, 0);
    }

    return isUpdate;
  }
  //好价取消点不赞
  Future<bool> updateCancelUnLike(String goodpriceid, int uid, String token, Function errorCallBack) async{
    bool isUpdate = false;
    var formData = {
      "token": token,
      "goodpriceid": goodpriceid,
      "uid": uid,
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/updateCancelUnLike", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);
    if(isUpdate){
      await imhelper.delGoodPriceState(goodpriceid,  uid, 0);
    }

    return isUpdate;
  }
  //搜索商品
  Future<List<GoodPiceModel>> searchProduct(String ordertype, String citycode, int currentIndex,
      bool isAllCity,String content, Function errorCallBack) async {
    List<GoodPiceModel> goodprices = [];
    var formData = {
      "content": content,
      "ordertype": ordertype,
      "citycode": citycode,
      "currentIndex": currentIndex,
      "isAllCity": isAllCity ? "1" : "0"
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/searchProduct", (
        Map<String, dynamic> data) {
      if (data["data"] != null) {
        for (int i = 0; i < data["data"].length; i++) {
          GoodPiceModel searchResult = GoodPiceModel.fromJson(data["data"][i]);
          goodprices.add(searchResult);
        }
      }
    }, errorCallBack);

    return goodprices;
  }
  //获取优惠商品详情
  Future<GoodPiceModel?> getGoodPriceInfo(String goodpriceid) async {
    GoodPiceModel? goodPiceModel;
    await NetUtil.getInstance().get("/api/grouppurchase/getGoodPriceInfo", (Map<String, dynamic> data){
      goodPiceModel = GoodPiceModel.fromJson(data["data"]);
    },params: {"goodpriceid": goodpriceid.toString()}, errorCallBack: errorResponse);
    return goodPiceModel;
  }
  //创建团购订单
  Future<String> createGPOrder(String actid, int uid, String token, int touid, Function errorCallBack) async {
    String orderid = "";
    var formData = {
      "token": token,
      "actid": actid,
      "uid": uid,
      "touid": touid
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/createGPOrder", (Map<String, dynamic> data) {
      orderid = data["data"];
    }, errorCallBack);

    return orderid;
  }

  //参加活动
  Future<Activity?> joinGPActivity(String actid, int uid, String token, String username, String sex, Function errorCallBack) async{
    Activity? activity;
    var formData = {
      "token": token,
      "actid": actid,
      "uid": uid,
      "username": username,
      "sex": sex,
    };
    await NetUtil.getInstance().postJson(formData, "/api/Activity/joinActivity", (Map<String, dynamic> data) {
      activity = Activity.fromJson(data['data']);
    }, errorCallBack);
    return activity;
  }

  Future<bool> clientPaySuccess(String orderid, int uid, String token, Function errorCallBack) async{
    bool isUpdate = false;
    var formData = {
      "token": token,
      "orderid": orderid,
      "uid": uid,
    };
    await NetUtil.getInstance().postJson(formData, "/api/Activity/clientPaySuccess", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);

    return isUpdate;
  }

  //获取相关活动
  Future<List<Activity>> getActivityList(String goodpriceid) async {
    List<Activity> activitys = [];
    await NetUtil.getInstance().get("/api/grouppurchase/getActivityList", (Map<String, dynamic> data){
      if (data["data"] != null) {
        for(int i=0; i<data["data"].length; i++){
          activitys.add(Activity.fromJson(data["data"][i]));
        }
      }
    },params: {"goodpriceid": goodpriceid, }, errorCallBack: errorResponse);
    return activitys;
  }
  //通知服务器客户端支付成功
  Future<bool> updategoodpricestatus(int uid, String token, String goodpriceid, int status, String msg, String tag,  Function errorCallBack) async {
    bool isUpdate = false;
    var formData = {
      "goodpriceid": goodpriceid,
      "uid": uid,
      "token": token,
      "status": status,
      "msg": msg,
      "tag": tag,
      "goodpriceid": goodpriceid
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/updategoodpricestatus", (Map<String, dynamic> data) {
      isUpdate = true;
    }, errorCallBack);

    return isUpdate;
  }
  //提交推荐商品
  Future<bool> createGoodPrice(int uid, String token, String title, String content, int productnum, int category, String brand, double totalprice, double price, double originalprice,
      String endtime,  List<String> imgs, String pic, String province, String city, String producturl, String purchasechannels, double discount, double lat, double lng, String address,
      String addresstitle, String captchaVerification, Function errorCallBack) async {
    String goodpriceid = "";
    String imageUrls = "";
    for (int i = 0; i < imgs.length; i++) {
      imageUrls += imgs[i] + ",";
    }
    if (imageUrls.length > 0) {
      imageUrls = imageUrls.substring(0, imageUrls.length - 1);
    }


    var formData = {
      "token": token,
      "uid": uid,
      "title": title,
      "content": content,
      "productnum": productnum,
      "category": category,
      "brand": brand,
      "totalprice": totalprice,
      "price": price,
      "originalprice": originalprice,
      "endtime": endtime,
      "albumpics": imageUrls,
      "pic": pic,
      "province": province,
      "city": city,
      "producturl": producturl,
      "purchasechannels": purchasechannels,
      "discount": discount,
      "lat": lat,
      "lng": lng,
      "address": address,
      "addresstitle": addresstitle,
      "captchaVerification": captchaVerification
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/createGoodPrice", (Map<String, dynamic> data) {
      goodpriceid = data["data"];
    }, errorCallBack);
    if(goodpriceid != null && goodpriceid.isNotEmpty){
      return true;
    }
    return false;
  }

  //修改推荐商品
  Future<bool> updateGoodPrice(int uid, String token, String title, String content, int productnum, int category, String brand, double totalprice, double price, double originalprice,
      String endtime,  List<String> imgs, String pic, String province, String city, String producturl, String purchasechannels, double discount, double lat, double lng, String address,
      String addresstitle, String goodpriceid, Function errorCallBack) async {
    String imageUrls = "";
    for (int i = 0; i < imgs.length; i++) {
      imageUrls += imgs[i] + ",";
    }
    if (imageUrls.length > 0) {
      imageUrls = imageUrls.substring(0, imageUrls.length - 1);
    }


    var formData = {
      "token": token,
      "uid": uid,
      "title": title,
      "content": content,
      "productnum": productnum,
      "category": category,
      "brand": brand,
      "totalprice": totalprice,
      "price": price,
      "originalprice": originalprice,
      "endtime": endtime,
      "albumpics": imageUrls,
      "pic": pic,
      "province": province,
      "city": city,
      "producturl": producturl,
      "purchasechannels": purchasechannels,
      "discount": discount,
      "lat": lat,
      "lng": lng,
      "address": address,
      "addresstitle": addresstitle,
      "goodpriceid": goodpriceid,
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/updateGoodPrice", (Map<String, dynamic> data) {
      goodpriceid = data["data"];
    }, errorCallBack);
    if(goodpriceid != null && goodpriceid.isNotEmpty){
      return true;
    }
    return false;
  }
  //sys获取推荐商品（运维）
  Future<List<GoodPiceModel>> getGoodPriceList() async {
    List<GoodPiceModel> goodPrices = [];
    await NetUtil.getInstance().get("/api/grouppurchase/getSysGoodPriceCheck", (Map<String, dynamic> data){
      if (data["data"] != null) {
        for(int i=0; i<data["data"].length; i++){
          goodPrices.add(GoodPiceModel.fromJson(data["data"][i]));
        }
      }
    },params: {"uid": Global.profile.user!.uid.toString(), "token": Global.profile.user!.token!}, errorCallBack: errorResponse);
    return goodPrices;
  }

  //获取我的推荐商品(审核中)
  Future<List<GoodPiceModel>> getMyGoodPricePendingList() async {
    List<GoodPiceModel> goodPrices = [];
    await NetUtil.getInstance().get("/api/grouppurchase/getMyGoodPricePendingList", (Map<String, dynamic> data){
      if (data["data"] != null) {
        for(int i=0; i<data["data"].length; i++){
          goodPrices.add(GoodPiceModel.fromJson(data["data"][i]));
        }
      }
    },params: {"uid": Global.profile.user!.uid.toString(), "token": Global.profile.user!.token!}, errorCallBack: errorResponse);
    return goodPrices;
  }

  //获取我的推荐商品(已审核)
  Future<List<GoodPiceModel>> getMyGoodPriceFinishList() async {
    List<GoodPiceModel> goodPrices = [];
    await NetUtil.getInstance().get("/api/grouppurchase/getMyGoodPriceFinishList", (Map<String, dynamic> data){
      if (data["data"] != null) {
        for(int i=0; i<data["data"].length; i++){
          goodPrices.add(GoodPiceModel.fromJson(data["data"][i]));
        }
      }
    },params: {"uid": Global.profile.user!.uid.toString(), "token": Global.profile.user!.token!}, errorCallBack: errorResponse);
    return goodPrices;
  }

  //删除我的推荐
  Future<bool> delMyGoodPrice(String goodpriceid,  Function errorCallBack) async {
    bool ret =false;
    await NetUtil.getInstance().get("/api/grouppurchase/delMyGoodPrice", (Map<String, dynamic> data){
      if (data["data"] != null) {
        ret = true;
      }
    },params: {"uid": Global.profile.user!.uid.toString(), "token": Global.profile.user!.token!, "goodpriceid": goodpriceid}, errorCallBack: errorCallBack);
    return ret;
  }

  //获取推荐商品
  Future<List<GoodPiceModel>> getRecommendGoodPriceList(int type,int currentIndex) async {
    List<GoodPiceModel> goodpicemodels = [];
    await NetUtil.getInstance().get("/api/grouppurchase/getRecommendGoodPriceList", (Map<String, dynamic> data){
      if (data["data"] != null) {
        for(int i=0; i<data["data"].length; i++) {
          goodpicemodels.add(GoodPiceModel.fromJson(data["data"][i]));
        }
      }
    },params: {"type": type.toString(), "currentIndex": currentIndex.toString(), "citycode": Global.profile.locationGoodPriceCode}, errorCallBack: errorResponse);
    return goodpicemodels;
  }

  //获取商品规格
  Future<List<Skuspecs>> getProductSpecsList(String goodpriceid) async {
    List<Skuspecs> skuspecsList = [];
    await NetUtil.getInstance().get("/api/grouppurchase/getSkuStockList", (Map<String, dynamic> data){
      if (data["data"] != null) {
        for(int i=0; i<data["data"].length; i++){
          skuspecsList.add(Skuspecs.fromJson(data["data"][i]));
        }
      }
    },params: {"goodpriceid": goodpriceid.toString()}, errorCallBack: errorResponse);
    return skuspecsList;
  }

  //获取评价列表
  Future<List<EvaluateActivity>> getEvaluateGoodPriceList(String goodpriceid, int currentIndex,  Function errorCallBack) async{
    List<EvaluateActivity> evaluateActivities = [];

    var formData = {
      "goodpriceid": goodpriceid,
      "currentIndex": currentIndex,
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/getEvaluateGoodPriceList", (Map<String, dynamic> data) {
      for (int i = 0; i < data["data"].length; i++) {
        EvaluateActivity evaluateActivity = EvaluateActivity.fromJson(data["data"][i]);
        evaluateActivities.add(evaluateActivity);
      }
    }, errorCallBack);

    if(evaluateActivities != null && evaluateActivities.length > 0 && Global.profile.user != null) {
      for (int i = 0; i < evaluateActivities.length; i++){
        List<String> evaluateid = await imhelper.selActivityEvaluateState(evaluateActivities[i].evaluateid.toString(),
            Global.profile.user!.uid);
        if(evaluateid.length > 0)
          evaluateActivities[i].likeuid = Global.profile.user!.uid;
        else{
          evaluateActivities[i].likeuid = 0;
        }
//        print("aaa:" + evaluateActivities[i].likeuid.toString());
//        print("bbb:" + evaluateActivities[i].likenum.toString());
      }
    }

    return evaluateActivities;
  }

  Future<EvaluateGoodsItem?> updateEvaluateGoodPrice(String goodpriceid, int likeuid, String token, int touid, String content,
      int likenum,
      String imagepaths,
      String gooditemcontent,
      Function errorCallBack) async{
    EvaluateGoodsItem? evaluate;
    var formData = {
      "token": token,
      "goodpriceid": goodpriceid,
      "likeuid": likeuid,
      "touid": touid,
      "content": content,
      "likenum": likenum,
      "imagepaths": imagepaths,
      "gooditemcontent": gooditemcontent
    };
    await NetUtil.getInstance().postJson(formData, "/api/grouppurchase/updateEvaluateGoodPrice", (Map<String, dynamic> data) {
      evaluate = EvaluateGoodsItem.fromJson(data["data"]);
    }, errorCallBack);
    return evaluate;
  }

  errorResponse(String statusCode, String msg) {
    ShowMessage.showToast(msg);
  }

}