import 'safe_convert.dart';

class Personalized {
  Personalized({
    this.hasTaste = false,
    this.code = 0,
    this.category = 0,
    required this.result,
  });

  factory Personalized.fromJson(Map<String, dynamic>? json) => Personalized(
        // hasTaste: asBool(json, 'hasTaste'),
        code: asInt(json, 'code'),
        // category: asInt(json, 'category'),
        result: asList(json, 'result')
            .map((e) => PersonalizedItem.fromJson(e))
            .toList(),
      );
  final bool hasTaste;
  final int code;
  final int category;
  final List<PersonalizedItem> result;

  Map<String, dynamic> toJson() => {
        'hasTaste': hasTaste,
        'code': code,
        'category': category,
        'result': result.map((e) => e.toJson()),
      };
}

class PersonalizedItem {
  PersonalizedItem({
    this.id = 0,
    this.type = 0,
    this.title = '',
    this.source = '',
    this.headPicUrl = '',
    this.updateTime = 0,
    this.starCount = 0,
    this.commentCount = 0,
  });

  factory PersonalizedItem.fromJson(Map<String, dynamic>? json) =>
      PersonalizedItem(
        id: asInt(json, 'id'),
        type: asInt(json, 'type'),
        title: asString(json, 'title'),
        source: asString(json, 'source'),
        headPicUrl: asString(json, 'headPicUrl'),
        updateTime: asInt(json, 'updateTime'),
        starCount: asInt(json, 'starCount'),
        commentCount: asInt(json, 'commentCount'),
      );

  final int id;
  final int type;
  final String title;
  final String source;
  final String headPicUrl;
  final int updateTime;
  final int starCount;
  final int commentCount;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'name': title,
        'source': source,
        'headPicUrl': headPicUrl,
        'created_at': updateTime,
        'starCount': starCount,
        'commentCount': commentCount,
      };
}
