import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    // List<dynamic> snapshot = newsListProvider(this._fromId);
    // if (snapshot)
    // setState(() {
    //
    // });
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
    return _PlayListItemView(playlist: p, width: 60, type: 0);
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
      backgroundColor: const Color(0xFF117215),
      appBar: AppBar(
        title: Text('AndBlog'),
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
      // SingleChildScrollView(
      //     controller: _scrollController,
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: <Widget>[
      //         CustomAppBar(
      //           title: context.strings.headlines,
      //           isShowLeftIcon: true,
      //           leftIcon: Icon(
      //             Icons.chevron_left_outlined,
      //             color: Colors.white,
      //           ),
      //           isShowActionIcon1: true,
      //           actionIcon1: Icon(
      //             Icons.category,
      //             color: Colors.white,
      //           ),
      //           isShowActionIcon2: true,
      //           actionIcon2: Icon(Icons.air_rounded, color: Colors.white,),
      //           isShowActionIcon3: true,
      //           actionIcon3: Icon(Icons.search, color: Colors.white,),
      //         ),
      //         _Header('推荐菜品', () {}), // 当你不知道吃什么时候
      //       ]),
      //   );
  }
}

class _NavigationLine extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _ItemNavigator(
            Icons.radio,
            '私人FM',
            () => ref
                .read(navigatorProvider.notifier)
                .navigate(NavigationTargetFmPlaying()),
          ),
          _ItemNavigator(Icons.today, '每日推荐', () {
            context.secondaryNavigator!.pushNamed(pageDaily);
          }),
          _ItemNavigator(Icons.show_chart, '排行榜', () {
            context.secondaryNavigator!.pushNamed(pageLeaderboard);
          }),
        ],
      ),
    );
  }
}

///common header for section
class _Header extends StatelessWidget {
  const _Header(this.text, this.onTap);

  final String text;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(padding: EdgeInsets.only(left: 8)),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.w800),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

class _ItemNavigator extends StatelessWidget {
  const _ItemNavigator(this.icon, this.text, this.onTap);

  final IconData icon;

  final String text;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: <Widget>[
            Material(
              shape: const CircleBorder(),
              elevation: 5,
              child: ClipOval(
                child: Container(
                  width: 40,
                  height: 40,
                  color: Theme.of(context).primaryColor,
                  child: Icon(
                    icon,
                    color: Theme.of(context).primaryIconTheme.color,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 8)),
            Text(text),
          ],
        ),
      ),
    );
  }
}

// class _HeadLineNews extends ConsumerWidget {
//   _HeadLineNews(this._fromId, this._callback);
//
//   int _fromId = 0;
//   final setEndIdCallback _callback;
//   List<RecommendedPlaylist> widgets = [];
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {

    // final snapshot = ref.watch(newsListProvider(this._fromId).logErrorOnDebug());
    // return snapshot.when(
    //   data: (list) {
    //     RecommendedPlaylist last = list.last as RecommendedPlaylist;
    //     _callback(last.id);
    //     widgets.addAll(list as List<RecommendedPlaylist>);
    //
    //     return LayoutBuilder(
    //       builder: (context, constraints) {
    //         assert(
    //         constraints.maxWidth.isFinite,
    //         'can not layout playlist item in infinite width container.',
    //         );
    //         final parentWidth = constraints.maxWidth - 8;
    //         const count = /* false ? 6 : */ 3;
    //         final width = (parentWidth / count).clamp(80.0, 200.0);
    //         final spacing = (parentWidth - width * count) / (count + 1);
    //         return Padding(
    //           padding:
    //           EdgeInsets.symmetric(horizontal: 4 + spacing.roundToDouble()),
    //           child: ListView.builder(
    //             itemCount: widgets.length,
    //             physics: const NeverScrollableScrollPhysics(),
    //             itemBuilder: (BuildContext context, int position) {
    //               return getRow(position);
    //             },
    //             scrollDirection: Axis.vertical,
    //             shrinkWrap: true,
    //           ),
    //         );
    //       },
    //     );
    //   },
    //   error: (error, stacktrace) {
    //     return SizedBox(
    //       height: 200,
    //       child: Center(
    //         child: Text(context.formattedError(error)),
    //       ),
    //     );
    //   },
    //   // loading 的时候显示的图标
    //   loading: () => const SizedBox(
    //     height: 200,
    //     child: Center(
    //       child: SizedBox.square(
    //         dimension: 24,
    //         child: CircularProgressIndicator(),
    //       ),
    //     ),
    //   ),
    // );
  // }

//   Widget getRow(int i) {
//     var p = widgets[i];
//     return _PlayListItemView(playlist: p, width: 150, type: 0);
//   }
// }

class _PlayListItemView extends ConsumerWidget {
  const _PlayListItemView({
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
          .navigate(NavigationTargetPlaylist(playlist.id)),
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

class _SectionNewSongs extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(personalizedNewSongProvider.logErrorOnDebug());
    // final snapshot = ref.watch(homePlaylistProvider.logErrorOnDebug());
    return snapshot.when(
      data: (songs) {
        final double width = 500;
        // return Flexible(
        //     child: Column(
        //       // children: songs.map(MusicTile.new).toList(),
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: songs.map<Widget>((p) {
        //         return _PlayListItemView(playlist: p, width: 100, type: 1);
        //       }).toList()
        // ));
        return MusicTileConfiguration(
          musics: songs,
          token: 'playlist_main_newsong',
          child: Column(
            children: songs.map(MusicTile.new).toList(),
          ),
        );
      },
      error: (error, stacktrace) {
        return SizedBox(
          height: 200,
            child: Text(context.formattedError(error)),
        );
      },
      loading: () => const SizedBox(
        height: 200,
        child: Center(
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
