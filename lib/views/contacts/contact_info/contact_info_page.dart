import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe/component/action_sheet/action_sheet.dart';
import 'package:recipe/component/list_tile/mh_list_tile.dart';
import 'package:recipe/constant/constant.dart';
import 'package:recipe/constant/style.dart';

// import 'package:flutter_wechat/constant/constant.dart';
// import 'package:flutter_wechat/constant/style.dart';

// import 'package:flutter_wechat/routers/fluro_navigator.dart';
// import 'package:flutter_wechat/views/contacts/contacts_router.dart';

// import 'package:flutter_wechat/model/user/user.dart';
// import 'package:flutter_wechat/utils/service/contacts_service.dart';

// import 'package:flutter_wechat/components/list_tile/mh_list_tile.dart';
// import 'package:flutter_wechat/widgets/contacts/contact_info/contact_info_header.dart';
// import 'package:flutter_wechat/widgets/contacts/contact_info/contact_info_remarks.dart';
// import 'package:flutter_wechat/widgets/contacts/contact_info/contact_info_moments.dart';
// import 'package:flutter_wechat/components/action_sheet/action_sheet.dart';
import 'package:recipe/repository/data/user.dart';
import 'package:recipe/utils/service/contacts_service.dart';
import 'package:recipe/widgets/contacts/contact_info/contact_info_header.dart';
import 'package:recipe/widgets/contacts/contact_info/contact_info_moments.dart';
import 'package:recipe/widgets/contacts/contact_info/contact_info_remarks.dart';

class ContactInfoPage extends StatefulWidget {
  ContactInfoPage({super.key, required this.idstr});

  /// 用户ID
  final String idstr;

  _ContactInfoPageState createState() => _ContactInfoPageState();
}

class _ContactInfoPageState extends State<ContactInfoPage> {
  /// 用户信息
  late User _user;

  @override
  void initState() {
    super.initState();

    /// 获取用户信息
    _user = ContactsService.sharedInstance.contactsMap[widget.idstr]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: new SvgPicture.asset(
              Constant.assetsImagesContacts + 'icons_outlined_more.svg',
              color: Color(0xFF333333),
            ),
            onPressed: () {
              // todo mzl important
              // NavigatorUtils.push(context,
              //     '${ContactsRouter.contactSettingInfoPage}?idstr=${_user.idstr}');
            },
          )
        ],
      ),
      body: Container(
        child: _buildChildWidget(),
      ),
    );
  }

  /// 构建actionsheet
  void _showActionSheet(BuildContext context) {
    ActionSheet.show(
      context,
      // todo mzl contact
      title: Text("test contact title"),
      message: Text("test contact message"),
      actions: <Widget>[
        ActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new SvgPicture.asset(
                  Constant.assetsImagesContacts + 'icons_filled_videocall.svg',
                  width: ScreenUtil().setWidth(16.0 * 3),
                  height: ScreenUtil().setWidth(16.0 * 3),
                  color: Colors.black,
                ),
                SizedBox(width: ScreenUtil().setWidth(4.0 * 3)),
                Text('视频通话'),
              ],
            )),
        ActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new SvgPicture.asset(
                Constant.assetsImagesContacts +
                    'icons_filled_contacts_phone.svg',
                width: ScreenUtil().setWidth(16.0 * 3),
                height: ScreenUtil().setWidth(16.0 * 3),
                color: Colors.black,
              ),
              SizedBox(width: ScreenUtil().setWidth(4.0 * 3)),
              Text('语音通话'),
            ],
          ),
        ),
      ],
      cancelButton: ActionSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('取消'),
      ),
    );
  }

  /// 构建子部件
  Widget _buildChildWidget() {
    return ListView(
      children: <Widget>[
        _buildHeaderWidget(),
        _buildSettingRemarksWidget(),
        // 朋友权限
        _buildFriendPermission(),
        SizedBox(height: ScreenUtil().setHeight(8.0 * 3)),
        _buildMomentsWidget(),
        _buildMoreInfoWidget(),
        SizedBox(height: ScreenUtil().setHeight(8.0 * 3)),
        _buildMessageAndVideoWidget(),
      ],
    );
  }

  /// 构建 header 部件
  Widget _buildHeaderWidget() {
    return ContactInfoHeader(
      user: _user,
    );
  }

  /// 构建设置备注和标签 部件
  Widget _buildSettingRemarksWidget() {
    return ContactInfoRemarks(
      user: _user,
    );
  }

  /// 构建朋友圈 部件
  Widget _buildMomentsWidget() {
    return ContactInfoMoments(
      user: _user,
    );
  }

  /// 构建盆友权限 部件
  Widget _buildFriendPermission() {
    Widget middle = Padding(
      padding: EdgeInsets.only(
          right: ScreenUtil().setWidth(Constant.pEdgeInset * 3)),
      child: Text(
        '朋友权限',
        style: TextStyle(
            fontSize: ScreenUtil().setSp(48.0), color: Style.pTextColor),
      ),
    );

    Widget trailing = Image.asset(
      Constant.assetsImagesArrow + 'tableview_arrow_8x13.png',
      width: ScreenUtil().setWidth(24.0),
      height: ScreenUtil().setHeight(39.0),
    );

    return Container(
      color: Colors.white,
      child: MHListTile(
        leading: const Icon(Icons.star_border),
        contentPadding:
            EdgeInsets.all(ScreenUtil().setWidth(Constant.pEdgeInset * 3.0)),
        middle: middle,
        trailing: trailing,
        dividerIndent: ScreenUtil().setWidth(Constant.pEdgeInset * 3),
        onTap: () {
          // todo mzl important
          // NavigatorUtils.push(
          //   context,
          //   '${ContactsRouter.friendPermissionPage}?idstr=${_user.idstr}',
          // );
        },
      ),
    );
  }

  /// 构建更多信息 部件
  Widget _buildMoreInfoWidget() {
    Widget middle = Padding(
      padding: EdgeInsets.only(
          right: ScreenUtil().setWidth(Constant.pEdgeInset * 3)),
      child: Text(
        '更多信息',
        style: TextStyle(
            fontSize: ScreenUtil().setSp(48.0), color: Style.pTextColor),
      ),
    );

    Widget trailing = Image.asset(
      Constant.assetsImagesArrow + 'tableview_arrow_8x13.png',
      width: ScreenUtil().setWidth(24.0),
      height: ScreenUtil().setHeight(39.0),
    );

    return MHListTile(
      leading: const Icon(Icons.star_border),
      contentPadding:
          EdgeInsets.all(ScreenUtil().setWidth(Constant.pEdgeInset * 3.0)),
      middle: middle,
      trailing: trailing,
      onTap: () {
        // todo mzl important
        // NavigatorUtils.push(
        //   context,
        //   '${ContactsRouter.contactMoreInfoPage}?idstr=${_user.idstr}',
        //   transition: TransitionType.inFromBottom,
        // );
      },
    );
  }

  // 构建发消息、音视频通话 部件
  Widget _buildMessageAndVideoWidget() {
    //
    return Column(
      children: <Widget>[
        _buildMessageAndVideoItemWidget(
            'icons_outlined_chats.svg', '发消息', () {}),
        _buildMessageAndVideoItemWidget('icons_outlined_videocall.svg', '音视频通话',
            () {
          _showActionSheet(context);
        }),
      ],
    );
  }

  /// 构建 发消息和音视频通话
  Widget _buildMessageAndVideoItemWidget(
      String icon, String title, void Function() onTap) {
    Color color = Color(0xFF576B95);
    Widget middle = Padding(
      padding: EdgeInsets.only(
          right: ScreenUtil().setWidth(Constant.pEdgeInset * 3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new SvgPicture.asset(
            Constant.assetsImagesContacts + icon,
            color: color,
            width: ScreenUtil().setWidth(16.0 * 3),
            height: ScreenUtil().setWidth(16.0 * 3),
          ),
          SizedBox(width: ScreenUtil().setWidth(4.0 * 3)),
          Text(
            title,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(16.0 * 3),
                color: color,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );

    return MHListTile(
      leading: const Icon(Icons.star_border),
      trailing: const Icon(Icons.star_border),
      contentPadding: EdgeInsets.all(Constant.pEdgeInset),
      middle: middle,
      onTap: onTap,
    );
  }
}
