import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:basic_utils/basic_utils.dart' as priceLibrary;
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:chotot/controllers/statistics_user.dart';
import 'package:chotot/data/ly_lich.dart';
// import 'package:chotot/data/ly_lich.dart';
import 'package:chotot/data/statistics_user_data.dart';
import 'package:chotot/data/type_user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsUserScreen extends StatefulWidget {
  const StatisticsUserScreen({super.key});

  @override
  State<StatisticsUserScreen> createState() => _StatisticsUserScreenState();
}

class _StatisticsUserScreenState extends State<StatisticsUserScreen> {
  // List dateJoin = lyLichInfo[0]
  //     .joinDate
  //     .substring(lyLichInfo[0].joinDate.indexOf(',') + 1,
  //         lyLichInfo[0].joinDate.length)
  //     .replaceAll('/', '-')
  //     .split('-');
  StatisticsUser statisticsUser = Get.put(StatisticsUser());
  late TooltipBehavior _tooltipBehavior;
  bool swapLoading = false;
  bool isLoading = false;
  String dateConvertToString = '';
  List<DateTime?> fromDate = [
    DateTime.now(),
  ];

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    DateTime? valueText = (values.isNotEmpty ? values[0] : null);
    // .toString()
    // .replaceAll('00:00:00.000', '');
    String formattedDate = DateFormat('d/M/y').format(valueText!);
    dateConvertToString = DateFormat('y-MM-dd').format(valueText);
    return formattedDate;
  }

  DateTime now = DateTime.now();
  getStatisticsData() async {
    statisticsUserData.clear();
    await statisticsUser.getStatisticsUser(
        type,
        '${now.year}-${now.month < 10 ? '0' : ''}${now.month}-01',
        '${now.year}-${now.month + 1 < 10 ? '0' : ''}${now.month + 1 > 12 ? 12 : now.month + 1}-${now.month + 1 > 12 ? '30' : ''}');
    statisticsUserData.add(statisticsUser.statisticsUser);
  }

  getStatisticsDataTotal() async {
    statisticsUserDataTotal.clear();
    await statisticsUser.getStatisticsUser(
        type, '${now.year}-01-01', '${now.year}-12-30');
    statisticsUserDataTotal.add(statisticsUser.statisticsUser);
    Timer(const Duration(seconds: 3), () {
      setState(() {
        swapLoading = false;
      });
    });
  }

  getFormatPrice(price) {
    final priceReverse = priceLibrary.StringUtils.addCharAtPosition(
        priceLibrary.StringUtils.reverse(price), ".", 3,
        repeat: true);

    return priceLibrary.StringUtils.reverse(priceReverse);
  }

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  List<DateTime?> toDate = [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
  ];
  @override
  Widget build(BuildContext context) {
    // String correctFormatDate =
    //     dateJoin[2] + '-' + dateJoin[1] + '-' + dateJoin[0];
    // final DateTime date2 =
    //     DateTime.parse(correctFormatDate.replaceAll(" ", "")).toUtc();
    // final date1 = DateTime.now().toUtc();
    // Duration month = date1.difference(date2);
    // print(month.inDays);
    final config = CalendarDatePicker2Config(
      selectedDayHighlightColor: Colors.amber[900],
      weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      firstDayOfWeek: 1,
      controlsHeight: 50,
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      dayTextStyle: const TextStyle(
        color: Colors.amber,
        fontWeight: FontWeight.bold,
      ),
      disabledDayTextStyle: const TextStyle(
        color: Colors.grey,
      ),
      selectableDayPredicate: (day) => !day
          .difference(DateTime.now().subtract(const Duration(days: 3)))
          .isNegative,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
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
        title: Text(
          type == 'host' ? 'Thống kê chi tiêu' : 'Thống kê thu nhập',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.white,
              ),
        ),
      ),
      body: swapLoading
          ? Center(
              child: LoadingAnimationWidget.waveDots(
                color: const Color.fromRGBO(1, 142, 33, 1),
                size: 30,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  lyLichInfo[0].workerAuthen == 'true'
                      ? GestureDetector(
                          onTap: () async {
                            setState(() {
                              swapLoading = true;
                              type = type == 'host' ? 'worker' : 'host';
                              getStatisticsData();
                              getStatisticsDataTotal();
                            });

                            // await prefs.setString('token', token.toString());
                          },
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: Row(children: [
                                      Image.asset(
                                        type == 'host'
                                            ? 'image/computer-worker.png'
                                            : 'image/mechanic.png',
                                        height: 30,
                                        width: 30,
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Text(
                                          type == 'host'
                                              ? 'Chủ Nhà - ${lyLichInfo[0].name}'
                                              : 'Thợ - ${lyLichInfo[0].name}',
                                          style:
                                              GoogleFonts.poppins(fontSize: 16),
                                          softWrap: true,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ]),
                                  ),
                                  const Icon(Icons.change_circle_outlined)
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text(
                          'Chọn thời gian:',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Từ ngày:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                  ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, right: 10),
                              // decoration: BoxDecoration(
                              //   border: Border.all(color: Colors.grey),
                              //   borderRadius: BorderRadius.circular(10),
                              // ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                      icon: const FaIcon(
                                          FontAwesomeIcons.calendarDay),
                                      onPressed: () async {
                                        fromDate =
                                            (await showCalendarDatePicker2Dialog(
                                          context: context,
                                          config:
                                              CalendarDatePicker2WithActionButtonsConfig(
                                            lastDate: DateTime.now(),
                                          ),
                                          dialogSize: const Size(325, 400),
                                          value: fromDate,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ))!;

                                        setState(() {});
                                      }),
                                  Text(
                                    _getValueText(
                                        config.calendarType, fromDate),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Đến ngày:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                  ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, right: 10),
                              // decoration: BoxDecoration(
                              //   border: Border.all(color: Colors.grey),
                              //   borderRadius: BorderRadius.circular(10),
                              // ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                      icon: const FaIcon(
                                          FontAwesomeIcons.calendarDay),
                                      onPressed: () async {
                                        toDate =
                                            (await showCalendarDatePicker2Dialog(
                                          context: context,
                                          config:
                                              CalendarDatePicker2WithActionButtonsConfig(
                                            lastDate: DateTime.now(),
                                          ),
                                          dialogSize: const Size(325, 400),
                                          value: toDate,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ))!;

                                        setState(() {});
                                      }),
                                  Text(
                                    _getValueText(config.calendarType, toDate),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        MaterialButton(
                          elevation: 1.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          height: 40.0,
                          minWidth: 100.0,
                          color: const Color.fromRGBO(38, 166, 83, 1),
                          child: Text(
                            'Tra cứu',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  color: Colors.white,
                                ),
                          ),
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            statisticsUserData.clear();
                            if (DateTime.parse(fromDate.toString().substring(
                                        1, toDate.toString().indexOf(' ')))
                                    .compareTo(DateTime.parse(toDate
                                        .toString()
                                        .substring(1,
                                            toDate.toString().indexOf(' ')))) >
                                0) {
                              AwesomeDialog(
                                context: Get.context!,
                                animType: AnimType.scale,
                                dialogType: DialogType.warning,
                                title: 'Thời gian tra cứu không hợp lệ',
                                titleTextStyle: GoogleFonts.poppins(),
                              ).show();
                            }
                            await statisticsUser.getStatisticsUser(
                                'host',
                                fromDate.toString().substring(
                                    1, toDate.toString().indexOf(' ')),
                                toDate.toString().substring(
                                    1, toDate.toString().indexOf(' ')));
                            statisticsUserData
                                .add(statisticsUser.statisticsUser);

                            setState(() {
                              isLoading = false;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  isLoading == true
                      ? Center(
                          child: LoadingAnimationWidget.waveDots(
                            color: const Color.fromRGBO(1, 142, 33, 1),
                            size: 30,
                          ),
                        )
                      : Column(
                          children: [
                            Card(
                              color: Colors.white,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: SfCartesianChart(
                                    primaryXAxis: const CategoryAxis(
                                        axisBorderType:
                                            AxisBorderType.rectangle),
                                    legend: const Legend(isVisible: true),
                                    tooltipBehavior: _tooltipBehavior,
                                    title: ChartTitle(
                                      text: type == 'host'
                                          ? 'Thống kê chi tiêu năm ${DateTime.now().year}'
                                          : 'Thống kê thu nhập năm ${DateTime.now().year}',
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                          ),
                                    ),
                                    series: <ColumnSeries<Satistics, String>>[
                                      ColumnSeries<Satistics, String>(
                                          name: '',
                                          trackColor: Colors.red,
                                          color: const Color.fromRGBO(
                                              38, 166, 83, 1),
                                          pointColorMapper:
                                              (Satistics data, _) => data.color,
                                          dataSource: <Satistics>[
                                            Satistics(
                                                '${_getValueText(config.calendarType, fromDate)} - ${_getValueText(config.calendarType, toDate)}',
                                                statisticsUserData[0].sum,
                                                const Color.fromARGB(
                                                    255, 187, 225, 43)),
                                            Satistics(
                                                DateTime.now().year.toString(),
                                                statisticsUserDataTotal[0].sum,
                                                const Color.fromARGB(
                                                    255, 159, 212, 225)),
                                          ],
                                          xValueMapper: (Satistics sales, _) =>
                                              sales.year,
                                          yValueMapper: (Satistics sales, _) =>
                                              sales.sales,
                                          // Enable data label
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true))
                                    ]),
                              ),
                            ),
                            Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        '${_getValueText(config.calendarType, fromDate)} - ${_getValueText(config.calendarType, toDate)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          type == 'host'
                                              ? 'Chi tiêu:'
                                              : 'Thu nhập:',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                              ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          getFormatPrice(statisticsUserData[0]
                                              .sum
                                              .toString()),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          type == 'host'
                                              ? 'Số lượng dịch vụ:'
                                              : 'Số lượng công việc:',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                              ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          statisticsUserData[0]
                                              .count
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Center(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    color: Colors.grey))),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Center(
                                      child: Text(
                                        DateTime.now().year.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          type == 'host'
                                              ? 'Chi tiêu'
                                              : 'Thu nhập',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                              ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          getFormatPrice(
                                              statisticsUserDataTotal[0]
                                                  .sum
                                                  .toString()),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          type == 'host'
                                              ? 'Số lượng dịch vụ:'
                                              : 'Số lượng công việc:',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                              ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          statisticsUserDataTotal[0]
                                              .count
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
    );
  }
}

class Satistics {
  Satistics(this.year, this.sales, this.color);
  final String year;
  final int sales;
  final Color color;
}
