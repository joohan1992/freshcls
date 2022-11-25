import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:developer';
import 'dart:convert';


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
        child: new Form(
          key: formKey,
          child: new Column(
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
              new ElevatedButton(
                child: new Text(
                  'Login',
                  style: new TextStyle(fontSize: 20.0),
                ),
                onPressed: validateAndSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_postRequest() async {

  final controller = Get.put(Controller());
  Uri url = Uri.parse('http://168.192.0.108/auth') as Uri;

  http.Response response = await http.post(
    url,
    headers: <String, String> {
      'Content-Type' : 'application/x-www-form-urlencoded',
    },
    body: <String, String> {
      'email' : '$controller.email',
      'Password' : '$controller.password',
    }
  );
}

class Session {
  Map<String, String> headers = {
    'Content-Type' : 'application/json',
    'Accept' : 'application/json',
  };

  Map<String, String> cookies = {};

  Future<dynamic> get(Uri url) async {
    print('get() url: $url');
    http.Response response =
        await http.get(Uri.encodeFull(url), headers: headers);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {

    }
    return json.decode(utf8.decode(response.bodyBytes));
  }
  Future<dynamic> post(String url, dynamic data) async {
    print('post() url: $url');
    http.Response response = await http.post(Uri.encodeFull(url),
      body: json.encode(data), headers: headers);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {

    }
    return json.decode(utf8.decode(response.bodyBytes));
  }
}
