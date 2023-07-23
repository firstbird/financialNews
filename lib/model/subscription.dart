import 'package:json_annotation/json_annotation.dart';

part 'subscription.g.dart';

@JsonSerializable()
class Subscription {
  int? id;
  int? uid;
  String? subsid;
  String? substime;
  String? expiretime;
  int? type; // pay type

  Map<String, dynamic> toMap(Subscription type) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['subsid'] = this.subsid;
    data['substime'] = this.substime;
    data['expiretime'] = this.expiretime;
    data['type'] = this.type;

    return data;
  }

  Subscription.fromMap(Map<String, dynamic> data) {
    this.id = data['id'];
    this.uid = data['uid'];
    this.subsid = data['subsid'];
    this.substime = data['substime'];
    this.expiretime = data['expiretime'];
    this.type = data['type'];
  }


  Subscription(this.id, this.uid, this.subsid, this.substime, this.expiretime, this.type);

  Map<String, dynamic> toJson() => _$SubscriptionToJson(this);
  factory Subscription.fromJson(Map<String, dynamic> json) => _$SubscriptionFromJson(json);
}