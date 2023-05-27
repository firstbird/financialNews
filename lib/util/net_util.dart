
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'showmessage_util.dart';
import '../global.dart';


class NetUtil {
  Dio? _dio;
  static NetUtil _instance = NetUtil._internal();
  factory NetUtil() => _instance;
  ///通用全局单例，第一次使用时初始化
  NetUtil._internal() {
    if (null == _dio) {
      // _dio = new Dio(
      //     new BaseOptions(baseUrl:  Global.serviceurl,  connectTimeout: 5000, receiveTimeout: 3000));
      BaseOptions _dioOpts = BaseOptions(
        method: 'POST',
        connectTimeout: 5000,
        sendTimeout: 5000,
        receiveTimeout: 5000,
        baseUrl: Global.serviceurl,
        contentType: Headers.formUrlEncodedContentType,
        responseType: ResponseType.json,
      );
      _dio = Dio(_dioOpts);
      Interceptor interceptor = LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
      );
      _dio!.interceptors.add(interceptor);
      _dio!.interceptors.add(InterceptorsWrapper(
        onError: (e, handler) {
        print("onError ${e.message}");
        handler.next(e);
      }, onRequest: (r, handler) {
        print("onRequest: ${r.method} path: ${r.path}");
        handler.next(r);
      }, onResponse: (r, handler) {
        print("onResponse: ${r.data}");
        handler.next(r);
      }));
    }
  }

  static NetUtil getInstance({String? baseUrl}) {
    if (baseUrl == null) {
      return _instance._normal();
    } else {
      return _instance._baseUrl(baseUrl);
    }
  }

  //一般请求，默认域名
  NetUtil _normal() {
    if (_dio != null) {
      if (_dio!.options.baseUrl != Global.serviceurl) {
        _dio!.options.baseUrl = Global.serviceurl;
      }
    }
    return this;
  }

  NetUtil _baseUrl(String baseUrl) {
    if (_dio != null) {
      _dio!.options.baseUrl = baseUrl;
    }
    return this;
  }


  Future<void> download(String url, String filepath, Function errorCallBack, Function callBack) async {
    Response responce = await _dio!.download(url, filepath);
    if(responce.statusCode == 200){
      callBack();
    }
    else{
      errorCallBack();
    }
  }

  ///get请求
  Future<void> get(String url, Function callBack,
      {Map<String, String>? params, Function? errorCallBack}) async {
    Response response;
    try {
      print('get queryParameters url : ${url}');
      response = await _dio!.get(url, queryParameters: params);
      print('response statusCode: ${response.statusCode}');
    } on DioError catch (e) {
      return resultError(e);
    }

    if(response.statusCode == 200) {
      if (response.data["status"] != null) {
        print('response data: not null');
        if (response.data["status"] < 0) {
          print('response data value<0: ${response.data["status"]}');
          if (errorCallBack != null) {
            errorCallBack(response.data["status"].toString(), response.data["msg"].toString());
          }
          return;
        }
        else {
          print('response data value>0: ${response.data["status"]}');
          if (callBack != null) {
            ///print("<net> response data:" + response.data["data"].runtimeType == "_InternalLinkedHashMap<int, String>");
            callBack(response.data);
          }
        }
      }
      else{
        print('response status: null');
        callBack(response.data);
      }
    }
  }

  postJson(Object jsonData, String api, Function callBack, Function errorCallBack, {bool isloginOut = false}) async {
    Response response;
    try {
      print('postjson form data url : ${api}');
      response = await _dio!.post(api, options: Options(headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }), data: jsonData);
    } on DioError catch (e) {
      return resultError(e);
    }

    print('postjson response.statusCode: ${response.statusCode} status: ${response.data["status"]}');
    if(response.statusCode == 200) {
      if (response.data["status"] < 0) {
        ///token过期
        if (response.data["status"] == -9006) {
          if (!isloginOut) {
            _handError(errorCallBack, response);
            Global.navigatorKey.currentState!.pushNamed('/Login');
          }
        }
        else {
          print("<net> error response status + ${response.data["status"]} errorCallback: ${errorCallBack}");
          if (errorCallBack != null) {
            print("<net> error response data:" + response.data["data"]);
            _handError(errorCallBack, response);
          }
        }
      }
      else {
        print("<net> ok response callBack + ${callBack}");
        if (callBack != null) {
          print("<net> ok response data runtimeType: ${response.data["data"]}");
          callBack(response.data);
        }
      }
    } else {
      print('post error response statusCode: ${response.statusCode} ');
      callBack(response.data);
    }
  }

  post(FormData formData, String api, Function callBack, Function errorCallBack, {bool isloginOut = false}) async {
    Response response;
    try {
      print('post form data url : ${api}');
      response = await _dio!.post(api, options: Options(headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }), data: formData.toString());
    } on DioError catch (e) {
      return resultError(e);
    }

    if(response.statusCode == 200) {
      if (response.data["status"] < 0) {
        ///token过期
        if (response.data["status"] == -9006) {
          if (!isloginOut) {
            _handError(errorCallBack, response);
            Global.navigatorKey.currentState!.pushNamed('/Login');
          }
        }
        else {
          if (errorCallBack != null) {
            //print("<net> response data:" + response.data["data"].runtimeType == "_InternalLinkedHashMap<int, String>");
            _handError(errorCallBack, response);
          }
        }
      }
      else {
        if (callBack != null) {
          //print("<net> response data:" + response.data["data"].runtimeType == "_InternalLinkedHashMap<int, String>");
          callBack(response.data);
        }
      }
    } else {
      print('post error response statusCode: ${response.statusCode} ');
      callBack(response.data);
    }
  }

  ///外网的网络请求
  Future<void> wget(String url, Function callBack,
      {Map<String, String>? params, Function? errorCallBack}) async {
    Response response;
    try {
      response = await _dio!.get(url, queryParameters: params);
    } on DioError catch (e) {
      return resultError(e);
    }

    if(response.statusCode == 200) {
      if(response.data["status"] == "1")
        callBack(response.data["pois"]);
    }
  }


  static Future<void> aliyunOSSpost(FormData formData ,  String url, Function callBack, Function errorCallBack) async {
    Response response;
    BaseOptions options = new BaseOptions();
    options.responseType = ResponseType.plain;
    options.contentType = "application/x-png";
    response = await Dio(options).post(url, data: formData);

    if (response.statusCode != 200) {
      errorCallBack(response.statusCode, response.statusMessage);
    }
    else {
      if (callBack != null) {
        //print("<net> response data:" + response.data["data"].runtimeType == "_InternalLinkedHashMap<int, String>");
        callBack(response.data);
      }
    }
  }

  //处理异常
  static void _handError(Function errorCallback, Response response) {
    if (errorCallback != null) {
      errorCallback(response.data["status"].toString(), response.data["msg"].toString());
    }
    print("<net> errorMsg :" + response.data["msg"]);
  }

  resultError(DioError error) {
    print("Dio resultError error type: ${error.type} , message: ${error.message}");
    switch (error.type) {
      case DioErrorType.cancel:
        ShowMessage.showToast("请求取消!");
        break;
      case DioErrorType.connectTimeout:
        ShowMessage.showToast("连接超时!");

        break;
      case DioErrorType.sendTimeout:
        ShowMessage.showToast("请求超时!");

        break;
      case DioErrorType.receiveTimeout:
        ShowMessage.showToast("响应超时!");
        break;

      default:
        if (error.message.contains("Network is unreachable")) {
          ShowMessage.showToast("网络不给力，请再试一下!");
        } else {
          ShowMessage.showToast("网络不给力，请再试一下!");
        }
    }
  }
}
