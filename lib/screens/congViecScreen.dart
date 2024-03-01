import 'package:cached_network_image/cached_network_image.dart';
import 'package:chotot/controllers/get_a_job.dart';
import 'package:chotot/controllers/get_host_job.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/models/get_host_job_model.dart';
import 'package:chotot/screens/login.dart';
import 'package:chotot/screens/thong_tin_job_screen.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:chotot/data/get_host_job_data.dart';

import 'package:get/get.dart';
// import 'package:chotot/models/get_host_job_model.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';

class CongViecScreen extends StatefulWidget {
  const CongViecScreen({super.key});
  static const route = '/lib/screens/congViecScreen.dart';

  @override
  State<CongViecScreen> createState() => _CongViecScreenState();
}

class _CongViecScreenState extends State<CongViecScreen>
    with SingleTickerProviderStateMixin {
  GetHostJob getHostJob = Get.put(GetHostJob());
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

  List<Widget> list = [
    const Tab(
      text: "Tất cả",
    ),
    const Tab(
      text: 'Công việc mới đăng',
    ),
    const Tab(
      text: 'Có thợ ứng tuyển',
    ),
    const Tab(
      text: 'Đã chọn thợ làm việc',
    ),
    const Tab(
      text: 'Công việc đã huỷ',
    ),
    const Tab(
      text: 'Thợ đã báo làm xong',
    ),
    const Tab(
      text: 'Chủ nhà đã báo hoàn tất',
    ),
  ];
  @override
  void initState() {
    getHostJob.getHostJob(0);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final List<String> statusJob = [
    //   'Tất cả',
    //   'Công việc mới đăng',
    //   'Có thợ ứng tuyển',
    //   'Đã chọn thợ làm việc',
    //   'Công việc đã huỷ',
    //   'Thợ đã báo làm xong',
    //   'Chủ nhà đã báo hoàn tất',
    // ];
    // convertJobStatus(String status) {
    //   switch (status) {
    //     case 'Công việc mới đăng':
    //       return 'posting';
    //     case 'Có thợ ứng tuyển':
    //       return 'apply';
    //     case 'Đã chọn thợ làm việc':
    //       return 'accept';
    //     case 'Công việc đã huỷ':
    //       return 'cancel';
    //     case 'Thợ đã báo làm xong':
    //       return 'worker_done';
    //     case 'Chủ nhà đã báo hoàn tất':
    //       return 'finish_job';
    //     default:
    //       return '';
    //   }
    // }

    // String? selectedValueType = type[0];
    // String? selectedValueStatus = statusJob[0];
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
                                fontFamily: GoogleFonts.lato().fontFamily,
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
                                    fontFamily: GoogleFonts.lato().fontFamily,
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
                child: DefaultTabController(
                  length: 7,
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(
                        'Trạng thái bài đăng',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                            ),
                      ),
                      centerTitle: true,
                      // leading: DropdownButtonHideUnderline(
                      //   child: DropdownButton2<String>(
                      //     isExpanded: true,
                      //     hint: Text(
                      //       'Người đăng',
                      //       style: TextStyle(
                      //         fontSize: 14,
                      //         color: Theme.of(context).hintColor,
                      //       ),
                      //     ),
                      //     items: type
                      //         .map((String item) => DropdownMenuItem<String>(
                      //               value: item,
                      //               child: Text(item,
                      //                   style: Theme.of(context)
                      //                       .textTheme
                      //                       .bodyMedium!
                      //                       .copyWith(
                      //                           fontFamily:
                      //                               GoogleFonts.montserrat()
                      //                                   .fontFamily,
                      //                           color: Colors.grey)),
                      //             ))
                      //         .toList(),
                      //     // value: selectedValueType,
                      //     onChanged: (String? value) {
                      //       setState(() {
                      //         selectedValueType = value;
                      //       });
                      //     },
                      //     buttonStyleData: const ButtonStyleData(
                      //       padding: EdgeInsets.symmetric(horizontal: 16),
                      //       height: 40,
                      //       width: 140,
                      //     ),
                      //     menuItemStyleData: const MenuItemStyleData(
                      //       height: 40,
                      //     ),
                      //   ),
                      // ),
                      // leadingWidth: MediaQuery.of(context).size.width * 0.35,
                      // actions: [
                      //   DropdownButtonHideUnderline(
                      //     child: DropdownButton2<String>(
                      //       isExpanded: true,
                      //       hint: Text(
                      //         'Trạng thái bài đăng',
                      //         style: TextStyle(
                      //           fontSize: 14,
                      //           color: Theme.of(context).hintColor,
                      //         ),
                      //       ),
                      //       items: statusJob
                      //           .map((String item) => DropdownMenuItem<String>(
                      //                 value: item,
                      //                 child: Text(
                      //                   item,
                      //                   style: Theme.of(context)
                      //                       .textTheme
                      //                       .bodyMedium!
                      //                       .copyWith(
                      //                           fontFamily:
                      //                               GoogleFonts.montserrat()
                      //                                   .fontFamily,
                      //                           color: Colors.grey),
                      //                 ),
                      //               ))
                      //           .toList(),
                      //       // value: selectedValueStatus,
                      //       onChanged: (String? value) {
                      //         isLoading = false;
                      //         Timer(const Duration(seconds: 4), () async {
                      //           setState(() {
                      //             isLoading = true;
                      //           });
                      //           await getHostJob.getHostJob(0);
                      //         });
                      //         getHostJob.statusHostJob =
                      //             convertJobStatus(value!);

                      //         setState(() {
                      //           selectedValueStatus = value;
                      //         });
                      //       },
                      //       buttonStyleData: ButtonStyleData(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 16),
                      //         height: 40,
                      //         width: MediaQuery.of(context).size.width * 0.5,
                      //       ),
                      //       menuItemStyleData: const MenuItemStyleData(
                      //         height: 40,
                      //       ),
                      //     ),
                      //   ),
                      // ],
                      bottom: TabBar(
                          // controller: _controller,
                          onTap: (index) {
                            // setState(() {});
                          },
                          isScrollable: true,
                          tabs: list),
                    ),
                    body: hostJobDataAll.isEmpty
                        ? Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(500))),
                            child: Image.asset(
                              'image/6678.jpg',
                              height: MediaQuery.of(context).size.height * 0.3,
                            ),
                          )
                        : TabBarView(
                            children: [
                              HostJobStatus(
                                hostJobData: hostJobDataAll,
                              ),
                              HostJobStatus(hostJobData: hostJobDataPosting),
                              HostJobStatus(hostJobData: hostJobDataApply),
                              HostJobStatus(hostJobData: hostJobDataAccept),
                              HostJobStatus(hostJobData: hostJobDataCancel),
                              HostJobStatus(hostJobData: hostJobDataWorkerDone),
                              HostJobStatus(hostJobData: hostJobDataFinishJob),
                            ],
                          ),
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator());
  }
}

// ignore: must_be_immutable
class HostJobStatus extends StatefulWidget {
  HostJobStatus({
    super.key,
    required this.hostJobData,
  });
  List<HostJob> hostJobData;
  @override
  State<HostJobStatus> createState() => _HostJobStatusState();
}

class _HostJobStatusState extends State<HostJobStatus> {
  GetHostJob getHostJob = Get.put(GetHostJob());
  GetAJob getAJob = Get.put(GetAJob());
  @override
  // void initState() {
  //   getHostJob.statusHostJob = widget.status;
  //   getHostJob.getHostJob(0);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return widget.hostJobData.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(children: [
                ...widget.hostJobData.map((item) {
                  // var imgUrl = item.photos[0].split('"').join('').split('');
                  // imgUrl.removeAt(0);
                  // imgUrl.removeAt(imgUrl.length - 1);
                  var dateTime = DateTime.fromMillisecondsSinceEpoch(
                          int.parse(item.workDate),
                          isUtc: true)
                      .toString();

                  var dateStringList = dateTime.split(' ');
                  var date = dateStringList[0];
                  var time = dateStringList[1];

                  var createAt =
                      DateTime.parse(item.priceHostJob.createAt).toString();
                  jobStatus(String status) {
                    switch (status) {
                      case 'posting':
                        return 'công việc mới đăng';
                      case 'apply':
                        return 'Có thợ ứng tuyển';
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

                  return GestureDetector(
                    onTap: () async {
                      await getAJob.getAJob(item.jobId);

                      Get.to(() => ThongTinJobScreen(
                          jobInfo: getAJob.jobInfo,
                          date: date,
                          time: time.substring(0, time.length - 4)));
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    const Color.fromARGB(119, 158, 158, 158)),
                            borderRadius: BorderRadius.circular(12)),
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                height:
                                    MediaQuery.of(context).size.height * 0.17,
                                width:
                                    MediaQuery.of(context).size.height * 0.15,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                ),
                                child: item.photos.isEmpty
                                    ? Image.asset('image/no_image.png',
                                        color: Colors.grey)
                                    : CachedNetworkImage(
                                        imageUrl:
                                            item.photos[0].split('"').join(''),
                                        imageBuilder: (context,
                                                imageProvider) =>
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(
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
                                                  fontFamily:
                                                      GoogleFonts.montserrat()
                                                          .fontFamily,
                                                  fontSize: 18,
                                                ),
                                            overflow: TextOverflow.fade,
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
                                                  fontFamily:
                                                      GoogleFonts.montserrat()
                                                          .fontFamily,
                                                  color: Colors.grey,
                                                ),
                                            overflow: TextOverflow.ellipsis,
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
                                            'Vào $date lúc ${time.substring(0, time.length - 4)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  fontFamily:
                                                      GoogleFonts.montserrat()
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
                                                        GoogleFonts.montserrat()
                                                            .fontFamily,
                                                    color: Colors.black,
                                                    fontSize: 13),
                                            overflow: TextOverflow.ellipsis,
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
                                                        GoogleFonts.montserrat()
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
              ]),
            ),
          )
        : const Center(
            child: Text(
              'không có bài đăng công việc trạng thái này',
            ),
          );
  }
}
