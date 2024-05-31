import 'dart:async';

import 'package:chotot/controllers/get_a_job.dart';
import 'package:chotot/controllers/login_controller.dart';
// import 'package:chotot/data/get_host_job_data.dart';
import 'package:chotot/screens/login.dart';
import 'package:chotot/screens/thong_tin_job_screen.dart';
import 'package:flutter/material.dart';
import 'package:chotot/controllers/get_notis.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chotot/data/noti_data.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ThongBaoScreen extends StatefulWidget {
  const ThongBaoScreen({super.key});
  static const route = '/lib/screens/thongBaoScreen.dart';
  @override
  State<ThongBaoScreen> createState() => _ThongBaoScreenState();
}

class _ThongBaoScreenState extends State<ThongBaoScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  NotiController notiController = Get.put(NotiController());
  LoginController loginController = Get.put(LoginController());
  GetAJob getAJob = Get.put(GetAJob());
  late AnimationController _animationController;
  bool isLoading = false;
  int index = 0;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    Timer(const Duration(milliseconds: 2500), () {
      // if (mounted) {
      setState(() {
        isLoading = false;
      });
      // }
    });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();
    // if (loginController.tokenString != '') {
    //   getData();
    // }
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  getData() async {
    notification.clear();
    isLoading = true;
    Timer(const Duration(milliseconds: 800), () async {
      await notiController.getNoti(index);
      setState(() {
        isLoading = false;
      });
    });

    if (notification.isNotEmpty) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
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
            'Tin nhắn',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: widthDevice * 0.055,
                color: Colors.white),
          ),
        ),
      ),
      body: isLoading == true
          ? Center(
              child: LoadingAnimationWidget.waveDots(
                color: const Color.fromRGBO(1, 142, 33, 1),
                size: 30,
              ),
            )
          : loginController.tokenString == ''
              ? Center(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Text(
                          //   'Vui lòng đăng nhập để sử dụng dịch vụ',
                          //   style: Theme.of(context)
                          //       .textTheme
                          //       .titleMedium!
                          //       .copyWith(
                          //           fontFamily: GoogleFonts.lato().fontFamily,
                          //           fontWeight: FontWeight.w600,
                          //           color: Colors.black87),
                          //   textAlign: TextAlign.center,
                          // ),
                          // const SizedBox(height: 10),
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
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontSize: widthDevice * 0.04,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                              )),
                        ]),
                  ),
                )
              : notification.isNotEmpty
                  ? AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) => SlideTransition(
                        position: Tween(
                          begin: const Offset(0, 0.4),
                          end: const Offset(0, 0),
                        ).animate(
                          CurvedAnimation(
                              parent: _animationController,
                              curve: Curves.easeInOut),
                        ),
                        child: child,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...notification
                                .map(
                                  (i) => Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () async {
                                          if (i.action == i.userId) return;
                                          await getAJob.getAJob(i.action);
                                          final dateTime = DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  int.parse(getAJob
                                                      .jobInfo[0].workDate),
                                                  isUtc: true);
                                          var date =
                                              '${dateTime.day < 10 ? 0 : ''}${dateTime.day}/${dateTime.month < 10 ? 0 : ''}${dateTime.month}/${dateTime.year}';
                                          var time =
                                              '${dateTime.hour < 10 ? 0 : ''}${dateTime.hour}:${dateTime.minute < 10 ? 0 : ''}${dateTime.minute}';
                                          Get.to(
                                            () => ThongTinJobScreen(
                                              jobInfo: getAJob.jobInfo,
                                              date: date,
                                              time: time,
                                            ),
                                          );
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          elevation: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color:
                                                      i.actionType == 'host_fee'
                                                          ? Colors.redAccent
                                                          : Colors.green,
                                                  width: 10,
                                                ),
                                                left: BorderSide(
                                                  color:
                                                      i.actionType == 'host_fee'
                                                          ? Colors.redAccent
                                                          : Colors.green,
                                                  width: 1,
                                                ),
                                                top: BorderSide(
                                                  color:
                                                      i.actionType == 'host_fee'
                                                          ? Colors.redAccent
                                                          : Colors.green,
                                                  width: 1,
                                                ),
                                                bottom: BorderSide(
                                                  color:
                                                      i.actionType == 'host_fee'
                                                          ? Colors.redAccent
                                                          : Colors.green,
                                                  width: 1,
                                                ),
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10),
                                              ),
                                            ),
                                            child: ListTile(
                                              leading: Text(
                                                DateFormat.yMd().format(
                                                  DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                    int.parse(
                                                      i.time,
                                                    ),
                                                  ),
                                                ),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge!
                                                    .copyWith(
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily,
                                                      fontSize:
                                                          widthDevice * 0.04,
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                              title: Text(
                                                i.title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily,
                                                      fontSize:
                                                          widthDevice * 0.04,
                                                    ),
                                              ),
                                              subtitle: Text(
                                                i.message,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily,
                                                      fontSize:
                                                          widthDevice * 0.035,
                                                      color: Colors.grey,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      index = (index == 0 ? index : index - 1);
                                      getData();
                                    });
                                  },
                                  child: const Icon(Icons.arrow_left,
                                      size: 30, color: Colors.black),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: null,
                                  child: Text(
                                    '${index + 1}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: widthDevice * 0.04,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (notification.length < 10) return;
                                        index += 1;
                                        getData();
                                      });
                                    },
                                    child: const Icon(Icons.arrow_right,
                                        size: 30, color: Colors.black)),
                              ],
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: LoadingAnimationWidget.waveDots(
                        color: const Color.fromRGBO(1, 142, 33, 1),
                        size: 30,
                      ),
                    ),
    );
  }
}
