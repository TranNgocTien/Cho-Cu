import 'package:chotot/controllers/get_host_job.dart';
import 'package:chotot/controllers/get_notis.dart';

import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/controllers/register_notification.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:chotot/screens/timThoScreen.dart';
import 'package:chotot/screens/congViecScreen.dart';
import 'package:chotot/screens/taiKhoanScreenRemake.dart';
import 'package:chotot/screens/choScreen.dart';

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
  NotiController notiController = Get.put(NotiController());
  onItemClicked(int index) {
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
    _tabController = TabController(length: 4, vsync: this);
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
              // ThongBaoScreen(),
              TaiKhoanScreen(),
            ]),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.white,
          activeColor: const Color.fromRGBO(38, 166, 83, 1),
          color: Colors.grey,
          style: TabStyle.react,
          height: 70,
          items: const [
            TabItem(
              title: 'Trang chủ',
              icon: FontAwesomeIcons.house,
            ),
            TabItem(
              title: 'Công việc',
              icon: FontAwesomeIcons.paperclip,
            ),
            TabItem(
              title: 'Chợ 4.0',
              icon: FontAwesomeIcons.shop,
            ),
            // TabItem(
            //     title: 'Thông báo',
            //     icon: FontAwesomeIcons.bell,
            //     activeIcon: ActionListener(
            //         listener: listener, action: action, child: child)),
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