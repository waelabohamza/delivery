import 'package:delivery/component/alert.dart';
import 'package:delivery/component/crud.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
// import 'dart:async';
import 'dart:math';

import 'package:url_launcher/url_launcher.dart';

import 'package:delivery/component/distancebetween.dart';

class Delivery extends StatefulWidget {
  final user;
  final res;
  final lat;
  final long;
  final orderid;
  final statusorders;
  Delivery(
      {Key key,
      this.lat,
      this.long,
      this.orderid,
      this.statusorders,
      this.res,
      this.user})
      : super(key: key);

  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  LocationData cl;

  List<Marker> markers = [];
  GoogleMapController _controller;

  // current Location
  Location location = new Location();
  Crud crud = new Crud();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  // Map<PolylineId, Polyline> polylines = {};
  // List<LatLng> polylineCoordinates = [];
  // PolylinePoints polylinePoints = PolylinePoints();

  BitmapDescriptor pinLocationIcon;

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/driving_pin.png');
  }

  getCurrentLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    // print("=================================") ;
    // print(_locationData.latitude) ;
    // print(_locationData.longitude) ;
    // print("=================================") ;

    markers.add(
      Marker(
          markerId: MarkerId("1"),
          infoWindow: InfoWindow(title: "موقعي الحالي"),
          position: LatLng(_locationData.latitude, _locationData.longitude),
          draggable: true,
          icon: pinLocationIcon,
          onDragEnd: (ondragend) {
            print(ondragend);
          }),
    );
    if (this.mounted) {
      // check whether the state object is in tree
      setState(() {
        // make changes here
      });
    }
//  _getPolyline() ;
  }

  // , "tokenuser" : widget.userid , "tokenres" : widget.resid
  doneDelivery() async {
    var data = {
      "orderid": widget.orderid,
      "userid": widget.user,
      "resid": widget.res
    };
    showLoading(context);
    var responsebody = await crud.writeData("donedelivery", data);
    if (responsebody['status'] == "success") {
      Navigator.of(context).pushNamed("home");
    }
  }

  @override
  void initState() {
    setCustomMapPin();
    getCurrentLocation();
    super.initState();
    markers.add(
      Marker(
          markerId: MarkerId(Random().nextInt(1000).toString()),
          infoWindow: InfoWindow(title: "موقع الزبون"),
          position: LatLng(widget.lat, widget.long),
          draggable: true,
          onDragEnd: (ondragend) {
            print(ondragend);
          }),
    );
    print(markers);
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        cl = currentLocation;
      });
      updatePinMap(currentLocation);
      if (this.mounted) {
        // check whether the state object is in tree
        setState(() {
          // make changes here
        });
      }
      // Use current location
    });

    print("=================================");
    print(widget.statusorders);
    print("=================================");
  }

  updatePinMap(cl) {
    markers.removeWhere((element) => element.markerId.value == "1");
    markers.add(
      Marker(
          markerId: MarkerId("1"),
          infoWindow: InfoWindow(title: "موقعي الحالي"),
          position: LatLng(cl.latitude, cl.longitude),
          draggable: true,
          icon: pinLocationIcon,
          onDragEnd: (ondragend) {
            print(ondragend);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    double mdh = MediaQuery.of(context).size.height;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('توصيل الطلبية'),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30))),
            padding: EdgeInsets.all(20),
            height: 80,
            child: MaterialButton(
              child: Text("تم التوصيل",
                  style: TextStyle(color: Colors.blue, fontSize: 20)),
              onPressed: () async {
                var distance = await destanceBetweenDriving(
                    cl.latitude, cl.longitude, widget.lat, widget.long);
                print(distance);
                if (distance > 50) {
                  showdialogall(context, "تنبيه", "لم تصل الى المكان المحدد");
                } else {
                  await doneDelivery();
                }
              },
              color: Colors.white,
            ),
          ),
          body: WillPopScope(
              child: cl == null
                  ? Center(child: CircularProgressIndicator())
                  : Stack(
                      children: [
                        Container(
                            height: mdh,
                            child: GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(widget.lat, widget.long),
                                  zoom: 10),
                              markers: markers.toSet(),
                              onTap: (latlng) {},
                              onMapCreated: onMapCreated,
                              // polylines: Set<Polyline>.of(polylines.values) ,
                              myLocationEnabled: true,
                              tiltGesturesEnabled: true,
                              compassEnabled: true,
                              scrollGesturesEnabled: true,
                              zoomGesturesEnabled: true,
                            )),
                        Positioned(
                            top: 50,
                            child: Container(
                              child: RaisedButton(
                                color: Colors.blue,
                                textColor: Colors.white,
                                onPressed: () async {
                                  await launch(
                                      "https://www.google.com/maps/dir/${cl.latitude},${cl.longitude}/${widget.lat},${widget.long}/@29.3643755,47.9921928,14z/data=!3m1!4b1");
                                },
                                child: Text("Google Map"),
                              ),
                            )),
                      ],
                    ),
              onWillPop: () {
                Navigator.of(context).pushNamed("home");
                return null;
              }),
        ));
  }

  onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }
}
