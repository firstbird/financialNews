part of 'module.dart';

Handler news_get = (query, cookie) {
  return request(
      'GET', 'http://10.0.2.2:8080/api/news_item?',
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

Handler login_with_phone = (query, cookie) {
  return request(
    'GET', 'http://10.0.2.2:8080/api/users/login_with_phone?',
    {
      'account': query!['account'],
      'passwd': query!['passwd'],
    },);
};

Handler users_detail = (query, cookie) {
  return request(
    'GET', 'http://10.0.2.2:8080/api/users/${query!['uid']}',
    {
    },);
};
