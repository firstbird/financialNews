part of 'module.dart';

Handler news_get = (query, cookie) {
  return request(
      'GET', 'http://10.0.2.2:8080/api/news?',
    {
    'type': query!['type'],
    'offset': query['offset'] ?? 0,
    'limit': query['limit'] ?? 0
  },);
};

Handler news_detail = (query, cookie) {
  return request(
    'GET', 'http://10.0.2.2:8080/api/news/detail?',
    {
      'id': query!['id'],
    },);
};