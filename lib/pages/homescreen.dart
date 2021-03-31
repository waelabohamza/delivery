import 'package:delivery/component/getnotify.dart';
import 'package:delivery/pages/editaccount.dart';
import 'package:delivery/pages/stagedelivery/home.dart';
import 'package:delivery/pages/stagedelivery/ordersdelivery.dart';
import 'package:delivery/pages/stagedelivery/ordersdonedelivery.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final initialpage  ; 
  HomeScreen({Key key  ,this.initialpage}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _email, _password, _username, _userid, _phone;

  getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userid = prefs.getString("id");
    _username = prefs.getString("username");
    _email = prefs.getString("email");
    _phone = prefs.getString("phone");
    _password = prefs.getString("password");
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {

    getNotify(context);
    requestPermissons();
    getLocalNotification()  ; 
    requestLocalPermissions() ;
    getprefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: DefaultTabController(
          initialIndex: widget.initialpage == "home" ? 0 : widget.initialpage == "wait" ? 1 : widget.initialpage == "done" ? 2  : 0 ,
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: Text('TalabGo'),
                actions: [
                  IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () async {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return EditAccount(
                            email: _email,
                            userid: _userid,
                            password: _password,
                            phone: _phone,
                            username: _username,
                          );

                        }));
                      }) ,
                      IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: ()  {
                        Navigator.of(context).pushNamed("messsage") ; 
                      })
                ],
                leading: IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.remove("id");
                      preferences.remove("username");
                      preferences.remove("email");
                      preferences.remove("balance");
                      preferences.remove("phone");
                      preferences.remove("password");
                      preferences.remove("res");
                      Navigator.of(context).pushNamed("login");
                    }),
                bottom: TabBar(
                  tabs: [
                    Text("بانتظار الموافقة"),
                    Text("قيد التوصيل "),
                    Text("تم التوصيل")
                  ],
                ),
              ),
              body: TabBarView(
                  children: [Home(), OrdersDelivery(), OrdersDoneDelivery()]),
            )));
  }
}
