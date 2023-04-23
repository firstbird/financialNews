import 'package:recipe/model/badge/badge.dart';
import 'package:recipe/repository/data/user.dart';

// 列表消息
class Message {
  late String idstr;
  List<User>? users;
  late String screenName;
  String? createdAt;
  late String text;
  Badge? badge;

  /// 消息免打扰
  late bool messageFree;

  /// 侧滑类型
  late String type;

  Message({
    this.idstr = "",
    this.users,
    this.screenName = "",
    this.createdAt,
    this.text = "",
    this.badge,
    this.messageFree = false,
    this.type = "",
  });

  Message.fromJson(Map<String, dynamic> json) {
    idstr = json['idstr'];
    if (json['users'] != null) {
      users = <User>[];
      json['users'].forEach((v) {
        users!.add(new User.fromJson(v));
      });
    }
    screenName = json['screen_name'];
    createdAt = json['created_at'];
    text = json['text'];
    badge = json['badge'] != null ? new Badge.fromJson(json['badge']) : null;
    messageFree = json['messageFree'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idstr'] = this.idstr;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    data['screen_name'] = this.screenName;
    data['created_at'] = this.createdAt;
    data['text'] = this.text;
    data['messageFree'] = this.messageFree;
    data['type'] = this.type;
    if (this.badge != null) {
      data['badge'] = this.badge!.toJson();
    }
    return data;
  }
}
