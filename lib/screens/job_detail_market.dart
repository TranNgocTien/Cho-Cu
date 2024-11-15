import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chotot/controllers/accept_worker.dart';
import 'package:chotot/controllers/apply_job.dart';
import 'package:chotot/controllers/get_a_job.dart';
import 'package:chotot/controllers/get_job_by_type_2.dart';
import 'package:chotot/controllers/host_done.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/controllers/worker_done.dart';
import 'package:chotot/data/acceptorker_data.dart';
import 'package:chotot/data/job_service_data.dart';
import 'package:chotot/data/ly_lich.dart';
import 'package:chotot/models/get_post_job_model.dart';
import 'package:chotot/screens/homeScreen.dart';
import 'package:chotot/screens/host_rate_screen.dart';
import 'package:chotot/screens/login.dart';
import 'package:chotot/screens/worker_rate_screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobDetailMarketScreen extends StatefulWidget {
  const JobDetailMarketScreen({super.key, required this.job});
  final PostJob job;
  @override
  State<JobDetailMarketScreen> createState() => _JobDetailMarketScreenState();
}

class _JobDetailMarketScreenState extends State<JobDetailMarketScreen> {
  ApplyJob applyJob = Get.put(ApplyJob());
  AcceptWorker acceptWorker = Get.put(AcceptWorker());
  LoginController loginController = Get.put(LoginController());
  Workerdone workerdone = Get.put(Workerdone());
  HostDone hostDone = Get.put(HostDone());
  GetAJob getAJob = Get.put(GetAJob());
  GetJobByType2 getJobByType2 = Get.put(GetJobByType2());
  var currentIndex = 0;
  String registed = '';
  bool isLoading = true;
  // bool showModalLoading = true;
  isRegisterJob(String jobId) async {
    await getAJob.getAJob(jobId);

    registed = getAJob.jobInfo[0].contracts
        .any((element) => element.employeeId == loginController.hostId)
        .toString();
    Timer(const Duration(milliseconds: 2000), () async {
      setState(() {
        isLoading = false;
      });
    });
  }

  var readMoreService = 1;
  var readMoreContract = 1;
  // final _formKey = GlobalKey<FormState>();
  bool chooseWorker = false;
  void _modalBottomSheetMenu(String employeeId) async {
    WorkersPostJob worker = widget.job.workers
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
              backgroundColor: Colors.white,
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
                                  fontSize: widthDevice * 0.04),
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
                            if (mounted) {
                              mystate(() {});
                            }
                          },
                          isLastPage: getJobByType2.isLastPage,
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 100.0,
                                backgroundColor:
                                    const Color.fromRGBO(84, 181, 111, 1),
                                child: CircleAvatar(
                                  radius: 90.0,
                                  backgroundImage:
                                      NetworkImage(worker.profileImg),
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
                                                      widthDevice * 0.04)),
                                          const SizedBox(width: 20),
                                          Text(worker.name,
                                              style: GoogleFonts.poppins(
                                                  fontSize:
                                                      widthDevice * 0.04)),
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
                                                      widthDevice * 0.04)),
                                          const SizedBox(width: 20),
                                          Text(
                                              widget.job.job.status
                                                              .toString() ==
                                                          'accept' &&
                                                      widget.job.employee?.id ==
                                                          employeeId
                                                  ? worker.phone
                                                  : '******${worker.phone.substring(worker.phone.length - 4)}',
                                              style: GoogleFonts.poppins(
                                                  fontSize:
                                                      widthDevice * 0.04)),
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
                                                      widthDevice * 0.04)),
                                          const SizedBox(width: 20),
                                          Text(
                                              (double.tryParse(worker.ds)! / 20)
                                                  .toStringAsFixed(1),
                                              style: GoogleFonts.poppins(
                                                  fontSize:
                                                      widthDevice * 0.04)),
                                          Image.asset(
                                            'image/star.png',
                                            height: 20,
                                            width: 20,
                                          ),
                                          Text(
                                              '(${double.parse(worker.ds).toStringAsFixed(1)})',
                                              style: GoogleFonts.poppins(
                                                  fontSize:
                                                      widthDevice * 0.04)),
                                        ],
                                      ),
                                    ],
                                  )),
                              const SizedBox(height: 20.0),
                              widget.job.job.status.toString() != 'posting'
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
                                                widget.job.contracts
                                                    .firstWhere((contract) =>
                                                        contract.employeeId ==
                                                        employeeId)
                                                    .jobId,
                                                widget.job.contracts
                                                    .firstWhere((contract) =>
                                                        contract.employeeId ==
                                                        employeeId)
                                                    .contractId,
                                                widget.job.job.prices.priceId);
                                            setState(() {
                                              chooseWorker = true;
                                            });
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
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Text(
                                  'Đánh giá của khách hàng trước',
                                  style: GoogleFonts.poppins(
                                      color:
                                          const Color.fromRGBO(38, 166, 83, 1),
                                      fontSize: widthDevice * 0.04),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              const SizedBox(height: 20.0),
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
                                      '${dateRate.day < 10 ? 0 : ''}${dateRate.day}-${dateRate.month < 10 ? 0 : ''}${dateRate.month}-${dateRate.year}';
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
                                                padding: const EdgeInsets.only(
                                                    bottom: 15.0),
                                                decoration: const BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                  color: Colors.grey,
                                                ))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Đánh giá từ chủ nhà',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize:
                                                                  widthDevice *
                                                                      0.04),
                                                    ),
                                                    Text(
                                                      nameHost,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize:
                                                                  widthDevice *
                                                                      0.04),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Thời gian',
                                                    style: GoogleFonts.poppins(
                                                      fontSize:
                                                          widthDevice * 0.035,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Text(
                                                    dateRateString,
                                                    style: GoogleFonts.poppins(
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
                                                              color:
                                                                  Colors.grey),
                                                    )
                                                  : SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
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
                                                          (double.parse(
                                                                      rate.d1) /
                                                                  20)
                                                              .toString(),
                                                        ),
                                                        const Icon(Icons.star,
                                                            color:
                                                                Colors.yellow),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          (double.parse(
                                                                      rate.d2) /
                                                                  20)
                                                              .toString(),
                                                        ),
                                                        const Icon(Icons.star,
                                                            color:
                                                                Colors.yellow),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          (double.parse(
                                                                      rate.d3) /
                                                                  20)
                                                              .toString(),
                                                        ),
                                                        const Icon(Icons.star,
                                                            color:
                                                                Colors.yellow),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          (double.parse(
                                                                      rate.d4) /
                                                                  20)
                                                              .toString(),
                                                        ),
                                                        const Icon(Icons.star,
                                                            color:
                                                                Colors.yellow),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          (double.parse(
                                                                      rate.d5) /
                                                                  20)
                                                              .toString(),
                                                        ),
                                                        const Icon(Icons.star,
                                                            color:
                                                                Colors.yellow),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          (double.parse(
                                                                      rate.ds) /
                                                                  20)
                                                              .toString(),
                                                        ),
                                                        const Icon(Icons.star,
                                                            color:
                                                                Colors.yellow),
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
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
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
                                                          color: Color.fromRGBO(
                                                              38, 166, 83, 1)),
                                                      const SizedBox(width: 5),
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
                                                          Icons.timer_outlined,
                                                          color: Color.fromRGBO(
                                                              38, 166, 83, 1)),
                                                      const SizedBox(width: 5),
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
                                                      CrossAxisAlignment.start,
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
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize:
                                                              widthDevice *
                                                                  0.04,
                                                        ),
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
                      SizedBox(height: widthDevice * 0.3),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
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
                      widget.job.job.jobId, widget.job.job.workerId);

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

  @override
  void initState() {
    isRegisterJob(widget.job.job.jobId).toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var createAt = DateTime.parse(widget.job.job.createdAt);
    var dateTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(widget.job.job.workDate.toString()),
        isUtc: true);
    final priceReverse = StringUtils.addCharAtPosition(
        StringUtils.reverse(widget.job.job.sumPrice), ".", 3,
        repeat: true);
    final widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.transparent,
        backgroundColor: const Color.fromRGBO(38, 166, 83, 1),
        title: Text(
          'Thợ thông minh',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: widthDevice * 0.06,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
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
                    items: widget.job.job.photos.isEmpty
                        ? [
                            InstaImageViewer(
                              child: Container(
                                // margin: const EdgeInsets.all(8),
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
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
                                                              element
                                                                  .code
                                                                  .trim() ==
                                                              widget.job
                                                                  .jobserviceid
                                                                  .trim()) !=
                                                  null
                                              ? Image.network(
                                                  jobServiceList
                                                      .firstWhere((element) =>
                                                          element.name.trim() ==
                                                          widget.job.job.name
                                                              .trim())
                                                      .img,
                                                  fit: BoxFit.contain,
                                                  height: double.infinity,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                )
                                              : Image.asset(
                                                  'image/logo_tho_thong_minh.jpeg',
                                                  fit: BoxFit.cover),
                                        ),
                                      ]);
                                    },
                                  ),
                                ),
                              ),
                            )
                          ]
                        : widget.job.job.photos.map((photo) {
                            return InstaImageViewer(
                              child: Container(
                                // margin: const EdgeInsets.all(8),
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
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
                                              color:
                                                  Color.fromARGB(93, 0, 0, 0),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              '${widget.job.job.photos.indexOf(photo) + 1}/${widget.job.job.photos.length}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: widthDevice * 0.03,
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
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(widget.job.job.name,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: widthDevice * 0.05,
                                  color: const Color.fromRGBO(38, 166, 83, 1),
                                )),
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
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Thời gian làm việc:',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: widthDevice * 0.04,
                          ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      '${dateTime.hour < 10 ? 0 : ''}${dateTime.hour}:${dateTime.minute < 10 ? 0 : ''}${dateTime.minute} - ${dateTime.day < 10 ? 0 : ''}${dateTime.day}/${dateTime.month < 10 ? 0 : ''}${dateTime.month}/${dateTime.year}',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: Colors.grey,
                            fontSize: widthDevice * 0.035,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Mô tả công việc:',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: widthDevice * 0.04,
                          ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      widget.job.job.description,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: Colors.grey,
                            fontSize: widthDevice * 0.035,
                          ),
                    ),
                  ),
                  acceptWorkerData.isNotEmpty
                      ? loginController.hostId ==
                                  acceptWorkerData[0].employeeId ||
                              loginController.hostId ==
                                  acceptWorkerData[0].hostId
                          ? Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                'Địa chỉ:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: widthDevice * 0.04,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                            )
                          : const SizedBox()
                      : const SizedBox(),
                  acceptWorkerData.isNotEmpty
                      ? loginController.hostId ==
                                  acceptWorkerData[0].employeeId ||
                              loginController.hostId ==
                                  acceptWorkerData[0].hostId
                          ? Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                widget.job.job.address,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      color: Colors.grey,
                                      fontSize: widthDevice * 0.035,
                                    ),
                              ),
                            )
                          : const SizedBox()
                      : const SizedBox(),
                  acceptWorkerData.isNotEmpty
                      ? loginController.hostId ==
                                  acceptWorkerData[0].employeeId ||
                              loginController.hostId ==
                                  acceptWorkerData[0].hostId
                          ? Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                'Số điện thoại:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: widthDevice * 0.04,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                            )
                          : const SizedBox()
                      : const SizedBox(),
                  acceptWorkerData.isNotEmpty
                      ? loginController.hostId ==
                                  acceptWorkerData[0].employeeId ||
                              loginController.hostId ==
                                  acceptWorkerData[0].hostId
                          ? Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                widget.job.job.phone,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      color: Colors.grey,
                                      fontSize: widthDevice * 0.035,
                                    ),
                              ),
                            )
                          : const SizedBox()
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Danh sách các dịch vụ:',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: widthDevice * 0.04,
                          ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  ...widget.job.job.services.map((service) {
                    final priceReverse = StringUtils.addCharAtPosition(
                        StringUtils.reverse(service.sum), ".", 3,
                        repeat: true);
                    final priceReverseUnitPrice = StringUtils.addCharAtPosition(
                        StringUtils.reverse(service.unitPrice), ".", 3,
                        repeat: true);

                    return readMoreService == 1
                        ? Card(
                            color: Colors.white,
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.only(
                                    right: 5, top: 10, bottom: 10),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                child: Text(
                                  '${StringUtils.reverse(priceReverseUnitPrice)} x ${service.qt}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: widthDevice * 0.035,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87),
                                ),
                              ),
                              title: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.5),
                                child: Text(
                                  service.name != 'null'
                                      ? service.name.toString()
                                      : '',
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
                              subtitle: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.5),
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
                                    left: 5, top: 10, bottom: 10),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                child: Text(
                                  '${StringUtils.reverse(priceReverse)} Đ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: widthDevice * 0.035,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox();
                  }).toList(),
                  readMoreService == 1
                      ? TextButton(
                          onPressed: () {
                            setState(() {
                              readMoreService = 0;
                            });
                          },
                          child: Text(
                            'Thu gọn',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize: widthDevice * 0.04,
                                    color: Colors.red),
                          ),
                        )
                      : TextButton(
                          onPressed: () {
                            setState(() {
                              readMoreService = 1;
                            });
                          },
                          child: Text(
                            'Xem thêm',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize: widthDevice * 0.04,
                                    color: Colors.green),
                          )),
                  widget.job.contracts.isEmpty
                      ? const SizedBox()
                      : chooseWorker != true
                          ? loginController.hostId == widget.job.job.hostId
                              ? Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    'Danh sách thợ ứng tuyển:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: widthDevice * 0.04,
                                        ),
                                    textAlign: TextAlign.start,
                                  ),
                                )
                              : const SizedBox()
                          : const SizedBox(),
                  ...widget.job.contracts.map((contract) {
                    var createAt = DateTime.parse(contract.createdAt);

                    return readMoreContract == 1
                        ? chooseWorker != true
                            ? loginController.hostId == widget.job.job.hostId
                                ? GestureDetector(
                                    onTap: () async {
                                      getJobByType2.rateList.clear();
                                      getJobByType2.contractList.clear();
                                      await getJobByType2.getJobByType2(
                                          contract.employeeId, '0');
                                      // Future.delayed(const Duration(seconds: 1),
                                      //     () {
                                      //   setState(() {
                                      //     showModalLoading = false;
                                      //   });
                                      // });
                                      _modalBottomSheetMenu(
                                          contract.employeeId);
                                      // acceptWorker.acceptWorker(
                                      //     contract.jobId,
                                      //     contract.contractId,
                                      //     widget.job.job.prices.priceId);
                                    },
                                    child: Card(
                                      color: Colors.white,
                                      child: ListTile(
                                        leading: Container(
                                          padding: const EdgeInsets.only(
                                              right: 20, top: 10, bottom: 10),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              right: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          child: Text(
                                            '${createAt.day < 10 ? 0 : ''}${createAt.day}/${createAt.month < 10 ? 0 : ''}${createAt.month}/${createAt.year}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    fontSize:
                                                        widthDevice * 0.035,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87),
                                          ),
                                        ),
                                        title: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            contract.employeeName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    fontSize:
                                                        widthDevice * 0.035,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87),
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            contract.description,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    fontSize:
                                                        widthDevice * 0.035,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black54),
                                          ),
                                        ),
                                        trailing: Container(
                                          padding: const EdgeInsets.only(
                                              left: 20, top: 10, bottom: 10),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          child: Text(
                                            'Xem thợ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                  color: const Color.fromRGBO(
                                                      38, 166, 83, 1),
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                  fontSize: widthDevice * 0.035,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox()
                            : const SizedBox()
                        : const SizedBox();
                  }).toList(),
                  widget.job.contracts.isEmpty
                      ? const SizedBox()
                      : chooseWorker != true
                          ? loginController.hostId == widget.job.job.hostId
                              ? readMoreContract == 1
                                  ? TextButton(
                                      onPressed: () {
                                        setState(() {
                                          readMoreContract = 0;
                                        });
                                      },
                                      child: Text(
                                        'Thu gọn',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                                fontSize: widthDevice * 0.04,
                                                color: Colors.red),
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: () {
                                        setState(() {
                                          readMoreContract = 1;
                                        });
                                      },
                                      child: Text(
                                        'Xem thêm',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                                fontSize: widthDevice * 0.04,
                                                color: Colors.green),
                                      ))
                              : const SizedBox()
                          : const SizedBox(),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 100,
                      right: 20,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey,
                        ),
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
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: widthDevice * 0.035,
                                ),
                          ),
                          Text(
                            StringUtils.reverse(StringUtils.addCharAtPosition(
                                StringUtils.reverse(
                                  widget.job.job.movingFee,
                                ),
                                ".",
                                3,
                                repeat: true)),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
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
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: widthDevice * 0.035,
                                ),
                          ),
                          Text(
                            StringUtils.reverse(StringUtils.addCharAtPosition(
                                StringUtils.reverse(
                                  widget.job.job.discount,
                                ),
                                ".",
                                3,
                                repeat: true)),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
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
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: widthDevice * 0.035,
                                ),
                          ),
                          Text(
                            StringUtils.reverse(StringUtils.addCharAtPosition(
                                StringUtils.reverse(
                                  widget.job.job.price,
                                ),
                                ".",
                                3,
                                repeat: true)),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
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
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: widthDevice * 0.035,
                                ),
                          ),
                          Text(
                            StringUtils.reverse(StringUtils.addCharAtPosition(
                                StringUtils.reverse(
                                  widget.job.job.discount,
                                ),
                                ".",
                                3,
                                repeat: true)),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: widthDevice * 0.035,
                                ),
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
                                    fontSize: widthDevice * 0.035,
                                  ),
                            ),
                            Text(
                              '${StringUtils.reverse(priceReverse)} VNĐ',
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
                      ),
                    ]),
                  ),
                  const SizedBox(height: 30),
                  loginController.tokenString != ''
                      ? loginController.hostId != widget.job.job.hostId
                          ? chooseWorker != true
                              ? Center(
                                  child: OutlinedButton(
                                    onPressed: registed == 'true'
                                        ? null
                                        : () {
                                            lyLichInfo[0].workerAuthen == 'true'
                                                ? showCustomDialog(context)
                                                : AwesomeDialog(
                                                    context: context,
                                                    dialogType:
                                                        DialogType.warning,
                                                    animType:
                                                        AnimType.rightSlide,
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
                                              fontSize: widthDevice * 0.04,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    loginController.hostId ==
                                            acceptWorkerData[0].employeeId
                                        ? 'Chủ nhà đã chọn bạn thực hiện công việc'
                                        : 'Công việc đã tuyển được thợ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                            color: Colors.green,
                                            fontSize: widthDevice * 0.04,
                                            fontWeight: FontWeight.bold),
                                  ),
                                )
                          : const SizedBox()
                      : Center(
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            // height: MediaQuery.of(context).size.height * 0.2,
                            // width: MediaQuery.of(context).size.width * 0.5,
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
                                      color:
                                          const Color.fromRGBO(38, 166, 83, 1),
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
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                                fontSize: widthDevice * 0.04,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                      )),
                                ]),
                          ),
                        ),
                  loginController.tokenString != ''
                      ? chooseWorker == true
                          ? Center(
                              child: OutlinedButton(
                                onPressed: () async {
                                  final SharedPreferences prefs = await _prefs;
                                  var hostId = prefs.getString('host_id');
                                  if (loginController.hostId ==
                                      widget.job.job.hostId) {
                                    await hostDone.hostDone();
                                    Get.offAll(
                                      const HostRateScreen(
                                        workerName: '',
                                        profileImage: '',
                                        contractId: '',
                                        jobId: '',
                                        employeeId: '',
                                        hostId: '',
                                      ),
                                    );
                                  }
                                  if (hostId ==
                                      acceptWorkerData[0].employeeId) {
                                    await workerdone.workerDone();
                                    Get.offAll(const WorkerRateScreen(
                                      hostname: '',
                                      profileImage: '',
                                      contractId: '',
                                      employeeId: '',
                                      hostId: '',
                                      jobId: '',
                                    ));
                                  }
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
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          color: Colors.green,
                                          fontSize: widthDevice * 0.04,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : const SizedBox()
                      : const SizedBox(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }
}
