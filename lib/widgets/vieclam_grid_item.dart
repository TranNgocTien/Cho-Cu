import 'dart:math';

import 'package:chotot/models/get_post_job_model.dart';
import 'package:chotot/screens/job_detail_market.dart';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

class ViecLamGridItem extends StatelessWidget {
  const ViecLamGridItem({super.key, required this.job});
  final PostJob job;
  @override
  Widget build(BuildContext context) {
    var createAt = DateTime.parse(job.job.createdAt);
    List<String> imageWorker = [
      'image/worker-1.png',
      'image/worker-2.png',
      'image/worker-3.png',
      'image/worker-4.png',
      'image/worker-5.png',
    ];
    Random random = Random();
    int randomNumber = random.nextInt(5);
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
        case 'finish_job':
          return 'Chủ nhà đã báo hoàn tất';
      }
    }

    var dateTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(job.job.workDate.toString()));

    // var dateStringList = dateTime.split(' ');
    // var date = dateStringList[0];
    // var time = dateStringList[1];

    return GestureDetector(
      onTap: () {
        Get.to(() => JobDetailMarketScreen(job: job));
      },
      child: Card(
        elevation: 4,
        color: Colors.white,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color.fromARGB(72, 158, 158, 158),
                    ),
                    child: Image.asset(
                      imageWorker[randomNumber],
                      width: 60,
                      height: 60,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          job.job.name,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                  ),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(114, 158, 158, 158),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          jobStatus(job.job.status)!,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const FaIcon(FontAwesomeIcons.clock,
                      size: 15, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(
                      '${dateTime.hour < 10 ? 0 : ''}${dateTime.hour}:${dateTime.minute < 10 ? 0 : ''}${dateTime.minute} - ${dateTime.day < 10 ? 0 : ''}${dateTime.day}/${dateTime.month < 10 ? 0 : ''}${dateTime.month}/${dateTime.year}',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontFamily: GoogleFonts.lato().fontFamily,
                          )),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FaIcon(FontAwesomeIcons.locationPin,
                      size: 15, color: Colors.grey),
                  const SizedBox(width: 5),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Text(
                      job.job.address,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontFamily: GoogleFonts.lato().fontFamily,
                          ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(
                  'Thời gian tạo: ${createAt.hour < 10 ? 0 : ''}${createAt.hour}:${createAt.minute < 10 ? 0 : ''}${createAt.minute} - ${createAt.day < 10 ? 0 : ''}${createAt.day}/${createAt.month < 10 ? 0 : ''}${createAt.month}/${createAt.year}',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontFamily: GoogleFonts.lato().fontFamily,
                        color: const Color.fromARGB(101, 158, 158, 158),
                      ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
