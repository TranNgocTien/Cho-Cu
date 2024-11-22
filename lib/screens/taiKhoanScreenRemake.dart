// import 'dart:ui';

import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:chotot/controllers/get_a_user.dart';
import 'package:chotot/controllers/get_job_type.dart';
import 'package:chotot/controllers/get_ly_lich.dart';
// import 'package:chotot/controllers/get_orders_user.dart';
import 'package:chotot/controllers/statistics.dart';
import 'package:chotot/controllers/statistics_user.dart';
import 'package:chotot/data/login_data.dart';
import 'package:chotot/data/reg_profile_data.dart';
import 'package:chotot/data/statistics_user_data.dart';
import 'package:chotot/data/type_user.dart';
import 'package:chotot/data/version_app.dart';
import 'package:chotot/screens/active_screen.dart';
import 'package:chotot/screens/cap_nhat_thong_tin_viewweb.dart';
import 'package:chotot/screens/dang_ky_tho.dart';

// import 'package:chotot/screens/dang_ky_tho_webview_inapp.dart';

import 'package:chotot/screens/homeScreen.dart';
import 'package:chotot/screens/login.dart';
import 'package:chotot/screens/nap_tien_screen.dart';
// import 'package:chotot/screens/statistics_screen.dart';
import 'package:chotot/screens/statistics_user_screen.dart';
import 'package:chotot/screens/xoa_tai_khoan_screen.dart';
// import 'package:chotot/screens/worker_rate_screen.dart';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:chotot/widgets/taikhoanItem.dart';
import 'package:chotot/screens/lyLichScreen.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/controllers/log_out.dart';
import 'package:chotot/data/ly_lich.dart';

class TaiKhoanScreen extends StatefulWidget {
  const TaiKhoanScreen({super.key});

  @override
  State<TaiKhoanScreen> createState() => _TaiKhoanScreenState();
}

class _TaiKhoanScreenState extends State<TaiKhoanScreen>
    with AutomaticKeepAliveClientMixin {
  LoginController loginController = Get.put(LoginController());
  LyLichController lyLichController = Get.put(LyLichController());
  LogOutController logOutController = Get.put(LogOutController());
  Statistics statistics = Get.put(Statistics());
  GetJobTypeController getJobTypeController = Get.put(GetJobTypeController());
  final _storage = const FlutterSecureStorage();
  StatisticsUser statisticsUser = Get.put(StatisticsUser());
  GetAUserController getAUserController = Get.put(GetAUserController());
  // GetOrdersUser getOrdersUser = Get.put(GetOrdersUser());
  String tokenString = '';
  void isLogin() async {
    tokenString = await _storage.read(key: "TOKEN") ?? '';

    if (tokenString != '') {
      setState(() {});
    }
  }

  // Future<void> _launchUrl(url) async {
  //   if (!await launchUrl(url)) {
  //     throw Exception('Could not launch $url');
  //   }
  // }

  DateTime now = DateTime.now();
  getStatisticsData() async {
    statisticsUserData.clear();
    await statisticsUser.getStatisticsUser(
        type,
        '${now.year}-${now.month < 10 ? '0' : ''}${now.month}-01',
        '${now.year}-${now.month + 1 < 10 ? '0' : ''}${now.month + 1 > 12 ? 12 : now.month + 1}-${now.month + 1 > 12 ? '30' : ''}');
    statisticsUserData.add(statisticsUser.statisticsUser);
  }

  getStatisticsDataTotal() async {
    statisticsUserDataTotal.clear();
    await statisticsUser.getStatisticsUser(
        type, '${now.year}-01-01', '${now.year}-12-30');
    statisticsUserDataTotal.add(statisticsUser.statisticsUser);
  }

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    if (loginController.tokenString != '') {
      lyLichController.getInfo();
      getStatisticsData();
      getStatisticsDataTotal();
      // getAUserController.getAUser();
    }
    setState(() {
      getJobTypeController.isLoading = true;
      getAUserController.isLoading = true;
    });
    Timer(const Duration(milliseconds: 300), () async {
      await getJobTypeController.getJobType();
      await statistics.getStatistics();
      // await getOrdersUser.getOrdersUser(
      //   0,
      // );
      isLogin();
      setState(() {
        getAUserController.isLoading = false;
        getJobTypeController.isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60.0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromRGBO(39, 166, 82, 1),
                Color.fromRGBO(1, 142, 33, 1),
                Color.fromRGBO(23, 162, 73, 1),
                Color.fromRGBO(84, 181, 111, 1),
              ],
            ),
          ),
        ),
        title: Center(
          child: Text(
            'Tài khoản',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.white,
                fontSize: widthDevice * 0.055),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // foregroundColor: Color.fromRGBO(54, 92, 69, 1),
        elevation: 3,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  tokenString != ''
                      ? Get.to(() => const LyLichScreen())
                      // : showDialog(
                      //     context: Get.context!,
                      //     builder: (context) {
                      //       return SimpleDialog(
                      //         title: const Text(
                      //           'Vui lòng đăng nhập',
                      //           textAlign: TextAlign.center,
                      //         ),
                      //         contentPadding: const EdgeInsets.all(20),
                      //         children: [
                      //           Center(
                      //             child: TextButton(
                      //                 onPressed: () {
                      //                   Get.to(() => const LoginScreen());
                      //                 },
                      //                 child: const Text('Đăng nhập')),
                      //           ),
                      //         ],
                      //       );
                      //     });
                      : AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'Vui lòng đăng nhập',
                          titleTextStyle: GoogleFonts.poppins(),
                          btnOkText: 'Đăng nhập',
                          btnOkOnPress: () {
                            Get.to(() => const LoginScreen());
                          },
                        ).show();
                  // await prefs.setString('token', token.toString());
                },
                child: Card(
                  color: const Color.fromARGB(255, 192, 244, 210),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: getAUserController.isLoading == true
                        ? Center(
                            child: LoadingAnimationWidget.waveDots(
                              color: const Color.fromRGBO(1, 142, 33, 1),
                              size: 30,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                tokenString != ''
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundImage: Image.network(
                                                      lyLichInfo[0]
                                                          .profileImage)
                                                  .image,
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(loginData[0].name,
                                                    textAlign: TextAlign.start),
                                                Text(loginData[0]
                                                    .phoneNumber
                                                    .toString()),
                                              ],
                                            ),
                                          ])
                                    : Text(
                                        'Vui lòng đăng nhập',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                const Icon(Icons.arrow_forward)
                              ]),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  tokenString != ''
                      ? Get.to(() => const StatisticsUserScreen())
                      : AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'Vui lòng đăng nhập',
                          titleTextStyle: GoogleFonts.poppins(),
                          btnOkText: 'Đăng nhập',
                          btnOkOnPress: () {
                            Get.to(() => const LoginScreen());
                          },
                        ).show();
                  // await prefs.setString('token', token.toString());
                },
                child: Card(
                  color: const Color.fromARGB(255, 192, 244, 210),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: getAUserController.isLoading == true
                        ? Center(
                            child: LoadingAnimationWidget.waveDots(
                              color: const Color.fromRGBO(1, 142, 33, 1),
                              size: 30,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Image.asset(
                                  'image/new_icon/TAI_KHOAN/THONG_KE.png',
                                  height: 30,
                                  width: 30,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Thống kê',
                                ),
                              ]),
                              const Icon(Icons.arrow_forward)
                            ],
                          ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  tokenString != ''
                      ? Get.to(() => const NapTienScreen())
                      : AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'Vui lòng đăng nhập',
                          titleTextStyle: GoogleFonts.poppins(),
                          btnOkText: 'Đăng nhập',
                          btnOkOnPress: () {
                            Get.to(() => const LoginScreen());
                          },
                        ).show();
                  // await prefs.setString('token', token.toString());
                },
                child: Card(
                  color: const Color.fromARGB(255, 192, 244, 210),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.height * 0.25,
                          child: Row(children: [
                            Image.asset(
                              'image/new_icon/TAI_KHOAN/NAP_TIEN.png',
                              height: 30,
                              width: 30,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Nạp tiền',
                            ),
                          ]),
                        ),
                        const Icon(Icons.arrow_forward)
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              tokenString != ''
                  ?
                  //  loginData[0].regProfile == '--'
                  //     ? const SizedBox()
                  //     :
                  regProfile.isNotEmpty
                      ? const SizedBox()
                      : GestureDetector(
                          onTap: () async {
                            tokenString != ''
                                ? Get.to(() => const DangKyThoScreen())
                                : AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.info,
                                    animType: AnimType.rightSlide,
                                    title: 'Vui lòng đăng nhập',
                                    titleTextStyle: GoogleFonts.poppins(),
                                    btnOkText: 'Đăng nhập',
                                    btnOkOnPress: () {
                                      Get.to(() => const LoginScreen());
                                    },
                                  ).show();
                            // await prefs.setString('token', token.toString());
                          },
                          child: Card(
                            color: const Color.fromARGB(255, 192, 244, 210),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.height *
                                        0.25,
                                    child: Row(children: [
                                      Image.asset(
                                        'image/new_icon/TAI_KHOAN/DANG_KY_THO.png',
                                        height: 30,
                                        width: 30,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        'Đăng ký thợ',
                                      ),
                                    ]),
                                  ),
                                  const Icon(Icons.arrow_forward)
                                ],
                              ),
                            ),
                          ),
                        )
                  : GestureDetector(
                      onTap: () async {
                        tokenString != ''
                            ? Get.to(() => const LyLichScreen())
                            : AwesomeDialog(
                                context: context,
                                dialogType: DialogType.info,
                                animType: AnimType.rightSlide,
                                title: 'Vui lòng đăng nhập',
                                titleTextStyle: GoogleFonts.poppins(),
                                btnOkText: 'Đăng nhập',
                                btnOkOnPress: () {
                                  Get.to(() => const LoginScreen());
                                },
                              ).show();
                        // await prefs.setString('token', token.toString());
                      },
                      child: Card(
                        color: const Color.fromARGB(255, 192, 244, 210),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          child: getAUserController.isLoading == true
                              ? Center(
                                  child: LoadingAnimationWidget.waveDots(
                                    color: const Color.fromRGBO(1, 142, 33, 1),
                                    size: 30,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      child: Row(children: [
                                        Image.asset(
                                          'image/new_icon/TAI_KHOAN/DANG_KY_THO.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          'Đăng ký thợ',
                                        ),
                                      ]),
                                    ),
                                    const Icon(Icons.arrow_forward)
                                  ],
                                ),
                        ),
                      ),
                    ),
              tokenString != ''
                  ?
                  // loginData[0].regProfile != '--'

                  //     ?
                  regProfile.isEmpty
                      ? const SizedBox()
                      : GestureDetector(
                          onTap: () async {
                            tokenString != ''
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CapNhatThongTinTho(),
                                    ))
                                // _launchUrl(
                                //     Uri.parse(
                                //         'https://thothongminh.com/dang-ky-tho-mobile/${getAUserController.aUser[0].user.id}'),
                                //   )
                                : AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.info,
                                    animType: AnimType.rightSlide,
                                    title: 'Vui lòng đăng nhập',
                                    titleTextStyle: GoogleFonts.poppins(),
                                    btnOkText: 'Đăng nhập',
                                    btnOkOnPress: () {
                                      Get.to(() => const LoginScreen());
                                    },
                                  ).show();
                            // await prefs.setString('token', token.toString());
                          },
                          child: Card(
                            color: const Color.fromARGB(255, 192, 244, 210),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    Image.asset(
                                      'image/new_icon/TAI_KHOAN/DANG_KY_THO.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Cập nhật thông tin thợ',
                                    ),
                                  ]),
                                  const Icon(Icons.arrow_forward)
                                ],
                              ),
                            ),
                          ),
                        )
                  : const SizedBox()
              // : const SizedBox()
              ,
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  tokenString != ''
                      ? await logOutController.logOut()
                      : AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'Vui lòng đăng nhập',
                          titleTextStyle: GoogleFonts.poppins(),
                          btnOkText: 'Đăng nhập',
                          btnOkOnPress: () {
                            Get.to(() => const LoginScreen());
                          },
                        ).show();
                  // await prefs.setString('token', token.toString());
                },
                child: Card(
                  color: const Color.fromARGB(255, 192, 244, 210),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: getAUserController.isLoading == true
                        ? Center(
                            child: LoadingAnimationWidget.waveDots(
                              color: const Color.fromRGBO(1, 142, 33, 1),
                              size: 30,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: Row(children: [
                                  Image.asset(
                                    'image/new_icon/TAI_KHOAN/DANG_XUAT.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Đăng xuất',
                                  ),
                                ]),
                              ),
                              const Icon(Icons.arrow_forward)
                            ],
                          ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  tokenString != ''
                      ? Get.to(
                          () => loginData[0].status == 'active'
                              ? const DeactiveUserScreen()
                              : const ActiveUserScreen(),
                        )
                      : AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'Vui lòng đăng nhập',
                          titleTextStyle: GoogleFonts.poppins(),
                          btnOkText: 'Đăng nhập',
                          btnOkOnPress: () {
                            Get.to(() => const LoginScreen());
                          },
                        ).show();
                  // await prefs.setString('token', token.toString());
                },
                child: tokenString != ''
                    ? loginData[0].status == 'active'
                        ? Card(
                            color: const Color.fromARGB(255, 192, 244, 210),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: Row(children: [
                                      Image.asset(
                                        'image/new_icon/TAI_KHOAN/XOA_TAI_KHOAN.png',
                                        height: 30,
                                        width: 30,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        'Xóa tài khoản',
                                      ),
                                    ]),
                                  ),
                                  const Icon(Icons.arrow_forward)
                                ],
                              ),
                            ),
                          )
                        : Card(
                            color: const Color.fromARGB(255, 192, 244, 210),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.height *
                                        0.25,
                                    child: Row(children: [
                                      Image.asset(
                                        'image/add-friend.png',
                                        height: 30,
                                        width: 30,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        'Kích hoạt tài khoản',
                                      ),
                                    ]),
                                  ),
                                  const Icon(Icons.arrow_forward)
                                ],
                              ),
                            ),
                          )
                    : const SizedBox(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Phiên bản 3.1.1',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: Colors.grey,
                          ),
                    ),
                    Text(
                      'Copyright© 2020-2024',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: Colors.grey,
                          ),
                    ),
                    Text(
                      'Công ty TNHH Công Nghệ GICO.',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: Colors.grey,
                          ),
                    ),
                    Text(
                        'Giấy chứng nhận ĐKKD số 0316121508, cấp ngày 21/01/2020 bởi Sở KH&ĐT TP. HCM.',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: Colors.grey,
                            ),
                        textAlign: TextAlign.center),
                    Text(
                        'Địa chỉ: 19 Đường 18, Khu B, Phường An Phú, Thành phố Thủ Đức, Hồ Chí Minh, Việt Nam',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: Colors.grey,
                            ),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
