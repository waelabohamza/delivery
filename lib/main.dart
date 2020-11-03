import 'package:delivery/pages/homescreen.dart';
import 'package:delivery/pages/login.dart';
import 'package:delivery/pages/resetpassword/resetpassword.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery',
      debugShowCheckedModeBanner: false ,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo',
            textTheme: TextTheme(
            bodyText1: TextStyle(fontSize: 20),
            bodyText2: TextStyle(fontSize: 15),
            headline3: TextStyle(fontSize: 25 , color: Colors.red)
          ) 
        )
      ,
      home:Login(),
      routes: {
        "home" : (context) => HomeScreen(), 
        "login" : (context) => Login(), 
        "resetpassword" : (context) => ResetPassword()
      },
    );
  }
}
 