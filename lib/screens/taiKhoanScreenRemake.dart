// import 'dart:ui';

import 'package:chotot/controllers/get_job_type.dart';
import 'package:chotot/controllers/get_ly_lich.dart';
import 'package:chotot/controllers/statistics.dart';
import 'package:chotot/controllers/statistics_user.dart';
import 'package:chotot/data/statistics_user_data.dart';
import 'package:chotot/data/type_user.dart';
import 'package:chotot/screens/login.dart';
import 'package:chotot/screens/nap_tien_screen.dart';
// import 'package:chotot/screens/statistics_screen.dart';
import 'package:chotot/screens/statistics_user_screen.dart';
// import 'package:chotot/screens/worker_rate_screen.dart';

import 'package:flutter/material.dart';

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

class _TaiKhoanScreenState extends State<TaiKhoanScreen> {
  LoginController loginController = Get.put(LoginController());
  LyLichController lyLichController = Get.put(LyLichController());
  LogOutController logOutController = Get.put(LogOutController());
  Statistics statistics = Get.put(Statistics());
  GetJobTypeController getJobTypeController = Get.put(GetJobTypeController());
  final _storage = const FlutterSecureStorage();
  StatisticsUser statisticsUser = Get.put(StatisticsUser());
  String tokenString = '';
  void isLogin() async {
    tokenString = await _storage.read(key: "TOKEN") ?? '';

    if (tokenString != '') {
      setState(() {});
    }
  }

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
  void initState() {
    getJobTypeController.getJobType();
    statistics.getStatistics();
    isLogin();
    if (loginController.tokenString != '') {
      lyLichController.getInfo();
      getStatisticsData();
      getStatisticsDataTotal();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Tài khoản',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // foregroundColor: Color.fromRGBO(54, 92, 69, 1),
        elevation: 0,
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
                      : showDialog(
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
                  // await prefs.setString('token', token.toString());
                },
                child: Card(
                  color: Colors.white,
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Row(
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
                                                lyLichInfo[0].profileImage)
                                            .image,
                                      ),
                                      const SizedBox(width: 20),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(lyLichInfo[0].name,
                                              textAlign: TextAlign.start),
                                          Text(lyLichInfo[0].phone),
                                        ],
                                      ),
                                    ])
                              : Text(
                                  'Vui lòng đăng nhập',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontFamily:
                                            GoogleFonts.montserrat().fontFamily,
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
                      : showDialog(
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
                  // await prefs.setString('token', token.toString());
                },
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Image.asset(
                            'image/analytics.png',
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(width: 20),
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
                      : showDialog(
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
                  // await prefs.setString('token', token.toString());
                },
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.height * 0.2,
                          child: Row(children: [
                            Image.asset(
                              'image/ewallet.png',
                              height: 30,
                              width: 30,
                            ),
                            const SizedBox(width: 20),
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
                  ? lyLichInfo[0].workerAuthen == 'true'
                      ? GestureDetector(
                          onTap: () async {
                            tokenString != ''
                                ? Get.to(() => const LyLichScreen())
                                : showDialog(
                                    context: Get.context!,
                                    builder: (context) {
                                      return SimpleDialog(
                                        title: const Text(
                                          'Vui lòng đăng nhập',
                                          textAlign: TextAlign.center,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.all(20),
                                        children: [
                                          Center(
                                            child: TextButton(
                                                onPressed: () {
                                                  Get.to(() =>
                                                      const LoginScreen());
                                                },
                                                child: const Text('Đăng nhập')),
                                          ),
                                        ],
                                      );
                                    });
                            // await prefs.setString('token', token.toString());
                          },
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.height *
                                        0.2,
                                    child: Row(children: [
                                      Image.asset(
                                        'image/up-arrow.png',
                                        height: 30,
                                        width: 30,
                                      ),
                                      const SizedBox(width: 20),
                                      const Text(
                                        'Nâng cấp thợ',
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
                                : showDialog(
                                    context: Get.context!,
                                    builder: (context) {
                                      return SimpleDialog(
                                        title: const Text(
                                          'Vui lòng đăng nhập',
                                          textAlign: TextAlign.center,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.all(20),
                                        children: [
                                          Center(
                                            child: TextButton(
                                                onPressed: () {
                                                  Get.to(() =>
                                                      const LoginScreen());
                                                },
                                                child: const Text('Đăng nhập')),
                                          ),
                                        ],
                                      );
                                    });
                            // await prefs.setString('token', token.toString());
                          },
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.height *
                                        0.2,
                                    child: Row(children: [
                                      Image.asset(
                                        'image/clipboard.png',
                                        height: 30,
                                        width: 30,
                                      ),
                                      const SizedBox(width: 20),
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
                            : showDialog(
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
                        // await prefs.setString('token', token.toString());
                      },
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.height * 0.2,
                                child: Row(children: [
                                  Image.asset(
                                    'image/clipboard.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                  const SizedBox(width: 20),
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
              GestureDetector(
                onTap: () async {
                  tokenString != ''
                      ? setState(() {
                          type = type == 'host' ? 'worker' : 'host';
                          getStatisticsData();
                          getStatisticsDataTotal();
                        })
                      : showDialog(
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
                  // await prefs.setString('token', token.toString());
                },
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.height * 0.3,
                          child: Row(children: [
                            Image.asset(
                              type == 'host'
                                  ? 'image/mechanic.png'
                                  : 'image/computer-worker.png',
                              height: 30,
                              width: 30,
                            ),
                            const SizedBox(width: 20),
                            Text(
                              type == 'host'
                                  ? 'Chuyển đổi thợ'
                                  : 'Chuyển đổi chủ nhà',
                            ),
                          ]),
                        ),
                        const Icon(Icons.change_circle_outlined)
                      ],
                    ),
                  ),
                ),
              ),
              tokenString != ''
                  ? lyLichInfo[0].workerAuthen == 'true'
                      ? GestureDetector(
                          onTap: () async {
                            tokenString != ''
                                ? Get.to(() => const LyLichScreen())
                                : showDialog(
                                    context: Get.context!,
                                    builder: (context) {
                                      return SimpleDialog(
                                        title: const Text(
                                          'Vui lòng đăng nhập',
                                          textAlign: TextAlign.center,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.all(20),
                                        children: [
                                          Center(
                                            child: TextButton(
                                                onPressed: () {
                                                  Get.to(() =>
                                                      const LoginScreen());
                                                },
                                                child: const Text('Đăng nhập')),
                                          ),
                                        ],
                                      );
                                    });
                            // await prefs.setString('token', token.toString());
                          },
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    Image.asset(
                                      'image/employee.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    const SizedBox(width: 20),
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
                  : const SizedBox(),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  tokenString != ''
                      ? await logOutController.logOut()
                      : showDialog(
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
                  // await prefs.setString('token', token.toString());
                },
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.height * 0.2,
                          child: Row(children: [
                            Image.asset(
                              'image/logout.png',
                              height: 30,
                              width: 30,
                            ),
                            const SizedBox(width: 20),
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
                      ? Get.to(() => const LyLichScreen())
                      : showDialog(
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
                  // await prefs.setString('token', token.toString());
                },
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.height * 0.2,
                          child: Row(children: [
                            Image.asset(
                              'image/delete-user.png',
                              height: 30,
                              width: 30,
                            ),
                            const SizedBox(width: 20),
                            const Text(
                              'Xóa tài khoản',
                            ),
                          ]),
                        ),
                        const Icon(Icons.arrow_forward)
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Copyright© 2020-2024',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                            color: Colors.grey,
                          ),
                    ),
                    Text(
                      'Công ty TNHH Công Nghệ GICO.',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                            color: Colors.grey,
                          ),
                    ),
                    Text(
                        'Giấy chứng nhận ĐKKD số 0316121508, cấp ngày 21/01/2020 bởi Sở KH&ĐT TP. HCM.',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                              color: Colors.grey,
                            ),
                        textAlign: TextAlign.center),
                    Text(
                        'Địa chỉ: 19 Đường 18, Khu B, Phường An Phú, Thành phố Thủ Đức, Hồ Chí Minh, Việt Nam',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontFamily: GoogleFonts.montserrat().fontFamily,
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
