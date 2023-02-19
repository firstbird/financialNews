import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

import 'answer.dart';
import 'request.dart';
// import 'util/request.dart';
// import 'util/utils.dart';

part 'news.dart';

typedef Handler = Future<Answer> Function(Map? query, List<Cookie> cookie);

final handles = <String, Handler>{
  "/personalized": news_get,
  "/news/detail": news_detail,
};
