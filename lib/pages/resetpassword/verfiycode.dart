import 'package:delivery/pages/resetpassword/newpassword.dart';
import 'package:flutter/material.dart';
import 'package:delivery/component/alert.dart';
import 'package:delivery/component/crud.dart';
import 'package:delivery/component/valid.dart';
 

class VerfiyCode extends StatefulWidget {
  final email;
  VerfiyCode({Key key, this.email}) : super(key: key);

  @override
  _VerfiyCodeState createState() => _VerfiyCodeState();
}

class _VerfiyCodeState extends State<VerfiyCode> {
  var _code;
  Crud crud = new Crud();
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  verfiyCode() async {
    var formdata = formstate.currentState;
    if (formdata.validate()) {
      formdata.save();
      var data = {"code": _code, "email": widget.email};
      showLoading(context);
      var responsybody = await crud.writeData("verfiycode", data);
      if (responsybody['status'] == "success") {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return NewPassword(email: widget.email);
        }));
      } else {
        Navigator.of(context).pop();
        showdialogall(context, "تنبيه", "رمز التحقق خاطىء");
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
                              "ادخل رمز التحقق الذي وصلك على بريدك ",
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
                                    _code = val;
                                  },
                                  validator: (val) {
                                    return validInput(val, 4, 6,
                                        " يكون رمز التحقق", "number");
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: "رمز التحقق مكون من 5 ارقام",
                                  ),
                                ),
                                SizedBox(height: 20),
                                RaisedButton(
                                  color: Colors.red,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 5),
                                  child: Text(
                                    "تم",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: verfiyCode,
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
