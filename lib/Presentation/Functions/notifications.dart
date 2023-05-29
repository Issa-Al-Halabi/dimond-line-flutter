import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationHelper {

  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('app_icon');
    // var iOSInitialize = const IOSInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }


  static Future<void> showTextNotification(String title, String body, String orderID, FlutterLocalNotificationsPlugin fln) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '6valley_delivery', '6valley_delivery name', playSound: true,
      importance: Importance.max, priority: Priority.max, sound: RawResourceAndroidNotificationSound('notification'),
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
  }

  static Future<void> showBigTextNotification(String title, String body, String orderID, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body, htmlFormatBigText: true,
      contentTitle: title, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '6valley_delivery channel id', '6valley_delivery name', importance: Importance.max,
      styleInformation: bigTextStyleInformation, priority: Priority.max, playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
  }
}

Future<void> generateSimpleNotication(
    String title, String msg, String type, String id) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      // sound: RawResourceAndroidNotificationSound(sound
      //     .split('.')
      //     .first),
      sound: RawResourceAndroidNotificationSound('notification'),
      playSound: true,
      styleInformation: BigTextStyleInformation(msg),
      ticker: 'ticker');
  print("layaaaaaaaaaaaaaaaaan");
  // var iosDetail = IOSNotificationDetails(
  //     sound: sound
  // );
}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  debugPrint("onBackground:diamond line ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey}");
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  var initializationSettingsAndroid =
  new AndroidInitializationSettings('@mipmap/ic_launcher');
  // new AndroidInitializationSettings('app_icon');
  // var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(
    android: initializationSettingsAndroid,
    // initializationSettingsIOS
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  var androidPlatformChannelSpecifics = new
  AndroidNotificationDetails(
      // 'com.example.diamondline', 'Updates',
      'com.abydos.diamondline', 'Updates',
      channelDescription: 'Receive updates about new features and bug fixes',
      playSound: true,
      importance: Importance.max, priority: Priority.high);
  var platformChannelSpecifics = new NotificationDetails(
    android: androidPlatformChannelSpecifics,
    // iOSPlatformChannelSpecifics
  );
  await flutterLocalNotificationsPlugin.show(
      0, message.notification?.title.toString(), message.notification?.body.toString(),
      platformChannelSpecifics,
      payload: 'item x');
}

Future<void> myForgroundMessageHandler(RemoteMessage message) async {
  // setPrefrenceBool(ISFROMBACK, true);
  // print(message.notification.toString());
  print("foreground");
  var type = message.data['type'] ?? '';
  var id = '';
  var data = message.notification!;
  var title = data.title.toString();
  var body = data.body.toString();
  generateSimpleNotication(title, body, type, id);
  return Future<void>.value();
}