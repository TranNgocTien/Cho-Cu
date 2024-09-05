import 'dart:async';

import 'package:basic_utils/basic_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chotot/data/job_service_data.dart';
import 'package:chotot/models/get_a_job_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HostRateWorkerScreen extends StatefulWidget {
  const HostRateWorkerScreen(
      {super.key,
      required this.jobInfo,
      required this.date,
      required this.time});
  final List<GetAJobModel> jobInfo;
  final String date;
  final String time;
  @override
  State<HostRateWorkerScreen> createState() => _HostRateWorkerScreenState();
}

class _HostRateWorkerScreenState extends State<HostRateWorkerScreen> {
  bool isLoading = true;

  @override
  void initState() {
    Timer(const Duration(milliseconds: 1000), () async {
      setState(() {
        isLoading = false;
      });
    });
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
                                                          element.name.trim() ==
                                                          widget.jobInfo[0].name
                                                              .trim(),
                                                    ) ==
                                                    null
                                                ? Image.asset(
                                                    'image/logo_tho_thong_minh.jpeg')
                                                : Image.network(
                                                    jobServiceList
                                                        .firstWhere((element) =>
                                                            element.name
                                                                .trim() ==
                                                            widget
                                                                .jobInfo[0].name
                                                                .trim())
                                                        .img,
                                                    fit: BoxFit.contain,
                                                    height: double.infinity,
                                                    width:
                                                        MediaQuery.of(context)
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
                                              '${widget.jobInfo[0].photos.indexOf(photo) + 1}/${widget.jobInfo[0].photos.length}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: widthDevice * 0.035,
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
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
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
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text('Mô tả:',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w600,
                                fontSize: widthDevice * 0.04,
                                color: Colors.black87),
                        textAlign: TextAlign.start),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(widget.jobInfo[0].description,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: widthDevice * 0.035,
                            color: Colors.black54),
                        textAlign: TextAlign.start),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text('Thời gian làm việc:',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w600,
                                fontSize: widthDevice * 0.04,
                                color: Colors.black87),
                        textAlign: TextAlign.start),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text('${widget.time} ngày ${widget.date}',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: widthDevice * 0.035,
                            color: Colors.black54),
                        textAlign: TextAlign.start),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text('Danh sách các dịch vụ:',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontFamily: GoogleFonts.poppins().fontFamily,
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
                            (int.parse(service.price) * service.qt).toString()),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  service.name,
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
                              )
                            : const Text(''),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text('Đánh giá từ chủ nhà',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w600,
                                fontSize: widthDevice * 0.04,
                                color: Colors.black87),
                        textAlign: TextAlign.start),
                  ),
                  const SizedBox(height: 15),
                  widget.jobInfo[0].rate.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                              'Chưa có đánh giá từ chủ nhà cho công việc này',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: widthDevice * 0.035,
                                      color: Colors.black87),
                              textAlign: TextAlign.start),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              widget.jobInfo[0].rate[0].content.isEmpty
                                  ? const SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Text(
                                        'Nội dung: ${widget.jobInfo[0].rate[0].content}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              fontSize: widthDevice * 0.035,
                                            ),
                                      ),
                                    ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Khả năng chuyên môn:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: widthDevice * 0.035,
                                        ),
                                  ),
                                  RatingBar.builder(
                                    ignoreGestures: true,
                                    initialRating: (double.tryParse(
                                            widget.jobInfo[0].rate[0].d1)! /
                                        20),
                                    minRating: 0,
                                    maxRating: 100,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 30,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {},
                                    // initialRating: (double.tryParse(
                                    //         getAUserController.aUser[0].worker.ds)! /
                                    //     20),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Thái độ công việc:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: widthDevice * 0.035,
                                        ),
                                  ),
                                  RatingBar.builder(
                                    initialRating: (double.tryParse(
                                            widget.jobInfo[0].rate[0].d2)! /
                                        20),
                                    minRating: 0,
                                    maxRating: 100,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemSize: 30,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Đến đúng giờ:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: widthDevice * 0.035,
                                        ),
                                  ),
                                  RatingBar.builder(
                                    initialRating: (double.tryParse(
                                            widget.jobInfo[0].rate[0].d3)! /
                                        20),
                                    minRating: 0,
                                    maxRating: 100,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemSize: 30,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Kỹ thuật/ kỹ năng:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: widthDevice * 0.035,
                                        ),
                                  ),
                                  RatingBar.builder(
                                    initialRating: (double.tryParse(
                                            widget.jobInfo[0].rate[0].d4)! /
                                        20),
                                    minRating: 0,
                                    maxRating: 100,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemSize: 30,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Mức độ hài lòng:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: widthDevice * 0.035,
                                        ),
                                  ),
                                  RatingBar.builder(
                                    initialRating: (double.tryParse(
                                            widget.jobInfo[0].rate[0].d5)! /
                                        20),
                                    minRating: 0,
                                    maxRating: 100,
                                    itemSize: 30,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Điểm trung bình các đánh giá: ${widget.jobInfo[0].rate[0].ds}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontWeight: FontWeight.w600,
                                      fontSize: widthDevice * 0.035,
                                      color:
                                          const Color.fromRGBO(38, 166, 83, 1),
                                    ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
