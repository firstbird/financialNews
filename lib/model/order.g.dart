// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      json['orderid'] as String?,
      json['gpactid'] as String?,
      (json['gpprice'] as num?)?.toDouble(),
      json['uid'] as int?,
      json['createtime'] as String?,
      json['updatetime'] as String?,
      json['paymenttype'] as int?,
      json['goodpriceid'] as String,
      json['goodpricesku'] as String,
      json['productname'] as String?,
      json['productpic'] as String?,
      json['creategpuid'] as int?,
      json['specsid'] as int?,
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      json['activity'] == null
          ? null
          : Activity.fromJson(json['activity'] as Map<String, dynamic>),
      json['ordertype'] as int?,
      json['orderstatus'] as int?,
      json['productnum'] as int,
      json['expirestime'] as int?,
      json['goodpricetitle'] as String,
      json['goodpricepic'] as String,
      json['touid'] as int,
      json['goodpricebrand'] as String,
      json['goodpricespeacename'] as String,
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'orderid': instance.orderid,
      'gpactid': instance.gpactid,
      'gpprice': instance.gpprice,
      'uid': instance.uid,
      'createtime': instance.createtime,
      'updatetime': instance.updatetime,
      'paymenttype': instance.paymenttype,
      'goodpriceid': instance.goodpriceid,
      'goodpricesku': instance.goodpricesku,
      'goodpricebrand': instance.goodpricebrand,
      'productname': instance.productname,
      'productpic': instance.productpic,
      'creategpuid': instance.creategpuid,
      'specsid': instance.specsid,
      'user': instance.user,
      'activity': instance.activity,
      'ordertype': instance.ordertype,
      'orderstatus': instance.orderstatus,
      'productnum': instance.productnum,
      'expirestime': instance.expirestime,
      'goodpricetitle': instance.goodpricetitle,
      'goodpricepic': instance.goodpricepic,
      'touid': instance.touid,
      'goodpricespeacename': instance.goodpricespeacename,
    };
