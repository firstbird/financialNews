import 'package:flutter/material.dart';
// import 'package:recipe/navigation/mobile/playlists/page_follow.dart';
// import 'package:recipe/navigation/mobile/playlists/page_history.dart';
// import 'package:recipe/navigation/mobile/playlists/page_like.dart';

import '../../providers/navigator_provider.dart';
import '../common/login/loginPage.dart';
import '../common/login/login_sub_navigation.dart';
import '../common/login/welcomePage.dart';
import '../common/navigation_target.dart';
// import 'artists/page_artist_detail.dart';
import 'home/page_home.dart';
import 'pages/page_collection.dart';
import 'pages/page_content_list.dart';
import 'pages/page_follow.dart';
import 'pages/page_history.dart';
import 'pages/page_like.dart';
import 'pages/page_newslist_detail.dart';
// import 'playlists/page_collection.dart';
// import 'playlists/page_newslist_detail.dart';
// import 'player/page_fm_playing.dart';
// import 'player/page_playing.dart';
// import 'player/page_playing_list.dart';
// import 'pages/page_album_detail.dart';
// import 'pages/page_newslist_detail.dart';
// import 'settings/page_setting.dart';
// import 'user/page_user_detail.dart';
// import 'widgets/bottom_sheet_page.dart';
// import 'widgets/slide_up_page_route.dart';

typedef AppWillPopCallback = bool Function();

enum _PageType {
  normal,
  slideUp,
  bottomSheet,
}

class MobileNavigatorController extends NavigatorController {
  MobileNavigatorController() {
    // _pages.add(NavigationTargetWelcome());
    _pages.add(NavigationTargetWelcome());
    notifyListeners();
  }

  final _pages = <NavigationTarget>[];

  final List<AppWillPopCallback> _willPopCallbacks = [];

  @override
  void back() {
    for (final callback in _willPopCallbacks.reversed) {
      if (!callback()) {
        return;
      }
    }
    if (canBack) {
      _pages.removeLast();
      notifyListeners();
    }
  }

  void addScopedWillPopCallback(AppWillPopCallback callback) {
    _willPopCallbacks.add(callback);
  }

  void removeScopedWillPopCallback(AppWillPopCallback callback) {
    _willPopCallbacks.remove(callback);
  }

  @override
  bool get canBack => _pages.length > 1;

  @override
  bool get canForward => false;

  @override
  void forward() => throw UnimplementedError('Forward is not supported');

  @override
  NavigationTarget get current => _pages.last;

  @override
  void navigate(NavigationTarget target) {
    if (current.isTheSameTarget(target)) {
      debugPrint('Navigation: already on $target');
      return;
    }
    if (target.isMobileHomeTab()) {
      _pages.clear();
    }
    _pages.add(target);
    notifyListeners();
  }

  @override
  List<Page> get pages => _pages.map(_buildPage).toList(growable: false);

  Page<dynamic> _buildPage(NavigationTarget target) {
    final Widget page;
    var pageType = _PageType.normal;
    switch (target.runtimeType) {
      case NavigationTargetLogin:
        page = LoginPage();
        break;
      case NavigationTargetWelcome:
        page = WelcomePage();
        break;
      case NavigationTargetHeadlines:
        page = PageHome(selectedTab: target);
        break;
      case NavigationTargetDiscover:
        page = PageHome(selectedTab: target);
        break;
      case NavigationTargetCommunity:
        page = PageHome(selectedTab: target);
        break;
      case NavigationTargetMessage:
        page = PageHome(selectedTab: target);
        break;
      case NavigationTargetUser:
        page = PageHome(selectedTab: target);
        // page = const PageSettings();
        break;
      case NavigationTargetCollection:
        page = const PageCollection();
        break;
      case NavigationTargetFollow:
        page = const PageFollow();
        break;
      case NavigationTargetHistory:
        page = const PageHistory();
        break;
      case NavigationTargetLike:
        page = const PageLike();
        break;
      case NavigationTargetNewsDetail:
        // page = PageHome(selectedTab: target);
        page = NewsDetailPage(
          (target as NavigationTargetNewsDetail).playlistId,
        );
        break;
      case NavigationTargetContentList:
        page = ContentListPage(contentType: (target as NavigationTargetContentList).contentType);
        break;
      case NavigationTargetPlaying:
        page = PageHome(selectedTab: target);
        // page = const PlayingPage();
        pageType = _PageType.slideUp;
        break;
      case NavigationTargetFmPlaying:
        page = PageHome(selectedTab: target);
        // page = const PagePlayingFm();
        pageType = _PageType.bottomSheet;
        break;
      case NavigationTargetUser:
        page = PageHome(selectedTab: target);
        // page = UserDetailPage(userId: (target as NavigationTargetUser).userId);
        break;
      case NavigationTargetLogin:
        page = const LoginNavigator();
        break;
      case NavigationTargetArtistDetail:
        page = PageHome(selectedTab: target);
        // page = ArtistDetailPage(
        //   artistId: (target as NavigationTargetArtistDetail).artistId,
        // );
        break;
      case NavigationTargetAlbumDetail:
        page = PageHome(selectedTab: target);
        // page = AlbumDetailPage(
        //   albumId: (target as NavigationTargetAlbumDetail).albumId,
        // );
        break;
      case NavigationTargetPlayingList:
        page = PageHome(selectedTab: target);
        // page = const PlayingListDialog();
        pageType = _PageType.bottomSheet;
        break;
      default:
        throw Exception('Unknown navigation type: $target');
    }
    return MaterialPage<dynamic>(
      child: page,
      name: target.runtimeType.toString(),
    );
    switch (pageType) {
      // case _PageType.normal:
      //   return MaterialPage<dynamic>(
      //     child: page,
      //     name: target.runtimeType.toString(),
      //   );
      // case _PageType.slideUp:
      //   return SlideUpPage(
      //     child: page,
      //     name: target.runtimeType.toString(),
      //   );
      // case _PageType.bottomSheet:
      //   return BottomSheetPage(
      //     child: page,
      //     name: target.runtimeType.toString(),
      //   );

    }
  }
}
