import 'dart:async';
import 'dart:convert';

// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/controllers/get_a_job.dart';
import 'package:chotot/controllers/get_a_stuff.dart';
import 'package:chotot/controllers/get_a_user.dart';
// import 'package:chotot/controllers/get_host_job.dart';
import 'package:chotot/controllers/get_notis.dart';
import 'package:chotot/controllers/get_orders_user.dart';
import 'package:chotot/controllers/get_reg.dart';

import 'package:chotot/controllers/get_stuffs.dart';
import 'package:chotot/controllers/get_stuffs_suggestion.dart';
// import 'package:chotot/controllers/get_worker_job.dart';

import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/controllers/register_notification.dart';
import 'package:chotot/data/a_stuff_data.dart';
import 'package:chotot/data/data_listener.dart';
import 'package:chotot/data/login_data.dart';
import 'package:chotot/data/ly_lich.dart';
// import 'package:chotot/controllers/register_notification.dart';
// import 'package:chotot/controllers/statistics_user.dart';
// import 'package:chotot/screens/login.dart';
import 'package:chotot/screens/thongBaoScreen.dart';
import 'package:chotot/screens/thongTinSanPham.dart';
import 'package:chotot/screens/thong_tin_job_screen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:chotot/screens/timThoScreen.dart';
import 'package:chotot/screens/congViecScreen.dart';
import 'package:chotot/screens/taiKhoanScreenRemake.dart';
import 'package:chotot/screens/choScreen.dart';
import 'package:chotot/data/notification_count.dart';
// import 'package:chotot/screens/thongBaoScreen.dart';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chotot/controllers/get_ly_lich.dart';
import 'package:get/get.dart';
// import 'package:chotot/controllers/get_news.dart';
// import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.tabIndex = 0});
  final int tabIndex;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  GetAStuff getAStuff = Get.put(GetAStuff());
  GetStuffs getStuffs = Get.put(GetStuffs());
  GetAJob getAJob = Get.put(GetAJob());
  LoginController loginController = Get.put(LoginController());
  GetReg getRegController = Get.put(GetReg());
  GetAUserController getAUserController = Get.put(GetAUserController());
  GetOrdersUser getOrdersUser = Get.put(GetOrdersUser());
  GetStuffsSuggestion getStuffsSuggestion = Get.put(GetStuffsSuggestion());
  // final _storage = const FlutterSecureStorage();
  LyLichController lyLichController = Get.put(LyLichController());

  int selectedIndex = 0;
  String tokenLogin = '';
  bool isNotiClick = false;
  bool isActive = false;

  NotiController notiController = Get.put(NotiController());
  onItemClicked(int index) async {
    if (index == 4 && loginController.tokenString != '') {
      getAUserController.isLoading = true;
      getOrdersUser.isLoading = true;
      Timer(const Duration(milliseconds: 1000), () async {
        await getAUserController.getAUser();
        await getOrdersUser.getOrdersUser(0);

        setState(() {
          getAUserController.isLoading = false;
          getOrdersUser.isLoading = false;
        });
      });
    }

    if (index != 3) {
      setState(() {
        isActive = false;
      });
    }

    if (index == 3) {
      // await notiController.getNoti(0);
      //nguyên nhân việc tương tác trễ
      setState(() {
        isActive = true;
        count.value = 0;
      });
    } else {
      setState(() {
        isNotiClick = false;
      });
    }
    setState(() {
      selectedIndex = index;
      _tabController!.index = selectedIndex;
    });
  }

  // void isLogin() async {
  //   tokenLogin = await _storage.read(key: "TOKEN") ?? '';
  // }

  Future _firebaseBackgroundMessage(RemoteMessage message) async {
    Map payload = {};

    payload = message.data;

    await notiController.getNoti(0);

    var actionType = payload['action_type'];

    switch (actionType) {
      case 'post_stuff':
        // print('stuff noti');

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
        // print('job noti');
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

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _firebaseBackgroundMessage(initialMessage);
    }
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   String payloadData = jsonEncode(message.data);

    //   if (message.notification != null) {
    //     RegisterNotification.showSimpleNotification(
    //         title: message.notification!.title!,
    //         body: message.notification!.body!,
    //         payload: payloadData);
    //   }
    // });
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    // FirebaseMessaging.onMessageOpenedApp.listen(_firebaseBackgroundMessage);
  }

  @override
  void initState() {
    getStuffsSuggestion.getStuffs();
    getRegController.getReg();
    setState(() {
      selectedIndex = widget.tabIndex;
      count.value = 0;
      isActive = false;
    });
    super.initState();
    if (loginController.tokenString != '') {
      lyLichController.getInfo();
    }
    _tabController = TabController(length: 5, vsync: this);
    //scroll

    setupInteractedMessage();
  }

  @override
  void dispose() {
    //scroll

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            // physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: const [
              TimThoScreen(),
              CongViecScreen(),
              ChoScreen(),
              ThongBaoScreen(),
              TaiKhoanScreen(),
            ]),
        bottomNavigationBar: ConvexAppBar.badge(
          badgePadding: const EdgeInsets.all(0),
          badgeMargin: const EdgeInsets.only(bottom: 40, left: 20),
          {
            3: ValueListenableBuilder<int>(
              builder: (BuildContext context, int value, Widget? child) {
                if (value == 0) {
                  return const SizedBox();
                }
                return const Icon(
                  Icons.circle,
                  color: Colors.red,
                  size: 15,
                );
              },
              valueListenable: count,
            )
          },
          backgroundColor: Colors.white,
          activeColor: const Color.fromRGBO(38, 166, 83, 1),
          color: const Color.fromARGB(255, 133, 188, 152),
          style: TabStyle.fixedCircle,
          height: MediaQuery.of(context).size.height * 0.1,
          items: [
            TabItem(
              title: 'Trang chủ',
              icon: FontAwesomeIcons.house,
            ),
            TabItem(
              title: 'Công việc',
              icon: FontAwesomeIcons.paperclip,
            ),
            TabItem(
              title: 'Chợ',
              icon: FontAwesomeIcons.shop,
            ),
            TabItem(
              title: 'Tin nhắn',
              icon: FontAwesomeIcons.bell,
            ),
            TabItem(
              title: 'Tài khoản',
              icon: FontAwesomeIcons.user,
            ),
          ],
          initialActiveIndex: selectedIndex,
          onTap: onItemClicked,
        ),
      ),
    );
  }
}
// const Color.fromRGBO(5, 109, 101, 1)
// isActive
            //     ? TabItem(
            //         title: 'Thông báo',
            //         icon: Stack(
            //           children: <Widget>[
            //             FaIcon(
            //               FontAwesomeIcons.bell,
            //               color: isActive
            //                   ? const Color.fromRGBO(38, 166, 83, 1)
            //                   : const Color.fromARGB(255, 133, 188, 152),
            //             ),
            //             ValueListenableBuilder<int>(
            //               builder:
            //                   (BuildContext context, int value, Widget? child) {
            //                 if (value == 0) {
            //                   return const SizedBox();
            //                 }
            //                 return Positioned(
            //                   right: 0,
            //                   child: Container(
            //                     padding: const EdgeInsets.all(1),
            //                     decoration: BoxDecoration(
            //                       color: Colors.red,
            //                       borderRadius: BorderRadius.circular(6),
            //                     ),
            //                     constraints: const BoxConstraints(
            //                       minWidth: 10,
            //                       minHeight: 10,
            //                     ),
            //                     child: Text(
            //                       value.toString(),
            //                       style: const TextStyle(
            //                         color: Colors.white,
            //                         fontSize: 8,
            //                       ),
            //                       textAlign: TextAlign.center,
            //                     ),
            //                   ),
            //                 );
            //               },
            //               valueListenable: count,
            //             )
            //           ],
            //         ),
            //       )