import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/utils/SendRequest.dart';
import 'package:test_app/utils/Toast.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'home page',
      // 创建登陆界面对象
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // 注册按钮区域
    Widget regButtonArea = new Container(
      margin: EdgeInsets.only(left: 20,right: 20),
      height: 45.0,
      child: new RaisedButton(
        color: Colors.blue[300],
        child: Text(
          "修改个人信息",
          style: Theme.of(context).primaryTextTheme.headline,
        ),
        // 设置按钮圆角
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: (){
        },
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      // 外层添加一个手势，用于点击空白部分，回收键盘
      body: new GestureDetector(
        onTap: (){
          // 点击空白区域，回收键盘
          print("点击了空白区域");
        },
        child: new ListView(
          children: <Widget>[
          new SizedBox(height: 70.0),
          regButtonArea,
          new SizedBox(height: 40.0),
        ],
        ),
      ),
    );
  }
  
}