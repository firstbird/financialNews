import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'user.dart';
import '../global.dart';
import 'package:path/path.dart' as path;

part 'profile.g.dart';

class ColorConverter extends JsonConverter<Color, String> {
  const ColorConverter();

  @override
  Color fromJson(String json) {
    return Color(int.parse(json));
  }

  @override
  String toJson(Color object) {
    return object.value.toRadixString(16);
  }
}

class ImageConverter extends JsonConverter<ImageProvider, String> {
  const ImageConverter();

  @override
  ImageProvider fromJson(String json) {
    if (json.startsWith("http")) {
      return NetworkImage(json);
    }
    return AssetImage(json);
  }

  @override
  String toJson(ImageProvider object) {
    if (object is AssetImage) {
      return path.basename(object.assetName);
    } else if (object is NetworkImage){
      return object.url;
    } else {
      throw Exception('Unsupported image provider type: $object');
    }
  }
}
@JsonSerializable()
class Profile {
  User? user;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color backColor;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color fontColor;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color disableColor;
  int backColorval;
  int fontColorval;
  String locationName;
  String locationCode; // for moment
  String locationActivityName;
  String locationActivityCode; // for activity
  String locationGoodPriceName;
  String locationGoodPriceCode;
  double lat;
  double lng;
  @JsonKey(fromJson: _imageFromJson, toJson: _imageToJson)
  ImageProvider defProfilePicture;
  String? profilePicture;
  bool isLogGuided = true;
  List<String>? communitys = [];

  ///获取服务器静态json
  //0xFF9C27B0 紫色 0xFFFFFFFF 白色 Color(0xffff2442);
  Profile({this.user,  this.backColor = const Color(0xffff7383), this.fontColor = const Color(0xFF9C27B0), this.disableColor = Colors.grey, this.defProfilePicture = const AssetImage(""), this.backColorval = 0xffff2442, this.fontColorval=0xffff2442,
     this.locationName= "", this.locationCode= "", this.locationActivityName = "", this.locationActivityCode = "", profilePicture = "", this.isLogGuided=true, this.lat=0, this.lng=0, this.locationGoodPriceCode = "", this.locationGoodPriceName = ""}) {

    if(user != null){
      if(user!.profilepicture != null && user!.profilepicture!.isNotEmpty){
        defProfilePicture = new NetworkImage(user!.profilepicture!);
      }
    }
    else{
      defProfilePicture = AssetImage(Global.headimg);
//      setProfilepicture();
    }
    //backColor = Color(0xffff2442);
    backColor = Color(0xffff7383);//0xffff2442
    fontColor = Color(fontColorval);
    disableColor = backColor!.withAlpha(100);

    if(disableColor == null)
      disableColor = Colors.purple.shade100;
  }

//  Future<void> setProfilepicture() async {
//    ///请求服务器配置
//    await _commonJSONController.getAppProfileConfig((Map<String, dynamic> data) {
//      if (data["data"] != null) {
//        for (int i = 0; i < data["data"].length; i++) {
//          profilePicture = data["data"][i]["value"];
//          if (user == null) {
//            ///用户未登录使用服务器配置图片
//            defProfilePicture =
//                CachedNetworkImageProvider(profilePicture);
//          }
//        }
//      }
//    });
//  }

  static Color _colorFromJson(String json) {
    return const ColorConverter().fromJson(json);
  }

  static String _colorToJson(Color color) {
    return const ColorConverter().toJson(color);
  }

  static ImageProvider _imageFromJson(String json) {
    return const ImageConverter().fromJson(json);
  }

  static String _imageToJson(ImageProvider image) {
    return const ImageConverter().toJson(image);
  }

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}
