import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


import '../../model/user.dart';
import '../../util/common_util.dart';
import '../../util/showmessage_util.dart';
import '../../util/imhelper_util.dart';
import '../../service/userservice.dart';
import '../../widget/circle_headimage.dart';
import '../../global.dart';

class MyFansUser extends StatefulWidget {
  final Object? arguments;
  int uid = 0;
  MyFansUser({this.arguments}){

    uid = (arguments as Map)["uid"];
  }


  @override
  _MyFansUserState createState() => _MyFansUserState();
}

class _MyFansUserState extends State<MyFansUser> {
  RefreshController _refreshController = RefreshController(initialRefresh: true);
  UserService _userService = new UserService();
  List<User> users = [];
  ImHelper imHelper = new ImHelper();
  bool _ismore = true;
  double pageheight = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pageheight = MediaQuery.of(context).size.height - 150;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text('粉丝', style: TextStyle(color: Colors.black, fontSize: 16)),
        centerTitle: true,
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: users.length >= 25,
        onRefresh: _getFollowList,
        header: MaterialClassicHeader(distance: 100, ),
        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus? mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text("加载更多", style: TextStyle(color: Colors.black45, fontSize: 13));
            }
            else if(mode==LoadStatus.loading){
              body =  Center(
                child: CircularProgressIndicator(
                  valueColor:  AlwaysStoppedAnimation(Global.profile.backColor),
                ),
              );
            }
            else if(mode == LoadStatus.failed){
              body = Text("加载失败!点击重试!", style: TextStyle(color: Colors.black45, fontSize: 13));
            }
            else if(mode == LoadStatus.canLoading){
              body = Text("放开我,加载更多!", style: TextStyle(color: Colors.black45, fontSize: 13));
            }
            else{
              body = Text("—————— 我也是有底线的 ——————", style: TextStyle(color: Colors.black45, fontSize: 13));
            }
            print(mode);
            return Container(
              height: 55.0,
              child: Center(child:body),
            );
          },
        ),
        controller: _refreshController,
        onLoading: _onLoading,
        child: _refreshController.headerStatus == RefreshStatus.completed && users.length == 0 ? Center(
          child: Text('创建活动就能受到更多关注',
            style: TextStyle(color: Colors.black54, fontSize: 14), maxLines: 2,),
        ) : ListView(
          addAutomaticKeepAlives: true,
          children: buildMemberList(),
        ),
      ),
    );
  }

  void _getFollowList() async {
    users = await _userService.getFans(widget.uid, Global.profile.user!.token!, 0);
    if(users != null){
      await getFollowInfo();
    }
    _refreshController.refreshCompleted();
    if(mounted)
      setState(() {

      });
  }

  void _onLoading() async{
    if(!_ismore) return;
    final moredata = await _userService.getFans(widget.uid, Global.profile.user!.token!, users.length);

    if(moredata.length > 0)
      users = users + moredata;

    if(users != null){
      await getFollowInfo();
    }

    if(moredata.length >= 25)
      _refreshController.loadComplete();
    else{
      _ismore = false;
      _refreshController.loadNoData();
    }

    if(mounted)
      setState(() {

      });
  }

  List<Widget> buildMemberList(){
    List<Widget> widgets = [];
    widgets.add(SizedBox(height: 10,));
    users.forEach((element) {
      if(element.uid == widget.uid){
        widgets.add(SizedBox.shrink());
      }
      else {
        String tem = element.isfollow ? "已关注" : " ＋ 关注";
        widgets.add(
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5, top: 0),
              child: Card(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),  //设置圆角
                elevation: 0,
                child: ListTile(
                  onTap: () {
                    if(Global.profile.user != null && element.uid == Global.profile.user!.uid){
                      Navigator.pushNamed(context, '/MyProfile');
                    }
                    else
                      Navigator.pushNamed(context, '/OtherProfile',
                        arguments: {"uid": element.uid});
                  },
                  title: Padding(
                    padding: EdgeInsets.only(top: 5,bottom: 3),
                    child: Text(element.username, style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        element.signature == null || element.signature == "" ? 'Ta很神秘' : element.signature,
                        maxLines: 2,style: TextStyle(color: Colors.black87, fontSize: 13),),
                      SizedBox(height: 3,),
                      Text(
                        '有${CommonUtil.getNum(element.likenum!)}个赞', style: TextStyle(color: Colors.black54, fontSize: 12, ),),
                      SizedBox(height: 5,)

                    ],
                  ),
                  leading: NoCacheCircleHeadImage(
                      imageUrl: element.profilepicture! == null ? Global.profile.profilePicture! : element.profilepicture!, width: 50, uid: element.uid,),
                  trailing: Global.profile.user != null && Global.profile.user!.uid == element.uid ? SizedBox.shrink() : Container(
                    height: 36,
                    child: OutlinedButton (
                      // shape:  RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.all(Radius.circular(10))),
                      // borderSide: BorderSide(color: element.isFollow ?  Colors.grey.shade200 :Global.profile.backColor!,
                      // ),
                      // color: element.isFollow ? Colors.grey.shade200 : Global.profile.backColor,
                      style: OutlinedButton.styleFrom(
                          primary: element.isfollow ? Colors.grey.shade200 : Global.profile.backColor,
                          side: BorderSide(color: element.isfollow ?  Colors.grey.shade200 :Global.profile.backColor!),
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(tem, style: TextStyle(color: element.isfollow ? Colors.black54 : Global.profile.backColor, fontSize: 14)),
                      onPressed: () async {
                        if (element.isfollow) {
                          bool ret = await _userService.cancelFollow(Global.profile.user!.token!, Global.profile.user!.uid, element.uid, errorCallBack);
                          print("[myfans clean follow] ret: $ret");
                          if(ret) {
                            await imHelper.delFollowState(element.uid, Global.profile.user!.uid);
                            Global.profile.user!.following = Global.profile.user!.following! - 1;
                            Global.saveProfile();
                            element.isfollow = false;
                            print("[myfans clean follow] following: ${Global.profile.user!.following}");
                            setState(() {

                            });
                          }
                        }
                        else {
                          bool ret = await _userService.Follow(Global.profile.user!.token!, Global.profile.user!.uid, element.uid, errorCallBack);
                          if(ret) {
                            await imHelper.delFollowState(element.uid, Global.profile.user!.uid);
                            await imHelper.saveFollowState(element.uid, Global.profile.user!.uid);
                            Global.profile.user!.following = Global.profile.user!.following! + 1;
                            Global.saveProfile();
                            element.isfollow = true;

                            setState(() {

                            });
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            )
        );
      }
    });
    return widgets;
  }

  Future<void> getFollowInfo() async {

    if(users != null){
      for(int i =0; i < users.length; i++){
        bool ret = await isFollow(users[i].uid, Global.profile.user!.uid);
        if(ret){
          users[i].isfollow = true;
        }
      }

    }

  }

  Future<bool> isFollow(int followed, int uid) async {
    bool isfollowed = false;
    List<int> list = await imHelper.selFollowState(
        followed, uid);
    if(list != null && list.length > 0)
      isfollowed = true;

    return isfollowed;
  }

  errorCallBack(String statusCode, String msg) {
    ShowMessage.showToast(msg);
  }
}
