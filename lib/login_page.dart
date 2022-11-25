import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:developer';
import 'dart:convert';

import 'main.dart';


class Controller extends GetxController{
  late String email;
  late String password;
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  final controller = Get.put(Controller());

  // late String _email;
  // late String _password;

  void validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid Email: $controller.email, password: $controller.password');
    } else {
      print('Form is invalid Email: $controller.email, password: $controller.password');
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
                decoration: new InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value!.isEmpty ? 'Email can\'t be empty' : null,
                onSaved: (value) => controller.email = value!,
              ),
              new TextFormField(
                obscureText: true,
                decoration: new InputDecoration(labelText: 'Password'),
                validator: (value) =>
                value!.isEmpty ? 'Password can\'t be empty' : null,
                onSaved: (value) => controller.password = value!,
              ),
              ElevatedButton(
                child: new Text(
                  'Login',
                  style: new TextStyle(fontSize: 20.0),
                ),
                onPressed: () async {validateAndSave(); requestPost();}
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// _postRequest() async {
//
//   final controller = Get.put(Controller());
//   Uri url = Uri.parse('http://168.192.0.108/auth') as Uri;
//
//   http.Response response = await http.post(
//     url,
//     headers: <String, String> {
//       'Content-Type' : 'application/x-www-form-urlencoded',
//     },
//     body: <String, String> {
//       'email' : '$controller.email',
//       'Password' : '$controller.password',
//     }
//   );
// }

// Flutter에서 controller로 입력 받은 내용을 Flask url로 POST하는 코드

requestPost() async {
  final controller = Get.put(Controller());
  Map<String, String> headers = {
    'Content-Type' : 'application/json',
    'Accept' : 'application/json',
  };
  Map<String, String> data = {'email': '$controller.email', 'Password': '$controller.password'};
  String url = 'https://192.168.0.108:9890/login';
  var postUri = Uri.parse(url);
  return http.post(postUri, headers: headers, body: jsonEncode(data));
}

// Flutter에서 POST 한 내용을 받아서 로그인 여부를



class Session {
  Map<String, String> headers = {
    'Content-Type' : 'application/json',
    'Accept' : 'application/json',
  };

  Map<String, String> cookies = {};

  Future<dynamic> get(String url) async {
    print('get() url: $url');
      http.Response response =
          await http.get(Uri.parse(url), headers: headers);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {

    }
    return json.decode(utf8.decode(response.bodyBytes));
  }
  Future<dynamic> post(String url, dynamic data) async {
    print('post() url: $url');
    http.Response response = await http.post(Uri.parse(url),
      body: json.encode(data), headers: headers);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {

    }
    return json.decode(utf8.decode(response.bodyBytes));
  }
}

class ResponseV0 {
  final dynamic code;
  final dynamic message;
  final dynamic timestamp;
  final dynamic response;

  ResponseV0({this.code, this.message, this.timestamp, this.response});

  factory ResponseV0.fromJSON(Map<String, dynamic> json, Future post) {
    print('responseV0.code : ${json['code']}');
    print('responseV0.message : ${json['message']}');
    print('responseV0.timestamp : ${json['timestamp']}');
    print('responseV0.response : ${json['response']}');

    return ResponseV0(
    code: json['code'],
    message: json['message'],
    timestamp: json['timestamp'],
    response: json['response'],
    );
}
}

// final ResponseV0 responseV0 = ResponseV0.fromJSON(await new Session().post('$url/sample/user/login', null));
//   if (responseV0 != null) {
//     if (responseV0.code == SUCCESS) {
//           Navigator.pushNamed(context, PlazaPage.PlazaPageRouteName);
//     } else if (responseV0.code == SERVER_ERROR) {
// showToast('error');
// } else if (responseV0.code == INFORMATION_NOT_OBTAINED) {
//       Navigator.pushNamed(context, JoinPage.JoinPageRouteName);
// }
// }
