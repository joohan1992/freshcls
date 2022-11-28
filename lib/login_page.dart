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

  get result => null;

  void validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid Email: $id, password: $password');
    } else {
      print('Form is invalid Email: $id, password: $password');
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
                    onPressed: () {
                      validateAndSave();
                      var result = requestPost(id, password);
                      // loginFailure(context, result);
                    },
                  ),
                ]),
          )),
    );
  }
}

// Flutter에서 controller로 입력 받은 내용을 Flask url로 POST하는 코드

requestPost(id, password) async {
  var data = {'id': id, 'password': password};
  var url = "https://192.168.0.108:2092/login";
  var postUri = Uri.parse(url);
  var res = await http.post(postUri, body: data);
  print(res.body);
  Map<String, dynamic> result = jsonDecode(res.body);
  print(result);
  return result;
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
          onPressed: () {},
        ),
      ),
    );
  }
}

loginFailure(BuildContext context, result) async {
  if (result['id_right'] == 'Y' && result['pw_right'] == 'Y') {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginSuccess()));
    if (result['id_right'] == 'Y' && result['pw_right'] == 'N') {
      Text('로그인 오류.');
      Text('비밀번호가 틀렸습니다.',
          textAlign: TextAlign.left,
          style: TextStyle(fontWeight: FontWeight.bold));
    }
    if (result['id_right'] == 'N' && result['pw_right'] == 'Y') {
      Text('로그인 오류.');
      Text('아이디가 틀렸습니다.',
          textAlign: TextAlign.left,
          style: TextStyle(fontWeight: FontWeight.bold));
    }
    ;
    if (result['id_right'] == 'N' && result['pw_right'] == 'N') {
      Text('로그인 오류');
      Text('아이디와 비밀번호가 둘 다 틀렸습니다.',
          textAlign: TextAlign.left,
          style: TextStyle(fontWeight: FontWeight.bold));
    }
    ;
  };
  if (result['act_yn'] == 'N') {
    String act_text = '인증되지 않은 계정입니다.';
    return AlertDialog(
      content: Text(act_text),
      actions: [
        ElevatedButton(
          child: Text('돌아가기'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

showSnackBar(BuildContext context, Text text) {
  final snackBar = SnackBar(
    content: text,
    backgroundColor: Colors.blueAccent,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
