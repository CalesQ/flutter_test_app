import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/LoginPage.dart';
import 'package:test_app/UpdateInfoPage.dart';
import 'package:test_app/utils/Contant.dart';
import 'package:test_app/utils/LocalStore.dart';
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
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getStorage('expired').then((value) {
      if (int.parse(value.toString()) <
          new DateTime.now().millisecondsSinceEpoch) {
        myToast("身份已过期，请重新登录");
        Navigator.pushAndRemoveUntil(
            context,
            new MaterialPageRoute(builder: (context) => new Login()),
            (route) => false);
      }
    });

    // 修改个人信息按钮区域
    Widget updateInfoButtonArea = new Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      height: 45.0,
      child: new RaisedButton(
        color: Colors.blue[300],
        child: Text(
          "修改个人信息",
          style: Theme.of(context).primaryTextTheme.headline,
        ),
        // 设置按钮圆角
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: () {
          Navigator.push(context, new MaterialPageRoute(builder: (context) {
            return UpdateInfo();
          }));
        },
      ),
    );
// 修改个人信息按钮区域
    Widget reLoginButtonArea = new Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      height: 45.0,
      child: new RaisedButton(
        color: Colors.blue[300],
        child: Text(
          "退出登录",
          style: Theme.of(context).primaryTextTheme.headline,
        ),
        // 设置按钮圆角
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: () {
          setStorage('user_id', null);
          setStorage('token', null);
          Navigator.pushAndRemoveUntil(context,
              new MaterialPageRoute(builder: (context) {
            return Login();
          }), (route) => false);
        },
      ),
    );

    return Scaffold(
      appBar: new AppBar(
        title: new Text("主页"),
        leading: Icon(Icons.home),
        backgroundColor: getMainColor(),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      // 外层添加一个手势，用于点击空白部分
      body: new GestureDetector(
        onTap: () {
          // 点击空白区域，回收键盘
          print("点击了空白区域");
        },
        child: new ListView(
          children: <Widget>[
            new SizedBox(height: 70.0),
            updateInfoButtonArea,
            new SizedBox(height: 40.0),
            reLoginButtonArea,
          ],
        ),
      ),
    );
  }
}
