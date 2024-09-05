import 'dart:convert';
import 'dart:io';

import 'package:chotot/controllers/get_a_job.dart';
import 'package:chotot/controllers/get_a_stuff.dart';
import 'package:chotot/controllers/get_ly_lich.dart';
import 'package:chotot/controllers/get_notis.dart';
import 'package:chotot/controllers/get_stuffs.dart';
import 'package:chotot/screens/thong_tin_job_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:chotot/data/data_listener.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chotot/screens/thongTinSanPham.dart';
import 'package:chotot/data/a_stuff_data.dart';

class RegisterNotification {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  NotiController notiController = Get.put(NotiController());
  GetStuffs getStuffs = Get.put(GetStuffs());
  GetAStuff getAStuff = Get.put(GetAStuff());
  GetAJob getAJob = Get.put(GetAJob());
  LyLichController lyLichController = Get.put(LyLichController());
  //YÊU CẦU CẤP QUYÊN NOTIFICATION

  Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    //Lấy device FCM token
    final token = await _firebaseMessaging.getToken();
  }

  // initalize local notifications
  Future localNotiInit() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    // final LinuxInitializationSettings initializationSettingsLinux =
    //     LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
    );
  }

  //on tap local notification in foreground

  void onNotificationTap(NotificationResponse notificationResponse) async {
    Map payload = {};

    payload = jsonDecode(notificationResponse.payload!);

    await notiController.getNoti(0);

    var actionType = payload['action_type'];

    switch (actionType) {
      case 'post_stuff':
        var stuffId = payload['action'];
        await getAStuff.getAStuff(stuffId);

        await getStuffs.getStuffs(0);
        marketListen.value++;
        Get.to(() => ThongTinSanPhamScreen(docu: aStuff[0]));
        break;
      case 'post_job':
      case 'book_job':
      case 'worker_accept_job':
      case 'worker_cancel_job':
      case 'worker_done':
      case 'finish_job':
      case 'apply_job':
      case 'accept_worker':
      case 'cancel_worker':
      case 'job_time_expired':
      case 'job_time_next':
        jobListen.value = 1.0;
        var jobId = payload['action'];
        await getAJob.getAJob(jobId);
        // await getPostJobs.getPostJobs(0);

        final dateTime = DateTime.fromMillisecondsSinceEpoch(
            int.parse(getAJob.jobInfo[0].workDate),
            isUtc: true);
        var date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
        var time = '${dateTime.hour}:${dateTime.minute}';
        Get.to(
          () => ThongTinJobScreen(
            jobInfo: getAJob.jobInfo,
            date: date,
            time: time,
          ),
        );
        break;
      case 'host_fee':
      case 'worker_fee':
      case 'charge_money':
        await lyLichController.getInfo();
      case 'worker_active':
      case 'cancel_register_worker':
      case 'worker_update':
      case 'host_bonus':
        // await lyLichController.getInfo();
        notiListen.value++;
        break;
      default:
        break;
    }
  }

  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
            interruptionLevel: InterruptionLevel.timeSensitive);
    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }

  Future<void> registerNoti() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName = "";
    String deviceID = '';
    final SharedPreferences prefs = await _prefs;
    final fCMToken = await _firebaseMessaging.getToken();

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
    // try {
    var url = Uri.parse('https://vstserver.com/CcoXPmxvIjBsvauaWrFe');

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
    // } catch (error) {
    //   throw 'Unknown Error Occured';
    // }
  }
}
