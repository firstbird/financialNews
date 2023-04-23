import 'package:flutter/material.dart';
import 'package:recipe/navigation/common/login/welcomePage.dart';
import 'package:recipe/navigation/mobile/home/main_page_community.dart';
import 'package:recipe/views/mainframe/mainframe_page.dart';

import '../../common/navigation_target.dart';
import '../widgets/bottom_bar.dart';
import 'main_page_discover.dart';
import 'main_page_headlines.dart';
import 'main_page_message.dart';
import 'person_center_page.dart';
// import 'tab_search.dart';

// only includes page on bottom tabs, also the sub pages of sub tabs
class PageHome extends StatelessWidget {
  PageHome({super.key, required this.selectedTab})
      : assert(selectedTab.isMobileHomeTab());

  final NavigationTarget selectedTab;

  @override
  Widget build(BuildContext context) {
    final Widget body;
    switch (selectedTab.runtimeType) {
      case NavigationTargetHeadlines:
        body = const MainPageHeadlines();
        break;
      case NavigationTargetDiscover:
        body = const MainPageDiscover();
        break;
      case NavigationTargetCommunity:
        body = const MainPageCommunity();
        break;
      case NavigationTargetMessage:
        // body = const MainPageMessage();
        body = MainframePage();
        break;
      case NavigationTargetUser:
        body = const PersonCenterPage();
        // body = WelcomePage();
        break;
      default:
        // assert(false, 'unsupported tab: $selectedTab');
        // body = const MainPageMy();
        body = const PersonCenterPage();
        break;
    }
    return Scaffold(body: AnimatedAppBottomBar(child: body));
  }
}
