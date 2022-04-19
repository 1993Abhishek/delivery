import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService{

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin= FlutterLocalNotificationsPlugin();
  Future onSelectNotification(String tag) async {
    debugPrint("------onSelectNotification-----$tag");
    // navigatorKey.currentState!.pushReplacement(MaterialPageRoute(builder: (context)=>EnRouteScreen()));
  }
  void initialize() {
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings(
      defaultPresentSound: true,
      defaultPresentBadge: true,
      defaultPresentAlert: true,
    );
    var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (value){
          onSelectNotification(value!);
        });

  }
  Future showNotificationWithDefaultSound(
      String title, String message, String payload) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      "oie_customer_local_notification",
      'oie_customer_notification',
      color: Color(0xFF673ab7),
      playSound: true,
      //style: AndroidNotificationStyle.BigText,
      importance: Importance.max,
      priority: Priority.high,
    );

    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    var random = new Random();
    var notificationID = random.nextInt(100);
    debugPrint("notificationID==>$notificationID");

    await _flutterLocalNotificationsPlugin.show(
      notificationID,
      title,
      message,
      platformChannelSpecifics,
      payload: payload,
    );
  }

}
