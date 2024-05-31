import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/controllers/get_a_user.dart';
import 'package:chotot/controllers/get_host_job.dart';
import 'package:chotot/controllers/get_notis.dart';
import 'package:chotot/controllers/get_orders_user.dart';
import 'package:chotot/controllers/get_worker_job.dart';

import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/controllers/register_notification.dart';
// import 'package:chotot/controllers/statistics_user.dart';
import 'package:chotot/screens/login.dart';
import 'package:chotot/screens/thongBaoScreen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
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
import 'package:chotot/controllers/get_news.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  LyLichController lyLichController = Get.put(LyLichController());
  LoginController loginController = Get.put(LoginController());
  // GetVouchersValid getVouchersValid = Get.put(GetVouchersValid());
  // GetNews getNewsController = Get.put(GetNews());
  GetHostJob getHostJobController = Get.put(GetHostJob());
  GetWorkerJob getWorkerJobController = Get.put(GetWorkerJob());
  GetAUserController getAUserController = Get.put(GetAUserController());
  GetOrdersUser getOrdersUser = Get.put(GetOrdersUser());

  // final _storage = const FlutterSecureStorage();
  int selectedIndex = 0;
  String tokenLogin = '';
  bool isNotiClick = false;
  bool isActive = false;

  NotiController notiController = Get.put(NotiController());
  onItemClicked(int index) async {
    if (index == 4 && loginController.tokenString != '') {
      getAUserController.isLoading = true;
      getOrdersUser.isLoading = true;
      Timer(const Duration(seconds: 3), () async {
        await getAUserController.getAUser();
        await getOrdersUser.getOrdersUser(0);
        setState(() {
          getAUserController.isLoading = false;
          getOrdersUser.isLoading = false;
        });
      });
    }

    if (index == 3) {
      // Timer(const Duration(seconds: 2), () async {
      await notiController.getNoti(0);
      setState(() {
        isActive = true;
        count.value = 0;
      });
      // });
    }
    if (index != 3) {
      setState(() {
        isActive = false;
      });
    }
    if (index == 1) {
      if (loginController.tokenString == '') {
        AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          title: 'Vui lòng đăng nhập',
          titleTextStyle: GoogleFonts.poppins(),
          btnOkText: 'Đăng nhập',
          btnOkOnPress: () {
            Get.to(() => const LoginScreen());
          },
        ).show();
      }
    }
    if (index == 3) {
      if (loginController.tokenString == '') {
        AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          title: 'Vui lòng đăng nhập',
          titleTextStyle: GoogleFonts.poppins(),
          btnOkText: 'Đăng nhập',
          btnOkOnPress: () {
            Get.to(() => const LoginScreen());
          },
        ).show();
      }
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

  @override
  void initState() {
    setState(() {
      count.value = 0;
      isActive = false;
    });
    super.initState();
    if (loginController.tokenString != '') {
      RegisterNotiController().registerNoti();
      lyLichController.isLoading = true;
      // getNewsController.getNewsData();
      Timer(const Duration(seconds: 2), () async {
        await lyLichController.getInfo();
        if (mounted) {
          setState(() {
            lyLichController.isLoading = false;
          });
        }
      });

      // getHostJobController.getHostJob(0, '');
      // Timer(const Duration(seconds: 3), () {
      //   getWorkerJobController.getWorkerJob(0, '', true);
      // });
      // getHostJobController.getHostJob(0, '');
      // getWorkerJobController.getWorkerJob(0, '');
      // getAUserController.getAUser();
    }
    _tabController = TabController(length: 5, vsync: this);
    //scroll
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
                return Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 15,
                    minHeight: 15,
                  ),
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
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