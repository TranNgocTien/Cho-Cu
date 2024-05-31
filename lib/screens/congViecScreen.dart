import 'dart:async';

import 'package:chotot/controllers/get_a_job.dart';
import 'package:chotot/controllers/get_host_job.dart';
// import 'package:chotot/controllers/get_ly_lich.dart';
import 'package:chotot/controllers/get_worker_job.dart';
import 'package:chotot/controllers/login_controller.dart';
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
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return loginController.tokenString == ''
        ? Center(
            child: Container(
              padding: const EdgeInsets.all(15),
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   'Vui lòng đăng nhập để sử dụng dịch vụ',
                    //   style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    //       fontFamily: GoogleFonts.poppins().fontFamily,
                    //       fontWeight: FontWeight.w600,
                    //       color: Colors.black87),
                    //   textAlign: TextAlign.center,
                    // ),
                    // const SizedBox(height: 15),
                    MaterialButton(
                        height: 40.0,
                        elevation: 10.0,
                        color: const Color.fromRGBO(38, 166, 83, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {
                          Get.to(() => const LoginScreen());
                        },
                        child: Text(
                          'Đăng nhập',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                        )),
                  ]),
            ),
          )
        : isLoading != true
            ? GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: DefaultTabController(
                  length: lyLichInfo[0].workerAuthen == 'true' ? 2 : 1,
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
                            tabs: lyLichInfo[0].workerAuthen == 'true'
                                ? list
                                : listHost),
                      ),
                    ),
                    body: lyLichInfo[0].workerAuthen == 'true'
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
