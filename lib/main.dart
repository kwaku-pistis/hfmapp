import 'package:HFM/themes/colors.dart';
import 'package:HFM/widgets/splashscreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: colortheme.primaryColor,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: SplashScreenPage(),
    );
  }
}
