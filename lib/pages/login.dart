import 'package:delivery/component/crud.dart';
import 'package:delivery/component/valid.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:delivery/component/alert.dart';
import 'package:delivery/component/getnotify.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String mytoken;


  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () => exit(0),
                //  onPressed: () =>   Navigator.of(context).pop(true)  ,
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Crud crud = new Crud();

  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  // Start Form Controller

  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController password = new TextEditingController();

  GlobalKey<FormState> formstatesignin = new GlobalKey<FormState>();
  GlobalKey<FormState> formstatesignup = new GlobalKey<FormState>();

  savePref(String username, String email, String id, String balance,
      String phone, String password, String res) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("id", id);
    preferences.setString("username", username);
    preferences.setString("email", email);
    preferences.setString("balance", balance);
    preferences.setString("phone", phone);
    preferences.setString("password", password);
    preferences.setString("res", res);
  }

  signin() async {
    var formdata = formstatesignin.currentState;
    if (formdata.validate()) {
      formdata.save();
      showLoading(context);
      var data ; 
      if (mytoken == null) {
              data = {
                "email": email.text,
                "password": password.text,
                "role": "3",
              };
      }else{
            data = {
            "email": email.text,
            "password": password.text,
            "role": "3",
            "token": mytoken 
          };
      }
 
      var responsebody = await crud.writeData("login", data);
      if (responsebody['status'] == "success") {
        savePref(
            responsebody['username'],
            responsebody['email'],
            responsebody['id'],
            responsebody['balance'],
            responsebody['phone'],
            responsebody['password'],
            responsebody['res']);
        Navigator.of(context).pushReplacementNamed("home");
      } else {
        print("login faild");
        Navigator.pop(context);
        showdialogall(context, "خطأ", "البريد الالكتروني او كلمة المرور خاطئة");
      }
    } else {
      print("not valid");
    }
  }

  bool showsignin = true;
     getmytoken() async {
         mytoken =  await  getTokenDevice() ; 
         if (mytoken != null) return  ; 
         mytoken =  await  getTokenDevice() ; 
    } 

  @override
  void initState() {
    // checkSignIn();
    getmytoken()  ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mdw = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: WillPopScope(
            child: Stack(
              children: <Widget>[
                Container(height: double.infinity, width: double.infinity),
                buildPositionedtop(mdw),
                buildPositionedBottom(mdw),
                Container(
                    height: 1000,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Center(
                              child: Container(
                                  margin: EdgeInsets.only(top: 30),
                                  child: Text(
                                    showsignin ? "تسجيل الدخول " : "انشاء حساب",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: showsignin ? 22 : 25),
                                  ))),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                          ),
                          buildContaineraAvatar(mdw),
                          buildFormBoxSignIn(mdw),
                          Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Column(
                                children: <Widget>[
                                  InkWell(
                                      onTap: () {
                                        return Navigator.of(context)
                                            .pushNamed("resetpassword");
                                      },
                                      child: Text(
                                        "  ? هل نسيت كلمة المرور",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18),
                                      )),
                                  SizedBox(height: showsignin ? 12 : 0),
                                  SizedBox(height: 0),
                                  RaisedButton(
                                    color: Colors.blue,
                                    elevation: 10,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 40),
                                    onPressed: signin,
                                    // onPressed: () => Navigator.of(context).pushNamed("home"),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          "تسجيل الدخول",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(top: 4),
                                            padding: EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                            ))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ))
              ],
            ),
            onWillPop: _onWillPop),
      ),
    );
  }

  Center buildFormBoxSignIn(double mdw) {
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        margin: EdgeInsets.only(top: 40),
        height: 250,
        width: mdw / 1.2,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black,
              spreadRadius: .1,
              blurRadius: 1,
              offset: Offset(1, 1))
        ]),
        child: Form(
            autovalidate: true,
            key: formstatesignin,
            child: Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Start Text Username
                    Text(
                      "البريد الالكتروني",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormFieldAll(
                        "ادخل البريد الالكتروني", false, email, "email"),
                    // End Text username
                    SizedBox(
                      height: 10,
                    ),
                    // Start Text password
                    Text("كلمة المرور",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFormFieldAll(
                        "ادخل كلمة المرور", true, password, "password"),
                    // End Text username
                  ],
                ),
              ),
            )),
      ),
    );
  }

  TextFormField buildTextFormFieldAll(String myhinttext, bool pass,
      TextEditingController myController, String type) {
    return TextFormField(
      controller: myController,
      obscureText: pass,
      validator: (val) {
        if (type == "email") {
          return validInput(val, 4, 40, "يكون البريد الالكتروني", "email");
        }
        if (type == "username") {
          return validInput(val, 4, 30, "يكون اسم المستخدم");
        }
        if (type == "password") {
          return validInput(val, 4, 30, "يكون كلمة المرور");
        }
        if (type == "phone") {
          return validInput(val, 4, 30, "يكون رقم الهاتف", "phone");
        }
        return null;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(4),
          hintText: myhinttext,
          filled: true,
          fillColor: Colors.grey[200],
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey[500], style: BorderStyle.solid, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.blue, style: BorderStyle.solid, width: 1))),
    );
  }

  AnimatedContainer buildContaineraAvatar(double mdw) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          color: showsignin ? Colors.yellow : Colors.grey[700],
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(color: Colors.black, blurRadius: 3, spreadRadius: 0.1)
          ]),
      child: InkWell(
        onTap: () {},
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 25,
                right: 25,
                child:
                    Icon(Icons.person_outline, size: 50, color: Colors.white)),
            Positioned(
                top: 35,
                left: 60,
                child: Icon(Icons.arrow_back, size: 30, color: Colors.white))
          ],
        ),
      ),
    );
  }

  Positioned buildPositionedtop(double mdw) {
    return Positioned(
        child: Transform.scale(
      scale: 1.3,
      child: Transform.translate(
        offset: Offset(0, -mdw / 1.7),
        child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: mdw,
            width: mdw,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(mdw),
                color: Colors.grey[800])),
      ),
    ));
  }

  Positioned buildPositionedBottom(double mdw) {
    return Positioned(
        top: 300,
        right: mdw / 1.5,
        child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: mdw,
            width: mdw,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(mdw),
                color: Colors.blue[800].withOpacity(0.2))));
  }
}
