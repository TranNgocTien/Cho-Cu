import 'dart:convert';
import 'dart:io';

import 'package:chotot/main.dart';
import 'package:chotot/screens/choScreen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:http/http.dart' as http;
import 'package:chotot/data/notification_count.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  // print('Title : ${message.notification?.title}');
  // print('Body : ${message.notification?.body}');
  // print('Payload : ${message.data}');
}

class RegisterNotiController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _firebaseMessaging = FirebaseMessaging.instance;

  String? fCMToken;
  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Important Notifications',
    description: 'channel',
    importance: Importance.defaultImportance,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState?.pushNamed(
      ChoScreen.route,
      arguments: message,
    );
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Important Notifications',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  Future<void> showNotification({
    required int id,
    String? title,
    String? body,
  }) async {
    count.value += 1;
    // print('* $count');
    final details = await _notificationDetails();
    await _localNotifications.show(id, title, body, details);
  }

  Future<void> showNotificationPayload({
    required int id,
    String? title,
    String? body,
    required payload,
  }) async {
    // count += 1;
    // print('*** $count');
    final details = await _notificationDetails();
    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(settings,
        onDidReceiveNotificationResponse: (payload) async {
      final message = RemoteMessage.fromMap(jsonDecode(payload.toString()));
      await showNotificationPayload(
          id: message.hashCode,
          title: message.notification?.title,
          body: message.notification?.body,
          payload: payload);
      handleMessage(message);
    });
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) async {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: 'ic_launcher',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
      await showNotification(
          id: message.notification.hashCode,
          title: message.notification!.title,
          body: message.notification!.body);
    });
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    fCMToken = await _firebaseMessaging.getToken();

    initPushNotifications();
    initLocalNotifications();
  }

  Future<void> registerNoti() async {
    // print(fcmToken);

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName = "";
    String deviceID = '';
    final SharedPreferences prefs = await _prefs;
    await initNotifications();
    // print('registerNoti');

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = androidInfo.model;
        deviceID = androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.name;
        deviceID = iosInfo.identifierForVendor!;
      }
    } on PlatformException {
      throw Exception('get device name failed');
    }
    try {
      var url = Uri.parse('https://vstserver.com/CcoXPmxvIjBsvauaWrFe');
      // print(prefs.getString('host_id'));
      // print('device_id: ${deviceID}');
      // print('fcmToken: ${fcmToken}');
      // print('deviceName: ${deviceName}');

      Map body = {
        'user_id': prefs.getString('host_id'),
        'home_id': prefs.getString('host_id'),
        'device_id': deviceID,
        'name': deviceName,
        'system_os': Platform.operatingSystem,
        'server_key': 'com.gico.service',
        'token': 'anhkhongdoiqua',
        'device_token': fCMToken!.trim(),
      };
      http.Response response = await http.post(
        url,
        body: body,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == 'ok') {
        } else if (json['status'] == "error") {
          throw jsonDecode(response.body)['error']['message'] ??
              'Unknown Error Occured1';
        }
      } else {
        throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured2';
      }
    } catch (error) {
      throw 'Unknown Error Occured';
    }
  }
}
