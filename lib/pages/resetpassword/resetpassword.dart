import 'package:delivery/pages/resetpassword/verfiycode.dart';
import 'package:flutter/material.dart';
 import 'package:delivery/component/alert.dart';
import 'package:delivery/component/crud.dart';
import 'package:delivery/component/valid.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  var _email;
  Crud crud = new Crud();
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  resetPassword() async {
    var formdata = formstate.currentState;
    if (formdata.validate()) {
      formdata.save();
      var data = {"email": _email};
      showLoading(context);
      var responsybody = await crud.writeData("resetpassword", data);
      if (responsybody['status'] == "success") {
        //  var email = responsybody["users"]['email'] ;
        //  print(email) ;
        Navigator.of(context).pop();
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return VerfiyCode(email: _email);
        }));
      } else {
        Navigator.of(context).pop();
        showdialogall(context, "تنبيه", "البريد الالكتروني غير موجود");
      }
    } else {
      print("not vaild");
    }
  }

  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Container(
            child: ListView(
              children: [
                Stack(
                  children: [
                    buildTopRaduis(mdw),
                    buildTopText(mdw),
                    Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: mdw - 50 / 100 * mdw),
                            child: Center(
                                child: Text(
                              "ارسال رمز التحقق ",
                              style: Theme.of(context).textTheme.headline5,
                            ))),
                        SizedBox(height: 20),
                        Form(
                            key: formstate,
                            child: Column(
                              children: [
                                TextFormField(
                                  autovalidate: true,
                                  onSaved: (val) {
                                    _email = val;
                                  },
                                  validator: (val) {
                                    return validInput(val, 4, 30,
                                        "ان يكون البريد الالكتروني", "email");
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: "ادخل البريد الالكتروني هنا",
                                  ),
                                ),
                                SizedBox(height: 20),
                                RaisedButton(
                                  color: Colors.red,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 5),
                                  child: Text(
                                    "ارسال",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: resetPassword,
                                )
                              ],
                            ))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Transform buildTopRaduis(mdw) {
    return Transform.scale(
        scale: 2,
        child: Transform.translate(
          offset: Offset(0, -200),
          child: Container(
            height: mdw,
            width: mdw,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(mdw)),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ));
  }

  Padding buildTopText(mdw) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    return Navigator.of(context).pop();
                  }),
              Text("TalabPay",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              Expanded(child: Container()),
            ],
          ),
          Container(
            padding: EdgeInsets.only(right: 20),
            child: Text("اعادة تعيين كلمة المرور",
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
