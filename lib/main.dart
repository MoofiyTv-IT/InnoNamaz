import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'Design/Home.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends AppMVC {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inno Namaz',
      home: Home(),
    );
  }
}