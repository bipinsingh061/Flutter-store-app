import 'package:flutter/material.dart';
import 'package:loginPage/SplashScreen.dart';
import 'package:loginPage/searchScreen.dart';

void main()
{
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "LoginPage",
      home: SearchScreen(),
    );
  }
}
