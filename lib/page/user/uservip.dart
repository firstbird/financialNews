import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/widget/icontext.dart';

import '../../util/imhelper_util.dart';
import '../../util/common_util.dart';
import '../../common/iconfont.dart';
import '../../widget/btnpositioned.dart';
import '../../widget/circle_headimage.dart';
import '../../global.dart';

class UserVip extends StatefulWidget {
  Object? arguments;
  bool isPop = false;

  UserVip({this.arguments}) {
    if (arguments != null) {
      isPop = true;
    }
  }

  @override
  _UserVipState createState() => _UserVipState();
}

class _UserVipState extends State<UserVip> {
  ImHelper _imHelper = ImHelper();

  int _countHistory = 0;
  int _countActivityEvaluate = 0;
  int _newmemberCount = 0;
  int _newFriendJoinCount = 0;
  int _newSharedCount = 0;
  int _myOrderCount = 0;
  int _collectioncount = 0;
  int _pendingOrderCount = 0;
  int _finishOrderCount = 0;

  bool _isagree = false;

  _hisBrowse() async {
    _countHistory = await _imHelper.countBrowseHistory();
    _newSharedCount = await _imHelper.getUserSharedCount();
    _myOrderCount = await _imHelper.getUserOrder(-1); //-1是获取所有数据

    _collectioncount = (await _imHelper
                .selGoodPriceCollectionByUid(Global.profile.user!.uid))
            .length +
        (await _imHelper.selActivityCollectionByUid(Global.profile.user!.uid))
            .length;

    setState(() {});
  }

  _getOrderCount() async {
    _countActivityEvaluate = await _imHelper.getUserUnEvaluateOrder();

    _pendingOrderCount = await _imHelper.getUserOrder(0); //-1是获取所有数据
    _finishOrderCount = await _imHelper.getUserOrder(1); //-1是获取所有数据
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hisBrowse();
    _getOrderCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18,
            ),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          color: Colors.grey.shade50,
          child: Column(
            children: [
              buildHeadInfo(),
              // Expanded(
              //   child: ListView(
              //     children: [
              Container(
                margin: EdgeInsets.only(top: 1),
                padding: EdgeInsets.only(top: 1, left: 10, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: Colors.deepOrange
                    //   ),
                    //   child:Text('开通会员, 尊享以下权益 👇', style: TextStyle(color: Colors.brown, fontSize: 16), ),
                    // ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 20),
                      decoration: BoxDecoration(color: Colors.orange),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconText(
                            '消息无限制',
                            icon: Icon(
                              IconFont.icon_jianyi,
                              size: 19,
                            ),
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            direction: Axis.horizontal,
                            padding: EdgeInsets.only(bottom: 0),
                            onTap: () {
                              Navigator.pushNamed(context, '/ProAndSuggestion');
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          IconText(
                            '发布活动',
                            icon: Icon(
                              IconFont.icon_zhanghuanquan1,
                              size: 19,
                            ),
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            direction: Axis.horizontal,
                            padding: EdgeInsets.only(bottom: 0),
                            onTap: () {
                              Navigator.pushNamed(context, '/MyUserId');
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          IconText(
                            '申请交友',
                            icon: Icon(
                              IconFont.icon_bangzhu_kefu,
                              size: 19,
                            ),
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            direction: Axis.horizontal,
                            padding: EdgeInsets.only(bottom: 0),
                            onTap: () {
                              Navigator.pushNamed(context, '/SysHelper');
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 20,),
                  ],
                ),
                decoration: BoxDecoration(color: Colors.white),
              ),

              SizedBox(
                height: 10,
              ),
              // Expanded(
              //     child:
              Container(
                  height: 130,
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child:
                  ChangeNotifierProvider(
                      create: (_) => Counter(),
                  child: ListView(scrollDirection: Axis.horizontal,
                      children: [
                    // payItem('1个月', '68', ''),
                    PayItemWidget(
                        focusNode: FocusScopeNode(), itemIndex: 0, text1: '1个月', text2: '68'),
                    SizedBox(
                      width: 5,
                    ),
                    PayItemWidget(
                        focusNode: FocusScopeNode(),
                        itemIndex: 1,
                        text1: '3个月',
                        text2: '180',
                        text3: '￥60/月'),
                    // payItem('3个月', '180', '￥60/月'),
                    SizedBox(
                      width: 5,
                    ),
                    PayItemWidget(
                        focusNode: FocusScopeNode(),
                        itemIndex: 2,
                        text1: '6个月',
                        text2: '300',
                        text3: '￥50/月'),
                    // payItem('6个月', '300', '￥50/月'),
                    SizedBox(
                      width: 5,
                    ),
                    PayItemWidget(
                        focusNode: FocusScopeNode(),
                        itemIndex: 3,
                        text1: '12个月',
                        text2: '480',
                        text3: '￥40/月'),
                    // payItem('12个月', '480', '￥40/月'),
                  ]))
              ),
              SizedBox(height: 20.0),
              _builduseragree(context),
              SizedBox(height: 10.0),
              Container(
                height: 40,
                // margin: EdgeInsets.all(5),
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('立即开通', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Color(0xffe3b28a),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              Spacer(),
            ],
          ),
        )
        // ],
        // )
        // )
        );
  }

  ///用户协议
  Align _builduseragree(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 9.0),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.start,
          children: <Widget>[
            Checkbox(
              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              checkColor: Colors.white,
              activeColor: Global.defredcolor,
              value: this._isagree,
              onChanged: (bool? value) {
                setState(() {
                  if(value != null)
                    this._isagree = value;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text('开通视为已阅读, 理解并同意', style: TextStyle(color: Colors.grey, fontSize: 11.5),),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child:  GestureDetector(
                child: Text(
                  '《XX会员服务协议》',
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
                onTap: () {
                  //TODO 跳转到登录用户协议页面
                  Navigator.pushNamed(context, '/HtmlContent', arguments: {"parameterkey": "loginuseragree", "title": ""});
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child:  Text('和', style: TextStyle(color: Colors.grey, fontSize: 11.5)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child:  GestureDetector(
                child: Text(
                  '《隐私政策》',
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
                onTap: () {
                  //TODO 跳转到登录用户协议页面
                  Navigator.pushNamed(context, '/HtmlContent', arguments: {"parameterkey": "useragreement", "title": ""});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeadInfo() {
    return Container(
      height: 149,
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    child: Global.profile.user != null
                        ? NoCacheClipRRectOhterHeadImage(
                            imageUrl: Global.profile.user!.profilepicture ?? "",
                            uid: Global.profile.user!.uid,
                            width: 60,
                            cir: 50,
                          )
                        : AssetImage(Global.headimg) as Widget,
                    onTap: () {
                      Navigator.pushNamed(context, '/PhotoViewImageHead',
                          arguments: {
                            "iscache": false,
                            "image": Global.profile.user!.profilepicture
                          });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Text(
                          Global.profile.user!.username,
                          style: TextStyle(color: Colors.black87, fontSize: 15),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/MyProfile')
                              .then((value) {
                            setState(() {});
                          });
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '会员号: ${Global.profile.user!.uid}',
                        style: TextStyle(color: Colors.black38, fontSize: 12),
                      )
                    ],
                  )
                ],
              ),
              Align(
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Row(
                      children: [
                        Text('我的订阅 ',
                            style:
                                TextStyle(color: Colors.black87, fontSize: 15)),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/MySubscription');
                  },
                ),
                alignment: Alignment.centerRight,
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(right: 10, left: 10),
            child: Text(
              '开通高级会员, 尊享以下权益 👇',
              style: TextStyle(color: Colors.brown, fontSize: 16),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
    );
  }
}

class Counter extends ChangeNotifier {
  int _payItemIndex = 0;

  int get payItemIndex => _payItemIndex;

  void setCurrentItemIndex(int index) {
    _payItemIndex = index;
    notifyListeners();
  }
}
class PayItemWidget extends StatefulWidget {
  final FocusScopeNode focusNode;
  final int itemIndex;
  final String text1;
  final String text2;
  final String? text3;

  const PayItemWidget(
      {super.key,
      required this.itemIndex,
      required this.focusNode,
      required this.text1,
      required this.text2,
      this.text3});

  @override
  _PayItemState createState() => _PayItemState();
}

class _PayItemState extends State<PayItemWidget> {
  @override
  Widget build(BuildContext context) {
    return payItem(widget.text1, widget.text2, widget.text3 ?? "");
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    widget.focusNode.dispose();

    super.dispose();
  }

  Widget payItem(String text1, String text2, String text3) {
    return Consumer<Counter>(
      builder: (context, counter, child) =>
          InkWell(
            onTap: () {
              // print("[vip page] ${widget.itemIndex} on tap");
              Provider.of<Counter>(context, listen: false).setCurrentItemIndex(widget.itemIndex);
            },
            child: Container(
        width: 110,
        height: 150,
        decoration: BoxDecoration(
            border: Border.all(
                color:
                // Consumer<Counter>(
                  // builder: (counter) => counter._payItemIndex == widget.itemIndex ? Colors.blue : Colors.grey,
                // ),
                counter.payItemIndex == widget.itemIndex ? Color(0xE0C59A58) : Colors.white70,
                width: 1.0), // Color(0xCECED0EE),
            borderRadius: BorderRadius.circular(10.0),
            color: counter.payItemIndex == widget.itemIndex ? Color(0xFFF9EAD8) : Colors.white,
        ),
        padding: EdgeInsets.all(16.0),
        child: payContent(text1, text2, text3),
      ),
          ),
    );
  }

  Widget payContent(String text1, String text2, String text3) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          text1, //,
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Colors.brown),
        ),
        // SizedBox(height: 4.0),
        Text.rich(
          TextSpan(
            text: '￥',
            style: TextStyle(fontSize: 15.0, color: Colors.redAccent),
            children: [
              TextSpan(
                text: text2, //'68',
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent),
              ),
            ],
          ),
        ),
        // SizedBox(height: 4.0),
        Text(
          text3, //'￥68/月',
          style: TextStyle(fontSize: 12.0),
        ),
      ],
    );
  }
}
