import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:recipe/constant/constant.dart';
import 'package:recipe/navigation/mobile/widgets/movie_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../component/global/orientation.dart';
import '../../../component/route.dart';
import '../../../extension.dart';
import '../../../providers/navigator_provider.dart';
import '../../../providers/personalized_playlist_provider.dart';
import '../../../repository.dart';
import '../../common/navigation_target.dart';
import '../../common/playlist/music_list.dart';
import 'main_page_companies.dart';

typedef DebugPrinter = void Function(String message);

typedef setEndIdCallback = void Function(int endId);

DebugPrinter debugPrint = (msg) {
  print(msg);
};

class MainPageHeadlines extends ConsumerStatefulWidget  {
  const MainPageHeadlines({super.key});

  @override
  PageHeadlinesState  createState() => PageHeadlinesState();
}

class PageHeadlinesState extends ConsumerState<MainPageHeadlines>
    with AutomaticKeepAliveClientMixin {

  bool isInSearch = false;
  final searchController = TextEditingController();
  String searchWord = "";

  @override
  bool get wantKeepAlive => true;

  double currentScrollOffset = 0;

  List<HeadLinesItem> _itemList = [];

  String _loadMoreText = "网络加载中";

  TextStyle _loadMoreTextStyle = new TextStyle(color: const Color(0xFF4483f6), fontSize: 14.0);

  //定时器自动轮播
  Timer? _timer = null;

  var _hasData = true;

  ScrollController _scrollController = new ScrollController();
  PageController _pageController=PageController();
  List<Widget> _viewPageList =<Widget>[
    // new Center(child:new Pages(text: "Page 1",)),
    // new Center(child:new Pages(text: "Page 2",)),
    // new Center(child:new Pages(text: "Page 3",)),
    // new Center(child:new Pages(text: "Page 4",))
    Container(
      color: Colors.green,
      width: double.infinity,
      height: 110,
    ),
    Container(
      color: Colors.red,
      width: double.infinity,
      height: 130,
    ),
    Container(
      color: Colors.blue,
      width: double.infinity,
      height: 110,
    )
  ];
  int _curr=0;
  var _page = 0;


  @override
  void initState() {
    super.initState();
    _loadMore();
    debugPrint('init state: add scroll listener =============');
    _scrollController.addListener(() {
      debugPrint('in listener: scroll pixels: ${_scrollController.position.pixels}, max: ${_scrollController.position.maxScrollExtent}' );
      currentScrollOffset = _scrollController.position.pixels;
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        debugPrint('load more: =============');
        _loadMore();

      }
    });
    ///当前页面绘制完第一帧后回调
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startTimer();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMore() async {

    var itemIndex = _itemList.isEmpty ? 0 : _itemList.last.id + 1;
    final list = (await ref.read(newsListProvider(itemIndex).future) ) as List<HeadLinesItem>;
    setState(() {
      if (list.length < 8) {
        _hasData = false;
      } else {
        _hasData = true;
      }
      _itemList.addAll(list);

      // setState 相当于 runOnUiThread
      if (_hasData) {
        // setState(() {
          _loadMoreText = "网络加载中";
          _loadMoreTextStyle = new TextStyle(color: const Color(0xFF4483f6), fontSize: 14.0);
        // });
        _page++;
        debugPrint('page = ${_page.toString()}');
      } else {
        // setState(() {
          _loadMoreText = "没有更多数据";
          _loadMoreTextStyle = new TextStyle(color: const Color(0xFF999999), fontSize: 14.0);
        // });
      }
      debugPrint('list length: ${list.length.toString()}');
    });
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      print('refresh');
      setState(() {
        _page = 0;
        _itemList.clear();
        _loadMore();
      });
    });
  }

  Widget _buildProgressMoreIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Center(
        child: new Text(_loadMoreText, style: _loadMoreTextStyle),
      ),
    );
  }

  Widget getRow(int i) {
    var p = _itemList[i];
    return _NewsListItemView(playlist: p, width: 60, type: 0);
  }
  Widget _contentList() {
    debugPrint('news length: ${_itemList.length.toString()}');
    return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: _itemList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == _itemList.length) {
              return _buildProgressMoreIndicator();
            } else {
              return getRow(index);
            }
          },
          controller: _scrollController,
        ));
  }

  void startTimer() {
    //间隔两秒时间
    _timer = new Timer.periodic(Duration(milliseconds: 5000), (value) {
      // print("定时器");
      // _curr = (_curr + 1) % _list.length;
      _curr++;
      //触发轮播切换
      _pageController.animateToPage(_curr,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
      //刷新
      setState(() {

      });
    });
  }

  Widget _buildIndicator() {
    var length = _viewPageList.length;
    return Positioned(
      bottom: 10,
      child: Row(
        children: _viewPageList.map((s) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: ClipOval(
              child: Container(
                width: 8,
                height: 8,
                color: s == _viewPageList[_curr % length]
                    ? Colors.white
                    : Colors.grey,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  _cancelTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    var content;
    var listChild;
    super.build(context);
    if (_itemList.length == 0) {
      listChild = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      listChild = _contentList();
    }
    content = Column(
      children: [
        Expanded(
          flex: 1,
          child:
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              PageView.builder(
                // children: _list,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onPanDown: (details) {
                        print("onPanDown");
                        _cancelTimer();
                      },
                      child: _viewPageList[index % _viewPageList.length]
                  );
                },
                scrollDirection: Axis.horizontal,
                // reverse: true,
                // physics: BouncingScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index){
                  setState(() {
                    if (index == 0) {
                      _curr = _viewPageList.length;
                    } else {
                      _curr = index;
                    }
                  });
                },
              ),
              _buildIndicator(),
            ],
          )
          ,
        ),
        Expanded(
          flex: 3,
          child: listChild,
        )
      ],
    );


    return Scaffold(
      backgroundColor: const Color(Constant.APPBAR_COLOR),
      appBar: CustomAppBar(
          title: Text(context.strings.headlines),
          isShowLeftIcon: true,
          backgroundColor: Colors.blue,
          leftIcon: Icon(
            Icons.person, // todo mzl
            color: Colors.white,
          ),
          isShowActionIcon1: false,
          // actionIcon1: isInSearch ?  : const Icon(Icons.search),
          // isShowActionIcon2: true,
          // actionIcon2: Icon(Icons.air_rounded, color: Colors.white,),
          isShowActionIcon3: false,
          // actionIcon3: Icon(Icons.search),
          // pressedActionIcon3: () {
          //   toast("搜索新闻");
          //   setState(() {
          //     isInSearch = !isInSearch;
          //   });
          // }
          ),
      body: content,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.account_box),
        onPressed: () {
          print("FloatingActionButton");
        },
        elevation: 30,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Pages extends StatelessWidget {
  final text;
  Pages({this.text});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            Text(text,textAlign: TextAlign.center,style: TextStyle(
                fontSize: 30,fontWeight:FontWeight.bold),),
          ]
      ),
    );
  }
}

class _NewsListItemView extends ConsumerWidget {
  const _NewsListItemView({
    super.key,
    required this.playlist,
    required this.width,
    required this.type,
  });

  final HeadLinesItem playlist;

  final double width;

  final int type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GestureLongPressCallback? onLongPress;

    if (playlist.source.isNotEmpty) {
      onLongPress = () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                playlist.source,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          },
        );
      };
    }

    return InkWell(
      onTap: () => ref
          .read(navigatorProvider.notifier)
          .navigate(NavigationTargetNewsDetail(playlist.id)),
      onLongPress: onLongPress,
      child: Container(
        width: this.type == 0 ? width : 800,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: this.type == 0 ? Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${playlist.title}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  children: <Widget>[
                    Text(
                      "${playlist.source}",
                      style: TextStyle(fontSize: 10),
                      maxLines: 1,
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Text(
                      "${DateTime.fromMillisecondsSinceEpoch(int.parse(playlist.updateTime.toString()))}",
                      style: TextStyle(fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    ]
                )
              ]
            ),
            // const Padding(padding: EdgeInsets.only(right: 8)),
            const Spacer(),
            SizedBox(
              height: width,
              width: width,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: FadeInImage(
                    placeholder:
                    const AssetImage('assets/playlist_playlist.9.png'),
                    image: CachedImage(playlist.headPicUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 8))
          ],
        ) :
        Row(
          children: <Widget>[
            SizedBox(
              height: width,
              width: width,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: FadeInImage(
                    placeholder:
                    const AssetImage('assets/playlist_playlist.9.png'),
                    image: CachedImage(playlist.headPicUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text(
              playlist.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        )
      ),
    );
  }
}
