import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/constant/constant.dart';
import 'package:recipe/navigation/common/navigation_target.dart';
import 'package:recipe/providers/navigator_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:doubanapp/constant/cache_key.dart';
// import 'package:doubanapp/main.dart';

import '../../../extension.dart';
import '../../../providers/personalized_playlist_provider.dart';
import '../widgets/heart_img_widget.dart';
import 'main_page_community.dart';
typedef VoidCallback = void Function();

///个人中心
class PersonCenterPage extends ConsumerWidget {
  const PersonCenterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build PersonCenterPage');
    return
    //   Scaffold(
    //   backgroundColor: Colors.white,
    //   body: SafeArea(
    //       child: Padding(
    //         padding: EdgeInsets.only(top: 10.0),
    //         child: CustomScrollView(
    //           physics: const BouncingScrollPhysics(),
    //           shrinkWrap: false,
    //           slivers: <Widget>[
    //             SliverAppBar(
    //               //backgroundColor: Colors.transparent,
    //               stretch: true,
    //               onStretchTrigger: () {
    //                 // Function callback for stretch
    //                 return Future<void>.value();
    //               },
    //               leading: Icon(Icons.account_circle_rounded),
    //               leadingWidth: 100, // default is 56
    //               flexibleSpace: FlexibleSpaceBar(
    //                 stretchModes: const <StretchMode>[
    //                   StretchMode.zoomBackground,
    //                   StretchMode.blurBackground,
    //                   StretchMode.fadeTitle,
    //                 ],
    //                 centerTitle: true,
    //                 title: const Text('Flight Report'),
    //                 background: Stack(
    //                   fit: StackFit.expand,
    //                   children: <Widget>[
    //                     Image.network(
    //                       'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
    //                       fit: BoxFit.cover,
    //                     ),
    //                     const DecoratedBox(
    //                       decoration: BoxDecoration(
    //                         gradient: LinearGradient(
    //                           begin: Alignment(0.0, 0.5),
    //                           end: Alignment.center,
    //                           colors: <Color>[
    //                             Color(0x60000000),
    //                             Color(0x00000000),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               //HeartImgWidget(Image.asset(
    //               //   Constant.ASSETS_IMG + 'bg_person_center_default.webp')),
    //               expandedHeight: 200.0,
    //             ),
    //             _personItem(Icon(
    //               Icons.account_circle,
    //             ), '18817845273', false),
    //             _divider(),
    //             _personItem(Image.asset(
    //               Constant.ASSETS_IMG + 'ic_me_wallet.png',
    //               width: 25.0,
    //               height: 25.0,
    //             ), '会员', true),
    //             _divider(),
    //             // _personItem(Icon(
    //             //   Icons.history,
    //             // ), '浏览历史', true),
    //             // _divider(),
    //             // _personItem(Image.asset(
    //             //   Constant.ASSETS_IMG + 'ic_me_follows.png',
    //             //   width: 25.0,
    //             //   height: 25.0,
    //             // ), '关注题材', true),
    //             SliverToBoxAdapter(
    //               child: Padding(
    //                 padding: EdgeInsets.only(
    //                     left: 10.0, top: 10.0, bottom: 20.0),
    //                 child: Text(
    //                   '我的收藏',
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.bold, fontSize: 18.0),
    //                 ),
    //               ),
    //             ),
    //             SliverToBoxAdapter(
    //               child: CompanyNews(), // to do
    //             )
    //             // SliverToBoxAdapter(
    //             //   child: Container(
    //             //     child: _VideoBookMusicBookWidget(),
    //             //   ),
    //             // ),
    //             // _personItem('ic_me_journal.png', '我的发布'),
    //             // _personItem(Image.asset(
    //             //   Constant.ASSETS_IMG + 'ic_me_follows.png',
    //             //   width: 25.0,
    //             //   height: 25.0,
    //             // ), '关注题材', true),
    //             // _personItem('ic_me_photo_album.png', '相册'),
    //             // _personItem(Image.asset(
    //             //   Constant.ASSETS_IMG + 'ic_me_doulist.png',
    //             //   width: 25.0,
    //             //   height: 25.0,
    //             // ), '收藏', true),
    //             // _divider(),
    //           ],
    //         ),
    //       )),
    // );
      Scaffold(
        body: CustomScrollView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.blue,
              stretch: true,
              pinned: true,
              onStretchTrigger: () {
                // Function callback for stretch
                return Future<void>.value();
              },
              // leading: Icon(Icons.account_circle_rounded),
              leadingWidth: 100,
              title: Row(
                children: [
                  Icon(Icons.account_circle_rounded),
                  SizedBox(width: 10),
                  Text('Profile Page'),
                ],
              ),
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const <StretchMode>[
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                  StretchMode.fadeTitle,
                ],
                centerTitle: true,
                titlePadding: EdgeInsetsDirectional.only(start: 0, bottom: 200),
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.network(
                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                      fit: BoxFit.cover,
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, 0.5),
                          end: Alignment.center,
                          colors: <Color>[
                            Color(0x60000000),
                            Color(0x00000000),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _personItem(Icon(Icons.history), '浏览历史', true, onTab: () {
              ref
                  .read(navigatorProvider.notifier)
                  .navigate(NavigationTargetHistory());
            }),
            _personItem(Image.asset(
              Constant.ASSETS_IMG + 'ic_me_doulist.png',
              width: 25.0,
              height: 25.0,
            ), '收藏', true, onTab: () {
              ref
                  .read(navigatorProvider.notifier)
                  .navigate(NavigationTargetCollection());
            }),
            // todo mzl pic
            _personItem(Image.asset(
              Constant.ASSETS_IMG + 'ic_me_doulist.png',
              width: 25.0,
              height: 25.0,
            ), '点赞', true, onTab: () {
              ref
                  .read(navigatorProvider.notifier)
                  .navigate(NavigationTargetLike());
            }),
            _divider(),
            _personItem(Image.asset(
              Constant.ASSETS_IMG + 'ic_me_follows.png',
              width: 25.0,
              height: 25.0,
            ), '关注公司', true, onTab: () {
              ref
                  .read(navigatorProvider.notifier)
                  .navigate(NavigationTargetFollow());
            }),
            _personItem(Image.asset(
              Constant.ASSETS_IMG + 'ic_me_follows.png',
              width: 25.0,
              height: 25.0,
            ), '关注领域', true, onTab: () {
              ref
                  .read(navigatorProvider.notifier)
                  .navigate(NavigationTargetFollow());
            }),
            _personItem(Image.asset(
              Constant.ASSETS_IMG + 'ic_me_wallet.png',
              width: 25.0,
              height: 25.0,
            ), '会员', true),
            _divider(),
            _personItem(Image.asset(
              Constant.ASSETS_IMG + 'ic_me_wallet.png',
              width: 25.0,
              height: 25.0,
            ), '主题切换', true),
            _divider(),
            _personItem(Image.asset(
              Constant.ASSETS_IMG + 'ic_me_wallet.png',
              width: 25.0,
              height: 25.0,
            ), '意见反馈', true),
            SliverList(
              delegate: SliverChildListDelegate(
                const <Widget>[
                  // const CompanyNews(),
                  // ListTile(
                  //   leading: Icon(Icons.wb_sunny),
                  //   title: Text('Sunday'),
                  //   subtitle: Text('sunny, h: 80, l: 65'),
                  // ),
                  // ListTile(
                  //   leading: Icon(Icons.wb_sunny),
                  //   title: Text('Monday'),
                  //   subtitle: Text('sunny, h: 80, l: 65'),
                  // ),
                  // ListTiles++
                ],
              ),
            ),
          ],
        ),
      );
  }

  _rightArrow() {
    return Icon(
      Icons.chevron_right,
      color: const Color.fromARGB(255, 204, 204, 204),
    );
  }

  SliverToBoxAdapter _divider() {
    return SliverToBoxAdapter(
      child: Container(
        height: 10.0,
        color: const Color.fromARGB(255, 247, 247, 247),
      ),
    );
  }

  SliverToBoxAdapter _personItem(Widget childWidget, String title, bool showIcon,
      {VoidCallback? onTab}) {
    return SliverToBoxAdapter(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: childWidget,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            showIcon ? _rightArrow() : Icon(Icons.logout)
          ],
        ),
        onTap: onTab,
      ),
    );
  }

  _dataSelect() {
    return UseNetDataWidget();
  }
}

///这个用来改变书影音数据来自网络还是本地模拟
class UseNetDataWidget extends StatefulWidget {
  @override
  _UseNetDataWidgetState createState() => _UseNetDataWidgetState();
}

class _UseNetDataWidgetState extends State<UseNetDataWidget> {
  bool mSelectNetData = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // mSelectNetData = prefs.getBool(CacheKey.USE_NET_DATA) ?? false;
    });
  }

  _setData(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setBool(CacheKey.USE_NET_DATA, value);
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          children: <Widget>[
            Text('书影音数据是否来自网络', style: TextStyle(color: Colors.redAccent, fontSize: 17.0),),
            Expanded(
              child: Container(),
            ),
            CupertinoSwitch(
              value: mSelectNetData,
              onChanged: (bool value) {
                mSelectNetData = value;
                _setData(value);
                var tmp;
                if(value){
                  tmp = '书影音数据 使用网络数据，重启APP后生效';
                }else{
                  tmp = '书影音数据 使用本地数据，重启APP后生效';
                }
                showDialog(context: context, builder: (BuildContext context){
                  return AlertDialog(title: Text('提示'),content: Text(tmp),actions: <Widget>[
                    FloatingActionButton(child: Text('稍后我自己重启'),onPressed: (){
                      Navigator.of(context).pop();
                    },),
                    FloatingActionButton(child: Text('现在重启'),onPressed: (){
                      // RestartWidget.restartApp(context);
                      Navigator.of(context).pop();
                    },)
                  ],);
                });
                setState(() {});
              },
            )
          ],
        ),
      ),
    );
  }
}

///影视、图书、音乐 TAB
class _VideoBookMusicBookWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VideoBookMusicBookWidgetState();
}

class _VideoBookMusicBookWidgetState extends State<_VideoBookMusicBookWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTxt.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130.0,
      child: DefaultTabController(
          length: tabTxt.length,
          child: Column(
            children: <Widget>[
              Align(
                child: _TabBarWidget(),
                alignment: Alignment.centerLeft,
              ),
              _tabView()
            ],
          )),
    );
  }

  Widget _tabView() {
    return Expanded(
      child: TabBarView(
        children: [
          _tabBarItem('bg_videos_stack_default.png'),
          _tabBarItem('bg_books_stack_default.png'),
          _tabBarItem('bg_music_stack_default.png'),
        ],
        controller: _tabController,
      ),
    );
  }

  Widget getTabViewItem(String img, String txt) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 7.0),
            child: Image.asset(
              Constant.ASSETS_IMG + img,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Text(txt)
      ],
    );
  }

  _tabBarItem(String img) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        getTabViewItem(img, '想看'),
        getTabViewItem(img, '在看'),
        getTabViewItem(img, '看过'),
      ],
    );
  }
}

///
///
class _TabBarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabBarWidgetState();
}

TabController? _tabController;

class _TabBarWidgetState extends State<_TabBarWidget> {
  Color? selectColor, unselectedColor;
  TextStyle? selectStyle, unselectedStyle;
  List<Widget>? tabWidgets;

  @override
  void initState() {
    super.initState();
    selectColor = Colors.black;
    unselectedColor = Color.fromARGB(255, 117, 117, 117);
    selectStyle = TextStyle(fontSize: 18, color: selectColor);
    unselectedStyle = TextStyle(fontSize: 18, color: selectColor);
    tabWidgets = tabTxt
        .map((item) =>
        Text(
          item,
          style: TextStyle(fontSize: 15),
        ))
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
    if (_tabController != null) {
      _tabController!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: tabWidgets as List<Widget>,
      isScrollable: true,
      indicatorColor: selectColor,
      labelColor: selectColor,
      labelStyle: selectStyle,
      unselectedLabelColor: unselectedColor,
      unselectedLabelStyle: unselectedStyle,
      indicatorSize: TabBarIndicatorSize.label,
      controller: _tabController,
    );
  }
}

final List<String> tabTxt = ['影视', '图书', '音乐'];
