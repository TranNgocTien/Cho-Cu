import 'dart:ui';

import 'package:chotot/controllers/get_job_type.dart';
import 'package:chotot/data/job_type_data.dart';
import 'package:chotot/data/statistics_data.dart';
import 'package:chotot/models/job_type.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:math';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

// background-color: #378b29;
// background-image: linear-gradient(315deg, #378b29 0%, #ffffff 74%);

class _StatisticsScreenState extends State<StatisticsScreen> {
  GetJobTypeController getJobTypeController = Get.put(GetJobTypeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thống kê',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(55, 139, 41, 0),
                Color.fromRGBO(255, 255, 255, 0.9)
              ],
            ),
          ),
        ),
      ),
      body: getJobTypeController.isLoading == true
          ? Center(
              child: LoadingAnimationWidget.waveDots(
                color: const Color.fromRGBO(1, 142, 33, 1),
                size: 30,
              ),
            )
          : Container(
              padding: const EdgeInsets.only(left: 10),
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(55, 139, 41, 0),
                    Color.fromRGBO(255, 255, 255, 0.9)
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Số lượng thợ ở các dịch vụ',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ...statisticsData[0]
                                  .workerTypeList
                                  .map((workerType) {
                                JobTypeModel typeName = jobTypeList.firstWhere(
                                    (type) =>
                                        type.jobtypeId == workerType.name);
                                return Card(
                                  color: Colors.white,
                                  elevation: 1,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 15, right: 15, left: 15),
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.width *
                                        0.55,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          child: Text(
                                            typeName.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    color: const Color.fromARGB(
                                                        255, 84, 84, 84),
                                                    fontSize: 15),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.person,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              workerType.amount,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    fontSize: 20,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        CircularPercentIndicator(
                                          radius: 50,
                                          percent: int.parse(
                                                  workerType.amount) /
                                              int.parse(
                                                  statisticsData[0].workers),
                                          animation: true,
                                          lineWidth: 10,
                                          curve: Curves.easeInOut,
                                          animateFromLastPercent: true,
                                          center: Text(
                                            '${((int.parse(workerType.amount) / int.parse(statisticsData[0].workers)) * 100).ceil()}%',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    color: Colors.grey,
                                                    fontSize: 15),
                                          ),
                                          progressColor: Colors.primaries[
                                              Random().nextInt(
                                                  Colors.primaries.length)],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList()
                            ],
                          )),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 5,
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(20),
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tổng cộng:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Image.asset('image/job-search.png',
                                      height: 90, width: 90),
                                  const Spacer(),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        statisticsData[0].jobs,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                            ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'công việc',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                                color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  Image.asset('image/workers-statistics.png',
                                      height: 90, width: 90),
                                  const Spacer(),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        statisticsData[0].workers,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                            ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'thợ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                                color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
