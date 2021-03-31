import 'package:shared_preferences/shared_preferences.dart';

 
  savePref(String username, String email,   String phone,
    String password, [String balance]) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
 
  preferences.setString("username", username);
  preferences.setString("email", email);
  
  // preferences.setString("balance", balance);
  preferences.setString("phone", phone);
  preferences.setString("password", password);
}

getCurrentUserInformation(id, email, username, balance, password, phone) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  id = prefs.getString("id");
  email = prefs.getString("email");
  username = prefs.getString("username");
  balance = prefs.getString("balance");
  password = prefs.getString("password");
  phone = prefs.getString("phone");
}

 