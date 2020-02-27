import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../screens/edit_product_screen.dart';
import '../screens/buy_services.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final BuildContext context;
  PushNotificationService(this.context);

  Future<void> initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      // Called when the app is in the foreground and we receive a push notification
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //Dialog or Snackbar
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      // ... has been closed completly and it's opened from the push notification directly
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _serialiseAndNavigate(message);
      },
      // ... is in the background and its opened from the push notification
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _serialiseAndNavigate(message);
      },
      onBackgroundMessage: Platform.isIOS ? null : _myBackgroundMessageHandler,
    );
  }

  void _serialiseAndNavigate(Map<String, dynamic> message) {
    var notificationData = message['data'];
    var view = notificationData['view'];

    if (view != null) {
      if (view == 'buy_service') {
        Navigator.of(context).pushNamed(BuyServices.routeName);
      }
      if (view == 'create_product') {
        Navigator.of(context).pushNamed(EditProductScreen.routeName);
      }
      // If there's no view it'll just open the app on the first view
    }
  }

  // static Future<dynamic> _myBackgroundMessageHandler(
  //     Map<String, dynamic> message) {
  //   if (message.containsKey('data')) {
  //     // Handle data message
  //     final dynamic data = message['data'];
  //   }

  //   if (message.containsKey('notification')) {
  //     // Handle notification message
  //     final dynamic notification = message['notification'];
  //   }

  //   // Or do other work.
  // }
  static Future<dynamic> _myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    print('AppPushs myBackgroundMessageHandler : $message');
    return Future<void>.value();
  }
}
