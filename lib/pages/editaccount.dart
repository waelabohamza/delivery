import 'package:flutter/material.dart';
import 'package:delivery/component/preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
 
import 'dart:io';
// My Import
import 'package:delivery/component/alert.dart';
import 'package:delivery/component/valid.dart';
import 'package:delivery/component/crud.dart';

class EditAccount extends StatefulWidget {
  final userid;
  final password;
  final username;
  final email;
  final phone;

  EditAccount(
      {Key key,
      this.userid,
      this.email,
      this.password,
      this.username,
      this.phone})
      : super(key: key);

  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  File file;
  File myfile;

  bool loading = false;

  void _chooseGallery() async {
    final myfile = await ImagePicker().getImage(source: ImageSource.gallery);
    // For Show Image Direct in Page Current witout Reload Page
    if (myfile != null)
      setState(() {
        file = File(myfile.path);
      });
    else {}
  }

  void _chooseCamera() async {
    final myfile = await ImagePicker().getImage(source: ImageSource.camera);
    // For Show Image Direct in Page Current witout Reload Page
    if (myfile != null)
      setState(() {
        file = File(myfile.path);
      });
    else {}
  }

  Crud crud = new Crud();

  var username, password, email, phone;

  GlobalKey<FormState> settings = new GlobalKey<FormState>();

  editAccount() async {
    var formstate = settings.currentState;
    if (formstate.validate()) {
      setState(() {
        loading = true;
      });
      formstate.save();
      if (file != null) {
        if (loading == true) {
          showLoading(context);
        }
        var usersnew = await crud.editUsers(
            username, email, password, phone, widget.userid, true, file);
        if (usersnew['status'] == "Success") {
             savePref(usersnew['username'], usersnew['email'], usersnew['phone'], usersnew['password']);
        }
      } else {
        if (loading == true) {
          showLoading(context);
        }
        var usersnew = await crud.editUsers(
            username, email, password, phone, widget.userid, false);
        if (usersnew['status'] == "Success") {
          savePref(usersnew['username'], usersnew['email'], usersnew['phone'], usersnew['password']);
        }
      }
      setState(() {
        loading = false;
      });

      Navigator.of(context).pushReplacementNamed("home");
    } else {
      print("Not Valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: ChangeNotifierProvider(
          create: (context) {
            return Common();
          },
          child: Scaffold(
              appBar: AppBar(
                title: Text('?????????? ?????????????? ????????????'),
              ),
              body: ListView(
                children: <Widget>[
                  Form(
                      key: settings,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            initialValue: widget.username,
                            onSaved: (val) {
                              username = val;
                            },
                            validator: (val) {
                              return validInput(
                                  val, 4, 20, "???????? ?????? ????????????????");
                            },
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "??????????",
                                prefixIcon: Icon(Icons.person)),
                          ),
                          TextFormField(
                            initialValue: widget.phone,
                            onSaved: (val) {
                              phone = val;
                            },
                            validator: (val) {
                              return validInput(val, 4, 20, "???????? ?????? ????????????");
                            },
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "??????????",
                                prefixIcon: Icon(Icons.phone)),
                          ),
                          Consumer<Common>(
                            builder: (context, common, child) {
                              return TextFormField(
                                obscureText: common.showpass,
                                initialValue: widget.password,
                                validator: (val) {
                                  return validInput(
                                      val, 4, 20, "???????? ???????? ????????????");
                                },
                                onSaved: (val) {
                                  password = val;
                                },
                                decoration: InputDecoration(
                                    
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: " ???????? ???????????? ",
                                    prefixIcon: Icon(Icons.vpn_key),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.remove_red_eye),
                                      onPressed: () {
                                        common.changeShowPass();
                                      },
                                    )),
                              );
                            },
                          ),
                          TextFormField(
                            initialValue: widget.email,
                            onSaved: (val) {
                              email = val;
                            },
                            validator: (val) {
                              return validInput(val, 4, 20,
                                  " ???????? ???????????? ???????????????????? ", "email");
                            },
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "???????????? ????????????????????",
                                prefixIcon: Icon(Icons.email)),
                          ),
                          RaisedButton(
                            color: file == null ? Colors.red : Colors.green,
                            child: Text(
                              "?????????? ????????",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              showbottommenu(context);
                            },
                          ),
                          RaisedButton(
                            color: Colors.blue,
                            child: Text(
                              "??????????",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              editAccount();
                            },
                          )
                        ],
                      ))
                ],
              )),
        ));
  }

  showbottommenu(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Directionality(textDirection: TextDirection.rtl, child: Container(
            padding: EdgeInsets.all(10),
            height: 190,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    "???????????? ?????????? ????????",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                ListTile(
                  onTap: () {
                    _chooseCamera();
                    Navigator.of(context).pop();
                  },
                  leading: Icon(
                    Icons.camera_alt,
                    size: 40,
                  ),
                  title: Text("   ???? ????????????????", style: TextStyle(fontSize: 20)),
                ),
                ListTile(
                  onTap: () {
                    _chooseGallery();
                    Navigator.of(context).pop();
                  },
                  leading: Icon(
                    Icons.image,
                    size: 40,
                  ),
                  title: Text("???? ????????????????",
                      style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          )) ; 
        });
  }
}

class Common with ChangeNotifier {
  bool showpass = false;
  changeShowPass() {
    showpass = !showpass;
    notifyListeners() ; 
  }
}
