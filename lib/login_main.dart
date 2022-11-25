import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_page.dart';

void main() {
  final controller = Get.put(Controller());
  runApp(new MyApp());
  print(
      }
}'email: $controller.email, password: $controller.password'.toString());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'login demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
    );