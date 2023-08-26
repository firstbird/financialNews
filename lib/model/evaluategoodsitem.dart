import 'package:json_annotation/json_annotation.dart';

import 'evaluateactivityreply.dart';
import 'user.dart';

part 'evaluategoodsitem.g.dart';

@JsonSerializable()
class EvaluateGoodsItem {
  int? evaluateid;
  User? user;
  int? touid;
  String? content;
  String? imagepaths;
  int? liketype;
  int? likenum;
  int? likeuid;//用于查询本地用户是否有点赞
  String? createtime;
  String? goodsitemcontent;
  String? coverimg;
  String orderid = "";
  String goodpriceid = "";

  EvaluateGoodsItem(this.evaluateid, this.user, this.content, this.likenum, this.createtime, this.likeuid,
      this.imagepaths, this.touid, this.liketype, this.coverimg, this.orderid, this.goodpriceid);

  Map<String, dynamic> toJson() => _$EvaluateGoodsItemToJson(this);
  factory EvaluateGoodsItem.fromJson(Map<String, dynamic> json) => _$EvaluateGoodsItemFromJson(json);
}