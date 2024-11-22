import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/controllers/get_a_job.dart';
import 'package:chotot/controllers/get_a_stuff.dart';
import 'package:chotot/controllers/get_ly_lich.dart';
import 'package:chotot/controllers/get_notis.dart';
import 'package:chotot/controllers/get_post_jobs.dart';
import 'package:chotot/controllers/get_stuffs.dart';
import 'package:chotot/data/a_stuff_data.dart';
import 'package:chotot/data/data_listener.dart';

import 'package:chotot/screens/thongTinSanPham.dart';
// import 'package:chotot/main.dart';
// import 'package:chotot/screens/choScreen.dart';
import 'package:chotot/screens/thong_tin_job_screen.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:chotot/data/notification_count.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterNotiController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _firebaseMessaging = FirebaseMessaging.instance;
  GetAJob getAJob = Get.put(GetAJob());
  GetAStuff getAStuff = Get.put(GetAStuff());
  LyLichController lyLichController = Get.put(LyLichController());
  String? fCMToken;
  NotiController notiController = Get.put(NotiController());
  GetPostJobs getPostJobs = Get.put(GetPostJobs());
  GetStuffs getStuffs = Get.put(GetStuffs());
  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Important Notifications',
    description: 'channel',
    importance: Importance.defaultImportance,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();
  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    var json = jsonEncode(message.data);
    var jobId = jsonDecode(json)['action'];

    await getAJob.getAJob(jobId);
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
  }

  void handleMessage(RemoteMessage? message) async {
    if (message == null) return;
    // await getAJob.getAJob(item.jobId);
    // Get.to(ThongTinJobScreen(
    //   jobInfo: [],
    // ));
    // print(message);
    // navigatorKey.currentState?.pushNamed(
    //   ChoScreen.route,
    //   arguments: message,
    // );\
    await notiController.getNoti(0);
    var json = jsonEncode(message!.data);

    var actionType = jsonDecode(json)['action_type'];
    switch (actionType) {
      case 'post_stuff':
        // print('stuff noti');

        var stuffId = jsonDecode(json)['action'];
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
        // print('job noti');
        jobListen.value = 1.0;
        var jobId = jsonDecode(json)['action'];
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
    const settings =
        InitializationSettings(android: android, iOS: iOS, macOS: null);

    await _localNotifications.initialize(settings,
        onDidReceiveNotificationResponse: (payload) async {
      final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));

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

      var json = jsonEncode(message.data);

      var actionType = jsonDecode(json)['action_type'];

      switch (actionType) {
        case 'post_stuff':
          // print('stuff noti');

          // var stuffId = jsonDecode(json)['action'];
          // await getAStuff.getAStuff(stuffId);

          // await getStuffs.getStuffs(0);
          marketListen.value++;
          // Get.to(() => ThongTinSanPhamScreen(docu: aStuff[0]));

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
        case "not_enough_point":
          // print('job noti');
          jobListen.value = 1.0;
          // var jobId = jsonDecode(json)['action'];
          // await getAJob.getAJob(jobId);
          // // await getPostJobs.getPostJobs(0);

          // final dateTime = DateTime.fromMillisecondsSinceEpoch(
          //     int.parse(getAJob.jobInfo[0].workDate),
          //     isUtc: true);
          // var date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
          // var time = '${dateTime.hour}:${dateTime.minute}';
          // Get.to(
          //   () => ThongTinJobScreen(
          //     jobInfo: getAJob.jobInfo,
          //     date: date,
          //     time: time,
          //   ),
          // );
          break;
        case 'charge_money':
        case 'host_fee':
        case 'worker_fee':
          await lyLichController.getInfo();
        case 'worker_active':
        case 'cancel_register_worker':
        case 'worker_update':
        case 'host_bonus':
          notiListen.value++;
          break;
        default:
          break;
      }
    });
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    fCMToken = await _firebaseMessaging.getToken();

    initPushNotifications();
    initLocalNotifications();
  }

  Future<void> registerNoti() async {
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
      } else if (json['status'] == 'error') {
        await AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.warning,
          animType: AnimType.rightSlide,
          title: json['error']['message'],
          titleTextStyle: GoogleFonts.poppins(),
          autoHide: const Duration(milliseconds: 800),
        ).show();
      }
    } else {
      throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured2';
    }
    // } catch (error) {
    //   throw 'Unknown Error Occured';
    // }
  }
}
