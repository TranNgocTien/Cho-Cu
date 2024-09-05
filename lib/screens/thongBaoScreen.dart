import 'dart:async';

import 'package:chotot/controllers/get_a_job.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/data/data_listener.dart';
// import 'package:chotot/data/get_host_job_data.dart';
import 'package:chotot/screens/login.dart';
import 'package:chotot/screens/thong_tin_job_screen.dart';
import 'package:flutter/material.dart';
import 'package:chotot/controllers/get_notis.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chotot/data/noti_data.dart';
// import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

class ThongBaoScreen extends StatefulWidget {
  const ThongBaoScreen({super.key});
  static const route = '/lib/screens/thongBaoScreen.dart';
  @override
  State<ThongBaoScreen> createState() => _ThongBaoScreenState();
}

class _ThongBaoScreenState extends State<ThongBaoScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  NotiController notiController = Get.put(NotiController());
  LoginController loginController = Get.put(LoginController());
  GetAJob getAJob = Get.put(GetAJob());
  late AnimationController _animationController;
  bool isLoading = true;
  int index = 0;
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

  colorNotificationFee(type) {
    switch (type) {
      case 'worker_fee':
      case "host_fee":
        return 'red';
      default:
        return 'green';
    }
  }

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    getData();
    // isLoading = true;
    // Timer(const Duration(milliseconds: 2000), () {
    //   // if (mounted) {

    //   setState(() {
    //     isLoading = false;
    //   });
    //   // }
    // });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0,
      upperBound: 1,
    );
    fadeTransitionFunc();
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
    isLoading = true;
    Timer(const Duration(milliseconds: 2000), () async {
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
    final heightDevice = MediaQuery.of(context).size.height;
    super.build(context);
    final widthDevice = MediaQuery.of(context).size.width;

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
                  'Tin nhắn',
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
        : Scaffold(
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
                        child: RefreshLoadmore(
                          onRefresh: () async {
                            notiListen.value = 0.0;
                            setState(() {
                              index = 0;
                            });
                            await getData();
                          },
                          // onLoadmore: () async {
                          //   if (onLoading == false) {
                          //     onLoading = true;
                          //     Timer(const Duration(seconds: 6), () {
                          //       setState(() {
                          //         onLoading = false;
                          //       });
                          //     });
                          //     currentIndex += 1;
                          //     await _getStuffs.getStuffs(currentIndex - 1);
                          //     setState(() {});
                          //   }
                          // },
                          onLoadmore: () async {
                            if (isLoading == false) {
                              await Future.delayed(const Duration(seconds: 3),
                                  () async {
                                // onLoading = true;
                                // Timer(const Duration(seconds: 5), () {
                                //   setState(() {
                                //     onLoading = false;
                                //   });
                                // });
                                index += 1;
                                await notiController.getNoti(index);
                                if (mounted) {
                                  setState(() {});
                                }
                              });
                            }
                          },
                          // noMoreWidget: Text(
                          //   'Bạn đã đến cuối trang',
                          //   style: TextStyle(
                          //     fontSize: 18,
                          //     color: Theme.of(context).disabledColor,
                          //   ),
                          // ),
                          isLastPage: false,
                          child: notification.isNotEmpty
                              ? Column(
                                  children: [
                                    ValueListenableBuilder(
                                      valueListenable: notiListen,
                                      builder: (context, value, widget) {
                                        return value > 0
                                            ? Card(
                                                color: Colors.white,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Có tin mới kéo xuống để tải lại ',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .copyWith(
                                                              fontFamily: GoogleFonts
                                                                      .poppins()
                                                                  .fontFamily,
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.03,
                                                              color: const Color
                                                                  .fromRGBO(
                                                                38,
                                                                166,
                                                                83,
                                                                1,
                                                              ),
                                                            ),
                                                      ),
                                                      const Icon(
                                                          Icons.arrow_downward,
                                                          color: Color.fromRGBO(
                                                              38, 166, 83, 1))
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : const SizedBox();
                                      },
                                    ),
                                    AlignedGridView.count(
                                      shrinkWrap: true,
                                      itemCount: notification.length,
                                      physics: const ScrollPhysics(),
                                      crossAxisCount: 1,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 5,
                                      itemBuilder: (context, i) {
                                        var dateTime =
                                            DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(notification[i].time),
                                        );
                                        return GestureDetector(
                                          onTap: () async {
                                            if (notification[i].action ==
                                                notification[i].userId) return;
                                            await getAJob.getAJob(
                                                notification[i].action);
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
                                                    color: colorNotificationFee(
                                                                notification[i]
                                                                    .actionType) ==
                                                            'red'
                                                        ? Colors.redAccent
                                                        : Colors.green,
                                                    width: 10,
                                                  ),
                                                  left: BorderSide(
                                                    color: colorNotificationFee(
                                                                notification[i]
                                                                    .actionType) ==
                                                            'red'
                                                        ? Colors.redAccent
                                                        : Colors.green,
                                                    width: 1,
                                                  ),
                                                  top: BorderSide(
                                                    color: colorNotificationFee(
                                                                notification[i]
                                                                    .actionType) ==
                                                            'red'
                                                        ? Colors.redAccent
                                                        : Colors.green,
                                                    width: 1,
                                                  ),
                                                  bottom: BorderSide(
                                                    color: colorNotificationFee(
                                                                notification[i]
                                                                    .actionType) ==
                                                            'red'
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
                                                  '${dateTime.hour < 10 ? 0 : ''}${dateTime.hour}:${dateTime.minute < 10 ? 0 : ''}${dateTime.minute} - ${dateTime.day < 10 ? 0 : ''}${dateTime.day}/${dateTime.month < 10 ? 0 : ''}${dateTime.month}/${dateTime.year}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge!
                                                      .copyWith(
                                                        fontFamily: GoogleFonts
                                                                .poppins()
                                                            .fontFamily,
                                                        fontSize:
                                                            widthDevice * 0.025,
                                                      ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                title: Text(
                                                  notification[i].title,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                        fontFamily: GoogleFonts
                                                                .poppins()
                                                            .fontFamily,
                                                        fontSize:
                                                            widthDevice * 0.04,
                                                      ),
                                                ),
                                                subtitle: Text(
                                                  notification[i].message,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontFamily: GoogleFonts
                                                                .poppins()
                                                            .fontFamily,
                                                        fontSize:
                                                            widthDevice * 0.035,
                                                        color: Colors.grey,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                )
                              : Stack(
                                  children: [
                                    Positioned(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                      left: MediaQuery.of(context).size.width *
                                          0.05,
                                      child: FadeTransition(
                                        opacity: _fadeInFadeOut,
                                        child: ShapeOfView(
                                          elevation: 20,
                                          // height:
                                          //     MediaQuery.of(context).size.height * 0.55,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          shape: BubbleShape(
                                              position: BubblePosition.Bottom,
                                              arrowPositionPercent: 0.7,
                                              borderRadius: 20,
                                              arrowHeight:
                                                  MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.17,
                                              arrowWidth: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  230, 246, 235, 1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: const Color.fromRGBO(
                                                      84, 181, 111, 1),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.205,
                                                ),
                                                top: const BorderSide(
                                                  color: Color.fromRGBO(
                                                      84, 181, 111, 1),
                                                  width: 5,
                                                ),
                                                left: const BorderSide(
                                                  color: Color.fromRGBO(
                                                      84, 181, 111, 1),
                                                  width: 5,
                                                ),
                                                right: const BorderSide(
                                                  color: Color.fromRGBO(
                                                      84, 181, 111, 1),
                                                  width: 5,
                                                ),
                                              ),
                                            ),
                                            padding: const EdgeInsets.only(
                                                bottom: 15.0,
                                                top: 15.0,
                                                left: 15.0,
                                                right: 15.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                      'Thợ 4.0 - nền tảng công nghệ Internet of Things kết nối CHỦ NHÀ với CHỦ NHÀ hoặc CHỦ NHÀ với  THỢ - nhằm cung cấp các dịch vụ chia sẻ thiết bị ĐIỆN - ĐIỆN TỬ và sản phẩm CÔNG NGHỆ đã sử dụng trong nhà nhanh nhất, tiện ích nhất.',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        letterSpacing: 2.0,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.033,
                                                      ),
                                                      textAlign:
                                                          TextAlign.justify),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                      'Bạn đang cần THANH LÝ các sản phẩm không dùng trong nhà, hãy sử dụng chức năng “Đăng tin chợ” trên trang “Chợ đồ cũ”. Chúng tôi sẽ giúp bạn bán/thanh lý sản phẩm trong thời gian nhanh nhất, tiện ích nhất.',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        letterSpacing: 2.0,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.033,
                                                      ),
                                                      textAlign:
                                                          TextAlign.justify),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
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
