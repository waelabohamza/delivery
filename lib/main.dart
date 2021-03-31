import 'dart:io';
import 'package:delivery/pages/homescreen.dart';
import 'package:delivery/pages/login.dart';
import 'package:delivery/pages/message.dart';
import 'package:delivery/pages/resetpassword/resetpassword.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
        ..maxConnectionsPerHost = 5;
  }
}
SharedPreferences sharedPrefs;
String userid;
void main() async { 
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp() ;
  sharedPrefs = await SharedPreferences.getInstance();
  userid = sharedPrefs.getString("id");

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
        ),

      home: userid == null ? Login() : HomeScreen(),

      routes: {
        "home"            : (context) => HomeScreen(), 
        "login"           : (context) => Login(), 
        "resetpassword"   : (context) => ResetPassword() , 
        "messsage"        : (context) => Message()
      },
    );
  }
}
 