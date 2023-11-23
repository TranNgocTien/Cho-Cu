import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chotot/widgets/taikhoanItem.dart';
import 'package:chotot/screens/lyLichScreen.dart';
import 'package:get/get.dart';
import 'package:chotot/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chotot/controllers/login_controller.dart';

class TaiKhoanScreen extends StatelessWidget {
  TaiKhoanScreen({super.key});
  final _storage = const FlutterSecureStorage();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Tài khoản',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontFamily: GoogleFonts.rubik().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(54, 92, 69, 1),
                ),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(54, 92, 69, 1),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const TaiKhoanItem(
              title: "Lý lịch",
              image: 'image/icon/ly_lich_(1).png',
              screen: LyLichScreen(),
            ),
            const TaiKhoanItem(
                title: 'Thống kê', image: 'image/icon/icon_thong_ke_(1).png'),
            const TaiKhoanItem(
                title: 'Cập nhật thông tin thợ',
                image: 'image/icon/dang_ki_tho_(1).png'),
            const TaiKhoanItem(
                title: 'Nâng cấp thợ',
                image: 'image/icon/nang_cap_tho_(1).png'),
            const TaiKhoanItem(
                title: 'Nap tiền',
                image: 'image/icon/huong_dan_nap_tien_(1).png'),
            TaiKhoanItem(
                title: 'Đăng xuất',
                image: 'image/icon/dnag_xuat_(1).png',
                onTap: () async {
                  final SharedPreferences prefs = await _prefs;

                  // await prefs.setString('token', token.toString());
                  loginController.tokenString = '';
                  loginController.hostId = '';
                  await prefs.clear();

                  await _storage.delete(key: "KEY_USERNAME");
                  await _storage.delete(key: "KEY_PASSWORD");
                  Get.offAll(const LoginScreen());
                }),
            const TaiKhoanItem(
                title: 'Xóa tài khoản', image: 'image/icon/dnag_xuat_(1).png'),
            // TaiKhoanItem(
            //     title: 'Thông tin công ty', icon: FontAwesomeIcons.circleInfo),
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.only(
                    left: 20, right: 5, top: 10, bottom: 5),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: const FaIcon(
                        FontAwesomeIcons.circleInfo,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 30),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            width: 1,
                            color: Color.fromRGBO(160, 160, 159, 0.906),
                          ),
                          bottom: BorderSide(
                            width: 1,
                            color: Color.fromRGBO(160, 160, 159, 0.906),
                          ),
                        ),
                      ),
                      child: Text('Thông tin công ty',
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontFamily: GoogleFonts.rubik().fontFamily,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                  ),
                          textAlign: TextAlign.start),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
