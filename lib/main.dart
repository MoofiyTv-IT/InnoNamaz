import 'package:flutter/material.dart';
import 'package:inno_namaz/resources/colors.dart';
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
      theme: ThemeData(
        splashColor: yellow54,
      ),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
      title: "Inno Namaz",
      home: Home(),
    );
  }
}
