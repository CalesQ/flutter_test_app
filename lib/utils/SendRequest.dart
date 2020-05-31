import 'dart:convert';
import 'dart:io';
import 'package:test_app/utils/Toast.dart';

import 'LocalStore.dart';

var ip = "139.155.151.126:6781";

Future<dynamic> request(uri, method, header, param, body) async {
  print("进入request");
  if (method == "GET") {
    return getRequest(uri, header, param, body);
  } else {
    return postRequest(uri, header, param, body);
  }
}

Future<dynamic> getRequest(path, header, param, body) async {
  print("进入get");
  var httpClient = new HttpClient();

  var url = Uri.http(ip, path, null);
  var request = await httpClient.postUrl(url);

  // 添加请求头
  request.headers.add("Content-type", "application/json");

  // 添加请求体
  request.add(utf8.encode(json.encode(param)));

  var response = await request.close();

  // 返回码
  var resCode = response.statusCode;

  var responseBody = await response.transform(utf8.decoder).join();
  if (resCode == 200) {
    print("200");
  } else {
    print("");
  }

  return responseBody;
}

Future<dynamic> postRequest(path, header, param, body) async {
  print("进入post方法");

  var httpClient = new HttpClient();
  var url = Uri.http(ip, path, param);

  // 构建请求头
  var userId = getStorage("user_id");
  var token = getStorage("token");

  var request = await httpClient.postUrl(url);

  // 添加请求头 header
  request.headers.add("Content-type", "application/json");
  request.headers.add("user_id", userId);
  request.headers.add("token", token);

  // 添加请求体 data/body
  request.add(utf8.encode(json.encode(body)));

  var response = await request.close();

  // 返回码
  var resCode = response.statusCode;

  var responseBody = await response.transform(utf8.decoder).join();
  print(resCode);
  if (resCode == 200 || resCode == 202) {
    // 处理返回值
    var res = json.decode(responseBody);

    if(res["code"] == 200){
      print("返回数据");
      return res;
    }
    else{
      myToast(res.msg);
    }
  } 
  else if(resCode == 401) {
    myToast("请重新登录");
  }
  else {
    myToast("请稍后重试");
  }
  return null;
}
