    
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

 final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    void redirectPage(Map<String, dynamic> message , BuildContext context )
        async{
        
          String title        = message["notification"]["title"].toString();
          String body         = message["notification"]["title"].toString();
          String page_name    = message["data"]["page_name"].toString();
          String page_id      = message["data"]["page_id"].toString();

          
        }

    getNotify(BuildContext context) {

       firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message ) async {
        print("Hay  Delivery App: $message");
        redirectPage(message , context) ; 
        
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
       
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
       
      },
    );
    }
  requestPermissons() async {
        firebaseMessaging.requestNotificationPermissions(
              const IosNotificationSettings(
                  sound: true, badge: true, alert: true, provisional: true));
          firebaseMessaging.onIosSettingsRegistered
              .listen((IosNotificationSettings settings) {
            print("Settings registered: $settings");
          });

    }


// Start Local Notifcation 

  