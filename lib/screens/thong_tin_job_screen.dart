// import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:basic_utils/basic_utils.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chotot/controllers/accept_worker.dart';
import 'package:chotot/controllers/apply_job.dart';
import 'package:chotot/controllers/get_job_by_type_2.dart';
import 'package:chotot/controllers/host_done.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/controllers/worker_done.dart';
import 'package:chotot/data/job_service_data.dart';
import 'package:chotot/data/ly_lich.dart';

import 'package:chotot/models/get_a_job_model.dart';
import 'package:chotot/screens/homeScreen.dart';
import 'package:chotot/screens/host_rate_screen.dart';
import 'package:chotot/screens/worker_rate_screen.dart';

import 'package:flutter/material.dart';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

// import 'package:getwidget/components/avatar/gf_avatar.dart';
// import 'package:getwidget/components/list_tile/gf_list_tile.dart';
// import 'package:getwidget/shape/gf_avatar_shape.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';

class ThongTinJobScreen extends StatefulWidget {
  const ThongTinJobScreen({
    super.key,
    required this.jobInfo,
    required this.date,
    required this.time,
  });
  final List<GetAJobModel> jobInfo;
  final String date;
  final String time;
  @override
  State<ThongTinJobScreen> createState() => _ThongTinJobScreenState();
}

class _ThongTinJobScreenState extends State<ThongTinJobScreen> {
  jobStatusHost(String status) {
    switch (status) {
      case 'posting':
        return 'công việc mới đăng';
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
    }
  }

  jobStatusWorker(String status) {
    switch (status) {
      case 'posting':
        return 'Công việc ứng tuyển';
      case 'accept':
        return 'Công việc được tuyển';
      case 'cancel':
        return 'Công việc đã hủy';
      case 'worker_done':
        return 'Thợ đã báo hoàn tất';
      case 'finish':
        return 'Chủ nhà đã báo hoàn tất';
    }
  }

  ApplyJob applyJob = Get.put(ApplyJob());
  AcceptWorker acceptWorker = Get.put(AcceptWorker());
  LoginController loginController = Get.put(LoginController());
  Workerdone workerdone = Get.put(Workerdone());
  HostDone hostDone = Get.put(HostDone());
  GetJobByType2 getJobByType2 = Get.put(GetJobByType2());
  var currentIndex = 0;
  void showCustomDialog(BuildContext context) {
    final widthDevice = MediaQuery.of(context).size.width;
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.info,
      animType: AnimType.rightSlide,
      body: Column(
        children: [
          Text(
            'Nhắn cho chủ nhà để ứng tuyển công việc:',
            style: GoogleFonts.poppins(
              fontSize: widthDevice * 0.04,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15.0),
          TextFormField(
            style: GoogleFonts.poppins(color: Colors.black87),
            maxLines: 10,
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(38, 166, 83, 1),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 47, 164, 88),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14,
                )),
            controller: applyJob.description,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                textColor: Colors.white,
                color: Colors.red,
                elevation: 15.0,
                onPressed: () {
                  Get.back();
                },
                child: Text('Hủy bỏ',
                    style: GoogleFonts.poppins(
                      fontSize: widthDevice * 0.035,
                    )),
              ),
              MaterialButton(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                textColor: Colors.white,
                elevation: 15.0,
                color: Colors.green,
                onPressed: () async {
                  await applyJob.applyJob(
                      widget.jobInfo[0].jobId, widget.jobInfo[0].workerId);

                  Get.back();
                },
                child: Text('Xác nhận',
                    style: GoogleFonts.poppins(
                      fontSize: widthDevice * 0.035,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
      titleTextStyle: GoogleFonts.poppins(),
    ).show();
  }

  void _modalBottomSheetMenu(String employeeId) async {
    WorkerAJob worker = widget.jobInfo[0].workers
        .firstWhere((worker) => worker.id.toString() == employeeId);
    showMaterialModalBottomSheet(
        duration: const Duration(
          milliseconds: 300,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: Get.context!,
        builder: (context) {
          currentIndex = 0;
          final widthDevice = MediaQuery.of(context).size.width;
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      // color: Color.fromRGBO(38, 166, 83, 1),
                      color: Color.fromRGBO(38, 166, 83, 1),
                      // size: 35,
                    ),
                  ),
                ),
                body: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //ádasdsadsa

                        ///ádsadsadsa
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: RefreshLoadmore(
                            onRefresh: () async {
                              mystate(() {});
                              currentIndex = currentIndex - 1;
                              await Future.delayed(const Duration(seconds: 3),
                                  () async {
                                await getJobByType2.getJobByType2(
                                  employeeId,
                                  (currentIndex).toString(),
                                );
                              });

                              mystate(() {});
                            },
                            noMoreWidget: Center(
                              child: Text(
                                'Không còn đánh giá nào khác',
                                style: GoogleFonts.poppins(
                                    fontSize: widthDevice * 0.035),
                              ),
                            ),
                            onLoadmore: () async {
                              mystate(() {});
                              currentIndex = currentIndex + 1;
                              await Future.delayed(const Duration(seconds: 3),
                                  () async {
                                await getJobByType2.getJobByType2(
                                  employeeId,
                                  (currentIndex).toString(),
                                );
                              });

                              mystate(() {});
                            },
                            isLastPage: getJobByType2.isLastPage,
                            child: Column(
                              children: [
                                //ádasdsadsa
                                CircleAvatar(
                                  radius: 100.0,
                                  backgroundColor:
                                      const Color.fromRGBO(84, 181, 111, 1),
                                  child: CircleAvatar(
                                    radius: 90.0,
                                    backgroundImage:
                                        NetworkImage(worker.profileImage),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                        color: Colors.grey,
                                      )),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const SizedBox(height: 30),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              'image/construction-worker.png',
                                              height: 40,
                                              width: 40,
                                            ),
                                            const SizedBox(width: 10),
                                            Text('Tên thợ:',
                                                style: GoogleFonts.poppins(
                                                    fontSize:
                                                        widthDevice * 0.035)),
                                            const SizedBox(width: 20),
                                            Text(worker.name,
                                                style: GoogleFonts.poppins(
                                                    fontSize:
                                                        widthDevice * 0.035)),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              'image/phone-call.png',
                                              height: 40,
                                              width: 40,
                                            ),
                                            const SizedBox(width: 10),
                                            Text('Số điện thoại:',
                                                style: GoogleFonts.poppins(
                                                    fontSize:
                                                        widthDevice * 0.035)),
                                            const SizedBox(width: 20),
                                            Text(
                                                widget.jobInfo[0].status
                                                                .toString() ==
                                                            'accept' &&
                                                        widget.jobInfo[0]
                                                                .employee.id ==
                                                            employeeId
                                                    ? worker.phone
                                                    : '******${worker.phone.substring(worker.phone.length - 4)}',
                                                style: GoogleFonts.poppins(
                                                    fontSize:
                                                        widthDevice * 0.035)),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              'image/star.png',
                                              height: 40,
                                              width: 40,
                                            ),
                                            const SizedBox(width: 10),
                                            Text('Điểm đánh giá:',
                                                style: GoogleFonts.poppins(
                                                    fontSize:
                                                        widthDevice * 0.035)),
                                            const SizedBox(width: 20),
                                            Text(
                                                (double.tryParse(worker.ds)! /
                                                        20)
                                                    .toStringAsFixed(1),
                                                style: GoogleFonts.poppins(
                                                    fontSize:
                                                        widthDevice * 0.035)),
                                            Image.asset(
                                              'image/star.png',
                                              height: 20,
                                              width: 20,
                                            ),
                                            Text(
                                                '(${double.parse(worker.ds).toStringAsFixed(1)})',
                                                style: GoogleFonts.poppins(
                                                    fontSize:
                                                        widthDevice * 0.035)),
                                          ],
                                        ),
                                      ],
                                    )),

                                const SizedBox(height: 20.0),

                                widget.jobInfo[0].status.toString() != 'posting'
                                    ? const SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          MaterialButton(
                                            elevation: 10.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            height: 30.0,
                                            minWidth: 100.0,
                                            color: Colors.red,
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text('Hủy bỏ',
                                                style: GoogleFonts.poppins(
                                                  fontSize: widthDevice * 0.035,
                                                  color: Colors.white,
                                                )),
                                          ),
                                          MaterialButton(
                                            elevation: 10.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            height: 30.0,
                                            minWidth: 100.0,
                                            color: Colors.green,
                                            onPressed: () async {
                                              await acceptWorker.acceptWorker(
                                                  widget.jobInfo[0].contracts
                                                      .firstWhere((contract) =>
                                                          contract.employeeId ==
                                                          employeeId)
                                                      .jobId,
                                                  widget.jobInfo[0].contracts
                                                      .firstWhere((contract) =>
                                                          contract.employeeId ==
                                                          employeeId)
                                                      .contractId,
                                                  widget.jobInfo[0].priceId);
                                              Get.to(() => const MainScreen());
                                            },
                                            child: Text('Chọn thợ này',
                                                style: GoogleFonts.poppins(
                                                  fontSize: widthDevice * 0.035,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ],
                                      ),
                                const SizedBox(height: 20.0),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Text(
                                    'Đánh giá của khách hàng trước',
                                    style: GoogleFonts.poppins(
                                        fontSize: widthDevice * 0.04,
                                        color: const Color.fromRGBO(
                                            38, 166, 83, 1)),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                const SizedBox(height: 20.0),

                                ///ádsadsadsa
                                ...getJobByType2.rateList.map((rate) {
                                  var nameHost = '';
                                  String dateRateString = '';
                                  if (rate.id != '') {
                                    nameHost = getJobByType2.contractList
                                        .firstWhere((contract) =>
                                            contract.contractId ==
                                            rate.contractId)
                                        .hostName;
                                    var dateRate =
                                        DateTime.parse(rate.time).toLocal();
                                    dateRateString =
                                        '${dateRate.day < 10 ? 0 : ''}${dateRate.day}-${dateRate.month < 10 ? 0 : ''}${dateRate.month}-${dateRate.year} ';
                                  }
                                  var index =
                                      getJobByType2.rateList.indexOf(rate);
                                  DateTime date = DateTime.parse(getJobByType2
                                          .contractList[index].createdAt)
                                      .toLocal();

                                  return nameHost != ''
                                      ? Card(
                                          color: Colors.white,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            // height: MediaQuery.of(context).size.height * 0.2,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 15.0),
                                                  decoration:
                                                      const BoxDecoration(
                                                          border: Border(
                                                              bottom:
                                                                  BorderSide(
                                                    color: Colors.grey,
                                                  ))),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Đánh giá từ chủ nhà',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize:
                                                                    widthDevice *
                                                                        0.035),
                                                      ),
                                                      Text(
                                                        nameHost,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize:
                                                                    widthDevice *
                                                                        0.035),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const SizedBox(),
                                                    Text(
                                                      dateRateString,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            widthDevice * 0.035,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                rate.content.isNotEmpty
                                                    ? Text(
                                                        rate.content,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize:
                                                                    widthDevice *
                                                                        0.035,
                                                                color: Colors
                                                                    .grey),
                                                      )
                                                    : SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.75),
                                                Row(children: [
                                                  Wrap(
                                                    direction: Axis.vertical,
                                                    spacing: 12.0,
                                                    children: [
                                                      Text(
                                                        'Khả năng chuyên môn:',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize:
                                                                    widthDevice *
                                                                        0.035),
                                                      ),
                                                      Text(
                                                        'Thái độ công việc:',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize:
                                                                    widthDevice *
                                                                        0.035),
                                                      ),
                                                      Text(
                                                        'Đến đúng giờ:',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize:
                                                                    widthDevice *
                                                                        0.035),
                                                      ),
                                                      Text(
                                                        'Kỹ thuật/ Kỹ năng:',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize:
                                                                    widthDevice *
                                                                        0.035),
                                                      ),
                                                      Text(
                                                        'Mức độ hài lòng:',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize:
                                                                    widthDevice *
                                                                        0.035),
                                                      ),
                                                      Text(
                                                        'Trung bình:',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize:
                                                                    widthDevice *
                                                                        0.035),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 40.0),
                                                  Wrap(
                                                    direction: Axis.vertical,
                                                    spacing: 9.0,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            (double.parse(rate
                                                                        .d1) /
                                                                    20)
                                                                .toString(),
                                                            style: GoogleFonts.poppins(
                                                                fontSize:
                                                                    widthDevice *
                                                                        0.035),
                                                          ),
                                                          Icon(Icons.star,
                                                              size:
                                                                  widthDevice *
                                                                      0.06,
                                                              color: Colors
                                                                  .yellow),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            (double.parse(rate
                                                                        .d2) /
                                                                    20)
                                                                .toString(),
                                                            style: GoogleFonts.poppins(
                                                                fontSize:
                                                                    widthDevice *
                                                                        0.035),
                                                          ),
                                                          Icon(Icons.star,
                                                              size:
                                                                  widthDevice *
                                                                      0.06,
                                                              color: Colors
                                                                  .yellow),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            (double.parse(rate
                                                                        .d3) /
                                                                    20)
                                                                .toString(),
                                                            style: GoogleFonts.poppins(
                                                                fontSize:
                                                                    widthDevice *
                                                                        0.035),
                                                          ),
                                                          Icon(Icons.star,
                                                              size:
                                                                  widthDevice *
                                                                      0.06,
                                                              color: Colors
                                                                  .yellow),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            (double.parse(rate
                                                                        .d4) /
                                                                    20)
                                                                .toString(),
                                                            style: GoogleFonts.poppins(
                                                                fontSize:
                                                                    widthDevice *
                                                                        0.035),
                                                          ),
                                                          Icon(Icons.star,
                                                              size:
                                                                  widthDevice *
                                                                      0.06,
                                                              color: Colors
                                                                  .yellow),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            (double.parse(rate
                                                                        .d5) /
                                                                    20)
                                                                .toString(),
                                                            style: GoogleFonts.poppins(
                                                                fontSize:
                                                                    widthDevice *
                                                                        0.035),
                                                          ),
                                                          Icon(Icons.star,
                                                              size:
                                                                  widthDevice *
                                                                      0.06,
                                                              color: Colors
                                                                  .yellow),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            (double.parse(rate
                                                                        .ds) /
                                                                    20)
                                                                .toString(),
                                                            style: GoogleFonts.poppins(
                                                                fontSize:
                                                                    widthDevice *
                                                                        0.035),
                                                          ),
                                                          Icon(Icons.star,
                                                              size:
                                                                  widthDevice *
                                                                      0.06,
                                                              color: Colors
                                                                  .yellow),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Card(
                                          color: Colors.white,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            // height: MediaQuery.of(context).size.height * 0.2,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Icon(
                                                            Icons
                                                                .production_quantity_limits_outlined,
                                                            color:
                                                                Color.fromRGBO(
                                                                    38,
                                                                    166,
                                                                    83,
                                                                    1)),
                                                        const SizedBox(
                                                            width: 5),
                                                        Flexible(
                                                          child: Text(
                                                            getJobByType2
                                                                .contractList[
                                                                    index]
                                                                .jobName,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize:
                                                                  widthDevice *
                                                                      0.035,
                                                            ),
                                                            softWrap: true,
                                                            maxLines: 3,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Icon(
                                                            Icons
                                                                .timer_outlined,
                                                            color:
                                                                Color.fromRGBO(
                                                                    38,
                                                                    166,
                                                                    83,
                                                                    1)),
                                                        const SizedBox(
                                                            width: 5),
                                                        Flexible(
                                                          child: Text(
                                                            '${date.hour < 10 ? '0' : ""}${date.hour}: ${date.minute < 10 ? '0' : ''}${date.minute} Ngày ${date.day < 10 ? '0' : ''}${date.day}/${date.month < 10 ? '0' : ''}${date.month}/${date.year}',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize:
                                                                  widthDevice *
                                                                      0.035,
                                                            ),
                                                            softWrap: true,
                                                            maxLines: 3,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .system_security_update_good_outlined,
                                                        color: Color.fromRGBO(
                                                          38,
                                                          166,
                                                          83,
                                                          1,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Flexible(
                                                        child: Text(
                                                          'Thợ này được hệ thống Thợ Thông Minh đánh giá ${double.parse(worker.ds).toStringAsFixed(1)}/100 điểm',
                                                          softWrap: true,
                                                          maxLines: 3,
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize:
                                                                      widthDevice *
                                                                          0.035),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ));
                                }),
                                SizedBox(height: widthDevice * 0.3),
                              ],
                            ),
                            // ListView.builder(
                            //   itemCount: getJobByType2.rateList.length,
                            //   itemBuilder: (BuildContext context, int index) {

                            //     return
                            //   },
                            // ),
                          ),
                        ),

                        // ListView.builder(
                        //   itemCount: getJobByType2.rateList.length,
                        //   itemBuilder: (BuildContext context, int index) {

                        //     return
                        //   },
                        // ),
                        SizedBox(height: widthDevice * 0.3),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  bool isLoading = true;

  String registed = '';
  @override
  void initState() {
    currentIndex = 0;
    registed = widget.jobInfo[0].contracts
        .any((element) => element.employeeId == loginController.hostId)
        .toString();
    Timer(const Duration(milliseconds: 1000), () async {
      setState(() {
        isLoading = false;
      });
    });
    // print(widget.jobInfo[0].status);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final priceReverseSum = StringUtils.addCharAtPosition(
        StringUtils.reverse(widget.jobInfo[0].sumPrice), ".", 3,
        repeat: true);
    final widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          // backgroundColor: Colors.transparent,
          backgroundColor: const Color.fromRGBO(38, 166, 83, 1),
          title: Text(
            'Thợ thông minh',
            style: GoogleFonts.poppins(
                color: Colors.white, fontSize: widthDevice * 0.055),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              // color: Color.fromRGBO(38, 166, 83, 1),
              color: Colors.white,
              // size: 35,
            ),
          ),
        ),
        body: isLoading
            ? Center(
                child: LoadingAnimationWidget.waveDots(
                  color: const Color.fromRGBO(1, 142, 33, 1),
                  size: 30,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 400.0,
                          autoPlay: true,
                          enableInfiniteScroll: false,
                          viewportFraction: 1,
                        ),
                        items: widget.jobInfo[0].photos.isEmpty
                            ? [
                                InstaImageViewer(
                                  child: Container(
                                    // margin: const EdgeInsets.all(8),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Center(
                                      child: Builder(
                                        builder: (BuildContext context) {
                                          return Stack(children: [
                                            Container(
                                                padding: EdgeInsets.all(10.0),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                ),
                                                child: jobServiceList
                                                            .firstWhereOrNull(
                                                          (element) =>
                                                              element.name
                                                                  .trim() ==
                                                              widget.jobInfo[0]
                                                                  .name
                                                                  .trim(),
                                                        ) ==
                                                        null
                                                    ? Image.asset(
                                                        'image/logo_tho_thong_minh.jpeg')
                                                    : Image.network(
                                                        jobServiceList
                                                            .firstWhere(
                                                                (element) =>
                                                                    element.name
                                                                        .trim() ==
                                                                    widget
                                                                        .jobInfo[
                                                                            0]
                                                                        .name
                                                                        .trim())
                                                            .img,
                                                        fit: BoxFit.contain,
                                                        height: double.infinity,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                      )),
                                          ]);
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ]
                            : widget.jobInfo[0].photos.map((photo) {
                                return InstaImageViewer(
                                  child: Container(
                                    // margin: const EdgeInsets.all(8),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Center(
                                      child: Builder(
                                        builder: (BuildContext context) {
                                          return Stack(children: [
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                              child: Image.network(
                                                photo.split('"').join(''),
                                                fit: BoxFit.cover,
                                                height: double.infinity,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 4,
                                              right: 4,
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 30,
                                                width: 30,
                                                decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      93, 0, 0, 0),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Text(
                                                  '${widget.jobInfo[0].photos.indexOf(photo) + 1}/${widget.jobInfo[0].photos.length}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        widthDevice * 0.035,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            )
                                          ]);
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(widget.jobInfo[0].name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w600,
                                  fontSize: widthDevice * 0.05,
                                  color: const Color.fromRGBO(38, 166, 83, 1),
                                ),
                            textAlign: TextAlign.start),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            border: Border(
                          top: BorderSide(
                            color: Colors.grey,
                          ),
                        )),
                      ),

                      widget.jobInfo[0].status == 'accept' &&
                              widget.jobInfo[0].contract.employeeId ==
                                  loginController.hostId
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text('Trạng thái:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontWeight: FontWeight.w600,
                                          fontSize: widthDevice * 0.035,
                                          color: Colors.black87),
                                  textAlign: TextAlign.start),
                            )
                          : const SizedBox(),
                      widget.jobInfo[0].status == 'accept' &&
                              widget.jobInfo[0].contract.employeeId ==
                                  loginController.hostId
                          ? const SizedBox(height: 10)
                          : const SizedBox(),
                      widget.jobInfo[0].status == 'accept' &&
                              widget.jobInfo[0].contract.employeeId ==
                                  loginController.hostId
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                  widget.jobInfo[0].hostId ==
                                          loginController.hostId
                                      ? jobStatusHost(
                                          widget.jobInfo[0].status.toString())
                                      : jobStatusWorker(
                                          widget.jobInfo[0].status.toString()),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: widthDevice * 0.035,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54),
                                  textAlign: TextAlign.start),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text('Mô tả:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.w600,
                                    fontSize: widthDevice * 0.04,
                                    color: Colors.black87),
                            textAlign: TextAlign.start),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(widget.jobInfo[0].description,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.w600,
                                    fontSize: widthDevice * 0.035,
                                    color: Colors.black54),
                            textAlign: TextAlign.start),
                      ),
                      const SizedBox(height: 10),
                      widget.jobInfo[0].status == 'accept' &&
                              widget.jobInfo[0].contract.hostId ==
                                  loginController.hostId
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                  'Địa chỉ ${widget.jobInfo[0].host.id == loginController.hostId ? 'thợ' : 'chủ nhà'}:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontWeight: FontWeight.w600,
                                          fontSize: widthDevice * 0.04,
                                          color: Colors.black87),
                                  textAlign: TextAlign.start),
                            )
                          : const SizedBox(),

                      widget.jobInfo[0].status == 'accept' &&
                              widget.jobInfo[0].contract.employeeId ==
                                  loginController.hostId
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                  'Địa chỉ ${widget.jobInfo[0].host.id == loginController.hostId ? 'thợ' : 'chủ nhà'}:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontWeight: FontWeight.w600,
                                          fontSize: widthDevice * 0.035,
                                          color: Colors.black87),
                                  textAlign: TextAlign.start),
                            )
                          : const SizedBox(),
                      widget.jobInfo[0].workerId == loginController.hostId ||
                              widget.jobInfo[0].hostId == loginController.hostId
                          ? const SizedBox(height: 10)
                          : const SizedBox(),
                      // widget.jobInfo[0].workerId == loginController.hostId ||
                      //         widget.jobInfo[0].hostId == loginController.hostId
                      widget.jobInfo[0].status == 'accept' &&
                              widget.jobInfo[0].contract.hostId ==
                                  loginController.hostId
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                  widget.jobInfo[0].host.id ==
                                          loginController.hostId
                                      ? widget.jobInfo[0].employee.address
                                      : widget.jobInfo[0].address,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: widthDevice * 0.035,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54),
                                  textAlign: TextAlign.start),
                            )
                          : const SizedBox(),
                      widget.jobInfo[0].status == 'accept' &&
                              widget.jobInfo[0].contract.employeeId ==
                                  loginController.hostId
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                  widget.jobInfo[0].host.id ==
                                          loginController.hostId
                                      ? widget.jobInfo[0].employee.address
                                      : widget.jobInfo[0].address,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: widthDevice * 0.035,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54),
                                  textAlign: TextAlign.start),
                            )
                          : const SizedBox(),
                      widget.jobInfo[0].workerId == loginController.hostId ||
                              widget.jobInfo[0].hostId == loginController.hostId
                          ? const SizedBox(height: 20)
                          : const SizedBox(),
                      // widget.jobInfo[0].workerId == loginController.hostId ||
                      //         widget.jobInfo[0].hostId == loginController.hostId
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.jobInfo[0].status == 'accept' &&
                                      widget.jobInfo[0].contract.hostId ==
                                          loginController.hostId
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Text(
                                          'Số điện thoại liên hệ ${widget.jobInfo[0].host.id == loginController.hostId ? 'thợ' : 'chủ nhà'}:',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: widthDevice * 0.04,
                                                  color: Colors.black87),
                                          textAlign: TextAlign.start),
                                    )
                                  : const SizedBox(),
                              widget.jobInfo[0].status == 'accept' &&
                                      widget.jobInfo[0].contract.employeeId ==
                                          loginController.hostId
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Text(
                                          'Số điện thoại liên hệ ${widget.jobInfo[0].host.id == loginController.hostId ? 'thợ' : 'chủ nhà'}:',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                  fontSize: widthDevice * 0.035,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87),
                                          textAlign: TextAlign.start),
                                    )
                                  : const SizedBox(),
                              const SizedBox(height: 10),
                              // widget.jobInfo[0].workerId == loginController.hostId ||
                              //         widget.jobInfo[0].hostId == loginController.hostId
                              widget.jobInfo[0].status == 'accept' &&
                                      widget.jobInfo[0].contract.employeeId ==
                                          loginController.hostId
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Text(
                                          widget.jobInfo[0].host.id ==
                                                  loginController.hostId
                                              ? widget.jobInfo[0].employee.phone
                                              : widget.jobInfo[0].phone,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: widthDevice * 0.035,
                                                  color: Colors.black54),
                                          textAlign: TextAlign.start),
                                    )
                                  : const SizedBox(),
                              widget.jobInfo[0].status == 'accept' &&
                                      widget.jobInfo[0].contract.hostId ==
                                          loginController.hostId
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Text(
                                          widget.jobInfo[0].host.id ==
                                                  loginController.hostId
                                              ? widget.jobInfo[0].employee.phone
                                              : widget.jobInfo[0].phone,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: widthDevice * 0.035,
                                                  color: Colors.black54),
                                          textAlign: TextAlign.start),
                                    )
                                  : const SizedBox(),
                              const SizedBox(height: 15),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text('Thời gian làm việc:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                            fontWeight: FontWeight.w600,
                                            fontSize: widthDevice * 0.04,
                                            color: Colors.black87),
                                    textAlign: TextAlign.start),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                    '${widget.time} ngày ${widget.date}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                            fontWeight: FontWeight.w600,
                                            fontSize: widthDevice * 0.035,
                                            color: Colors.black54),
                                    textAlign: TextAlign.start),
                              ),
                            ],
                          ),
                          widget.jobInfo[0].status == 'accept' &&
                                  widget.jobInfo[0].contract.hostId ==
                                      loginController.hostId
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Image.network(
                                    widget.jobInfo[0].employee.profileImage,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height:
                                        MediaQuery.of(context).size.width * 0.3,
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),

                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text('Danh sách các dịch vụ:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.w600,
                                    fontSize: widthDevice * 0.04,
                                    color: Colors.black87),
                            textAlign: TextAlign.start),
                      ),
                      const SizedBox(height: 10),
                      ...widget.jobInfo[0].service.map((service) {
                        final priceReverse = StringUtils.addCharAtPosition(
                            StringUtils.reverse(service.price), ".", 3,
                            repeat: true);

                        final sumPriceReverse = StringUtils.addCharAtPosition(
                            StringUtils.reverse(
                                (int.parse(service.price) * service.qt)
                                    .toString()),
                            ".",
                            3,
                            repeat: true);
                        return Card(
                          color: Colors.white,
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.only(
                                  right: 20, top: 10, bottom: 10),
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: Text(
                                ' ${StringUtils.reverse(priceReverse)} x ${service.qt}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontWeight: FontWeight.w600,
                                        fontSize: widthDevice * 0.035,
                                        color: Colors.black87),
                              ),
                            ),
                            title: service.name != 'null'
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      service.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              fontWeight: FontWeight.w600,
                                              fontSize: widthDevice * 0.035,
                                              color: Colors.black87),
                                    ),
                                  )
                                : const Text(''),
                            subtitle: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                service.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontWeight: FontWeight.w600,
                                        fontSize: widthDevice * 0.035,
                                        color: Colors.black54),
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 10, bottom: 10),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: Text(
                                '${StringUtils.reverse(sumPriceReverse)} Đ',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontWeight: FontWeight.w600,
                                        fontSize: widthDevice * 0.035,
                                        color: Colors.black87),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 15),
                      widget.jobInfo[0].host.id == loginController.hostId
                          ? widget.jobInfo[0].status.toString() != 'cancel'
                              ? widget.jobInfo[0].status.toString() == 'accept'
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Text('Thợ đã tuyển',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                  fontSize: widthDevice * 0.035,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87),
                                          textAlign: TextAlign.start),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Text('Danh sách thợ ứng tuyển',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                  fontSize: widthDevice * 0.035,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87),
                                          textAlign: TextAlign.start),
                                    )
                              : const SizedBox()
                          : const SizedBox(),
                      const SizedBox(height: 10),
                      // if(  widget.jobInfo[0].status.toString()=='accept')

                      widget.jobInfo[0].host.id == loginController.hostId
                          ? widget.jobInfo[0].status.toString() == 'accept'
                              ? GestureDetector(
                                  onTap: () async {
                                    if (loginController.hostId ==
                                        widget.jobInfo[0].host.id) {
                                      getJobByType2.rateList.clear();
                                      getJobByType2.contractList.clear();
                                      await getJobByType2.getJobByType2(
                                          widget.jobInfo[0].employee.id, '0');
                                      _modalBottomSheetMenu(
                                          widget.jobInfo[0].employee.id);
                                    } else {
                                      return;
                                    }
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    child: ListTile(
                                      title: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          widget.jobInfo[0].employee.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: widthDevice * 0.035,
                                                  color: Colors.black87),
                                        ),
                                      ),
                                      trailing: Container(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 10, bottom: 10),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            left:
                                                BorderSide(color: Colors.grey),
                                          ),
                                        ),
                                        child: Text(
                                          'Đã tuyển',
                                          style: GoogleFonts.poppins(
                                            color: const Color.fromRGBO(
                                                38, 166, 83, 1),
                                            fontSize: widthDevice * 0.035,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Column(children: [
                                  ...widget.jobInfo[0].contracts
                                      .map((contract) {
                                    return widget.jobInfo[0].status
                                                .toString() ==
                                            'cancel'
                                        ? const SizedBox()
                                        : GestureDetector(
                                            onTap: () async {
                                              if (loginController.hostId ==
                                                  widget.jobInfo[0].host.id) {
                                                getJobByType2.rateList.clear();
                                                getJobByType2.contractList
                                                    .clear();
                                                await getJobByType2
                                                    .getJobByType2(
                                                        contract.employeeId,
                                                        '0');
                                                _modalBottomSheetMenu(
                                                    contract.employeeId);
                                              }
                                            },
                                            child: Card(
                                              color: Colors.white,
                                              child: ListTile(
                                                // leading: Container(
                                                //   padding:
                                                //       const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                                                //   decoration: const BoxDecoration(
                                                //     border: Border(
                                                //       right: BorderSide(color: Colors.grey),
                                                //     ),
                                                //   ),
                                                //   child: Text(
                                                //     ,
                                                //     style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                                //         fontFamily: GoogleFonts.poppins().fontFamily,
                                                //         fontWeight: FontWeight.w600,
                                                //         color: Colors.black87),
                                                //   ),
                                                // ),
                                                title: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    contract.employeeName,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .copyWith(
                                                            fontFamily:
                                                                GoogleFonts
                                                                        .poppins()
                                                                    .fontFamily,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize:
                                                                widthDevice *
                                                                    0.035,
                                                            color:
                                                                Colors.black87),
                                                  ),
                                                ),
                                                subtitle: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    contract.description,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .copyWith(
                                                          fontFamily:
                                                              GoogleFonts
                                                                      .poppins()
                                                                  .fontFamily,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              widthDevice *
                                                                  0.035,
                                                          color: Colors.black54,
                                                        ),
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                                trailing: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20,
                                                          top: 10,
                                                          bottom: 10),
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      left: BorderSide(
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Xem thợ',
                                                    style: GoogleFonts.poppins(
                                                      color:
                                                          const Color.fromRGBO(
                                                              38, 166, 83, 1),
                                                      fontSize:
                                                          widthDevice * 0.035,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                  }).toList(),
                                ])
                          : const SizedBox(),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 150,
                          right: 20,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Phí di chuyển:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: widthDevice * 0.035,
                                    ),
                              ),
                              Text(
                                StringUtils.reverse(
                                    StringUtils.addCharAtPosition(
                                        StringUtils.reverse(
                                          widget.jobInfo[0].movingFee,
                                        ),
                                        ".",
                                        3,
                                        repeat: true)),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: widthDevice * 0.035,
                                    ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Giảm giá:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: widthDevice * 0.035,
                                    ),
                              ),
                              Text(
                                StringUtils.reverse(
                                    StringUtils.addCharAtPosition(
                                        StringUtils.reverse(
                                          widget.jobInfo[0].discount,
                                        ),
                                        ".",
                                        3,
                                        repeat: true)),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: widthDevice * 0.035,
                                    ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Giá dịch vụ:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: widthDevice * 0.035,
                                    ),
                              ),
                              Text(
                                StringUtils.reverse(
                                    StringUtils.addCharAtPosition(
                                        StringUtils.reverse(
                                          widget.jobInfo[0].price,
                                        ),
                                        ".",
                                        3,
                                        repeat: true)),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: widthDevice * 0.035,
                                    ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Phụ thu ngày lễ:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: widthDevice * 0.035,
                                    ),
                              ),
                              Text(
                                StringUtils.reverse(
                                    StringUtils.addCharAtPosition(
                                        StringUtils.reverse(
                                          widget.jobInfo[0].holidayPrice,
                                        ),
                                        ".",
                                        3,
                                        repeat: true)),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontSize: widthDevice * 0.035),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tổng chi phí',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: widthDevice * 0.035),
                                ),
                                Text(
                                  '${StringUtils.reverse(priceReverseSum)} VNĐ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: widthDevice * 0.035),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),

                      const SizedBox(height: 30),
                      widget.jobInfo[0].hostId == loginController.hostId
                          ? widget.jobInfo[0].status == 'worker_done'
                              ? Center(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      await hostDone.hostDone(
                                        contractId: widget
                                            .jobInfo[0].contract.contractId,
                                        jobId: widget.jobInfo[0].contract.jobId,
                                        hostId:
                                            widget.jobInfo[0].contract.hostId,
                                        hostName:
                                            widget.jobInfo[0].contract.hostName,
                                      );
                                      Get.to(
                                        HostRateScreen(
                                          workerName:
                                              widget.jobInfo[0].employee.name,
                                          profileImage: widget
                                              .jobInfo[0].employee.profileImage,
                                          contractId: widget.jobInfo[0]
                                              .contracts[0].contractId,
                                          jobId: widget
                                              .jobInfo[0].contracts[0].jobId,
                                          employeeId: widget.jobInfo[0]
                                              .contracts[0].employeeId,
                                          hostId: widget
                                              .jobInfo[0].contracts[0].hostId,
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                        elevation: 1,
                                        foregroundColor: Colors.lightGreen,
                                        side: const BorderSide(
                                            color: Colors.green, width: 2.0)),
                                    child: Text(
                                      'Thông báo công việc đã hoàn thành',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              fontSize: widthDevice * 0.035,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : const SizedBox()
                          : const SizedBox(),

                      widget.jobInfo[0].hostId == loginController.hostId
                          ? const SizedBox()
                          : widget.jobInfo[0].status == 'posting'
                              ? Center(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      registed == 'true'
                                          ? null
                                          : lyLichInfo[0].workerAuthen == 'true'
                                              ? showCustomDialog(context)
                                              : AwesomeDialog(
                                                  context: context,
                                                  dialogType:
                                                      DialogType.warning,
                                                  animType: AnimType.rightSlide,
                                                  title:
                                                      'Bạn cần phải đăng ký thợ để ứng tuyển công việc',
                                                  titleTextStyle:
                                                      GoogleFonts.poppins(
                                                    fontSize:
                                                        widthDevice * 0.04,
                                                  ),
                                                ).show();
                                    },
                                    style: OutlinedButton.styleFrom(
                                        elevation: 1,
                                        foregroundColor: Colors.lightGreen,
                                        side: const BorderSide(
                                            color: Colors.green, width: 2.0)),
                                    child: Text(
                                      registed == 'true'
                                          ? 'Chờ xác nhận của chủ nhà'
                                          : 'Đăng ký công việc',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              color: Colors.green,
                                              fontSize: widthDevice * 0.035,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : const SizedBox(),

                      widget.jobInfo[0].employee.id == loginController.hostId
                          ? widget.jobInfo[0].status == 'accept'
                              ? Center(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      await workerdone.workerDone(
                                        contractId: widget
                                            .jobInfo[0].contract.contractId,
                                        jobId: widget.jobInfo[0].contract.jobId,
                                        employeeId: widget
                                            .jobInfo[0].contract.employeeId,
                                        employeeName: widget
                                            .jobInfo[0].contract.employeeName,
                                      );
                                      Get.to(WorkerRateScreen(
                                        hostname: widget.jobInfo[0].host.name,
                                        profileImage:
                                            widget.jobInfo[0].host.profileImage,
                                        contractId: widget
                                            .jobInfo[0].contracts[0].contractId,
                                        employeeId: widget
                                            .jobInfo[0].contracts[0].employeeId,
                                        hostId: widget
                                            .jobInfo[0].contracts[0].hostId,
                                        jobId: widget
                                            .jobInfo[0].contracts[0].jobId,
                                      ));
                                    },
                                    style: OutlinedButton.styleFrom(
                                        elevation: 1,
                                        foregroundColor: Colors.lightGreen,
                                        side: const BorderSide(
                                            color: Colors.green, width: 2.0)),
                                    child: Text(
                                      'Thông báo công việc đã hoàn thành',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              color: Colors.green,
                                              fontSize: widthDevice * 0.035,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : const SizedBox()
                          : const SizedBox(),

                      const SizedBox(height: 30),
                    ]),
              ));
  }
}
