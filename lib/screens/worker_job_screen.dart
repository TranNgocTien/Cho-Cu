import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chotot/controllers/get_a_job.dart';

import 'package:chotot/controllers/get_worker_job.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/data/get_worker_job_data.dart';
import 'package:chotot/data/job_service_data.dart';
import 'package:chotot/data/login_data.dart';
import 'package:chotot/screens/host_rate_worker_screen.dart';

import 'package:chotot/screens/login.dart';
import 'package:chotot/screens/thong_tin_job_screen.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
// import 'package:chotot/models/get_host_job_model.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';

class CongViecWorkerScreen extends StatefulWidget {
  const CongViecWorkerScreen({super.key});
  static const route = '/lib/screens/congViecScreen.dart';

  @override
  State<CongViecWorkerScreen> createState() => _CongViecWorkerScreenState();
}

class _CongViecWorkerScreenState extends State<CongViecWorkerScreen>
    with SingleTickerProviderStateMixin {
  GetWorkerJob getWorkerJob = Get.put(GetWorkerJob());
  GetAJob getAJob = Get.put(GetAJob());
  LoginController loginController = Get.put(LoginController());
  bool isLoading = true;
  late AnimationController _animationController;
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

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                                    color: Colors.green),
                          )),
                    ]),
              ),
            ),
          )
        : isLoading
            ? GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Scaffold(
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
                        'Thợ - ${loginData[0].name}',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.bold,
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
                                      backgroundColor: const Color.fromARGB(
                                          255, 192, 244, 210),
                                      child: Image.asset(
                                          'image/new_icon/CONG_VIEC/THO/CONG_VIEC_DA_UNG_TUYEN.png'),
                                    ),
                                    description: Text('Công việc đã ứng tuyển',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith()),
                                    padding: EdgeInsets.zero,
                                    radius: 50,
                                    onTap: () async {
                                      await getWorkerJob.getWorkerJob(
                                          0, 'apply', true);
                                      if (workerJobData.isEmpty) {
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
                                        Get.to(const WorkerJobStatus(
                                          workerJobStatus: 'apply',
                                          isHostRate: false,
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
                                      backgroundColor: const Color.fromARGB(
                                          255, 192, 244, 210),
                                      child: Image.asset(
                                          'image/new_icon/CONG_VIEC/THO/CONG_VIEC_DUOC_TUYEN.png'),
                                    ),
                                    title: Text('Công việc được tuyển',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith()),
                                    padding: EdgeInsets.zero,
                                    radius: 50,
                                    onTap: () async {
                                      await getWorkerJob.getWorkerJob(
                                          0, 'accept', true);
                                      if (workerJobData.isEmpty) {
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
                                        Get.to(const WorkerJobStatus(
                                          workerJobStatus: 'accept',
                                          isHostRate: false,
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
                                      backgroundColor: const Color.fromARGB(
                                          255, 192, 244, 210),
                                      child: Image.asset(
                                          'image/new_icon/CONG_VIEC/THO/CONG_VIEC_DA_HUY.png'),
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
                                      await getWorkerJob.getWorkerJob(
                                          0, 'cancel', true);
                                      if (workerJobData.isEmpty) {
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
                                        Get.to(const WorkerJobStatus(
                                          workerJobStatus: 'cancel',
                                          isHostRate: false,
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
                                      backgroundColor: const Color.fromARGB(
                                          255, 192, 244, 210),
                                      child: Image.asset(
                                          'image/new_icon/CONG_VIEC/THO/THO_BAO_HOAN_TAT.png'),
                                    ),
                                    title: Text('Thợ báo hoàn tất',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith()),
                                    padding: EdgeInsets.zero,
                                    radius: 50,
                                    onTap: () async {
                                      await getWorkerJob.getWorkerJob(
                                          0, 'worker_done', true);
                                      if (workerJobData.isEmpty) {
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
                                        Get.to(const WorkerJobStatus(
                                          workerJobStatus: 'worker_done',
                                          isHostRate: false,
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
                                      backgroundColor: const Color.fromARGB(
                                          255, 192, 244, 210),
                                      child: Image.asset(
                                        'image/new_icon/CONG_VIEC/THO/CHU_NHA_BAO_HOAN_TAT.png',
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
                                      await getWorkerJob.getWorkerJob(
                                          0, 'finish', true);
                                      if (workerJobData.isEmpty) {
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
                                        Get.to(const WorkerJobStatus(
                                          workerJobStatus: 'finish',
                                          isHostRate: false,
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
                                      backgroundColor: const Color.fromARGB(
                                          255, 192, 244, 210),
                                      child: Image.asset(
                                        'image/new_icon/CONG_VIEC/THO/DANH_GIA_TU_CHU_NHA.png',
                                      ),
                                    ),
                                    title: Text('Đánh giá từ chủ nhà',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith()),
                                    padding: EdgeInsets.zero,
                                    radius: 50,
                                    onTap: () async {
                                      await getWorkerJob.getWorkerJob(
                                          0, 'finish', true);
                                      if (workerJobData.isEmpty) {
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
                                        Get.to(const WorkerJobStatus(
                                          workerJobStatus: 'finish',
                                          isHostRate: true,
                                        ));
                                      }
                                    }),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              )
            : Center(
                child: LoadingAnimationWidget.waveDots(
                  color: const Color.fromRGBO(1, 142, 33, 1),
                  size: 30,
                ),
              );
  }
}

class WorkerJobStatus extends StatefulWidget {
  const WorkerJobStatus(
      {super.key, required this.workerJobStatus, required this.isHostRate});
  final String workerJobStatus;
  final bool isHostRate;
  @override
  State<WorkerJobStatus> createState() => _WorkerJobStatusState();
}

class _WorkerJobStatusState extends State<WorkerJobStatus>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animationController;
  GetWorkerJob getWorkerJob = Get.put(GetWorkerJob());
  GetAJob getAJob = Get.put(GetAJob());
  var currentIndex = 0;
  late var timer;
  bool isLoading = true;

  bool onLoading = false;

  getData() async {
    await getWorkerJob.getWorkerJob(
        currentIndex, widget.workerJobStatus, false);
    if (workerJobData.isNotEmpty) {
      setState(() {});
    }
  }

  @override
  bool get wantKeepAlive => true;
  @override
  void dispose() {
    timer.cancel();
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
    jobStatus(String status) {
      switch (status) {
        case 'posting':
          return 'Công việc ứng tuyển';
        case 'apply':
          return 'Công việc ứng tuyển';
        case 'accept':
          return 'Công việc được tuyển';
        case 'cancel':
          return 'Công việc đã hủy';
        case 'worker_done':
          return 'Thợ đã báo hoàn tất';
        case 'finish':
          return 'Chủ nhà đã báo hoàn tất';
        default:
          return 'Công việc';
      }
    }

    return
        // isLoading
        //     ? centerLoading
        //     : workerJobData.isNotEmpty
        //         ?
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
            jobStatus(widget.workerJobStatus),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
                  workerJobData.clear();
                  currentIndex = currentIndex == 0 ? 0 : currentIndex--;
                  // timer = Timer(const Duration(seconds: 3), () {
                  //   setState(() {
                  //     isLoading = false;
                  //     _animationController.forward();
                  //   });
                  // });

                  await getData();
                  setState(() {
                    getWorkerJob.isLoading = false;
                  });
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
                      await getWorkerJob.getWorkerJob(
                          currentIndex, widget.workerJobStatus, false);
                      if (mounted) {
                        setState(() {
                          // _animationController.forward();
                        });
                      }
                    });
                  }
                },
                isLastPage: getWorkerJob.isLastPage,
                child:
                    //  workerJobData.isNotEmpty
                    //     ?
                    SingleChildScrollView(
                  child: Column(
                    children: [
                      ...workerJobData.map((item) {
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
                        var createAt =
                            DateTime.parse(item.priceWorkerJob.createAt)
                                .toString();

                        return GestureDetector(
                          onTap: () async {
                            await getAJob.getAJob(item.jobId);
                            widget.isHostRate == true
                                ? Get.to(() => HostRateWorkerScreen(
                                    jobInfo: getAJob.jobInfo,
                                    date: date,
                                    time: time))
                                : Get.to(() => ThongTinJobScreen(
                                    jobInfo: getAJob.jobInfo,
                                    date: date,
                                    time: time));
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
                                              0.17,
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
                                                  createAt.substring(
                                                      0, createAt.length - 5),
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
                ),
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


