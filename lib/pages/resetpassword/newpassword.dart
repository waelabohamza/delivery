import 'package:delivery/component/alert.dart';
import 'package:delivery/component/crud.dart';
import 'package:delivery/component/valid.dart';
import 'package:flutter/material.dart';
 

class NewPassword extends StatefulWidget {
  final email ; 
  NewPassword({Key key , this.email}) : super(key: key);

  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  var _password;
  Crud crud = new Crud();
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  newPassword() async {
    var formdata = formstate.currentState;
    if (formdata.validate()) {
      formdata.save();
      var data = {"password": _password , "email" : widget.email};
        showLoading(context);
      var responsybody = await crud.writeData("newpassword", data);
      if (responsybody['status'] == "success") {
        Navigator.of(context).pop() ; 
        return Navigator.of(context).pushReplacementNamed("login");
      }else {
        Navigator.of(context).pop() ; 
        showdialogall(context, "تنبيه", "لا يوجد اي تحديث") ; 
        Future.delayed(Duration(seconds: 2) , (){
                 Navigator.of(context).pushReplacementNamed("login") ; 
        }) ; 
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
                                  // obscureText: true,
                                  autovalidate: true,
                                  onSaved: (val) {
                                    _password = val;
                                  },
                                  validator: (val) {
                                    return validInput(
                                        val, 4, 40, "ان تكون كلمة المرور");
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: "ادخل كلمة المرور هنا",
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
                                  onPressed: newPassword,
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
            child: Text("كلمة المرور الجديدة",
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
