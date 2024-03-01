import 'package:chotot/controllers/get_host_job.dart';
import 'package:chotot/controllers/get_notis.dart';

import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/controllers/register_notification.dart';
// import 'package:chotot/controllers/statistics_user.dart';
import 'package:chotot/screens/login.dart';
import 'package:chotot/screens/thongBaoScreen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
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
  GetNews getNewsController = Get.put(GetNews());
  GetHostJob getHostJobController = Get.put(GetHostJob());

  // final _storage = const FlutterSecureStorage();
  int selectedIndex = 0;
  String tokenLogin = '';
  bool isNotiClick = false;
  NotiController notiController = Get.put(NotiController());
  onItemClicked(int index) {
    if (index == 3) {
      if (loginController.tokenString != '') {
        setState(() {
          isNotiClick = true;
          count.value = 0;
        });
      } else {
        showDialog(
            context: Get.context!,
            builder: (context) {
              return SimpleDialog(
                title: const Text(
                  'Vui lòng đăng nhập',
                  textAlign: TextAlign.center,
                ),
                contentPadding: const EdgeInsets.all(20),
                children: [
                  Center(
                    child: TextButton(
                        onPressed: () {
                          Get.to(() => const LoginScreen());
                        },
                        child: const Text('Đăng nhập')),
                  ),
                ],
              );
            });
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
    super.initState();
    if (loginController.tokenString != '') {
      RegisterNotiController().registerNoti();
      lyLichController.getInfo();
      notiController.getNoti(0);
      getHostJobController.getHostJob(0);
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
            controller: _tabController,
            children: const [
              TimThoScreen(),
              CongViecScreen(),
              ChoScreen(),
              ThongBaoScreen(),
              TaiKhoanScreen(),
            ]),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.white,
          activeColor: const Color.fromRGBO(38, 166, 83, 1),
          color: Colors.grey,
          style: TabStyle.react,
          height: 70,
          items: [
            const TabItem(
              title: 'Trang chủ',
              icon: FontAwesomeIcons.house,
            ),
            const TabItem(
              title: 'Công việc',
              icon: FontAwesomeIcons.paperclip,
            ),
            const TabItem(
              title: 'Chợ 4.0',
              icon: FontAwesomeIcons.shop,
            ),
            TabItem(
              title: 'Thông báo',
              icon: isNotiClick
                  ? FontAwesomeIcons.bell
                  : Stack(
                      children: <Widget>[
                        const FaIcon(FontAwesomeIcons.bell, color: Colors.grey),
                        ValueListenableBuilder<int>(
                          builder:
                              (BuildContext context, int value, Widget? child) {
                            if (value == 0) {
                              return const SizedBox();
                            }
                            return Positioned(
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: Text(
                                  value.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                          valueListenable: count,
                        )
                      ],
                    ),
            ),
            const TabItem(
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