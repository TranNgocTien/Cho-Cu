import 'dart:async';

import 'package:chotot/controllers/get_a_job.dart';
import 'package:chotot/controllers/get_host_job.dart';
// import 'package:chotot/controllers/get_ly_lich.dart';
import 'package:chotot/controllers/get_worker_job.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/data/login_data.dart';
import 'package:chotot/data/ly_lich.dart';
import 'package:chotot/screens/host_job_screen.dart';

import 'package:chotot/screens/login.dart';

import 'package:chotot/screens/worker_job_screen.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

// import 'package:chotot/models/get_host_job_model.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

class CongViecScreen extends StatefulWidget {
  const CongViecScreen({super.key});
  static const route = '/lib/screens/congViecScreen.dart';

  @override
  State<CongViecScreen> createState() => _CongViecScreenState();
}

class _CongViecScreenState extends State<CongViecScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  GetHostJob getHostJob = Get.put(GetHostJob());
  GetWorkerJob getWorkerJob = Get.put(GetWorkerJob());
  GetAJob getAJob = Get.put(GetAJob());
  LoginController loginController = Get.put(LoginController());
  bool isLoading = true;
  late Animation<double> _fadeInFadeOut;
  late AnimationController animation;
  fadeTransitionFunc() {
    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1).animate(animation);

    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     animation.reverse();
    //   } else if (status == AnimationStatus.dismissed) {
    //     animation.forward();
    //   }
    // });
    animation.forward();
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = '${diff.inDays}DAY AGO';
      } else {
        time = '${diff.inDays}DAYS AGO';
      }
    }

    return time;
  }

  // int _selectedIndex = 0;
  List<Widget> listHost = [
    Tab(
      child: Text('Chủ nhà',
          style: GoogleFonts.poppins(
            fontSize: 15,
          )),
    ),
  ];
  List<Widget> list = [
    Tab(
      child: Text('Chủ nhà',
          style: GoogleFonts.poppins(
            fontSize: 15,
          )),
    ),
    Tab(
      child: Text('Thợ',
          style: GoogleFonts.poppins(
            fontSize: 15,
          )),
    ),
  ];

  @override
  void initState() {
    getHostJob.getHostJob(0, '');
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    if (mounted) {
      setState(() {});
    }

    fadeTransitionFunc();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    final widthDevice = MediaQuery.of(context).size.width;
    final heightDevice = MediaQuery.of(context).size.height;
    super.build(context);
    return loginController.tokenString == ''
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
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
              backgroundColor: Colors.white,
              title: Center(
                child: Text(
                  'Công việc',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: widthDevice * 0.055,
                      color: Colors.white),
                ),
              ),
            ),
            body: Stack(children: [
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.05,
                child: FadeTransition(
                  opacity: _fadeInFadeOut,
                  child: ShapeOfView(
                    elevation: 20,
                    // height: MediaQuery.of(context).size.height * 0.55,
                    width: MediaQuery.of(context).size.width * 0.9,
                    shape: BubbleShape(
                        position: BubblePosition.Bottom,
                        arrowPositionPercent: 0.7,
                        borderRadius: 20,
                        arrowHeight: MediaQuery.of(context).size.height * 0.2,
                        arrowWidth: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(230, 246, 235, 1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border(
                          bottom: BorderSide(
                            color: const Color.fromRGBO(84, 181, 111, 1),
                            width: MediaQuery.of(context).size.height * 0.205,
                          ),
                          top: const BorderSide(
                            color: Color.fromRGBO(84, 181, 111, 1),
                            width: 4,
                          ),
                          left: const BorderSide(
                            color: Color.fromRGBO(84, 181, 111, 1),
                            width: 4,
                          ),
                          right: const BorderSide(
                            color: Color.fromRGBO(84, 181, 111, 1),
                            width: 4,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.only(
                          bottom: 15.0, top: 15.0, left: 15.0, right: 15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text(
                                'Thợ 4.0 - nền tảng công nghệ Internet of Things kết nối THỢ THÔNG MINH với CHỦ NHÀ - nhằm cung cấp các dịch vụ trong nhà nhanh nhất, an toàn nhất, tiết kiệm nhất.',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.033,
                                ),
                                textAlign: TextAlign.justify),
                            const SizedBox(height: 5),
                            Text(
                                'Bạn đang cần Thợ xử lý các việc trong nhà, hãy sử dụng chức năng “Đăng nhập” hoặc "Tạo tài khoản" sau đó sử dụng chức năng "Đăng việc" trên trang “Chợ việc làm”. Chúng tôi sẽ giúp bạn tìm được Thợ giỏi trong thời gian nhanh nhất.',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.033,
                                ),
                                textAlign: TextAlign.justify),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                    onPressed: () {
                      Get.to(() => const LoginScreen());
                    },
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    height: heightDevice * 0.03,
                    minWidth: 100.0,
                    color: const Color.fromRGBO(38, 166, 83, 1),
                    child: Text('Đăng nhập',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: widthDevice * 0.04,
                            color: Colors.white))),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.all(10),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(50),
                  //   border:
                  //       Border.all(color: const Color.fromRGBO(38, 166, 83, 1)),
                  // ),
                  child: const Icon(
                    Icons.login,
                    size: 30,
                    color: Color.fromRGBO(38, 166, 83, 1),
                  ),
                ),
              ],
            ))
        : isLoading != true
            ? GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: DefaultTabController(
                  length: loginData[0].workerAuthen == 'true' ? 2 : 1,
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    bottomNavigationBar: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        height: 60.0,
                        child: TabBar(
                            dividerColor: Colors.grey,
                            labelColor: const Color.fromRGBO(38, 166, 83, 1),
                            indicatorColor: Colors.orange,
                            indicatorSize: TabBarIndicatorSize.tab,
                            unselectedLabelColor: Colors.grey,
                            tabAlignment: TabAlignment.fill,
                            onTap: (index) {
                              // setState(() {});
                            },
                            tabs: loginData[0].workerAuthen == 'true'
                                ? list
                                : listHost),
                      ),
                    ),
                    body: loginData[0].workerAuthen == 'true'
                        ? const TabBarView(
                            children: [
                              CongViecHostScreen(),
                              CongViecWorkerScreen(),
                            ],
                          )
                        : const TabBarView(
                            children: [
                              CongViecHostScreen(),
                            ],
                          ),
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: LoadingAnimationWidget.waveDots(
                    color: const Color.fromRGBO(1, 142, 33, 1),
                    size: 30,
                  ),
                ),
              );
  }
}
