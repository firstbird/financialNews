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

class MainPageCompanies extends StatefulWidget {
  const MainPageCompanies({super.key});

  @override
  State<StatefulWidget> createState() => PageCompaniesState();
}

class PageCompaniesState extends State<MainPageCompanies>
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
                    searchWord == "" ? context.strings.companies : searchWord,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'search company name',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.white,
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
                // if (customIcon.icon == Icons.search) {
                //   customIcon = const Icon(Icons.cancel);
                //   companyTitle = "";
                //   customSearchBar = const ListTile(
                //     leading: Icon(
                //       Icons.search,
                //       color: Colors.white,
                //       size: 28,
                //     ),
                //     title: TextField(
                //       decoration: InputDecoration(
                //         hintText: 'type in journal name...',
                //         hintStyle: TextStyle(
                //           color: Colors.white,
                //           fontSize: 18,
                //           fontStyle: FontStyle.italic,
                //         ),
                //         border: InputBorder.none,
                //       ),
                //       style: TextStyle(
                //         color: Colors.white,
                //       ),
                //     ),
                //   );
                // } else {
                //   // customIcon = const Icon(Icons.search);
                //   // customSearchBar = const Text('My Personal Journal');
                //   customIcon = Icon(Icons.search);
                //   customSearchBar = Icon(
                //     Icons.category,
                //     color: Colors.white,
                //   );
                //   companyTitle = context.strings.companies;
                // }
              });
            }),
        _Header('公司快讯', () {}), // 当你不知道吃什么时候
        const CompanyNews(),
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
          child: this.type == 0
              ? Column(
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
                    const Padding(padding: EdgeInsets.only(top: 4)),
                    Text(
                      playlist.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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

class CompanyNews extends ConsumerWidget {
  const CompanyNews({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final snapshot = ref.watch(personalizedNewSongProvider.logErrorOnDebug());
    final snapshot = ref.watch(newsListProvider(0).logErrorOnDebug());
    return snapshot.when(
      data: (songs) {
        final double width = 500;
        return Flexible(
            child: Column(
                // children: songs.map(MusicTile.new).toList(),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: songs.map<Widget>((p) {
                  return _PlayListItemView(playlist: p, width: 100, type: 1);
                }).toList()));
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
