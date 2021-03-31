import 'dart:async';
import 'dart:io';
import 'package:delivery/component/alert.dart';
import 'package:delivery/component/getnotify.dart';
import 'package:delivery/pages/delivery.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:delivery/component/crud.dart';
import 'package:shared_preferences/shared_preferences.dart';
// My Import

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var resid;
  var userid;
  Map data;
  Crud crud = new Crud();
  setLocal() async {
    await Jiffy.locale("ar");
  }

  getidres() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    resid = prefs.getString("res");
    userid = prefs.getString("id");
    data = {"resid": resid, "userid": userid, "status": 1.toString()};
    if (this.mounted) {
      // check whether the state object is in tree
      setState(() {
        // make changes here
      });
    }
  }

// Timer _timer;
  @override
  void initState() {

    setLocal();
    getidres();

    // _timer = new Timer.periodic(Duration(seconds: 30), (Timer t) =>     (this.mounted) ? setState(() {}) : ""  );
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
            child: resid == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : FutureBuilder(
                    future: crud.writeData("ordersdelivery", data),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data[0] == "faild") {
                          return Center(
                              child: Text(
                            "لا يوجد اي طلبات بانتظار الموافقة",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ));
                        }
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListOrders(
                              orders: snapshot.data[index],
                              userid: userid,
                              crud: crud,
                              context: context,
                            );
                          },
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
            onWillPop: _onWillPop));
  }
}

class ListOrders extends StatelessWidget {
  final orders;
  final userid;
  final crud;
  final context;
  ListOrders({Key key, this.orders, this.userid, this.crud, this.context})
      : super(key: key);
  approveDelivery() async {
    Map data2 = {
      "deliveyid": userid,
      "ordersid": orders['orders_id'],
      "userid": orders['orders_users'],
      "resid": orders['orders_res']
    };
    showLoading(context);
    var responsebody = await crud.writeData("approvedelivery", data2);
    if (responsebody['status'] == "success") {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return Delivery(
            res:orders['orders_res'] ,
            user: orders['orders_users'] ,
            orderid: orders['orders_id'],
            lat: double.parse(orders['orders_lat']),
            long: double.parse(orders['orders_long']));
      }));
    } else {
      Navigator.of(context).pop();
      showdialogall(
          context, "هام", "تم الموافقة على هذه الطلبية من قبل عامل توصيل اخر");
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pushNamed("home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: InkWell(
      onTap: () {},
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Container(
                margin: EdgeInsets.only(top: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "معرف الطلبية : ${orders['orders_id']}",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                            children: <TextSpan>[
                          TextSpan(
                              text: "اسم الزبون : ",
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(
                              text: "${orders['username']}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))
                        ])),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                            children: <TextSpan>[
                          TextSpan(
                              text: "هاتف الزبون  : ",
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(
                              text: "${orders['user_phone']}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))
                        ])),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                            children: <TextSpan>[
                          TextSpan(
                              text: " السعر الكلي   : ",
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(
                              text: "${orders['orders_total']} د.ك",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600))
                        ])),
                  ],
                ),
              ),
              trailing: Container(
                  margin: EdgeInsets.only(top: 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "${Jiffy(orders['orders_date']).fromNow()}",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )),
            ),
            // Container(
            //   color: Colors.red,
            //   padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
            //   child: Row(
            //     children: [
            //       Text(
            //         "الوجبة",
            //         style: TextStyle(
            //             color: Colors.white, fontWeight: FontWeight.w600),
            //       ),
            //       Expanded(child: Container()),
            //       Text("الكميه",
            //           style: TextStyle(
            //               color: Colors.white, fontWeight: FontWeight.w600)),
            //     ],
            //   ),
            // ),
            // FutureBuilder(
            //   future:
            //       Crud().readDataWhere("ordersdetails", orders['orders_id']),
            //   builder: (BuildContext context, AsyncSnapshot snapshot) {
            //     if (snapshot.hasData) {
            //       return ListView.builder(
            //           shrinkWrap: true,
            //           itemCount: snapshot.data.length,
            //           physics: NeverScrollableScrollPhysics(),
            //           itemBuilder: (context, i) {
            //             return Container(
            //               padding:
            //                   EdgeInsets.symmetric(vertical: 4, horizontal: 20),
            //               child: Column(
            //                 children: [
            //                   Row(
            //                     children: [
            //                       Text(snapshot.data[i]['item_name']),
            //                       Expanded(child: Container()),
            //                       Text(snapshot.data[i]['details_quantity']),
            //                     ],
            //                   )
            //                 ],
            //               ),
            //             );
            //           });
            //     }
            //     return Center(child: CircularProgressIndicator());
            //   },
            // ),
            Container(
              padding:
                  EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 10),
              child: Row(
                children: [
                  Text(
                    "بانتظار الموافقة",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  InkWell(
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.3),
                            borderRadius: BorderRadius.circular(50)),
                        child: Text(
                          "موافق",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.grey),
                        )),
                    onTap: approveDelivery,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
