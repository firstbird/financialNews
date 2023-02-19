import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';
// import 'package:netease_music_api/netease_cloud_music.dart';

import 'package:http/http.dart';

import 'answer.dart';

Future<Answer> request(
  String method,
  String url,
  Map data) async {
  data = Map.from(data);
  // final headers = _buildHeader(url, ua, method, cookies);
  // if (crypto == Crypto.weapi) {
  //   var csrfToken = cookies.firstWhereOrNull((c) => c.name == "__csrf");
  //   data["csrf_token"] = csrfToken?.value ?? "";
  //   data = weApi(data);
  //   url = url.replaceAll(RegExp(r"\w*api"), 'weapi');
  // } else if (crypto == Crypto.linuxapi) {
  //   data = linuxApi({
  //     "params": data,
  //     "url": url.replaceAll(RegExp(r"\w*api"), 'api'),
  //     "method": method,
  //   });
  //   headers['User-Agent'] =
  //       'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36';
  // url = 'https://music.163.com/api/linux/forward';
  // }

// final response = await post(
//     url,
//     body: jsonEncode(body),
//     headers: {
//       HttpHeaders.contentTypeHeader: 'application/json',
//     },
//   );
//   return response;
  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.contentLengthHeader: '-1',
  };
  return _doRequest(url, headers, data, method).then((response) async {
    var ans = Answer(cookie: response.cookies);

    final content =
        await response.cast<List<int>>().transform(utf8.decoder).join();
    final body = response.statusCode == 200 ? json.decode(content) : null;
    final newBody = {"code": response.statusCode == 204 ? 200 : response.statusCode,  "result": body};
    ans = ans.copy(
        status: response.statusCode,
        body: newBody);

    ans = ans.copy(
        status: ans.status > 100 && ans.status < 600 ? ans.status : 400);
    return ans;
  }
  ).catchError((e, s) {
    debugPrint(e.toString());
    debugPrint(s.toString());
    return Answer(status: 502, body: {'code': 502, 'msg': e.toString()});
  });
}

Future<HttpClientResponse> _doRequest(
    String url, Map<String, String> headers, Map data, String method) {
  String reqPath = Uri(queryParameters: data.cast()).query;
  return HttpClient().openUrl(method, Uri.parse(url + reqPath)).then((request) {
    headers.forEach(request.headers.add);
    debugPrint('_doRequest ==========: $reqPath');
    // request.write(reqPath);
    return request.close();
  });
}
