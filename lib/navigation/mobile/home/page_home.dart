import 'package:flutter/material.dart';
import 'package:recipe/navigation/common/login/welcomePage.dart';
import 'package:recipe/navigation/mobile/home/main_page_companies.dart';

import '../../common/navigation_target.dart';
import '../widgets/bottom_bar.dart';
import 'main_page_headlines.dart';
import 'person_center_page.dart';
// import 'tab_search.dart';

class PageHome extends StatelessWidget {
  PageHome({super.key, required this.selectedTab})
      : assert(selectedTab.isMobileHomeTab());

  final NavigationTarget selectedTab;

  @override
  Widget build(BuildContext context) {
    final Widget body;
    switch (selectedTab.runtimeType) {
      case NavigationTargetUser:
        body = const PersonCenterPage();
        // body = WelcomePage();
        break;
      case NavigationTargetHeadlines:
        body = const MainPageHeadlines();
        break;
      case NavigationTargetCompanies:
        body = const MainPageCompanies();
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
