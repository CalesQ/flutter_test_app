import 'package:flutter/material.dart';
import 'package:test_app/utils/Contant.dart';
import 'package:test_app/utils/LocalStore.dart';
import 'package:test_app/utils/SendRequest.dart';
import 'package:test_app/utils/Toast.dart';

class UpdateInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'update info page',
      // 创建登陆界面对象
      home: UpdateInfoPage(),
    );
  }
}

class UpdateInfoPage extends StatefulWidget {
  @override
  UpdateInfoPageState createState() => new UpdateInfoPageState();
}

class UpdateInfoPageState extends State<UpdateInfoPage> {
  // 变量
  String userName = '';
  String phone = '';

  //焦点
  FocusNode focusNodeUserName = new FocusNode();
  FocusNode focusNodePhone = new FocusNode();

  var isShowClear = false; //是否显示输入框尾部的清除按钮
  var isShowPhoneClear = false;

  //表单状态
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //输入框控制器，此控制器可以监听输入框操作
  TextEditingController userNameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  @override
  void initState() {
    //设置焦点监听
    focusNodeUserName.addListener(focusNodeListener);
    focusNodePhone.addListener(focusNodeListener);

    //监听用户名框的输入改变
    userNameController.addListener(() {
      print(userNameController.text);
      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (userNameController.text.length > 0) {
        isShowClear = true;
      } else {
        isShowClear = false;
      }
      setState(() {});
    });

    //监听手机号框的输入改变
    phoneController.addListener(() {
      print(phoneController.text);
      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (phoneController.text.length > 0) {
        isShowPhoneClear = true;
      } else {
        isShowPhoneClear = false;
      }
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    // 移除焦点监听
    focusNodeUserName.removeListener(focusNodeListener);
    focusNodePhone.removeListener(focusNodeListener);
    userNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // 监听焦点具体执行方法
  Future<Null> focusNodeListener() async {
    if (focusNodeUserName.hasFocus) {
      print("用户名框获取焦点");
      // 取消其他框焦点状态
      focusNodePhone.unfocus();
    } else {
      print("手机号框获取焦点");
      // 取消其他框焦点状态
      focusNodeUserName.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    //输入文本框区域
    Widget inputTextArea = new Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white),
      child: new Form(
        key: formKey,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // 用户名
            new TextFormField(
              controller: userNameController,
              focusNode: focusNodeUserName,
              decoration: InputDecoration(
                labelText: "用户名",
                hintText: "请输入用户名",
                prefixIcon: Icon(Icons.person),
                //尾部添加清除按钮
                suffixIcon: (isShowClear)
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          // 清空输入框内容
                          userNameController.clear();
                        },
                      )
                    : null,
              ),
              //验证用户名
              validator: validateUserName,
              //保存数据
              onSaved: (String value) {
                userName = value;
              },
            ),

            // 手机号
            new TextFormField(
              controller: phoneController,
              focusNode: focusNodePhone,
              decoration: InputDecoration(
                labelText: "手机号",
                hintText: "请输入手机号",
                prefixIcon: Icon(Icons.person),
                //尾部添加清除按钮
                suffixIcon: (isShowClear)
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          // 清空输入框内容
                          userNameController.clear();
                        },
                      )
                    : null,
              ),
              //验证用户名
              validator: validatePhone,
              //保存数据
              onSaved: (String value) {
                phone = value;
              },
            ),
          ],
        ),
      ),
    );

    // 修改按钮区域
    Widget updateButtonArea = new Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      height: 45.0,
      child: new RaisedButton(
        color: Colors.blue[300],
        child: Text(
          "修改",
          style: Theme.of(context).primaryTextTheme.headline,
        ),
        // 设置按钮圆角
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: () {
          //点击登录按钮，解除焦点，回收键盘
          focusNodePhone.unfocus();
          focusNodeUserName.unfocus();

          if (formKey.currentState.validate()) {
            //只有输入通过验证，才会执行这里
            formKey.currentState.save();

            Map<String, String> data = {"user_name": userName, "phone": phone};
            // 注册请求
            request('/api/v1/user/vip/info/update', 'POST', null, null, data,
                    context)
                .then((res) {
              // 返回上一层
              if (res != null) {
                myToast("修改成功");
                //Navigator.pop(context);
              }
            }).whenComplete(() {
              print("修改信息请求处理完成");
            }).catchError(() {
              myToast("出现异常,请重试");
            });
          }
        },
      ),
    );

    // 返回
    return Scaffold(
      appBar: new AppBar(
        title: new Text("修改信息"),
        leading: Icon(Icons.verified_user),
        backgroundColor: getMainColor(),
        centerTitle: true,
      ),
      // 外层添加一个手势，用于点击空白部分，回收键盘
      body: new GestureDetector(
        onTap: () {
          // 点击空白区域，回收键盘
          print("点击了空白区域");
          focusNodePhone.unfocus();
          focusNodeUserName.unfocus();
        },
        child: new ListView(
          children: <Widget>[
            new SizedBox(height: 40.0),
            inputTextArea,
            new SizedBox(height: 30.0),
            updateButtonArea,
            new SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }

  /**
   * 验证号码
   */
  String validatePhone(String value) {
    //正则匹配手机号
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    if (value.isEmpty) {
      return '手机号不能为空!';
    } else if (!exp.hasMatch(value)) {
      return '请输入正确手机号';
    }
    return null;
  }

  /**
   * 验证用户名
   */
  String validateUserName(String value) {
    if (value.isEmpty) {
      return '用户名不能为空';
    } else if (value.length > 10) {
      return '用户名太长了';
    }
    return null;
  }
}
