import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:recipe/page/user/subscribe.dart';

import '../../global.dart';
import '../../widget/my_tabbarview.dart';
import '../home.dart';
import 'follow.dart';

class MySubscription extends StatefulWidget {
  @override
  _MySubscriptionState createState() => _MySubscriptionState();
}

class _MySubscriptionState extends State<MySubscription> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  final GlobalKey<_TabBarItemState> _itemKey1 = GlobalKey();
  final GlobalKey<_TabBarItemState> _itemKey2 = GlobalKey();

  int _currentIndex= 1;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        toolbarHeight: 39,
        leading: Container(
          width: 56,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        titleSpacing: 5,
        title: Text('您的订阅服务', style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
        // actions: <Widget>[
        //   _activity != null
        //       ? Padding(
        //           padding: EdgeInsets.only(right: 10),
        //           child: Global.profile.user != null
        //               ? ShareView(
        //                   icon: Icon(Icons.more_horiz, color: Colors.black),
        //                   image: _activity!.coverimg,
        //                   contentid: _activity!.actid,
        //                   content: _activity!.content,
        //                   sharedtype: "0",
        //                   actid: _activity!.actid,
        //                   createuid: _activity!.user!.uid,
        //                 )
        //               : IconButton(
        //                   icon: Icon(Icons.more_horiz, color: Colors.black),
        //                   onPressed: () {
        //                     _islogin();
        //                   },
        //                 ),
        //         )
        //       : SizedBox.shrink() //  String sharedtype;//分享类型 0 活动 1商品 2拼玩
        // ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //SearchBar(),
            _buildTabRow(),
            Expanded(
              child: _buildTabView(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    if (Platform.isAndroid) {
      WidgetsBinding.instance!.renderView.automaticSystemUiAdjustment =
      false; //去掉会导致底部状态栏重绘变成黑色，系统UI重绘，，页面退出后要改成true
    }
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.index = _currentIndex;
    _tabController.addListener((){
      _itemKey1.currentState!.onPressed(_tabController.index);
      _itemKey2.currentState!.onPressed(_tabController.index);
      // _itemCityKey2.currentState!.onPressed(_tabController.index);
    });
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      WidgetsBinding.instance!.renderView.automaticSystemUiAdjustment =
      true; //去掉会导致底部状态栏重绘变成黑色，系统UI重绘，，页面退出后要改成true
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  MyTabBarView _buildTabView(){
    return MyTabBarView(
        controller: _tabController,
        //physics: new NeverScrollableScrollPhysics(),
        children: <Widget>[
          MySubscribe(),
          MySubscribe(),
          //CityActivity(parentJumpShop: widget.parentJumpMyProfile),
        ]
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildTabRow() {
    // if(Global.profile.locationCode != _temcitycode) {
    //   _temcitycode = Global.profile.locationCode;
    // }

    return
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // children: <Widget>[
          // Expanded(flex: 3,
            child: TabBar(
                controller: _tabController,
                isScrollable: false,
                dragStartBehavior: DragStartBehavior.down,
                labelPadding: EdgeInsets.only(top: 15),
                indicatorWeight: 0.000001,
                tabs: <Widget>[
                  //_item("关注", 0), Alignment.bottomRight, 0, "关注", 0
                  TabBarItem(key: _itemKey1, title: "当前订阅服务", bottomAlignment: Alignment.center, itemtype: 0, itemindex: 0),
                  TabBarItem(key: _itemKey2, title: "会员订阅记录", bottomAlignment: Alignment.center, itemtype: 0, itemindex: 1),
                ]),
          );

  }
}

//头部的tabbar
class TabBarItem extends StatefulWidget {
  Alignment? bottomAlignment;
  int itemtype;
  String title;
  int itemindex;
  TabController? tabController;
  // GlobalKey<MomentListState>? momentKey;

  TabBarItem({Key? key, this.bottomAlignment, this.itemtype = 0,  this.title = "", this.itemindex = 0, this.tabController}) : super(key: key){
    //print(this.title);
  }

  @override
  _TabBarItemState createState() => _TabBarItemState(bottomAlignment!, itemtype,  itemindex);

}
class _TabBarItemState extends State<TabBarItem> {
  Alignment _bottomAlignment;
  int _itemtype;
  int _currentIndex = 1;
  int _itemindex;

  // late ActivityDataBloc _activityDataBloc;
  // late CityActivityDataBloc _cityActivityDataBloc;
  // GlobalKey<MomentListState> _momentState;
  _TabBarItemState(this._bottomAlignment, this._itemtype, this._itemindex);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _activityDataBloc = BlocProvider.of<ActivityDataBloc>(context);
    // _cityActivityDataBloc = BlocProvider.of<CityActivityDataBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
      return item1();
  }

  Widget item1() {
    return Container(
        alignment: _bottomAlignment,
        child: Column(
          children: <Widget>[
            Text(
                widget.title,
                style: TextStyle(
                    fontSize: _itemindex == _currentIndex ? 16 : 15,
                    fontWeight: _itemindex == _currentIndex
                        ? FontWeight.w900
                        : FontWeight.w500,
                    color:
                    _itemindex == _currentIndex
                        ? Global.profile.backColor
                        : Colors.black)
            ),
            Text(
                _itemindex == _currentIndex ? "—" : "",
                style: TextStyle(
                    fontSize: _itemindex == _currentIndex ? 16 : 15,
                    fontWeight: _itemindex == _currentIndex
                        ? FontWeight.w900
                        : FontWeight.w500,
                    color:
                    _itemindex == _currentIndex
                        ? Global.profile.backColor
                        : Colors.black)
            )
          ],
        )
    );
  } //关注和首页

  void onPressed(int val) {
    this._currentIndex = val;

    setState(() {
    });
  }
}

