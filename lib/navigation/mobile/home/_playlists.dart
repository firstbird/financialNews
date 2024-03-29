import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../extension.dart';
import '../../../providers/account_provider.dart';
import '../../../providers/user_playlists_provider.dart';
import '../../../repository.dart';
import 'newslist_tile.dart';

class PlayListsGroupHeader extends StatelessWidget {
  const PlayListsGroupHeader({super.key, required this.name, this.count});

  final String name;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        color: Theme.of(context).backgroundColor,
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Text('$name($count)'),
              const Spacer(),
              const Icon(Icons.add),
              const Icon(Icons.more_vert),
            ],
          ),
        ),
      ),
    );
  }
}

class MainPlayListTile extends StatelessWidget {
  const MainPlayListTile({
    super.key,
    required this.data,
    this.enableBottomRadius = false,
  });

  final NewsDetail data;
  final bool enableBottomRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        borderRadius: enableBottomRadius
            ? const BorderRadius.vertical(bottom: Radius.circular(4))
            : null,
        color: context.colorScheme.background,
        child: NewsListTile(playlist: data),
      ),
    );
  }
}

const double kPlayListHeaderHeight = 48;

const double _kPlayListDividerHeight = 10;

class MyPlayListsHeaderDelegate extends SliverPersistentHeaderDelegate {
  MyPlayListsHeaderDelegate();

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) =>
      const _MyPlayListsHeader();

  @override
  double get maxExtent => kPlayListHeaderHeight;

  @override
  double get minExtent => kPlayListHeaderHeight;

  @override
  bool shouldRebuild(covariant MyPlayListsHeaderDelegate oldDelegate) {
    return false;
  }
}

final _playListTabUserSelectedProvider = Provider(
  (ref) => StreamController<int>.broadcast(),
);

class _MyPlayListsHeader extends ConsumerWidget implements PreferredSizeWidget {
  const _MyPlayListsHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kPlayListHeaderHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColoredBox(
      color: context.colorScheme.background,
      child: TabBar(
        labelColor: context.colorScheme.textPrimary,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: context.colorScheme.primary,
        onTap: (index) {
          ref.read(_playListTabUserSelectedProvider).add(index);
        },
        tabs: [
          Tab(text: context.strings.createdSongList),
          Tab(text: context.strings.favoriteSongList),
        ],
      ),
    );
  }
}

class UserPlayListSection extends ConsumerWidget {
  const UserPlayListSection({
    super.key,
    required this.scrollController,
    required this.firstItemOffset,
  });

  final ScrollController scrollController;

  final double firstItemOffset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider);
    if (userId == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    final playlists = ref.watch(userPlaylistsProvider(userId));
    return playlists.when(
      data: (result) {
        final created = result.where((p) => p.creator.userId == userId);
        final subscribed = result.where((p) => p.creator.userId != userId);
        return _UserPlaylists(
          created: created.toList(),
          subscribed: subscribed.toList(),
          scrollController: scrollController,
          firstItemOffset: firstItemOffset,
        );
      },
      error: (error, stackTrace) => SliverToBoxAdapter(
        child: Text(context.formattedError(error)),
      ),
      loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
    );
  }
}

class _UserPlaylists extends HookConsumerWidget {
  const _UserPlaylists({
    super.key,
    required this.created,
    required this.subscribed,
    required this.scrollController,
    required this.firstItemOffset,
  });

  final List<NewsDetail> created;
  final List<NewsDetail> subscribed;
  final ScrollController scrollController;

  final double firstItemOffset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createdHeight = _kPlayListDividerHeight + 40 + 60 * created.length;

    final tabController = DefaultTabController.of(context);

    final tabAnimating = useRef(false);

    useEffect(
      () {
        void onScroll() {
          if (tabController == null) {
            return;
          }

          if (tabController.indexIsChanging || tabAnimating.value) {
            return;
          }

          final int targetIndex;
          if (scrollController.offset < createdHeight + firstItemOffset) {
            targetIndex = 0;
          } else {
            targetIndex = 1;
          }

          if (tabController.index == targetIndex) {
            return;
          }

          tabAnimating.value = true;
          tabController.animateTo(targetIndex);
          Future.delayed(
            kTabScrollDuration + const Duration(milliseconds: 100),
          ).whenComplete(() {
            tabAnimating.value = false;
          });
        }

        scrollController.addListener(onScroll);
        return () {
          scrollController.removeListener(onScroll);
        };
      },
      [scrollController],
    );

    final stream = useMemoized(
      () => ref.read(_playListTabUserSelectedProvider).stream,
    );
    useEffect(
      () {
        final subscription = stream.listen((index) {
          scrollController.animateTo(
            index == 0 ? firstItemOffset : firstItemOffset + createdHeight,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        });
        return subscription.cancel;
      },
      [stream],
    );

    return SliverList(
      delegate: SliverChildListDelegate.fixed(
        [
          const SizedBox(height: _kPlayListDividerHeight),
          PlayListsGroupHeader(
            name: context.strings.createdSongList,
            count: created.length,
          ),
          ..._playlistWidget(created),
          const SizedBox(height: _kPlayListDividerHeight),
          PlayListsGroupHeader(
            name: context.strings.favoriteSongList,
            count: subscribed.length,
          ),
          ..._playlistWidget(subscribed),
          const SizedBox(height: _kPlayListDividerHeight),
        ],
        addAutomaticKeepAlives: false,
      ),
    );
  }

  static Iterable<Widget> _playlistWidget(List<NewsDetail> details) {
    return [
      for (var i = 0; i < details.length; i++)
        MainPlayListTile(
          data: details[i],
          enableBottomRadius: i == details.length - 1,
        )
    ];
  }
}
