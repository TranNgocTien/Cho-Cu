import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chotot/controllers/get_a_job.dart';
import 'package:chotot/controllers/get_host_job.dart';

import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/data/job_service_data.dart';
import 'package:chotot/data/login_data.dart';

import 'package:chotot/screens/login.dart';
import 'package:chotot/screens/thong_tin_job_screen.dart';

import 'package:flutter/material.dart';
import 'package:chotot/data/get_host_job_data.dart';

import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
// import 'package:chotot/models/get_host_job_model.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';

class CongViecHostScreen extends StatefulWidget {
  const CongViecHostScreen({super.key});
  static const route = '/lib/screens/congViecScreen.dart';

  @override
  State<CongViecHostScreen> createState() => _CongViecHostScreenState();
}

class _CongViecHostScreenState extends State<CongViecHostScreen>
    with SingleTickerProviderStateMixin {
  GetHostJob getHostJob = Get.put(GetHostJob());
  // GetWorkerJob getWorkerJob = Get.put(GetWorkerJob());
  late AnimationController _animationController;
  GetAJob getAJob = Get.put(GetAJob());
  LoginController loginController = Get.put(LoginController());
  bool isLoading = true;
  // late TabController _controller;

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

  // List<Widget> hostList = [
  //   Tab(
  //     child: Text(
  //       "Tất cả",
  //       style: GoogleFonts.poppins(
  //         fontSize: 15,
  //       ),
  //     ),
  //   ),
  //   Tab(
  //     child: Text(
  //       "Công việc mới đăng",
  //       style: GoogleFonts.poppins(
  //         fontSize: 15,
  //       ),
  //     ),
  //   ),
  //   Tab(
  //     child: Text(
  //       'Đã chọn thợ làm việc',
  //       style: GoogleFonts.poppins(
  //         fontSize: 15,
  //       ),
  //     ),
  //   ),
  //   Tab(
  //     child: Text(
  //       'Công việc đã huỷ',
  //       style: GoogleFonts.poppins(
  //         fontSize: 15,
  //       ),
  //     ),
  //   ),
  //   Tab(
  //     child: Text(
  //       'Thợ đã báo làm xong',
  //       style: GoogleFonts.poppins(
  //         fontSize: 15,
  //       ),
  //     ),
  //   ),
  //   Tab(
  //     child: Text(
  //       'Chủ nhà đã báo hoàn tất',
  //       style: GoogleFonts.poppins(
  //         fontSize: 15,
  //       ),
  //     ),
  //   ),
  // ];

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController.forward();
    getHostJob.getHostJob(0, '');

    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthDevice = MediaQuery.of(context).size.width;

    return loginController.tokenString == ''
        ? Center(
            child: Card(
              color: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(15),
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Vui lòng đăng nhập để sử dụng dịch vụ',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w600,
                                fontSize: widthDevice * 0.04,
                                color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      TextButton(
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
                                    fontWeight: FontWeight.w600,
                                    fontSize: widthDevice * 0.04,
                                    color: Colors.green),
                          )),
                    ]),
              ),
            ),
          )
        :
        // isLoading
        //     ?
        GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child:
                //  DefaultTabController(
                //   length: hostList.length,
                //   child:
                Scaffold(
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
                    'Chủ nhà - ${loginData[0].name}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: widthDevice * 0.045,
                          color: Colors.white,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                // foregroundColor: Color.fromRGBO(54, 92, 69, 1),
                elevation: 3,
              ),
              // bottom: TabBar(
              //     dividerColor: const Color.fromRGBO(84, 181, 111, 1),
              //     labelColor: Colors.white,
              //     indicatorColor: Colors.white,
              //     indicatorSize: TabBarIndicatorSize.label,
              //     unselectedLabelColor: Colors.black87,
              //     onTap: (index) {
              //       setState(() {
              //         getHostJob.isLoading = true;
              //       });
              //     },
              //     isScrollable: true,
              //     tabs: hostList)),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) => Opacity(
                            opacity: _animationController.value,
                            child: child,
                          ),
                          child: Card(
                            color: const Color.fromARGB(255, 192, 244, 210),
                            child: GFListTile(
                                avatar: GFAvatar(
                                  shape: GFAvatarShape.circle,
                                  backgroundColor:
                                      const Color.fromARGB(255, 192, 244, 210),
                                  child: Image.asset(
                                    'image/new-employee.png',
                                  ),
                                ),
                                description: Text('Công việc mới đăng',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith()),
                                padding: EdgeInsets.zero,
                                radius: 50,
                                onTap: () async {
                                  await getHostJob.getHostJob(0, 'posting');
                                  if (hostJobData.isEmpty) {
                                    await AwesomeDialog(
                                      context: Get.context!,
                                      dialogType: DialogType.info,
                                      animType: AnimType.rightSlide,
                                      title:
                                          'Hiện tại không có công việc trạng thái này',
                                      titleTextStyle: GoogleFonts.poppins(),
                                      autoHide:
                                          const Duration(milliseconds: 800),
                                    ).show();
                                  } else {
                                    Get.to(const HostJobStatus(
                                      hostJobStatus: 'posting',
                                    ));
                                  }
                                }),
                          ),
                        ),
                        const SizedBox(height: 20),
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) => Opacity(
                            opacity: _animationController.value,
                            child: child,
                          ),
                          child: Card(
                            color: const Color.fromARGB(255, 192, 244, 210),
                            child: GFListTile(
                                avatar: GFAvatar(
                                  shape: GFAvatarShape.circle,
                                  backgroundColor:
                                      const Color.fromARGB(255, 192, 244, 210),
                                  child: Image.asset('image/choosing.png'),
                                ),
                                title: Text('Đã chọn thợ làm việc',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith()),
                                padding: EdgeInsets.zero,
                                radius: 50,
                                onTap: () async {
                                  await getHostJob.getHostJob(0, 'accept');
                                  if (hostJobData.isEmpty) {
                                    await AwesomeDialog(
                                      context: Get.context!,
                                      dialogType: DialogType.info,
                                      animType: AnimType.rightSlide,
                                      title:
                                          'Hiện tại không có công việc trạng thái này',
                                      titleTextStyle: GoogleFonts.poppins(),
                                      autoHide:
                                          const Duration(milliseconds: 800),
                                    ).show();
                                  } else {
                                    Get.to(const HostJobStatus(
                                      hostJobStatus: 'accept',
                                    ));
                                  }
                                }),
                          ),
                        ),
                        const SizedBox(height: 20),
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) => Opacity(
                            opacity: _animationController.value,
                            child: child,
                          ),
                          child: Card(
                            color: const Color.fromARGB(255, 192, 244, 210),
                            child: GFListTile(
                                avatar: GFAvatar(
                                  shape: GFAvatarShape.circle,
                                  backgroundColor:
                                      const Color.fromARGB(255, 192, 244, 210),
                                  child: Image.asset('image/cancel-order.png'),
                                ),
                                // titleText: vouchersValid[index].name,
                                title: Text('Công việc đã hủy',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith()),
                                padding: EdgeInsets.zero,
                                radius: 50,
                                onTap: () async {
                                  await getHostJob.getHostJob(0, 'cancel');
                                  if (hostJobData.isEmpty) {
                                    await AwesomeDialog(
                                      context: Get.context!,
                                      dialogType: DialogType.info,
                                      animType: AnimType.rightSlide,
                                      title:
                                          'Hiện tại không có công việc trạng thái này',
                                      titleTextStyle: GoogleFonts.poppins(),
                                      autoHide:
                                          const Duration(milliseconds: 800),
                                    ).show();
                                  } else {
                                    Get.to(const HostJobStatus(
                                      hostJobStatus: 'cancel',
                                    ));
                                  }
                                }),
                          ),
                        ),
                        const SizedBox(height: 20),
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) => Opacity(
                            opacity: _animationController.value,
                            child: child,
                          ),
                          child: Card(
                            color: const Color.fromARGB(255, 192, 244, 210),
                            child: GFListTile(
                                avatar: GFAvatar(
                                  shape: GFAvatarShape.circle,
                                  backgroundColor:
                                      const Color.fromARGB(255, 192, 244, 210),
                                  child: Image.asset('image/worker_done.png'),
                                ),
                                title: Text('Thợ báo hoàn tất',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith()),
                                padding: EdgeInsets.zero,
                                radius: 50,
                                onTap: () async {
                                  await getHostJob.getHostJob(0, 'worker_done');
                                  if (hostJobData.isEmpty) {
                                    await AwesomeDialog(
                                      context: Get.context!,
                                      dialogType: DialogType.info,
                                      animType: AnimType.rightSlide,
                                      title:
                                          'Hiện tại không có công việc trạng thái này',
                                      titleTextStyle: GoogleFonts.poppins(),
                                      autoHide:
                                          const Duration(milliseconds: 800),
                                    ).show();
                                  } else {
                                    Get.to(const HostJobStatus(
                                      hostJobStatus: 'worker_done',
                                    ));
                                  }
                                }),
                          ),
                        ),
                        const SizedBox(height: 20),
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) => Opacity(
                            opacity: _animationController.value,
                            child: child,
                          ),
                          child: Card(
                            color: const Color.fromARGB(255, 192, 244, 210),
                            child: GFListTile(
                                avatar: GFAvatar(
                                  shape: GFAvatarShape.circle,
                                  backgroundColor:
                                      const Color.fromARGB(255, 192, 244, 210),
                                  child: Image.asset(
                                    'image/marking_host.png',
                                  ),
                                ),
                                title: Text('Chủ nhà báo hoàn tất',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith()),
                                padding: EdgeInsets.zero,
                                radius: 50,
                                onTap: () async {
                                  await getHostJob.getHostJob(0, 'finish');
                                  if (hostJobData.isEmpty) {
                                    await AwesomeDialog(
                                      context: Get.context!,
                                      dialogType: DialogType.info,
                                      animType: AnimType.rightSlide,
                                      title:
                                          'Hiện tại không có công việc trạng thái này',
                                      titleTextStyle: GoogleFonts.poppins(),
                                      autoHide:
                                          const Duration(milliseconds: 800),
                                    ).show();
                                  } else {
                                    Get.to(const HostJobStatus(
                                      hostJobStatus: 'finish',
                                    ));
                                  }
                                }),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ]),
                ),
              ),
              // const TabBarView(
              //   physics: NeverScrollableScrollPhysics(),
              //   children: [
              //     HostJobStatus(
              //       hostJobStatus: '',
              //     ),
              //     HostJobStatus(
              //       hostJobStatus: 'posting',
              //     ),
              //     HostJobStatus(
              //       hostJobStatus: 'accept',
              //     ),
              //     HostJobStatus(
              //       hostJobStatus: 'cancel',
              //     ),
              //     HostJobStatus(
              //       hostJobStatus: 'worker_done',
              //     ),
              //     HostJobStatus(
              //       hostJobStatus: 'finish',
              //     ),
              //   ],
              // ),
            ),
          );
    // : Center(
    //     child: LoadingAnimationWidget.waveDots(
    //       color: const Color.fromRGBO(1, 142, 33, 1),
    //       size: 30,
    //     ),
    //   );
  }
}

class HostJobStatus extends StatefulWidget {
  const HostJobStatus({super.key, required this.hostJobStatus});
  final String hostJobStatus;
  @override
  State<HostJobStatus> createState() => _HostJobStatusState();
}

class _HostJobStatusState extends State<HostJobStatus>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animationController;
  GetHostJob getHostJob = Get.put(GetHostJob());
  GetAJob getAJob = Get.put(GetAJob());
  var currentIndex = 0;
  late var timer;
  bool isLoading = true;

  bool onLoading = false;

  getData() async {
    await getHostJob.getHostJob(currentIndex, widget.hostJobStatus);
    if (hostJobData.isNotEmpty) {
      setState(() {});
    }
  }

  @override
  bool get wantKeepAlive => true;
  @override
  void dispose() {
    timer.cancel();
    currentIndex = 0;
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0,
      upperBound: 1,
    );

    currentIndex = 0;

    if (mounted) {
      timer = Timer(const Duration(seconds: 3), () {
        getData();
        setState(() {
          isLoading = false;
        });
      });
    }

    // getData();

    _animationController.forward();
    super.initState();
  }

  Widget centerLoading = Center(
    child: LoadingAnimationWidget.waveDots(
      color: const Color.fromRGBO(1, 142, 33, 1),
      size: 30,
    ),
  );
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final widthDevice = MediaQuery.of(context).size.width;
    jobStatus(String status) {
      switch (status) {
        case 'posting':
          return 'Công việc mới đăng';
        // case 'apply':
        //   return 'Có thợ ứng tuyển';
        case 'accept':
          return 'Đã chọn thợ làm việc';
        case 'cancel':
          return 'Công việc đã hủy';
        case 'worker_done':
          return 'Thợ đã báo làm xong';
        case 'finish':
          return 'Chủ nhà đã báo hoàn tất';
        default:
          return 'Công việc';
      }
    }

    return
        // isLoading
        // ? centerLoading

        Scaffold(
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
            jobStatus(widget.hostJobStatus),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: widthDevice * 0.055,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // foregroundColor: Color.fromRGBO(54, 92, 69, 1),
        elevation: 3,
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.easeInOut),
          ),
          child: child,
        ),
        child: isLoading
            ? centerLoading
            : RefreshLoadmore(
                onRefresh: () async {
                  // setState(() {
                  //   isLoading = true;
                  // });
                  hostJobData.clear();
                  currentIndex = currentIndex == 0 ? 0 : currentIndex--;
                  // timer = Timer(const Duration(seconds: 3), () {
                  //   setState(() {
                  //     isLoading = false;
                  //     _animationController.forward();
                  //   });
                  // });

                  await getData();
                },
                noMoreWidget: Text(
                  'Không còn bài đăng',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                  ),
                ),
                onLoadmore: () async {
                  if (onLoading == false) {
                    await Future.delayed(const Duration(seconds: 6), () async {
                      currentIndex += 1;
                      await getHostJob.getHostJob(
                          currentIndex, widget.hostJobStatus);
                      if (mounted) {
                        setState(() {
                          // _animationController.forward();
                        });
                      }
                    });
                  }
                },
                isLastPage: getHostJob.isLastPage,
                child:
                    // hostJobData.isNotEmpty
                    // ?
                    SingleChildScrollView(
                  child: Column(
                    children: [
                      ...hostJobData.map((item) {
                        // var imgUrl = item.photos[0].split('"').join('').split('');
                        // imgUrl.removeAt(0);
                        // imgUrl.removeAt(imgUrl.length - 1);
                        var dateTime = DateTime.fromMillisecondsSinceEpoch(
                            int.parse(item.workDate),
                            isUtc: true);

                        // var date =
                        //     '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                        // var time =
                        //     '${dateTime.hour}:${dateTime.minute}';
                        var date =
                            '${dateTime.day < 10 ? 0 : ''}${dateTime.day}/${dateTime.month < 10 ? 0 : ''}${dateTime.month}/${dateTime.year}';
                        var time =
                            '${dateTime.hour < 10 ? 0 : ''}${dateTime.hour}:${dateTime.minute < 10 ? 0 : ''}${dateTime.minute}';
                        // var createAt =
                        //     DateTime.parse(item.priceHostJob.createAt)
                        //         .toString();
                        DateTime dateTimeCreateAt =
                            DateTime.parse(item.priceHostJob.createAt);

                        // Create a DateFormat instance
                        DateFormat dateFormat =
                            DateFormat("dd-MM-yyyy HH:mm:ss");

                        // Format the DateTime
                        String formattedDate =
                            dateFormat.format(dateTimeCreateAt.toLocal());
                        return GestureDetector(
                          onTap: () async {
                            await getAJob.getAJob(item.jobId);

                            Get.to(
                              () => ThongTinJobScreen(
                                jobInfo: getAJob.jobInfo,
                                date: date,
                                time: time,
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 0,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          119, 158, 158, 158)),
                                  borderRadius: BorderRadius.circular(12)),
                              width: MediaQuery.of(context).size.width * 0.95,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)),
                                      ),
                                      child: item.photos.isEmpty
                                          ? jobServiceList.firstWhereOrNull(
                                                    (element) =>
                                                        element.name.trim() ==
                                                        item.name.trim(),
                                                  ) ==
                                                  null
                                              ? Image.asset(
                                                  'image/logo_tho_thong_minh.jpeg')
                                              : Image.network(
                                                  jobServiceList
                                                      .firstWhere((element) =>
                                                          element.name.trim() ==
                                                          item.name.trim())
                                                      .img,
                                                )
                                          : CachedNetworkImage(
                                              imageUrl: item.photos[0]
                                                  .split('"')
                                                  .join(''),
                                              imageBuilder: (context,
                                                      imageProvider) =>
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10)),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                              memCacheWidth: 200,
                                              maxHeightDiskCache: 200,
                                              maxWidthDiskCache: 200),
                                    ),
                                    Flexible(
                                      child: Column(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        fontFamily: GoogleFonts
                                                                .poppins()
                                                            .fontFamily,
                                                        fontSize: 18,
                                                      ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 5),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  formattedDate,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        fontFamily: GoogleFonts
                                                                .poppins()
                                                            .fontFamily,
                                                        color: Colors.grey,
                                                      ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: false,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 25),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Vào $date lúc $time',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontFamily: GoogleFonts
                                                                .poppins()
                                                            .fontFamily,
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                      ),
                                                  softWrap: true,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Mô tả: ${item.description}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          fontFamily:
                                                              GoogleFonts
                                                                      .poppins()
                                                                  .fontFamily,
                                                          color: Colors.black,
                                                          fontSize: 13),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Trạng thái: ${jobStatus(item.status)}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          fontFamily:
                                                              GoogleFonts
                                                                      .poppins()
                                                                  .fontFamily,
                                                          color: Colors.black,
                                                          fontSize: 13),
                                                  softWrap: true,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        );
                      }).toList()
                    ],
                  ),
                )
                // : const Center(
                //     child: Text(
                //         'không có bài đăng công việc trạng thái này'),
                //   ),
                ),
      ),
    );
    // : const Center(
    //     child: Text('không có bài đăng công việc trạng thái này'),
    //   );
  }
}
// Image.asset(
//                                                       'image/no_image.png',
//                                                       color: Colors.grey)
