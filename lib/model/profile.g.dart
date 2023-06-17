// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      backColor: json['backColor'] == null
          ? const Color(0xffff7383)
          : Profile._colorFromJson(json['backColor'] as String),
      fontColor: json['fontColor'] == null
          ? const Color(0xFF9C27B0)
          : Profile._colorFromJson(json['fontColor'] as String),
      disableColor: json['disableColor'] == null
          ? Colors.grey
          : Profile._colorFromJson(json['disableColor'] as String),
      defProfilePicture: json['defProfilePicture'] == null
          ? const AssetImage("")
          : Profile._imageFromJson(json['defProfilePicture'] as String),
      backColorval: json['backColorval'] as int? ?? 0xffff2442,
      fontColorval: json['fontColorval'] as int? ?? 0xffff2442,
      locationName: json['locationName'] as String? ?? "",
      locationCode: json['locationCode'] as String? ?? "",
      locationActivityName: json['locationActivityName'] as String? ?? "",
      locationActivityCode: json['locationActivityCode'] as String? ?? "",
      profilePicture: json['profilePicture'] ?? "",
      isLogGuided: json['isLogGuided'] as bool? ?? true,
      lat: (json['lat'] as num?)?.toDouble() ?? 0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0,
      locationGoodPriceCode: json['locationGoodPriceCode'] as String? ?? "",
      locationGoodPriceName: json['locationGoodPriceName'] as String? ?? "",
    )..communitys = (json['communitys'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList();

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'user': instance.user,
      'backColor': Profile._colorToJson(instance.backColor),
      'fontColor': Profile._colorToJson(instance.fontColor),
      'disableColor': Profile._colorToJson(instance.disableColor),
      'backColorval': instance.backColorval,
      'fontColorval': instance.fontColorval,
      'locationName': instance.locationName,
      'locationCode': instance.locationCode,
      'locationActivityName': instance.locationActivityName,
      'locationActivityCode': instance.locationActivityCode,
      'locationGoodPriceName': instance.locationGoodPriceName,
      'locationGoodPriceCode': instance.locationGoodPriceCode,
      'lat': instance.lat,
      'lng': instance.lng,
      'defProfilePicture': Profile._imageToJson(instance.defProfilePicture),
      'profilePicture': instance.profilePicture,
      'isLogGuided': instance.isLogGuided,
      'communitys': instance.communitys,
    };
