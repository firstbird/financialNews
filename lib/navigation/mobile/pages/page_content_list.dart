import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:recipe/providers/navigator_provider.dart';
import 'package:recipe/providers/personalized_playlist_provider.dart';

import '../../../extension.dart';
import '../../../providers/account_provider.dart';
import '../../../providers/player_provider.dart';
import '../../../providers/playlist_detail_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../repository.dart';
import '../../common/navigation_target.dart';
import '../../common/playlist/music_list.dart';
import '../widgets/movie_app_bar.dart';
import '../widgets/track_title.dart';
import 'playlist_flexible_app_bar.dart';

const double kHeaderHeight = 180 + kToolbarHeight;

/// page display a Playlist
///
/// Playlist : a list of musics by user collected

class ContentListPage extends ConsumerStatefulWidget {

  ContentListPage({super.key, required this.contentType});

  final int contentType;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return PageContentListState(contentType: contentType);
  }

}
class PageContentListState extends ConsumerState<ContentListPage>
    with AutomaticKeepAliveClientMixin {

  PageContentListState({required this.contentType});

  bool isInSearch = false;
  final searchController = TextEditingController();
  String searchWord = "";
  final double tabHeight = 15.0;
  final int contentType;
  List<HeadLinesItem> _itemList = [];

  ScrollController _scrollController = new ScrollController();
  var _page = 0;

  String _loadMoreText = "网络加载中";

  TextStyle _loadMoreTextStyle = new TextStyle(color: const Color(0xFF4483f6), fontSize: 14.0);

  //定时器自动轮播
  Timer? _timer = null;

  var _hasData = true;
  double currentScrollOffset = 0;

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
  Widget build(BuildContext context) {
    var listChild;
    debugPrint('content build begin');
    // _itemList = ref.read(newsListProvider(contentType)) as List<HeadLinesItem>;
    if (_itemList.length == 0) {
      listChild = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      listChild = _contentList();
    }
    // final absorberHandle = useMemoized(SliverOverlapAbsorberHandle.new);
    // return headLines.when(
    //   data: (result) {
    //     final created = result.where((p) => p.creator.userId == userId);
    //     final subscribed = result.where((p) => p.creator.userId != userId);
    //     return _UserPlaylists(
    //       created: created.toList(),
    //       subscribed: subscribed.toList(),
    //       scrollController: scrollController,
    //       firstItemOffset: firstItemOffset,
    //     );
    //   },
    //   error: (error, stackTrace) => SliverToBoxAdapter(
    //     child: Text(context.formattedError(error)),
    //   ),
    //   loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
    // );
    // final settings =
    // context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;
    // final deltaExtent = settings.maxExtent - settings.minExtent;
    return
      Scaffold(
        appBar: CustomAppBar(
            title: !isInSearch
                ? Text(
              // todo mzl search area style
              searchWord == "" ? context.strings.discover : searchWord,
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
                    hintText: 'search company name',
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  ),
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                  onEditingComplete: () {
                    // toast(searchController.text);
                    searchWord = searchController.text;
                    isInSearch = false;
                  },
                )),
            isShowLeftIcon: true,
            backgroundColor: Colors.lightGreen,
            leftIcon: Icon(
              Icons.chevron_left_outlined,
              color: Colors.white,
            ),
            isShowActionIcon1: false,
            // actionIcon1: isInSearch ?  : const Icon(Icons.search),
            // isShowActionIcon2: true,
            // actionIcon2: Icon(Icons.air_rounded, color: Colors.white,),
            isShowActionIcon3: true,
            actionIcon3: Icon(Icons.search),
            pressedActionIcon3: () {
              toast("搜索公司");
              isInSearch = !isInSearch;
            }),
        body: Column(
        children: <Widget>[
            GridView.count(
              crossAxisCount: 5,
              childAspectRatio: 2.0, // width / height
              physics: NeverScrollableScrollPhysics(),
              // to disable GridView's scrolling
              shrinkWrap: true,
              // You won't see infinite size error
              children: <Widget>[
                Container(
                  color: Colors.green,
                ),
                Container(
                  color: Colors.blue,
                ),
                Container(
                  color: Colors.red,
                ),
                Container(
                  color: Colors.yellow,
                ),
                Container(
                  color: Colors.cyan,
                ),
                Container(
                  color: Colors.deepOrangeAccent,
                ),
                Container(
                  color: Colors.lightGreen,
                ),
                Container(
                  color: Colors.yellowAccent,
                ),
                Container(
                  color: Colors.brown,
                ),
                Container(
                  color: Colors.purple,
                ),
              ],
          ),
          _Header('热门推荐', () {}), // 当你不知道吃什么时候
          Expanded(
            child:listChild),
        ],
    ),
      );
  }

  Widget getRow(int i) {
    var p = _itemList[i];
    return _NewsListItemView(headLinesItem: p, width: 500, type: 0);
  }

  Widget _buildProgressMoreIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Center(
        child: new Text(_loadMoreText, style: _loadMoreTextStyle),
      ),
    );
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
      _page = 0;
      _itemList.clear();
      _loadMore();
    });
  }
  Widget _contentList() {
    debugPrint('news length: ${_itemList.length.toString()}');
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
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
  bool get wantKeepAlive => true;

}

class _NewsListItemView extends ConsumerWidget {
  const _NewsListItemView({
  super.key,
  required this.headLinesItem,
  required this.width,
  required this.type,
  });

  final HeadLinesItem headLinesItem;

  final double width;

  final int type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GestureLongPressCallback? onLongPress;

    if (headLinesItem.source.isNotEmpty) {
      onLongPress = () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                headLinesItem.source,
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
          .navigate(NavigationTargetNewsDetail(headLinesItem.id)),
      onLongPress: onLongPress,
      child: Container(
          width: this.type == 0 ? width : 800,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: this.type == 0 ? Column(
            children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                        children: <Widget>[
                          CircleAvatar(
                            //头像半径
                            radius: 25,
                            //头像图片 -> NetworkImage网络图片，AssetImage项目资源包图片, FileImage本地存储图片
                            backgroundImage: CachedImage(headLinesItem.headPicUrl),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "叮当",
                                style: TextStyle(fontSize: 15),
                                maxLines: 1,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${DateTime.fromMillisecondsSinceEpoch(int.parse(headLinesItem.updateTime.toString()))}",
                                    style: TextStyle(fontSize: 10),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Padding(padding: EdgeInsets.only(left: 10)),
                                  Text(
                                    "${headLinesItem.source}",
                                    style: TextStyle(fontSize: 10),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ],
                          ),

                        ]
                    ),
                    const Padding(padding: EdgeInsets.only(top: 8)),
                    Text(
                      "${headLinesItem.title}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 3)),
                    SizedBox(
                      height: 200, // todo mzl adjust size
                      width: 500, // todo mzl adjust size
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: FadeInImage(
                            placeholder:
                            const AssetImage('assets/playlist_playlist.9.png'),
                            image: CachedImage(headLinesItem.headPicUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 3)),
                    Divider(height: 1.0,indent: 3, endIndent: 3, color: Colors.grey,)
                  ]
              ),
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
                      image: CachedImage(headLinesItem.headPicUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Text(
                headLinesItem.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )
      ),
    );
  }
}

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

class _OverlappedButton extends StatefulWidget {
  const _OverlappedButton({
  super.key,
  required this.label,
  required this.onPressed,
  this.borderRadius,
  });

  final Widget label;

  final VoidCallback onPressed;

  final BorderRadiusGeometry? borderRadius;

  @override
  State<StatefulWidget> createState() {
    return OverlappedButtonState();
  }
}

class OverlappedButtonState extends State<_OverlappedButton> {
  bool _isFavorited = false;
  int _favoriteCount = 41;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      customBorder: widget.borderRadius == null
          ? null
          : RoundedRectangleBorder(
        borderRadius: widget.borderRadius!,
      ),
      child:
        // Expanded(
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    context.strings.subscribe,
                    style: context.primaryTextTheme.titleSmall,
                ),
                IconTheme.merge(
                  data: IconThemeData(
                    size: 30,
                    color: context.textTheme.bodySmall!.color,
                  ),
                  child: IconButton(
                    iconSize: 20,
                    padding: const EdgeInsets.all(0),
                    alignment: Alignment.center,
                    icon: (_isFavorited
                        ? const Icon(Icons.star)
                        : const Icon(Icons.star_border)),
                    color: Colors.white,
                    onPressed: _toggleFavorite,
                  ),
                ),
                // DefaultTextStyle(
                //   style: context.textTheme.bodySmall!,
                // ),
              ],
            ),
            // widget.label,
          // ],
        // ),
      );
  }

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount -= 1;
        _isFavorited = false;
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }
}

class _Appbar extends StatelessWidget {
  const _Appbar({super.key, required this.newsDetail});

  final NewsDetail newsDetail;

  @override
  Widget build(BuildContext context) => SliverAppBar(
        elevation: 0,
        pinned: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        expandedHeight: kHeaderHeight,
        // bottom: MusicListHeader(playlist.tracks.length),
        flexibleSpace: PlaylistFlexibleAppBar(newsList: newsDetail),
      );
}

///body display the list of song item and a header of playlist
class _MusicList extends ConsumerWidget {
  const _MusicList(this.playlist);

  final NewsDetail playlist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String text = "星云大师说：分享故事：小朋友好奇地问智者：“我到底应该拜哪些老师，跟谁去学习呢？”智者说：“小朋友的问题问得好。世界上有那么多知名的大学，里面又有非常多的教授，他们都是学识渊博的顶级导师，而你现在是个小学三年级的小孩，你应该选择跟谁去学习呢？我建议啊，你可以先跟你的小学老师学！小学毕业了有中学老师教你，中学毕业了有高中和大学老师教你，然后还有社会老师教你… 智者笑着继续说：“其实，生活中所有的人都可以成为你的老师，他们都可以在各领域教导你一些知识，或者做人的道理。重点在于，你要把自己放的很低，千万不要骄傲。你骄傲，就没有人能教得了你，如果你把自己放得足够低，那么所有人都能成为你的老师，包括你的朋友、家人、同事、甚至你的敌人，乃至山川大河、花鸟虫鱼，你都能从中得到感悟。小朋友说：“就是不要自以为了不起，这样就可以学到很多东西，是这样吗？”智者说：“说一句你长大后就会明白的话：我们如果能让心不染尘，万物都可以是我们学习的对象，重要的是你要从这个时候开始，把姿态放低，越低越好。方便"
        "“低姿态”的修养，说来容易做起来不简单，如果能从小培养孩子有这方面的认知更好，因为它须经年累月养成。一般人有了“低姿态”的修养，在社会上做人处事，必能得到许多方便。因为人生在世，昂首与低头，低头的人定比较受人喜爱，所以低姿态的人会有人缘。古代的儒家，学子入学，先教你叩头拜师；佛教的信者，信佛要先礼拜，朋友相交，也要点头敬礼。一个人如果不和别人接触，随你长得有多高，随你如何不可一世；一旦你要和人接触，就必须要低头、谦卑。傲慢只是，一般人在平常，极不容易向别人低头，因为把自己的面子放在前头，认为低头是不光彩的事，除非是会伤害到自己的利益或逼不得已时，才肯低头。然而，所谓“舍得，不舍不得，小舍小得，大舍大得”，我们在生活中，说穿了就是一连串“舍得、得舍”的过程，能够衡量其中的利害关系，就会知道，能把自己的姿态放得最低，往往就是大舍而大得。星云大师说：分享故事：小朋友好奇地问智者：“我到底应该拜哪些老师，跟谁去学习呢？”智者说：“小朋友的问题问得好。世界上有那么多知名的大学，里面又有非常多的教授，他们都是学识渊博的顶级导师，而你现在是个小学三年级的小孩，你应该选择跟谁去学习呢？我建议啊，你可以先跟你的小学老师学！小学毕业了有中学老师教你，中学毕业了有高中和大学老师教你，然后还有社会老师教你… 智者笑着继续说：“其实，生活中所有的人都可以成为你的老师，他们都可以在各领域教导你一些知识，或者做人的道理。重点在于，你要把自己放的很低，千万不要骄傲。你骄傲，就没有人能教得了你，如果你把自己放得足够低，那么所有人都能成为你的老师，包括你的朋友、家人、同事、甚至你的敌人，乃至山川大河、花鸟虫鱼，你都能从中得到感悟。小朋友说：“就是不要自以为了不起，这样就可以学到很多东西，是这样吗？”智者说：“说一句你长大后就会明白的话：我们如果能让心不染尘，万物都可以是我们学习的对象，重要的是你要从这个时候开始，把姿态放低，越低越好。方便"
        "“低姿态”的修养，说来容易做起来不简单，如果能从小培养孩子有这方面的认知更好，因为它须经年累月养成。一般人有了“低姿态”的修养，在社会上做人处事，必能得到许多方便。因为人生在世，昂首与低头，低头的人定比较受人喜爱，所以低姿态的人会有人缘。古代的儒家，学子入学，先教你叩头拜师；佛教的信者，信佛要先礼拜，朋友相交，也要点头敬礼。一个人如果不和别人接触，随你长得有多高，随你如何不可一世；一旦你要和人接触，就必须要低头、谦卑。傲慢只是，一般人在平常，极不容易向别人低头，因为把自己的面子放在前头，认为低头是不光彩的事，除非是会伤害到自己的利益或逼不得已时，才肯低头。然而，所谓“舍得，不舍不得，小舍小得，大舍大得”，我们在生活中，说穿了就是一连串“舍得、得舍”的过程，能够衡量其中的利害关系，就会知道，能把自己的姿态放得最低，往往就是大舍而大得。星云大师说：分享故事：小朋友好奇地问智者：“我到底应该拜哪些老师，跟谁去学习呢？”智者说：“小朋友的问题问得好。世界上有那么多知名的大学，里面又有非常多的教授，他们都是学识渊博的顶级导师，而你现在是个小学三年级的小孩，你应该选择跟谁去学习呢？我建议啊，你可以先跟你的小学老师学！小学毕业了有中学老师教你，中学毕业了有高中和大学老师教你，然后还有社会老师教你… 智者笑着继续说：“其实，生活中所有的人都可以成为你的老师，他们都可以在各领域教导你一些知识，或者做人的道理。重点在于，你要把自己放的很低，千万不要骄傲。你骄傲，就没有人能教得了你，如果你把自己放得足够低，那么所有人都能成为你的老师，包括你的朋友、家人、同事、甚至你的敌人，乃至山川大河、花鸟虫鱼，你都能从中得到感悟。小朋友说：“就是不要自以为了不起，这样就可以学到很多东西，是这样吗？”智者说：“说一句你长大后就会明白的话：我们如果能让心不染尘，万物都可以是我们学习的对象，重要的是你要从这个时候开始，把姿态放低，越低越好。方便"
        "“低姿态”的修养，说来容易做起来不简单，如果能从小培养孩子有这方面的认知更好，因为它须经年累月养成。一般人有了“低姿态”的修养，在社会上做人处事，必能得到许多方便。因为人生在世，昂首与低头，低头的人定比较受人喜爱，所以低姿态的人会有人缘。古代的儒家，学子入学，先教你叩头拜师；佛教的信者，信佛要先礼拜，朋友相交，也要点头敬礼。一个人如果不和别人接触，随你长得有多高，随你如何不可一世；一旦你要和人接触，就必须要低头、谦卑。傲慢只是，一般人在平常，极不容易向别人低头，因为把自己的面子放在前头，认为低头是不光彩的事，除非是会伤害到自己的利益或逼不得已时，才肯低头。然而，所谓“舍得，不舍不得，小舍小得，大舍大得”，我们在生活中，说穿了就是一连串“舍得、得舍”的过程，能够衡量其中的利害关系，就会知道，能把自己的姿态放得最低，往往就是大舍而大得。星云大师说：分享故事：小朋友好奇地问智者：“我到底应该拜哪些老师，跟谁去学习呢？”智者说：“小朋友的问题问得好。世界上有那么多知名的大学，里面又有非常多的教授，他们都是学识渊博的顶级导师，而你现在是个小学三年级的小孩，你应该选择跟谁去学习呢？我建议啊，你可以先跟你的小学老师学！小学毕业了有中学老师教你，中学毕业了有高中和大学老师教你，然后还有社会老师教你… 智者笑着继续说：“其实，生活中所有的人都可以成为你的老师，他们都可以在各领域教导你一些知识，或者做人的道理。重点在于，你要把自己放的很低，千万不要骄傲。你骄傲，就没有人能教得了你，如果你把自己放得足够低，那么所有人都能成为你的老师，包括你的朋友、家人、同事、甚至你的敌人，乃至山川大河、花鸟虫鱼，你都能从中得到感悟。小朋友说：“就是不要自以为了不起，这样就可以学到很多东西，是这样吗？”智者说：“说一句你长大后就会明白的话：我们如果能让心不染尘，万物都可以是我们学习的对象，重要的是你要从这个时候开始，把姿态放低，越低越好。方便"
        "“低姿态”的修养，说来容易做起来不简单，如果能从小培养孩子有这方面的认知更好，因为它须经年累月养成。一般人有了“低姿态”的修养，在社会上做人处事，必能得到许多方便。因为人生在世，昂首与低头，低头的人定比较受人喜爱，所以低姿态的人会有人缘。古代的儒家，学子入学，先教你叩头拜师；佛教的信者，信佛要先礼拜，朋友相交，也要点头敬礼。一个人如果不和别人接触，随你长得有多高，随你如何不可一世；一旦你要和人接触，就必须要低头、谦卑。傲慢只是，一般人在平常，极不容易向别人低头，因为把自己的面子放在前头，认为低头是不光彩的事，除非是会伤害到自己的利益或逼不得已时，才肯低头。然而，所谓“舍得，不舍不得，小舍小得，大舍大得”，我们在生活中，说穿了就是一连串“舍得、得舍”的过程，能够衡量其中的利害关系，就会知道，能把自己的姿态放得最低，往往就是大舍而大得。星云大师说：分享故事：小朋友好奇地问智者：“我到底应该拜哪些老师，跟谁去学习呢？”智者说：“小朋友的问题问得好。世界上有那么多知名的大学，里面又有非常多的教授，他们都是学识渊博的顶级导师，而你现在是个小学三年级的小孩，你应该选择跟谁去学习呢？我建议啊，你可以先跟你的小学老师学！小学毕业了有中学老师教你，中学毕业了有高中和大学老师教你，然后还有社会老师教你… 智者笑着继续说：“其实，生活中所有的人都可以成为你的老师，他们都可以在各领域教导你一些知识，或者做人的道理。重点在于，你要把自己放的很低，千万不要骄傲。你骄傲，就没有人能教得了你，如果你把自己放得足够低，那么所有人都能成为你的老师，包括你的朋友、家人、同事、甚至你的敌人，乃至山川大河、花鸟虫鱼，你都能从中得到感悟。小朋友说：“就是不要自以为了不起，这样就可以学到很多东西，是这样吗？”智者说：“说一句你长大后就会明白的话：我们如果能让心不染尘，万物都可以是我们学习的对象，重要的是你要从这个时候开始，把姿态放低，越低越好。方便"
        "“低姿态”的修养，说来容易做起来不简单，如果能从小培养孩子有这方面的认知更好，因为它须经年累月养成。一般人有了“低姿态”的修养，在社会上做人处事，必能得到许多方便。因为人生在世，昂首与低头，低头的人定比较受人喜爱，所以低姿态的人会有人缘。古代的儒家，学子入学，先教你叩头拜师；佛教的信者，信佛要先礼拜，朋友相交，也要点头敬礼。一个人如果不和别人接触，随你长得有多高，随你如何不可一世；一旦你要和人接触，就必须要低头、谦卑。傲慢只是，一般人在平常，极不容易向别人低头，因为把自己的面子放在前头，认为低头是不光彩的事，除非是会伤害到自己的利益或逼不得已时，才肯低头。然而，所谓“舍得，不舍不得，小舍小得，大舍大得”，我们在生活中，说穿了就是一连串“舍得、得舍”的过程，能够衡量其中的利害关系，就会知道，能把自己的姿态放得最低，往往就是大舍而大得。星云大师说：分享故事：小朋友好奇地问智者：“我到底应该拜哪些老师，跟谁去学习呢？”智者说：“小朋友的问题问得好。世界上有那么多知名的大学，里面又有非常多的教授，他们都是学识渊博的顶级导师，而你现在是个小学三年级的小孩，你应该选择跟谁去学习呢？我建议啊，你可以先跟你的小学老师学！小学毕业了有中学老师教你，中学毕业了有高中和大学老师教你，然后还有社会老师教你… 智者笑着继续说：“其实，生活中所有的人都可以成为你的老师，他们都可以在各领域教导你一些知识，或者做人的道理。重点在于，你要把自己放的很低，千万不要骄傲。你骄傲，就没有人能教得了你，如果你把自己放得足够低，那么所有人都能成为你的老师，包括你的朋友、家人、同事、甚至你的敌人，乃至山川大河、花鸟虫鱼，你都能从中得到感悟。小朋友说：“就是不要自以为了不起，这样就可以学到很多东西，是这样吗？”智者说：“说一句你长大后就会明白的话：我们如果能让心不染尘，万物都可以是我们学习的对象，重要的是你要从这个时候开始，把姿态放低，越低越好。方便"
        "“低姿态”的修养，说来容易做起来不简单，如果能从小培养孩子有这方面的认知更好，因为它须经年累月养成。一般人有了“低姿态”的修养，在社会上做人处事，必能得到许多方便。因为人生在世，昂首与低头，低头的人定比较受人喜爱，所以低姿态的人会有人缘。古代的儒家，学子入学，先教你叩头拜师；佛教的信者，信佛要先礼拜，朋友相交，也要点头敬礼。一个人如果不和别人接触，随你长得有多高，随你如何不可一世；一旦你要和人接触，就必须要低头、谦卑。傲慢只是，一般人在平常，极不容易向别人低头，因为把自己的面子放在前头，认为低头是不光彩的事，除非是会伤害到自己的利益或逼不得已时，才肯低头。然而，所谓“舍得，不舍不得，小舍小得，大舍大得”，我们在生活中，说穿了就是一连串“舍得、得舍”的过程，能够衡量其中的利害关系，就会知道，能把自己的姿态放得最低，往往就是大舍而大得。";

    return SliverToBoxAdapter(
        child: SizedBox(
          child: Scrollbar( // 显示进度条
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Text(playlist.text, textScaleFactor: 1.2)
          ),
          ),
        ),
    );

  }
}
