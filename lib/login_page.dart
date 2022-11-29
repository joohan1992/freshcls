import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'dart:async';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  late String id;
  late String password;

  Map <String, String> resultMap = {};

  Text title_text = Text('');
  Text act_text = Text('');

  void validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid Email: $id, password: $password');
    } else {
      print('Form is invalid Email: $id, password: $password');
    }
  }

  loginFailure(BuildContext context, resultMap) {
    if (resultMap['log_in_st'] == "0") {
      Navigator.push(context,
          MaterialPageRoute(
              builder: (BuildContext context) => const LoginSuccess()));
    }
    else {
      if (resultMap['log_in_st'] == "1") {
        title_text = Text('인증 실패', textAlign: TextAlign.left,);
        act_text = Text(resultMap['log_in_text'], textAlign: TextAlign.center,);
      }
      else if (resultMap['log_in_st'] == "2") {
        title_text = Text('로그인 실패', textAlign: TextAlign.left,);
        act_text = Text(resultMap['log_in_text'], textAlign: TextAlign.center,);
      }
      else if (resultMap['log_in_st'] == "3") {
        title_text = Text('로그인 실패', textAlign: TextAlign.left,);
        act_text = Text(resultMap['log_in_text'], textAlign: TextAlign.center,);
      }
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: title_text,
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  act_text,
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: new AppBar(
      title: new Text('login demo'),
    ),
    body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new TextFormField(
                  decoration: new InputDecoration(labelText: 'Id'),
                  validator: (value) =>
                  value!.isEmpty ? 'Id can\'t be empty' : null,
                  onSaved: (value) => id = value!,
                  onChanged: (value) => id = value,
                ),
                new TextFormField(
                  obscureText: true,
                  decoration: new InputDecoration(labelText: 'Password'),
                  validator: (value) =>
                  value!.isEmpty ? 'Password can\'t be empty' : null,
                  onSaved: (value) => password = value!,
                  onChanged: (value) => password = value,
                ),
                ElevatedButton(
                  child: new Text(
                    'Login',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () async {
                    validateAndSave();
                    Map<String, String> resultMap = await requestPost(
                        id, password);
                    loginFailure(context, resultMap);
                  },
                ),
              ]),
        )),
  );
}}

// Flutter에서 controller로 입력 받은 내용을 Flask url로 POST하는 코드

requestPost(id, password) async {
  var data = {'id': id, 'password': password};
  var url = "https://192.168.0.108:2092/login";
  var postUri = Uri.parse(url);
  var res = await http.post(postUri, body: data);
  String resBody = utf8.decode(res.bodyBytes);
  Map<String, dynamic> resultmap = jsonDecode(resBody);
  Map<String, String> resultMap = {};
  resultMap['log_in_st'] = resultmap['log_in_st'].toString();
  resultMap['str_no'] = resultmap['str_no'].toString();
  resultMap['login_no'] = resultmap['login_no'].toString();
  resultMap['act_yn'] = resultmap['act_yn'].toString();
  resultMap['log_in_text'] = resultmap['log_in_text'].toString();
  print(res.body);
  // print(resultMap);
  return resultMap;
}

// Flutter에서 POST 한 내용을 받아서 로그인 성공 여부와 id, password, activated 여부를 띄워주는 page

class LoginSuccess extends StatelessWidget {
  const LoginSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: ElevatedButton(
          child: const Text('로그인 성공 페이지입니다.'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}


// showSnackBar(BuildContext context, Text text) {
//   final snackBar = SnackBar(
//     content: text,
//     backgroundColor: Colors.blueAccent,
//   );
//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }
