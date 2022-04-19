import 'dart:io';
import 'dart:math';

import 'package:delivery/notification_service/local_notification_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  String tag = "";
  print('Message:${message.data}');
  // if (Platform.isIOS) {
  //   tag = message.data['tag'] != null ? message.data['tag'].toString() : "";
  // } else {
  //   tag = message.data["data"]['tag'] != null
  //       ? message.data["data"]['tag'].toString()
  //       : "";
  // }
  // SharedPreference.saveStringPreference('tag', tag);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalNotificationService localNotificationService =
      LocalNotificationService();
  localNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(
      (message) => backgroundHandler(message));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      print('Initial Message:$value');
    });
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("onMessage: $message");
      String title = "";
      String description = "";
      String tag = "";
      if (Platform.isIOS) {
        title = message.data["notification"]['title'];
        description = message.data["notification"]['body'];
        tag = message.data['tag'];
        //need to show ios dialog stuff
      } else {
        // title = message.data["notification"]['title'];
        // description = message.data["notification"]['body'];
        // tag = message.data['data']['tag'];
        LocalNotificationService localNotificationService =
            LocalNotificationService();
        localNotificationService.showNotificationWithDefaultSound(
          message.notification!.title!,
          message.notification!.body!,
          '',
        );
      }
      debugPrint("title==>$title");
      debugPrint("description==>$description");
      debugPrint("tag==>$tag");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("onResume: ${message.notification!.title}");
      String tag = "";
      if (Platform.isIOS) {
        // tag = message.data['tag'];
      } else {
        // tag = message.data['data']['tag'];
      }
      // onSelectNotification(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
