import 'package:json_annotation/json_annotation.dart';

part 'skuspecs.g.dart';

@JsonSerializable()
class Skuspecs {
  String specsid = "";
  String goodpriceid = "";
  String spdata;
  double cost;
  String pic;

  Skuspecs(this.specsid, this.goodpriceid, this.spdata, this.cost, this.pic);

  factory Skuspecs.fromJson(Map<String, dynamic> json) => _$SkuspecsFromJson(json);
}