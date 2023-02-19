import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:recipe/navigation/common/navigation_target.dart';
import 'package:recipe/navigation/mobile/home/page_home.dart';
import 'package:recipe/providers/navigator_provider.dart';

import '../../../providers/account_provider.dart';
import 'bezierContainer.dart';
import 'loginPage.dart';

import 'dart:async';

import 'package:flutter/material.dart';

///show a loading overlay above the screen
///indicator that page is waiting for response
Future<T> showLoaderOverlay<T>(
    BuildContext context,
    Future<T> data, {
      Duration timeout = const Duration(seconds: 5),
    }) {
  final completer = Completer<T>.sync();

  final entry = OverlayEntry(
    builder: (context) {
      return AbsorbPointer(
        child: SafeArea(
          child: Center(
            child: Container(
              height: 160,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      );
    },
  );
  Overlay.of(context)!.insert(entry);
  data
      .then(completer.complete)
      .timeout(timeout)
      .catchError(completer.completeError)
      .whenComplete(entry.remove);
  return completer.future;
}

class SignUpPage extends StatefulWidget {
  SignUpPage({Key ?key, this.title}) : super(key: key);

  final String? title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: SignUpForm(),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
            _loginAccountLabel(),
          ],
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
    );
  }
}

class SignUpForm extends ConsumerWidget {
  SignUpForm({super.key});

  final accountTextController = TextEditingController();
  final passwordTextController = TextEditingController();


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: height * .2),
          _title(),
          SizedBox(
            height: 50,
          ),
          _emailPasswordWidget(),
          SizedBox(
            height: 20,
          ),
          InkWell(
              onTap: () {
                _doRegister(context, ref);
                ref
                    .read(navigatorProvider.notifier)
                    .navigate(NavigationTargetHeadlines());
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context)
                        {
                          final navigatorState = ref.watch(navigatorProvider);
                          NavigationTarget target = navigatorState.current;
                          return PageHome(selectedTab: target.runtimeType == NavigationTargetWelcome ? NavigationTargetHeadlines() : target);
                        }
                    ));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.shade200,
                          offset: Offset(2, 4),
                          blurRadius: 5,
                          spreadRadius: 2)
                    ],
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xfffbb448), Color(0xfff7892b)])),
                child: Text(
                  'Register & Login',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )
          ),
          SizedBox(height: height * .14),
        ],
      );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              controller: isPassword ? passwordTextController : accountTextController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'd',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xffe46b10)
          ),

          children: [
            TextSpan(
              text: 'ev',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'rnz',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Username"),
        // _entryField("Email id"),
        _entryField("Password", isPassword: true),
      ],
    );
  }

  void _doRegister(BuildContext context, WidgetRef ref) async {
    final String password = passwordTextController.text;
    if (password.isEmpty) {
      // toast(context.strings.pleaseInputPassword);
      return;
    }
    final String account = accountTextController.text;
    final accountProvider = ref.read(userProvider.notifier);
    // final result =
    // await showLoaderOverlay(context, accountProvider.register("123456", account, password));
    final result = accountProvider.register("123456", account, password);
    toast('登录成功');
  }
}
