import 'package:basic_utils/basic_utils.dart';
import 'package:chotot/controllers/accept_worker.dart';
import 'package:chotot/controllers/apply_job.dart';
import 'package:chotot/controllers/host_done.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/controllers/worker_done.dart';
import 'package:chotot/data/acceptorker_data.dart';
import 'package:chotot/models/get_post_job_model.dart';
import 'package:chotot/screens/host_rate_screen.dart';
import 'package:chotot/screens/worker_rate_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
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
  var readMoreService = 1;
  var readMoreContract = 1;
  final _formKey = GlobalKey<FormState>();
  bool chooseWorker = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  void showCustomDialog(BuildContext context) {
    showGeneralDialog(
        context: context,
        barrierLabel: 'Barrier',
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) {
          return Scaffold(
            body: Center(
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40)),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Text(
                            'Nhắn cho chủ nhà để ứng tuyển công việc',
                          ),
                          TextFormField(
                            controller: applyJob.description,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text('Hủy bỏ'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await applyJob.applyJob(widget.job.job.jobId,
                                      widget.job.job.workerId);
                                  Get.back();
                                },
                                child: const Text('Xác nhận'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          );
        },
        transitionBuilder: (_, anim, __, child) {
          Tween<Offset> tween;
          if (anim.status == AnimationStatus.reverse) {
            tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
          } else {
            tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
          }

          return SlideTransition(
            position: tween.animate(anim),
            child: FadeTransition(
              opacity: anim,
              child: child,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var createAt = DateTime.parse(widget.job.job.createdAt);
    var dateTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(widget.job.job.workDate.toString()));
    final priceReverse = StringUtils.addCharAtPosition(
        StringUtils.reverse(widget.job.job.sumPrice), ".", 3,
        repeat: true);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(widget.job.job.name,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontFamily: GoogleFonts.lato().fontFamily,
                        fontSize: 20,
                      )),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.grey),
                      bottom: BorderSide(color: Colors.grey))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Số lượng  ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  color: Colors.grey),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${widget.job.contracts.length.toString()} thợ',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Column(
                      children: [
                        Text(
                          'Lương',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${StringUtils.reverse(priceReverse)}  ',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Ngày',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                            '${dateTime.day < 10 ? 0 : ''}${dateTime.day}/${dateTime.month < 10 ? 0 : ''}${dateTime.month}/${dateTime.year}',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      // fontSize: 14,
                                    )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                'Thời gian khởi tạo:',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontFamily: GoogleFonts.lato().fontFamily,
                    ),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                '${createAt.hour < 10 ? 0 : ''}${createAt.hour}:${createAt.minute < 10 ? 0 : ''}${createAt.minute} - ${createAt.day < 10 ? 0 : ''}${createAt.day}/${createAt.month < 10 ? 0 : ''}${createAt.month}/${createAt.year}',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      color: Colors.grey,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                'Mô tả công việc:',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontFamily: GoogleFonts.lato().fontFamily,
                    ),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                widget.job.job.description,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      color: Colors.grey,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                'Địa chỉ:',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontFamily: GoogleFonts.lato().fontFamily,
                    ),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                widget.job.job.address,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      color: Colors.grey,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                'Số điện thoại:',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontFamily: GoogleFonts.lato().fontFamily,
                    ),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                widget.job.job.phone,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      color: Colors.grey,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                'Danh sách các dịch vụ:',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontFamily: GoogleFonts.lato().fontFamily,
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
                            service.qt.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87),
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            service.description,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '${StringUtils.reverse(priceReverseUnitPrice)} Đ x ${service.qt}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    fontWeight: FontWeight.w600,
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
                            '${StringUtils.reverse(priceReverse)} Đ',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    fontFamily: GoogleFonts.lato().fontFamily,
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
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.lato().fontFamily,
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
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          color: Colors.green),
                    )),
            chooseWorker != true
                ? loginController.hostId == widget.job.job.hostId
                    ? Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Danh sách thợ ứng tuyển:',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontFamily: GoogleFonts.lato().fontFamily,
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
                              onTap: () {
                                acceptWorker.acceptWorker(
                                    contract.jobId,
                                    contract.contractId,
                                    widget.job.job.prices.priceId);
                                setState(() {
                                  chooseWorker = true;
                                });
                              },
                              child: Card(
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
                                      '${createAt.day < 10 ? 0 : ''}${createAt.day}/${createAt.month < 10 ? 0 : ''}${createAt.month}/${createAt.year}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              fontFamily:
                                                  GoogleFonts.lato().fontFamily,
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
                                                  GoogleFonts.lato().fontFamily,
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
                                                  GoogleFonts.lato().fontFamily,
                                              fontWeight: FontWeight.w600,
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
                                      contract.status,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              fontFamily:
                                                  GoogleFonts.lato().fontFamily,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox()
                      : const SizedBox()
                  : const SizedBox();
            }).toList(),
            chooseWorker != true
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
                                      fontFamily: GoogleFonts.lato().fontFamily,
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
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: Colors.green),
                            ))
                    : const SizedBox()
                : const SizedBox(),
            loginController.hostId != widget.job.job.hostId
                ? chooseWorker != true
                    ? Center(
                        child: OutlinedButton(
                          onPressed: () {
                            showCustomDialog(context);
                          },
                          style: OutlinedButton.styleFrom(
                              elevation: 1,
                              foregroundColor: Colors.lightGreen,
                              side: const BorderSide(
                                  color: Colors.green, width: 2.0)),
                          child: Text(
                            'Đăng ký công việc',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    color: Colors.green,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : const Center(
                        child: Text('Công việc đã tuyển được thợ'),
                      )
                : const SizedBox(),
            chooseWorker == true
                ? Center(
                    child: OutlinedButton(
                      onPressed: () async {
                        final SharedPreferences prefs = await _prefs;
                        var hostId = prefs.getString('host_id');
                        if (loginController.hostId == widget.job.job.hostId) {
                          await hostDone.hostDone();
                          Get.to(const HostRateScreen());
                        }
                        if (hostId == acceptWorkerData[0].employeeId) {
                          await workerdone.workerDone();
                          Get.to(const WorkerRateScreen());
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
                                fontFamily: GoogleFonts.lato().fontFamily,
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
