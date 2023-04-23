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

class MainPageCommunity extends StatefulWidget {
  const MainPageCommunity({super.key});

  @override
  State<StatefulWidget> createState() => PageCommunityState();
}

class PageCommunityState extends State<MainPageCommunity>
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
                    searchWord == "" ? context.strings.community : searchWord,
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
            actionIcon3: Icon(Icons.add),
            pressedActionIcon3: () {
              toast("搜索公司");
              setState(() {
                isInSearch = !isInSearch;
              });
            }),
        _Header('关注领域', () {}),
        SizedBox(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.green[100],
                child: const Text("He'd have you all unravel at the"),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.green[200],
                child: const Text('Heed not the rabble'),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.green[300],
                child: const Text('Sound of screams but the'),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.green[400],
                child: const Text('Who scream'),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.green[500],
                child: const Text('Revolution is coming...'),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.green[600],
                child: const Text('Revolution, they...'),
              ),
            ],
          ),
        ),
        // _Header('关注领域', () {}), // 当你不知道吃什么时候
        const Trends(),
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
          Spacer(),
          const Icon(Icons.add_box_rounded),
          const Padding(padding: EdgeInsets.only(right: 13)),
        ],
      ),
    );
  }
}

class _TrendsItemView extends ConsumerWidget {
  const _TrendsItemView({
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
          child: this.type == 0
              ? Column(
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(children: <Widget>[
                            CircleAvatar(
                              //头像半径
                              radius: 25,
                              //头像图片 -> NetworkImage网络图片，AssetImage项目资源包图片, FileImage本地存储图片
                              backgroundImage: CachedImage(playlist.headPicUrl),
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
                                      "${DateTime.fromMillisecondsSinceEpoch(int.parse(playlist.updateTime.toString()))}",
                                      style: TextStyle(fontSize: 10),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 10)),
                                    Text(
                                      "${playlist.source}",
                                      style: TextStyle(fontSize: 10),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Spacer(),
                            // todo mzl merge icon and nums
                            Column(
                                children: [
                                  IconButton( icon: const Icon(Icons.comment_rounded), iconSize: 20,
                                    onPressed: ()
                                    {}, ),
                                  Text("10")//your label)
                                  ]),
                            Column(
                                children: [
                                  IconButton( icon: const Icon(Icons.star_border_outlined), iconSize: 20,
                                    onPressed: ()
                                    {}, ),
                                  Text("10")//your label)
                                ]),
                            // TextButton.icon(
                            //   icon: const Icon(Icons.star_border_outlined),
                            //   onPressed: () {},
                            //   label: const Text("100"),
                            // ),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                          ]),
                          const Padding(padding: EdgeInsets.only(top: 8)),
                          Text(
                            "${playlist.title}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Padding(padding: EdgeInsets.only(top: 3)),
                          SizedBox(
                            height: 200, // todo mzl adjust size
                            width: 500, // todo mzl adjust size
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
                          const Padding(padding: EdgeInsets.only(bottom: 3)),
                          Divider(
                            height: 1.0,
                            indent: 3,
                            endIndent: 3,
                            color: Colors.grey,
                          )
                        ]),
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

class Trends extends ConsumerWidget {
  const Trends({super.key});

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
              return _TrendsItemView(playlist: p, width: 500, type: 0);
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
