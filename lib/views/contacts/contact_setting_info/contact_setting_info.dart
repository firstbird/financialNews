import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// import 'package:flutter_wechat/constant/constant.dart';
// import 'package:flutter_wechat/constant/cache_key.dart';
// import 'package:flutter_wechat/constant/style.dart';
// import 'package:flutter_wechat/utils/util.dart';

// import 'package:flutter_wechat/routers/fluro_navigator.dart';
// import 'package:flutter_wechat/views/contacts/contacts_router.dart';
import 'package:recipe/component/action_sheet/action_sheet.dart';
import 'package:recipe/constant/cache_key.dart';
import 'package:recipe/constant/style.dart';
import 'package:recipe/model/common/common_group.dart';
import 'package:recipe/model/common/common_item.dart';
import 'package:recipe/repository/data/user.dart';
import 'package:recipe/utils/service/account_service.dart';
import 'package:recipe/utils/service/contacts_service.dart';
import 'package:recipe/widgets/common/common_group_widget.dart';

// import 'package:flutter_wechat/model/common/common_item.dart';
// import 'package:flutter_wechat/model/common/common_group.dart';
// import 'package:flutter_wechat/model/common/common_header.dart';
// import 'package:flutter_wechat/model/common/common_footer.dart';
// import 'package:flutter_wechat/components/action_sheet/action_sheet.dart';

// import 'package:flutter_wechat/widgets/common/common_group_widget.dart';

// import 'package:flutter_wechat/model/user/user.dart';
// import 'package:flutter_wechat/utils/service/contacts_service.dart';
// import 'package:flutter_wechat/utils/service/account_service.dart';

class ContactSettingInfoPage extends StatefulWidget {
  /// 构造函数
  ContactSettingInfoPage({Key? key, required this.idstr}) : super(key: key);

  /// 用户ID
  final String idstr;
  _ContactSettingInfoPageState createState() => _ContactSettingInfoPageState();
}

class _ContactSettingInfoPageState extends State<ContactSettingInfoPage> {
  /// 用户信息
  late User _user;

  /// 当前用户信息
  late User _currentUser;

  /// 数据源
  List<CommonGroup> _dataSource = [];

  @override
  void initState() {
    super.initState();
    // 获取用户信息
    _user = ContactsService.sharedInstance.contactsMap[widget.idstr]!;
    _currentUser = AccountService.sharedInstance.currentUser;

    // 配置数据
    _dataSource = _configData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('资料设置'),
        elevation: 0, // 隐藏AppBar底部细线阴影
      ),
      body: Container(
        child: _buildChildWidget(context),
      ),
    );
  }

  /// 配置数据
  List<CommonGroup> _configData() {
    // group0
    // 设置备注和标签
    final settingRemarks = CommonItem(
      title: '设置备注和标签',
      // todo mzl contact
      // subtitle: _user.screenName,
    );
    // 朋友权限
    final friendPermission = CommonItem(
      title: '朋友权限',
      onTap: (item) {
        // todo mzl contact
        // NavigatorUtils.push(
        //   context,
        //   '${ContactsRouter.friendPermissionPage}?idstr=${_user.idstr}',
        // );
      },
    );
    final group0 = CommonGroup(
      items: [
        settingRemarks,
        friendPermission,
      ],
    );

    // 把他推荐给朋友
    // group1
    // todo mzl contact
    final String heOrShe = "他";//_user.gender == 1 ? "她" : "他";
    final recommendToFriends = CommonItem(
      title: "把" + heOrShe + "推荐给朋友",
    );
    final group1 = CommonGroup(
      items: [recommendToFriends],
    );

    // PS: 这里需要把当前账号和用户的id 作为前缀去片接cachekey
    final preCacheKey = "test preCacheKey";//_currentUser.idstr + '_' + _user.idstr + '_';

    // group2
    // 设为星标朋友
    final starFriend = CommonSwitchItem(
      title: '设为星标朋友',
      cacheKey: preCacheKey + CacheKey.settingToStarFriendKey,
    );
    final group2 = CommonGroup(
      items: [
        starFriend,
      ],
    );

    // group3
    // 加入黑名单
    final joinToBlacklist = CommonSwitchItem(
      title: "加入黑名单",
      cacheKey: preCacheKey + CacheKey.joinToBlacklistKey,
    );

    /// 投诉
    final complaint = CommonItem(
      title: "投诉",
    );
    final group3 = CommonGroup(
      items: [
        joinToBlacklist,
        complaint,
      ],
    );

    /// 删除
    final delete = CommonCenterItem(
        title: "删除",
        titleColor: Style.pTextWarnColor,
        onTap: (_) {
          // 显示action sheet
          _showActionSheet(context);
        });
    final group4 = CommonGroup(
      items: [delete],
    );

    // 添加数据源
    return [group0, group1, group2, group3, group4];
  }

  /// 构建actionsheet
  void _showActionSheet(BuildContext context) {
    // todo mzl contact
    final String title = '将联系人' + "test screen name" + '”删除，同时删除与该联系人的聊天记录';//'将联系人' + _user.screenName + '”删除，同时删除与该联系人的聊天记录';
    ActionSheet.show(
      // todo mzl contact
      message: const Text("test contact message"),
      context,
      title: Text(title),
      actions: <Widget>[
        ActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          isDestructiveAction: true,
          child: Text('删除联系人'),
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

  /// 构建child
  Widget _buildChildWidget(BuildContext context) {
    return ListView.builder(
      itemCount: _dataSource.length,
      itemBuilder: (BuildContext context, int index) {
        return CommonGroupWidget(
          group: _dataSource[index],
        );
      },
    );
  }
}
