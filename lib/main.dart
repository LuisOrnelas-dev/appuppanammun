import 'package:flutter/material.dart';

import 'package:up_panammun/screens/home.dart';
import 'package:up_panammun/screens/signin.dart';
import 'package:up_panammun/screens/signup.dart';
import 'package:up_panammun/screens/webinfo.dart';
import 'package:up_panammun/screens/webdrive.dart';

import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(MaterialApp(home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            "assets/background.jpg",
            fit: BoxFit.fill,
          ),
        ),
        (_loginStatus==1)?Home():SignIn()
      ],),
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signin': (BuildContext context) => new SignIn(),
        '/signup': (BuildContext context) => new SignUp(),
        '/home': (BuildContext context) => new Home(),
        '/webinfo': (BuildContext context) => new WebInfo(),
        '/webdrive': (BuildContext context) => new WebDrive(url:"https://drive.google.com/file/d/1SzR5LVhSl7yDsvF8mGuV1Kc2WQAk34F_/view?usp=sharing"),
      },
    );
  }
  var _loginStatus=0;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _loginStatus = preferences.getInt("value")?? 0;
    });
  }
}

