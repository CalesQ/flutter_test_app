import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/utils/Toast.dart';

import '../LoginPage.dart';
import 'LocalStore.dart';

var ip = "139.155.151.126:6781";

Future<dynamic> request(uri, method, header, param, body, context) async {
  print("进入request");
  // 创建请求客户端
  HttpClient httpClient = new HttpClient();

  // 请求资源定位
  var url = Uri.http(ip, uri, param);

  // 请求实体
  HttpClientRequest request = null;
  if (method == "GET") {
    request = await httpClient.getUrl(url);
  } else {
    request = await httpClient.postUrl(url);

    // 添加请求体
    request.add(utf8.encode(json.encode(body)));
  }

  // 构建请求头
  String userId = '';
  String token = '';

  await getStorage('user_id').then((value) => {userId = value});
  await getStorage('token').then((t) => {token = t});

  // 添加请求头 header
  request.headers.add("Content-type", "application/json");
  request.headers.add("user_id", userId);
  request.headers.add("token", token);

  var response = await request.close();

  // 返回码
  var resCode = response.statusCode;

  var responseBody = await response.transform(utf8.decoder).join();
  print(resCode);
  if (resCode == 200) {
    // 处理返回值
    var res = json.decode(responseBody);

    if (res["code"] == 200) {
      print("返回数据");
      return res;
    } else {
      myToast(res["msg"]);
    }
    print("信息" + res["msg"]);
  } else if (resCode == 401) {
    myToast("请重新登录");
    Navigator.pushAndRemoveUntil(
        context,
        new MaterialPageRoute(builder: (context) => new Login()),
        (Route<dynamic> route) => false);
  } else if (resCode == 202) {
    myToast("您的等级不够，请注意升级。");
  } else {
    myToast("请稍后重试");
  }

  return null;
}