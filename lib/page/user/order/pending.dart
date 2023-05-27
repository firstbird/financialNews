import 'package:flutter/material.dart';

import '../../../model/order.dart';
import '../../../model/im/grouprelation.dart';
import '../../../widget/circle_headimage.dart';
import '../../../widget/captcha/block_puzzle_captcha.dart';
import '../../../model/grouppurchase/goodpice_model.dart';
import '../../../service/gpservice.dart';
import '../../../service/activity.dart';
import '../../../service/userservice.dart';
import '../../../util/showmessage_util.dart';
import '../../../util/imhelper_util.dart';
import '../../../global.dart';

class MyOrderPending extends StatefulWidget {

  MyOrderPending();

  @override
  _MyOrderPendingState createState() => _MyOrderPendingState();
}

class _MyOrderPendingState extends State<MyOrderPending>{
  UserService _userService = UserService();
  ActivityService _activityService = ActivityService();
  List<Order> _orderList = [];
  int _pagestatus = 0;//简单处理载入状态
  ImHelper _imhelper = new ImHelper();
  GPService _gpservice = new GPService();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMyOrder();
  }

  _getMyOrder() async {
    _orderList = await _userService.getMyOrder(Global.profile.user!.token!, Global.profile.user!.uid, (String statecode, String error){
      ShowMessage.showToast(error);
    });
    _pagestatus = 1;
    if (mounted){
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, size: 18,),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title:  Text('待付款的订单',textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 16)),
        centerTitle: true,
      ),
      body: _pagestatus == 0 ? Center(child: CircularProgressIndicator(
        valueColor:  AlwaysStoppedAnimation(Global.profile.backColor),
      )) : _buildOrderList(),
    );
  }

  Widget _buildOrderList(){
    Widget ret = SizedBox.shrink();
    List<Widget> lists = [];

    if(_orderList != null && _orderList.length > 0){
      _orderList.forEach((e) {
        String time = "已过期";
        if(e.ordertype == 3){
          //团购付款时间30分钟
          var endDate =  DateTime.parse(e.createtime!);
          endDate = endDate.add(Duration(minutes: 30));//团购订单30分钟后过期
          int min = endDate.difference(DateTime.now()).inMinutes;
          if(min > 0 ){
            time = min.toString() + "分钟";
          }
        }

        if(e.ordertype == 0){
          //拼单后付款时间3小时
          var endDate =  DateTime.parse(e.createtime!);
          endDate = endDate.add(Duration(hours: 3));//团购订单30分钟后过期
          int min = endDate.difference(DateTime.now()).inMinutes;
          int hour = (min/60).toInt();
          min = (min%60).toInt();
          if(hour > 0){
            time = hour.toString() + "小时" + min.toString() + "分钟";
          }
          if(min > 0 && hour <= 0){
            time = min.toString() + "分钟";
          }

          if(min == 0 && hour == 0){
            time = "已过期";
          }
        }
        lists.add(Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            children: [
              SizedBox(height: 12,),
              InkWell(
                child: Container(
                  height: 109,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            e.goodpricepic != "" ? ClipRRectOhterHeadImageContainer(imageUrl: e.goodpricepic,  width: 109, height: 109, cir: 5,) : SizedBox.shrink(),
                            SizedBox(width: 10,),
                            Expanded(
                                child: Container(
                                  height: 109,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: Text(e.goodpricetitle, overflow: TextOverflow.ellipsis,maxLines: 3, style: TextStyle(color: Colors.black87, fontSize: 14),)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('下单时间: ${e.createtime}',style: TextStyle(color: Colors.black45, fontSize: 12, )),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text("x", style: TextStyle( fontSize: 12, color: Colors.black45),),
                              Text(e.productnum.toString(), style: TextStyle(fontSize: 14, color: Colors.black45),)
                            ],
                          ),
                          Row(
                            children: [
                              Text("￥", style: TextStyle( fontSize: 12),),
                              Text(e.gpprice.toString(), style: TextStyle(fontSize: 14),)
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                onTap: (){
                  _gotoGoodPrice(e.goodpriceid);
                },
              ),
              SizedBox(height: 9,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                      child: Text('联系客服', style: TextStyle( fontSize: 12)),
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.all(Radius.circular(9))
                      // ),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                      ),
                      onPressed: () async {
                        _telCustomerCare("", e.touid);
                      }
                  ),
                  SizedBox(width: 10,),
                  OutlinedButton(
                      child: Text('取消订单', style: TextStyle( fontSize: 12)),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.all(Radius.circular(9))
                      // ),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                      ),
                      onPressed: () async {
                        _asked(e.gpactid!, e.orderid!);
                      }
                  ),
                  SizedBox(width: 10,),
                  TextButton(
                    child: Text('去支付', style: TextStyle(color: Colors.white, fontSize: 12),),
                    // color: Global.profile.backColor,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.all(Radius.circular(9))
                    // ),
                    style: TextButton.styleFrom(
                      primary: Global.profile.backColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                    ),
                  onPressed: () async {
                    await _gotoPay(e.goodpriceid, e.goodpricesku, e.productnum, e.goodpricespeacename, e.gpprice!,
                        e.goodpricetitle, e.goodpricebrand, e.goodpricepic, e.orderid!);
                  },),
                ],
              ),
              SizedBox(height: 9,),
            ],
          ),
          decoration: new BoxDecoration(//背景
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            //设置四周边框
          ),
        ));
        lists.add(Container(height: 6, color: Colors.grey.shade200,));
      });

      lists.add(SizedBox(height: 10,));

      ret = ListView(
        children: lists,
      );
    }
    else{
      ret = Center(
        child: Text('没有发现待付款订单', style: TextStyle(color: Colors.black54, fontSize: 14, )),
      );
    }

    return ret;
  }

  Future<void> _gotoGoodPrice(String goodpriceid) async {
    GoodPiceModel? goodprice = await _gpservice.getGoodPriceInfo(goodpriceid);
    if (goodprice != null) {
      Navigator.pushNamed(
          context, '/GoodPriceInfo', arguments: {
        "goodprice": goodprice
      });
    }
  }

  Future<void> _gotoPay(String goodpriceid, String specsid, int productNum,
      String speaceName, double gpprice, String title, String brand, String pic, String orderid) async {

    Navigator.pushNamed(context, '/OrderInfo',
        arguments: {"title": title, "specsid": specsid,
          "productNum": productNum, "specsname": speaceName ,
          "saleprice": gpprice, "goodpriceid": goodpriceid, "brand": brand, "pic": pic, "orderid": orderid}).then((value){
            _getMyOrder();
          });
  }

  Future<void> _asked(String gpactid, String orderid) async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('确定取消订单吗?', style: new TextStyle(fontSize: 17.0)),
            actions: <Widget>[
              new TextButton(
                child: new Text('确定'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  bool ret = await _activityService.delActivityOrder(gpactid, Global.profile.user!.uid, Global.profile.user!.token!,orderid, (String statusCode, String msg) {
                    ShowMessage.showToast(msg);
                  });
                  if(ret){
                    _getMyOrder();
                  }
                },
              ),
              new TextButton(
                child: new Text('取消'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }

  Future<void> _telCustomerCare(String vcode, int touid) async {
    String timeline_id = "";
    //获取客服
    int uid = Global.profile.user!.uid;
    if(uid == touid){
      ShowMessage.showToast("不能联系自己");
      return;
    }

    if (uid > touid) {
      timeline_id = touid.toString() + uid.toString();
    }
    else {
      timeline_id = uid.toString() + touid.toString();
    }
    GroupRelation? groupRelation = await _imhelper.getGroupRelationByGroupid(
        uid, timeline_id);
    if (groupRelation == null) {
      groupRelation = await _userService.joinSingleCustomer(
          timeline_id, uid, touid, Global.profile.user!.token!,
          vcode,  (String statusCode, String msg) {
        if(statusCode == "-1008"){
          _loadingBlockPuzzle(context, touid: touid);
          return;
        }
        else{
          ShowMessage.showToast(msg);
        }
      }, isCustomer: 1);
    }
    if (groupRelation != null) {
      List<GroupRelation> groupRelations = [];
      groupRelations.add(groupRelation);
      int ret = await _imhelper.saveGroupRelation(groupRelations);
      if (Global.isInDebugMode) {
        print("保存本地是否成功：-----------------------------------");
        print(groupRelations[0].group_name1);
        //print(ret);
      }
      if (ret > 0) {
        print("[_telCustomerCare] /MyMessage：-----------------------------------");
        Navigator.pushNamed(this.context, '/MyMessage', arguments: {"GroupRelation": groupRelation});
      }
    }
  }

  //滑动拼图
  _loadingBlockPuzzle(BuildContext context, {barrierDismissible = true,required int touid}) {
    showDialog<Null>(
      context: this.context,
      barrierDismissible: barrierDismissible,
      builder: (_) {
        return BlockPuzzleCaptchaPage(
          onSuccess: (v){
            _telCustomerCare(v, touid);
          },
          onFail: (){

          },
        );
      },
    );
  }

  errorCallBack(String statusCode, String msg) {
    ShowMessage.showToast(msg);
  }
}
