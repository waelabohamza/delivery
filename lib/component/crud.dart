import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';

String basicAuth = 'Basic ' +
    base64Encode(utf8.encode(
        'TalabGoUser@58421710942258459:TalabGoPassword@58421710942258459'));
Map<String, String> myheaders = {
  // 'content-type': 'application/json',
  // 'accept': 'application/json',
  'authorization': basicAuth
};

class Crud {
  
  var server_name = "talabpay.com/api";
  // var server_name = "almotorkw.com/talabgo/food";

  // var server_name = "192.168.1.5:8080/food";
  // var server_name = "10.0.2.2:8080/food";

  readData(String type) async {
    var url;
    try {
      var response = await http.get(Uri.parse(url), headers: myheaders);
      if (response.statusCode == 200) {
        print(response.body);
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("page not found");
      }
    } catch (e) {
      print("caught Error : ");
      print(e);
    }
  }

  Future readDataWhere(String url, String value) async {
    var data;
    if (url == "ordersdetails") {
      url = "http://${server_name}/delivery/orders_delivery_details.php";
      data = {"ordersid": value};
    }
    if (url == "messages") {
      url = "http://$server_name/message/messagedelivery.php";
      data = {"deliveryid": value};
    }
    try {
      var response = await http.post(Uri.parse(url), body: data, headers: myheaders);
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("File Not Found ");
      }
    } catch (e) {
      print("caught Error : ");
      print(e);
    }
  }

  writeData(String type, var data) async {
    var url;
    if (type == "login") {
      url = "http://${server_name}/auth/login.php";
    }
    if (type == "resetpassword") {
      url = "http://${server_name}/resetpassword.php";
    }
    if (type == "verfiycode") {
      url = "http://${server_name}/verfiycode.php";
    }
    if (type == "newpassword") {
      url = "http://${server_name}/newpassword.php";
    }
    if (type == "approvedelivery") {
      url = "http://${server_name}/delivery/orders_delivery_approve.php";
    }
    if (type == "donedelivery") {
      url = "http://${server_name}/delivery/donedelivery.php";
    }
    if (type == "ordersdelivery") {
      url = "http://${server_name}/delivery/orders_delivery.php";
    }
    try {
      var response = await http.post(Uri.parse(url), body: data, headers: myheaders);
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("page Not found");
      }
    } catch (e) {
      print("caught Error : ");
      print(e);
    }
  }

  Future editUsers(username, email, password, phone, id, bool issfile,
      [File imagefile]) async {
    var uri = Uri.parse("http://${server_name}/users/editusers.php");

    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(myheaders);
    if (issfile == true) {
      var stream = new http.ByteStream(imagefile.openRead());
      stream.cast();
      var length = await imagefile.length();
      var multipartFile = new http.MultipartFile("file", stream, length,
          filename: basename(imagefile.path));
      request.files.add(multipartFile);
    }
    request.fields["username"] = username;
    request.fields["email"] = email;
    request.fields["password"] = password;
    request.fields["userid"] = id;
    request.fields["phone"] = phone;
    var myrequest = await request.send();
    var response = await http.Response.fromStream(myrequest);
    if (myrequest.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }
  }
}
