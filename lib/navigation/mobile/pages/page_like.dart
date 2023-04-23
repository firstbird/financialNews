import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:recipe/constant/constant.dart';
import 'package:recipe/navigation/common/buttons.dart';
import 'package:recipe/navigation/mobile/widgets/movie_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../component/global/orientation.dart';
import '../../../component/route.dart';
import '../../../extension.dart';
import '../../../providers/navigator_provider.dart';
import '../../../providers/personalized_playlist_provider.dart';
import '../../../repository.dart';
import '../../common/navigation_target.dart';

typedef setEndIdCallback = void Function(int endId);

class PageLike extends ConsumerStatefulWidget  {
  const PageLike({super.key});

  @override
  PageLikeState  createState() => PageLikeState();
}

class PageLikeState extends ConsumerState<PageLike>
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

  var _hasData = true;

  ScrollController _scrollController = new ScrollController();
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
    return _LikeItemView(playlist: p, width: 60, type: 0);
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

  @override
  Widget build(BuildContext context) {
    var content;
    super.build(context);
    if (_itemList.length == 0) {
       content = new Center(
         child: new CircularProgressIndicator(),
       );
    } else {
      content = _contentList();
    }

    return Scaffold(
      backgroundColor: const Color(Constant.APPBAR_COLOR),
      appBar: CustomAppBar(
          title: !isInSearch
              ? Text(
            // todo mzl search area style
                searchWord == "" ? context.strings.collectionLike : searchWord,
                style: TextStyle(
                  color: Colors.white,
                ),
              )
              : SizedBox(
            // padding: const EdgeInsets.all(16.0),
              height: 28.0,
              width: 270.0,
              child: TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'search likes',
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 5, horizontal: 10),
                ),
                style: TextStyle(
                  color: Colors.black54,
                ),
                onEditingComplete: () {
                  setState(() {
                    // toast(searchController.text);
                    searchWord = searchController.text;
                    isInSearch = false;
                  });
                },
              )),
          isShowLeftIcon: true,
          backgroundColor: Colors.blue,
          leftIcon: Icon(
            Icons.chevron_left_outlined,
            color: Colors.white,
          ),
          pressedLeftIcon: () {
            ref.read(navigatorProvider.notifier).back();
          },
          isShowActionIcon1: false,
          // actionIcon1: isInSearch ?  : const Icon(Icons.search),
          // isShowActionIcon2: true,
          // actionIcon2: Icon(Icons.air_rounded, color: Colors.white,),
          isShowActionIcon3: true,
          actionIcon3: Icon(Icons.search),
          pressedActionIcon3: () {
            toast("搜索关注");
            setState(() {
              isInSearch = !isInSearch;
            });
          }),
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

class _LikeItemView extends ConsumerWidget {
  const _LikeItemView({
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
