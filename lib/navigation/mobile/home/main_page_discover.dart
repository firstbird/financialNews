import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:recipe/navigation/mobile/widgets/movie_app_bar.dart';

import '../../../component/global/orientation.dart';
import '../../../component/route.dart';
import '../../../extension.dart';
import '../../../providers/navigator_provider.dart';
import '../../../providers/personalized_playlist_provider.dart';
import '../../../repository.dart';
import '../../common/navigation_target.dart';
import '../../common/playlist/music_list.dart';

class MainPageDiscover extends StatefulWidget {
  const MainPageDiscover({super.key});

  @override
  State<StatefulWidget> createState() => PageDiscoverState();
}

class PageDiscoverState extends State<MainPageDiscover>
    with AutomaticKeepAliveClientMixin {
  bool isInSearch = false;
  final searchController = TextEditingController();
  String searchWord = "";

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // companyTitle = context.strings.companies;
    super.build(context);
    return ListView(
      children: <Widget>[
        CustomAppBar(
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
            isShowActionIcon1: false,
            // actionIcon1: isInSearch ?  : const Icon(Icons.search),
            // isShowActionIcon2: true,
            // actionIcon2: Icon(Icons.air_rounded, color: Colors.white,),
            isShowActionIcon3: true,
            actionIcon3: Icon(Icons.search),
            pressedActionIcon3: () {
              toast("搜索公司");
              setState(() {
                isInSearch = !isInSearch;
              });
            }),
        GridView.count(
          crossAxisCount: 5,
          physics: NeverScrollableScrollPhysics(),
          // to disable GridView's scrolling
          shrinkWrap: true,
          // You won't see infinite size error
          children: <Widget>[
            Container(
              height: 24,
              color: Colors.green,
            ),
            Container(
              height: 24,
              color: Colors.blue,
            ),
            Container(
              height: 24,
              color: Colors.red,
            ),
            Container(
              height: 24,
              color: Colors.yellow,
            ),
            Container(
              height: 24,
              color: Colors.cyan,
            ),
            Container(
              height: 24,
              color: Colors.deepOrangeAccent,
            ),
            Container(
              height: 24,
              color: Colors.lightGreen,
            ),
            Container(
              height: 24,
              color: Colors.yellowAccent,
            ),
            Container(
              height: 24,
              color: Colors.brown,
            ),
            Container(
              height: 24,
              color: Colors.purple,
            ),
          ],
        ),
        _Header('公司快讯', () {}), // 当你不知道吃什么时候
        const DesignCategory(),
      ],
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

class _DesignCategoryItemView extends ConsumerWidget {
  const _DesignCategoryItemView({
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
          width: this.type == 0 ? double.infinity : 800,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: this.type == 0
              ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: 180, // todo mzl size
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: FadeInImage(
                            placeholder: const AssetImage(
                                'assets/playlist_playlist.9.png'),
                            image: CachedImage(playlist.headPicUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 4)),
                    SizedBox(
                      height: 100, // todo mzl size
                      width: double.infinity,
                      child: GridView(
                        physics: NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          // 一行几列
                          crossAxisCount: 4,
                          // 设置每子元素的大小（宽高比）
                          childAspectRatio: 1.8,
                          // 元素的左右的 距离
                          crossAxisSpacing: 20,
                          // 子元素上下的 距离
                          mainAxisSpacing: 10,
                        ),
                        children: [
                          Container(
                            color: Colors.red,
                            child: Icon(Icons.keyboard),
                          ),
                          Container(
                            color: Colors.pink,
                            child: Icon(Icons.add),
                          ),
                          Container(
                            color: Colors.green,
                            child: Icon(Icons.home),
                          ),
                          Container(
                            color: Colors.blue,
                            child: Icon(Icons.add),
                          ),
                          Container(
                            color: Colors.orange,
                            child: Icon(Icons.home),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30, // todo mzl size
                      width: double.infinity,
                      child: Text(
                        playlist.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Divider(
                      height: 1.0,
                      indent: 3,
                      endIndent: 3,
                      color: Colors.grey,
                    )
                  ],
                )
              : Row(
                  children: <Widget>[
                    SizedBox(
                      height: width,
                      width: width,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: FadeInImage(
                            placeholder: const AssetImage(
                                'assets/playlist_playlist.9.png'),
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
                )),
    );
  }
}

class DesignCategory extends ConsumerWidget {
  const DesignCategory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final snapshot = ref.watch(personalizedNewSongProvider.logErrorOnDebug());
    final snapshot = ref.watch(newsListProvider(0).logErrorOnDebug());
    return snapshot.when(
      data: (songs) {
        final double width = 500;
        return Column(
            // children: songs.map(MusicTile.new).toList(),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: songs.map<Widget>((p) {
              return _DesignCategoryItemView(playlist: p, width: 100, type: 0);
            }).toList());
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
