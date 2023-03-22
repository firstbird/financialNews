import 'package:equatable/equatable.dart';

class HeadLinesItem with EquatableMixin {
  HeadLinesItem({
    required this.id,
    required this.title,
    required this.source,
    required this.headPicUrl,
    required this.starCount,
    required this.commentCount,
    required this.updateTime,
  });

  final int id;
  final String title;
  final String source;

  final String headPicUrl;

  final int starCount;

  final int commentCount;

  final int updateTime;

  @override
  List<Object?> get props => [
        id,
        title,
        source,
        headPicUrl,
        starCount,
        commentCount,
        updateTime,
      ];
}
