import 'package:flutter/material.dart';
import 'package:chotot/screens/timThoScreen.dart';
import 'package:chotot/screens/congViecScreen.dart';
import 'package:chotot/screens/taiKhoanScreen.dart';
import 'package:chotot/screens/choScreen.dart';
import 'package:chotot/screens/thongBaoScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  int selectedIndex = 0;

  onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      _tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
            children: [
              const TimThoScreen(),
              const CongViecScreen(),
              const ChoScreen(),
              const ThongBaoScreen(),
              TaiKhoanScreen(),
            ]),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.house),
              label: 'Tìm thợ',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.paperclip),
              label: 'Công việc',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.shop),
              label: 'Chợ 4.0',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.bell),
              label: 'Thông báo',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.user),
              label: 'Tài khoản',
            ),
          ],
          elevation: 10,
          backgroundColor: const Color.fromRGBO(5, 109, 101, 1),
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontSize: 14),
          currentIndex: selectedIndex,
          onTap: onItemClicked,
        ),
      ),
    );
  }
}
