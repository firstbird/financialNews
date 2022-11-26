import 'package:flutter/material.dart';

import 'welcomePage.dart';

const pageLoginPhone = 'loginWithPhone';

///
/// 需要的参数:
/// phone : 手机号
///
const pageLoginPassword = 'loginPassword';

const pageRegister = 'register';

///登录子流程
class LoginNavigator extends StatelessWidget {
  const LoginNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: pageLoginPhone,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => _generatePage(settings)!,
        );
      },
    );
  }

  Widget? _generatePage(RouteSettings settings) {
    // switch (settings.name) {
    //   case pageLoginPhone:
    //     return const PageLoginWithPhone();
    //   case pageLoginPassword:
    //     final args = settings.arguments! as Map<String, Object>;
    //     return PageLoginPassword(
    //       phone: args['phone'] as String?,
    //     );
    // }
    // return WelcomePage();
    return null;
  }
}
