import 'package:basic_utils/basic_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chotot/models/get_a_job_model.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

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

  @override
  Widget build(BuildContext context) {
    final priceReverseSum = StringUtils.addCharAtPosition(
        StringUtils.reverse(widget.jobInfo[0].sumPrice), ".", 3,
        repeat: true);
    return Scaffold(
        body: SingleChildScrollView(
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
              items: widget.jobInfo[0].photos.map((photo) {
                return InstaImageViewer(
                  child: Container(
                    // margin: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.2,
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
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Image.network(
                                photo.split('"').join(''),
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: MediaQuery.of(context).size.width,
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
                                  color: Color.fromARGB(93, 0, 0, 0),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${widget.jobInfo[0].photos.indexOf(photo) + 1}/${widget.jobInfo[0].photos.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
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
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(widget.jobInfo[0].name,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(182, 0, 0, 0)),
                  textAlign: TextAlign.start),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text('Trạng thái:',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                  textAlign: TextAlign.start),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(jobStatus(widget.jobInfo[0].status),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                  textAlign: TextAlign.start),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text('Mô tả:',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                  textAlign: TextAlign.start),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(widget.jobInfo[0].description,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                  textAlign: TextAlign.start),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text('Địa chỉ:',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                  textAlign: TextAlign.start),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(widget.jobInfo[0].address,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                  textAlign: TextAlign.start),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text('Thời gian',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                  textAlign: TextAlign.start),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text('${widget.time} ngày ${widget.date}',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                  textAlign: TextAlign.start),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text('Thông tin các dịch vụ',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                  textAlign: TextAlign.start),
            ),
            const SizedBox(height: 10),
            ...widget.jobInfo[0].service.map((service) {
              final priceReverse = StringUtils.addCharAtPosition(
                  StringUtils.reverse(service.price), ".", 3,
                  repeat: true);
              return Card(
                child: ListTile(
                  leading: Container(
                    padding:
                        const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: Text(
                      service.qt.toString(),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      service.name,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      service.description,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54),
                    ),
                  ),
                  trailing: Container(
                    padding:
                        const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: Text(
                      '${StringUtils.reverse(priceReverse)} Đ',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.only(top: 15),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text('Tổng thanh toán:',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontFamily: GoogleFonts.lato().fontFamily,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87),
                        textAlign: TextAlign.start),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text('${StringUtils.reverse(priceReverseSum)} VNĐ',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontFamily: GoogleFonts.lato().fontFamily,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87),
                        textAlign: TextAlign.start),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ]),
    ));
  }
}
