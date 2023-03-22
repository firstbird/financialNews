import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../../extension.dart';
import '../../../providers/account_provider.dart';
import '../../../providers/player_provider.dart';
import '../../../providers/playlist_detail_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../repository.dart';
import '../../common/playlist/music_list.dart';
import '../widgets/track_title.dart';
import 'playlist_flexible_app_bar.dart';

const double kHeaderHeight = 180 + kToolbarHeight;

/// page display a Playlist
///
/// Playlist : a list of musics by user collected
class PlaylistDetailPage extends HookConsumerWidget {
  const PlaylistDetailPage(
    this.playlistId, {
    super.key,
  });

  final int playlistId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(
      playlistDetailProvider(playlistId).logErrorOnDebug(),
    );
    final absorberHandle = useMemoized(SliverOverlapAbsorberHandle.new);
    // final settings =
    // context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;
    // final deltaExtent = settings.maxExtent - settings.minExtent;
    return Scaffold(
      body: detail.when(
        data: (detail) => Stack(
          children: <Widget>[
              CustomScrollView(
                  slivers: <Widget>[
                    SliverOverlapAbsorber(handle: absorberHandle),
                    _Appbar(newsDetail: detail),
                    _MusicList(detail),
                  ],
              ),
            Positioned(
            top: 30, // todo mzl
            right: 10, // todo mzl
            child: _OverlappedButton(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
              // icon: const Icon(Icons.library_add),
              label: Text(detail.subscribedCount.toString()),
              onPressed: () {
                // toast(context.strings.todo + " play list store");
                // 1. store subscribed count on item's record
                // 2. change icon
                toast(context.strings.todo + " play list part implemented");
              },
            ))]),
        error: (error, stacktrace) => Center(
          child: Text(context.formattedError(error)),
        ),
        loading: () => const Center(
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class _OverlappedActionButtons extends StatelessWidget {
  const _OverlappedActionButtons({
  super.key,
  required this.currentExtent,
  required this.extent,
  required this.children,
  });

  final double currentExtent;

  final double extent;

  final List<_OverlappedButton> children;

  @override
  Widget build(BuildContext context) {
    const extentLimit = 66;
    return Column(
      children: [
        const Spacer(),
        Transform.translate(
          offset: Offset(
            0,
            currentExtent < extentLimit ? extentLimit - currentExtent : 0,
          ),
          child: AnimatedOpacity(
            opacity: currentExtent > extentLimit ? 1 : 0,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 150),
            child: AnimatedScale(
              scale: currentExtent > extentLimit ? 1 : 0.6,
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 150),
              child: Material(
                elevation: 1,
                color: context.colorScheme.background,
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  height: 80,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: children
                        .cast<Widget>()
                        .separated(
                      Container(
                        width: 1,
                        height: 60,
                        color: context.colorScheme.divider,
                      ),
                    )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10)
      ],
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

// class _NewsDetail extends ConsumerWidget {
//   const _NewsDetail(this.playlist);
//
//   final NewsDetail playlist;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return SliverToBoxAdapter(
//         child: Container(
//           height: 200.0,
//           child: specialCharsPanel(context),
//         )
//     );
//   }
//
//   Widget specialCharsPanel(BuildContext context) {
//     return SizedBox(
//       height: 100,
//       child: Material(
//         elevation: 4.0,
//         borderRadius: BorderRadius.all(Radius.circular(6.0)),
//         child: Row(
//           children: <Widget>[
//             _OverlappedButton(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(24),
//                 bottomLeft: Radius.circular(24),
//               ),
//               // icon: const Icon(Icons.library_add),
//               label: Text(
//                   playlist.subscribedCount.toString(),
//                   style: context.primaryTextTheme.titleMedium,
//               ),
//               onPressed: () {
//                 // toast(context.strings.todo + " play list store");
//                 // 1. store subscribed count on item's record
//                 // 2. change icon
//                 toast(context.strings.todo + " play list part implemented");
//               },
//             ),
//             _OverlappedButton(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(24),
//                 bottomLeft: Radius.circular(24),
//               ),
//               // icon: const Icon(Icons.library_add),
//               label: Text(playlist.subscribedCount.toString()),
//               onPressed: () {
//                 // toast(context.strings.todo + " play list store");
//                 // 1. store subscribed count on item's record
//                 // 2. change icon
//                 toast(context.strings.todo + " play list part implemented");
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
