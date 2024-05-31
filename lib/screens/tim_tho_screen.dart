import 'dart:convert';
import 'dart:io';

// import 'package:basic_utils/basic_utils.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:basic_utils/basic_utils.dart' as basic;
import 'package:chotot/controllers/book_job_v3.dart';
import 'package:chotot/controllers/get_job_item.dart';
import 'package:chotot/controllers/get_jobservice.dart';
import 'package:chotot/controllers/get_price_v2.dart';

import 'package:chotot/data/get_job_item_data.dart';
import 'package:chotot/data/job_service_data.dart';
import 'package:chotot/data/selected_items.dart';

import 'package:chotot/models/addressUpdate.dart';
import 'package:chotot/models/job_item.dart';
import 'package:chotot/models/place.dart';

import 'package:chotot/screens/homeScreen.dart';
import 'package:chotot/screens/job_item_screen.dart';
import 'package:chotot/screens/mapScreen.dart';
// import 'package:chotot/screens/voucher_valid_screen.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:dropdown_button2/dropdown_button2.dart';

class TimThoThongMinhScreen extends StatefulWidget {
  const TimThoThongMinhScreen({
    super.key,
    required this.codeService,
    required this.nameService,
  });
  final String codeService;
  final String nameService;
  @override
  State<TimThoThongMinhScreen> createState() => _TimThoThongMinhScreenState();
}

class _TimThoThongMinhScreenState extends State<TimThoThongMinhScreen> {
  final _formKey = GlobalKey<FormState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final ImagePicker imagePicker = ImagePicker();
  GetJobItem getJobItem = Get.put(GetJobItem());
  GetJobService getJobService = Get.put(GetJobService());
  GetPrice getPrice = Get.put(GetPrice());
  BookJob bookJob = Get.put(BookJob());
  String serviceSelected = '';
  String workHour = '';
  int timeStampWorkhour = 0;
  int countGetPrice = 0;

  Future<void> _convertCoordinatefromAddress(double lat, double lng) async {
    final url = Uri.parse(
        'https://rsapi.goong.io/Geocode?latlng=$lat,$lng&api_key=WOXLNGkieaqVH3DPxcDpJoInSLk7QQajAHdzmyhB');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];

    setState(() {
      bookJob.addressController.text = address;
    });
  }

  Future<void> _convertAddressToCoordinate(string) async {
    // List<Location> location = await locationFromAddress(string);
    final url = Uri.parse(
        'https://rsapi.goong.io/geocode?address=$string&api_key=WOXLNGkieaqVH3DPxcDpJoInSLk7QQajAHdzmyhB');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final latlng = resData['results'][0]['geometry'];
    final lat = latlng['location']['lat'];
    final lng = latlng['location']['lng'];
    bookJob.lat = lat;

    bookJob.lng = lng;

    if (bookJob.lat == null || bookJob.lng == null) {
      return;
    }
  }

  bookJobV3() async {
    if (bookJob.imageFileList!.length > 3) {
      await AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Đăng tối thiểu 1 ảnh, tối đa 3 ảnh',
        titleTextStyle: GoogleFonts.poppins(),
      ).show();

      return;
    }
    await bookJob.uploadJobPhoto();
    if (bookJob.addressController.text.isEmpty) {
      await AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Vui lòng chọn theo tên gợi ý!',
        titleTextStyle: GoogleFonts.poppins(),
      ).show();
      return;
    }
    if (bookJob.addressController.text.isEmpty ||
        bookJob.nameController.text.isEmpty ||
        bookJob.phoneController.text.isEmpty) {
      await AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Vui lòng điền đầy đủ các thông tin',
        titleTextStyle: GoogleFonts.poppins(),
      ).show();
      return;
    }
    await _convertAddressToCoordinate(bookJob.addressController.text);

    if (bookJob.lat == null || bookJob.lng == null) {
      await AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Nhập lại địa chỉ',
        titleTextStyle: GoogleFonts.poppins(),
      ).show();
      return;
    }

    await bookJob.bookJob(
      serviceSelected,
      getPrice.dataPrice.workDate,
      workHour,
      getPrice.dataPrice.priceId,
    );
    items.clear();
    bookJob.imageFileList!.clear();

    Get.to(const MainScreen());
  }

  _openGallery() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.length > 3) {
      await AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Vui lòng chọn không quá 3 hình ảnh',
        titleTextStyle: GoogleFonts.poppins(),
      ).show();
      return;
    }
    if (selectedImages.isNotEmpty) {
      bookJob.imageFileList!.addAll(selectedImages);
    }
    setState(() {});
    // try {
    //   final imageFileGallery = await ImagePicker()
    //       .pickImage(source: ImageSource.gallery, maxWidth: 600);
    //   if (imageFileGallery == null) return;
    //   final imageTemp = File(imageFileGallery.path);
    //   setState(() {
    //     imageFile = imageTemp;
    //   });
    // } on PlatformException catch (e) {
    //   AlertDialog(
    //     content: Text(
    //       e.toString(),
    //     ),
    //   );
    // }
  }

  showAlertDialog(context) => AwesomeDialog(
      // autoDismiss: false,
      context: Get.context!,
      animType: AnimType.scale,
      dialogType: DialogType.info,
      body: Center(
        child: Text(
          'Cấp phép truy cập máy ảnh',
          style: TextStyle(
              color: Colors.black,
              fontFamily: GoogleFonts.poppins().fontFamily),
          textAlign: TextAlign.center,
        ),
      ),
      btnOk: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(39, 166, 82, 1),
        ),
        onPressed: () => openAppSettings(),
        child: Text(
          'Cài đặt',
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      btnCancel: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(39, 166, 82, 1)),
        onPressed: () {
          Get.back();
        },
        child: Text(
          'Hủy bỏ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      btnOkOnPress: () => openAppSettings(),
      btnCancelOnPress: () {
        Get.back();
      }).show();

  _openCamera(context) async {
    var status = await Permission.camera.status;

    if (status.isPermanentlyDenied) {
      showAlertDialog(context);
      return;
    }

    try {
      List<XFile> selectedImages = [];
      final imageFileGallery = await ImagePicker()
          .pickImage(source: ImageSource.camera, maxWidth: 600);
      if (imageFileGallery == null) return;
      final imageTemp = XFile(imageFileGallery.path);
      selectedImages.add(imageTemp);
      setState(() {
        bookJob.imageFileList!.addAll(selectedImages);
      });
    } on PlatformException catch (e) {
      AlertDialog(
        content: Text(
          e.toString(),
        ),
      );
    }
    Get.back();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return AwesomeDialog(
            width: double.infinity,
            context: Get.context!,
            animType: AnimType.scale,
            dialogType: DialogType.info,
            body: Center(
              child: Text(
                'Lựa chọn tải ảnh',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: GoogleFonts.poppins().fontFamily),
                textAlign: TextAlign.center,
              ),
            ),
            btnOk: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(38, 166, 83, 1)),
              onPressed: () {
                _openGallery();
                Get.back();
              },
              icon: const FaIcon(FontAwesomeIcons.image, color: Colors.white),
              label: Text(
                'Thư viện',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            btnCancel: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(38, 166, 83, 1),
              ),
              onPressed: () async {
                await _openCamera(context);
              },
              icon: const FaIcon(
                FontAwesomeIcons.camera,
                color: Colors.white,
              ),
              label: Text(
                'Máy ảnh',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            btnOkOnPress: () {},
            btnCancelOnPress: () async {})
        .show();

    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         content: Container(
    //           width: MediaQuery.of(context).size.width * 0.3,
    //           height: MediaQuery.of(context).size.height * 0.2,
    //           padding: const EdgeInsets.all(10),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               const SizedBox(
    //                 height: 20,
    //               ),
    //               Text(
    //                 'Lựa chọn tải ảnh:',
    //                 style: Theme.of(context).textTheme.titleMedium!.copyWith(
    //                       fontFamily: GoogleFonts.poppins().fontFamily,
    //                       color: Colors.black,
    //                       fontWeight: FontWeight.w600,
    //                     ),
    //                 textAlign: TextAlign.center,
    //               ),
    //               const SizedBox(height: 20),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   GestureDetector(
    //                     onTap: () {
    //                       _openGallery();
    //                     },
    //                     child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         const Icon(FontAwesomeIcons.image),
    //                         Text(
    //                           'Thư viện',
    //                           style: Theme.of(context)
    //                               .textTheme
    //                               .labelLarge!
    //                               .copyWith(
    //                                 fontFamily:
    //                                     GoogleFonts.poppins().fontFamily,
    //                                 color: Colors.black,
    //                                 fontWeight: FontWeight.w600,
    //                               ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                   GestureDetector(
    //                     onTap: () {
    //                       _openCamera();
    //                     },
    //                     child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         const Icon(FontAwesomeIcons.camera),
    //                         Text(
    //                           'Chụp ảnh',
    //                           style: Theme.of(context)
    //                               .textTheme
    //                               .labelLarge!
    //                               .copyWith(
    //                                 fontFamily:
    //                                     GoogleFonts.poppins().fontFamily,
    //                                 color: Colors.black,
    //                                 fontWeight: FontWeight.w600,
    //                               ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     });
  }

  List<XFile>? imageFileList = [];
  List<DateTime?> initialDate = [
    DateTime.now(),
  ];
  var time = DateTime.now();
  // var idSevice = '';
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
  ];

  List<String> selectedItemsId = [];
  String dateConvertToString = '';
  String hourConvertToString = '';
  int tempTotalPrice = 0;

  // dynamic code = '';
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

// millisecondsSinceEpoch
  getPriceFunc() async {
    if (getPrice.code.runtimeType != String) getPrice.code = '';
    var workDate = '$dateConvertToString$hourConvertToString'
        'Z';

    if (dateConvertToString != '' && hourConvertToString != '') {
      var milisecondsConvert = DateTime.parse(workDate);

      var timeStamp = milisecondsConvert.millisecondsSinceEpoch;
      if (jobItemsSelected.isEmpty) {
        AwesomeDialog(
          context: Get.context!,
          animType: AnimType.scale,
          dialogType: DialogType.info,
          body: Center(
            child: Text(
              'Vui lòng chọn dịch vụ',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: GoogleFonts.montserrat().fontFamily),
              textAlign: TextAlign.center,
            ),
          ),
        ).show();

        return;
      }
      await getPrice.getPrice(
        countGetPrice == 0 ? '' : getPrice.dataPrice.priceId,
        timeStamp.toString(),
        jobItemsSelected,
        bookJobV3,
      );
      setState(() {});
      countGetPrice++;
    } else {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              contentPadding: EdgeInsets.all(20),
              children: [
                Center(
                  child: Text('Vui lòng chọn thời gian đặt thợ'),
                ),
              ],
            );
          });
      return;
    }
  }

  List image = [];
  List dienuoc = ['image/DICH VU DIEN-NUOC/KIEM TRA KHAC PHUC DIEN NUOC.png'];
  List maygiat = [
    'image/DICH VU MAY GIAT/1 VS CUA TREN.png',
    'image/DICH VU MAY GIAT/2 VS CUA TRUOC.png'
  ];
  List maylanh = [
    'image/DICH VU MAY LANH/1 VSML 1-1.5HP.png',
    'image/DICH VU MAY LANH/2 VSML 2-2.5HP.png',
    'image/DICH VU MAY LANH/3 VSML AM TRAN.png',
    'image/DICH VU MAY LANH/4 VSML TU DUNG.png',
    'image/DICH VU MAY LANH/5 VSML MULTI.png',
    'image/DICH VU MAY LANH/6 LAP DAT TREO TUONG (THAO NGUYEN BO).png',
    'image/DICH VU MAY LANH/7 LAP DAT TREO TUONG (LAP NGUYEN BO).png',
    'image/DICH VU MAY LANH/8 LAP DAT TREO TUONG(THAO VA LAP).png',
    'image/DICH VU MAY LANH/9 LAP DAT TREO TUONG (THAY DAN NONG.png',
    'image/DICH VU MAY LANH/10 LAP DAT TREO TUONG(THAY DAN LANH).png',
    'image/DICH VU MAY LANH/11 LAP DAT TU DUNG,AP TRAN, AM TRAN(THAO).png',
    'image/DICH VU MAY LANH/12 LAP DAT TU DUNG, AP TRAN, AM TRAN(LAP).png',
    'image/DICH VU MAY LANH/13 LAP DAT TU DUNG (THAO VA LAP).png',
    'image/DICH VU MAY LANH/14 LAP DAT TU DUNG,AP TRAN, AM TRAN(THAY DAN NONG).png',
    'image/DICH VU MAY LANH/15 LAP DAT TU DUNG,AM TRAN,AP TRAN(THAY DAN LANH).png',
    'image/DICH VU MAY LANH/16-20 SAC GAS.png',
    'image/DICH VU MAY LANH/16-20 SAC GAS.png',
    'image/DICH VU MAY LANH/16-20 SAC GAS.png',
    'image/DICH VU MAY LANH/16-20 SAC GAS.png',
    'image/DICH VU MAY LANH/16-20 SAC GAS.png',
  ];
  List quatmay = [
    'image/DICH VU QUAT MAY/1 VS QUAT DIEU HOA.png',
    'image/DICH VU QUAT MAY/2 VS QUAT KHO.png',
  ];
  List tulanh = [
    'image/DICH VU TU LANH/1 VS TU LANH THUONG.png',
    'image/DICH VU TU LANH/2 VS TU LANH 2 CANH.png',
    'image/DICH VU TU LANH/3 SUA CHUA TU LANH.png',
  ];
  List giadung = [
    'image/DV LAP DAT THIET BI GIA DUNG/LAP DAT THIET BI GIA DUNG.png',
  ];
  List maytinh = [
    'image/DV MAY TINH-IN/1 SUA CHUA MAY TINH.png',
    'image/DV MAY TINH-IN/2 BAO TRI MAY TINH.png',
    'image/DV MAY TINH-IN/3 BAO TRI MAY IN.png',
  ];

  chooseListImage(nameService) {
    switch (nameService) {
      case "Dịch vụ máy lạnh":
        return maylanh;
      case "Dịch vụ máy giặt":
        return maygiat;
      case "Dịch vụ quạt máy":
        return quatmay;
      case "Dịch vụ tủ lạnh":
        return tulanh;
      case "Dịch vụ sửa chữa điện – nước":
        return dienuoc;
      case "Dịch vụ lắp đặt thiết bị gia dụng":
        return giadung;
      case "Dịch vụ máy tính - máy in":
        return maytinh;
      default:
    }
  }

  priceReserve(price) {
    return basic.StringUtils.addCharAtPosition(
        basic.StringUtils.reverse(price.toString()), ".", 3,
        repeat: true);
  }

  prePriceReserve(index) {
    var price =
        int.parse(jobItemsSelected[index].price) * jobItemsSelected[index].qt;
    return basic.StringUtils.addCharAtPosition(
        basic.StringUtils.reverse(price.toString()), ".", 3,
        repeat: true);
  }

  void _modalBottomSheetMenu() async {
    // image = await chooseListImage(widget.nameService);
    await getJobItem.getJobItem(widget.codeService);
    showMaterialModalBottomSheet(
        context: Get.context!,
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
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
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
              ),
              title: Text(
                jobServiceList
                    .firstWhere((element) => element.code == widget.codeService)
                    .name,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: Colors.white,
                      fontSize: 18,
                    ),
              ),
            ),
            body: SafeArea(
              child: ListView.builder(
                itemCount: jobItemList.length,
                itemBuilder: (context, int index) {
                  final priceReverse = basic.StringUtils.addCharAtPosition(
                      basic.StringUtils.reverse(jobItemList[index].price),
                      ".",
                      3,
                      repeat: true);
                  return GFListTile(
                      avatar: GFAvatar(
                        shape: GFAvatarShape.circle,
                        backgroundColor:
                            const Color.fromARGB(255, 192, 244, 210),
                        child: Image.asset(
                          image[index],
                        ),
                      ),
                      // titleText: vouchersValid[index].name,
                      title: Text(jobItemList[index].name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith()),
                      subTitle: Text(
                          '${basic.StringUtils.reverse(priceReverse)} VNĐ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w900,
                              )),
                      description: Text(jobItemList[index].description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              )),
                      // icon: Icon(Icons.home, color: Colors.red),
                      padding: EdgeInsets.zero,
                      radius: 50,
                      onTap: () {
                        setState(() {
                          selectedItems.add(
                              '${jobServiceList.firstWhere((element) => element.code == jobItemList[index].jobserviceId).name} - ${jobItemList[index].name}');

                          List<JobItems> id = jobItemList
                              .where((element) =>
                                  element.name == jobItemList[index].name)
                              .toList();
                          int indexJobItemList = jobItemList.indexWhere(
                              (element) => element.id == jobItemList[index].id);

                          jobItemsSelected.add(jobItemList[indexJobItemList]);
                          selectedItemsId.add(id[0].id);
                          serviceSelected = jobServiceList
                              .firstWhere((element) =>
                                  element.code ==
                                  jobItemList[index].jobserviceId)
                              .name;
                          tempTotalPrice +=
                              int.parse(jobItemList[indexJobItemList].price);
                        });
                        Navigator.pop(context);
                      }
                      // title: Text('$dateTo-$dateFrom'),
                      );
                },
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    // print(image);
    hourConvertToString =
        ' ${time.hour < 10 ? 0 : ''}${time.hour.toString()}:${time.minute < 10 ? 0 : ''}${time.minute.toString()}:${time.second < 10 ? 0 : ''}${time.second.toString()}';
    if (widget.codeService != '') {
      image = chooseListImage(widget.nameService);
      _modalBottomSheetMenu();
    }
    selectedItems.clear();
    jobItemsSelected.clear();
    super.initState();
  }

  @override
  void dispose() {
    selectedItems.clear();
    jobItemsSelected.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Đặt thợ thông minh',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Colors.white,
                ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tên chủ đơn hàng: ',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 192, 244, 210)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 15, right: 15),
                      child: TextFormField(
                        controller: bookJob.nameController,
                        decoration: const InputDecoration(
                          hintText: 'Họ và tên chủ đơn hàng',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.streetAddress,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('required!'),
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Địa chỉ của bạn: ',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 5.0,
                          right: 5.0,
                          bottom: 10.0,
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color:
                                    const Color.fromARGB(255, 192, 244, 210)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TypeAheadField<AddressUpdate?>(
                            hideOnError: true,
                            debounceDuration: const Duration(milliseconds: 500),
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: bookJob.addressController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Địa chỉ (chọn địa chỉ gợi ý)',
                              ),
                            ),
                            suggestionsCallback:
                                AddressUpdateApi.getAddressSuggestions,
                            itemBuilder: (context, AddressUpdate? suggestion) {
                              final address = suggestion!;
                              return ListTile(
                                title: Text(address.description),
                              );
                            },
                            noItemsFoundBuilder: (context) => SizedBox(
                              height: 100,
                              child: Center(
                                child: Text(
                                  'Không tìm thấy địa chỉ.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontSize: 18,
                                      ),
                                ),
                              ),
                            ),
                            onSuggestionSelected: (AddressUpdate? suggestion) {
                              final address = suggestion!;
                              setState(() {});
                              bookJob.addressController.text =
                                  address.description;

                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Selected address: ${address.description}'),
                                  ),
                                );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        onPressed: () async {
                          final SharedPreferences prefs = await _prefs;

                          // await prefs.setString('token', token.toString());

                          final lat = prefs.getDouble('lat')!;
                          final lng = prefs.getDouble('lng')!;

                          final pickedLocation =
                              await Navigator.of(context).push<LatLng>(
                            MaterialPageRoute(
                              builder: (ctx) => MapScreen(
                                  currentLocation: PlaceLocation(
                                      latitude: lat,
                                      longitude: lng,
                                      address: '')),
                            ),
                          );

                          if (pickedLocation == null) {
                            return;
                          }

                          _convertCoordinatefromAddress(pickedLocation.latitude,
                              pickedLocation.longitude);
                        },
                        shape: const CircleBorder(
                            eccentricity: 0.0,
                            side: BorderSide(
                              color: Color.fromRGBO(38, 166, 83, 1),
                              width: 2.0,
                            )),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                        elevation: 20.0,
                        child: const FaIcon(FontAwesomeIcons.locationPin,
                            size: 25, color: Color.fromRGBO(38, 166, 83, 1)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Số điện thoại liên hệ:',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 192, 244, 210)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 15, right: 15),
                      child: TextFormField(
                        controller: bookJob.phoneController,
                        decoration: const InputDecoration(
                          hintText: 'Số điện thoại của bạn! (Bắt buộc)',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.phone,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Phone input is required!'),
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Chọn thời gian: ',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 192, 244, 210)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                                icon:
                                    const FaIcon(FontAwesomeIcons.calendarDay),
                                onPressed: () async {
                                  initialDate =
                                      (await showCalendarDatePicker2Dialog(
                                    context: context,
                                    config:
                                        CalendarDatePicker2WithActionButtonsConfig(),
                                    dialogSize: const Size(325, 400),
                                    value: initialDate,
                                    borderRadius: BorderRadius.circular(15),
                                  ))!;
                                  setState(() {});
                                }),
                            Text(
                              _getValueText(config.calendarType, initialDate),
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
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 192, 244, 210)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.clock),
                              onPressed: () async {
                                picker.DatePicker.showTimePicker(context,
                                    showTitleActions: true, onConfirm: (date) {
                                  setState(() {
                                    time = date;
                                    workHour =
                                        ' ${date.hour < 10 ? 0 : ''}${date.hour.toString()}:${date.minute < 10 ? 0 : ''}${date.minute.toString()}';

                                    timeStampWorkhour =
                                        date.hour * 3600 + date.minute * 60;
                                    hourConvertToString =
                                        ' ${date.hour < 10 ? 0 : ''}${date.hour.toString()}:${date.minute < 10 ? 0 : ''}${date.minute.toString()}:${date.second < 10 ? 0 : ''}${date.second.toString()}';
                                  });
                                  // print('confirm $date');
                                }, currentTime: DateTime.now());
                              },
                            ),
                            Text(
                              DateFormat('Hm').format(time).toString(),
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
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      // value: 'Thêm dịch vụ:',
                      hint: Text(
                        'Thêm dịch vụ:',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily),
                      ),
                      items: nameService
                          .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: GFListTile(
                                  avatar: GFAvatar(
                                    backgroundColor: Colors.white,
                                    shape: GFAvatarShape.square,
                                    child: Image.network(
                                      imgService[nameService.indexOf(item)],
                                    ),
                                  ),
                                  // titleText: vouchersValid[index].name,

                                  description: Text(
                                    item,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                        ),
                                  ),
                                  // icon: Icon(Icons.home, color: Colors.red),
                                  padding: EdgeInsets.zero,
                                  radius: 50,
                                  onTap: () async {
                                    if (dateConvertToString == '' &&
                                        hourConvertToString == '') {
                                      AwesomeDialog(
                                        context: Get.context!,
                                        dialogType: DialogType.warning,
                                        animType: AnimType.rightSlide,
                                        title:
                                            'Vui lòng chọn thời gian đặt thợ',
                                        titleTextStyle: GoogleFonts.poppins(),
                                      ).show();

                                      return;
                                    }
                                    if (serviceSelected == '' ||
                                        serviceSelected == item) {
                                      await getJobItem.getJobItem(
                                          jobServiceList[
                                                  nameService.indexOf(item)]
                                              .code);
                                      // idSevice = jobServiceList[
                                      //         nameService.indexOf(item)]
                                      //     .id;

                                      var jobItemName =
                                          await showBarModalBottomSheet(
                                        expand: false,
                                        context: Get.context!,
                                        builder: (context) => JobItemScreen(
                                          nameService: item,
                                        ),
                                      );

                                      if (jobItemName != null) {
                                        Get.back();
                                      }
                                      setState(() {
                                        if (jobItemName != null) {
                                          selectedItems
                                              .add('$item - ${jobItemName[1]}');
                                          List<JobItems> id = jobItemList
                                              .where((element) =>
                                                  element.id == jobItemName[0])
                                              .toList();
                                          int index = jobItemList.indexWhere(
                                              (element) =>
                                                  element.id == jobItemName[0]);

                                          jobItemsSelected
                                              .add(jobItemList[index]);
                                          selectedItemsId.add(id[0].id);
                                          serviceSelected = item;

                                          tempTotalPrice = tempTotalPrice +
                                              int.parse(
                                                  jobItemList[index].price);
                                        }
                                      });
                                    } else {
                                      AwesomeDialog(
                                        context: Get.context!,
                                        dialogType: DialogType.info,
                                        animType: AnimType.rightSlide,
                                        title:
                                            'Quý khách đã chọn $serviceSelected. Vui lòng tạo đơn đặt mới để sử dụng thêm dịch vụ khác',
                                        titleTextStyle: GoogleFonts.poppins(),
                                      ).show();
                                      // showDialog(
                                      //     context: Get.context!,
                                      //     builder: (context) {
                                      //       return SimpleDialog(
                                      //         contentPadding:
                                      //             const EdgeInsets.all(20),
                                      //         children: [
                                      //           Text(
                                      //               'Quý khách đã chọn $serviceSelected. Vui lòng tạo đơn đặt mới để sử dụng thêm dịch vụ khác',
                                      //               textAlign:
                                      //                   TextAlign.center),
                                      //         ],
                                      //       );
                                      //     });
                                    }
                                    // getPriceFunc();
                                  }

                                  // title: Text('$dateTo-$dateFrom'),
                                  )))
                          .toList(),

                      onChanged: (value) {
                        setState(() {
                          selectedItems.add(value!);
                        });
                      },
                      //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                      // value: selectedItems.isEmpty ? null : selectedItems.last,

                      buttonStyleData: ButtonStyleData(
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color.fromARGB(255, 192, 244, 210),
                          ),
                          color: Colors.white,
                        ),
                        height: 40,
                        width: double.infinity,
                      ),
                      // iconStyleData: const IconStyleData(
                      //   icon: Icon(
                      //     Icons.arrow_forward_ios_outlined,
                      //   ),
                      //   iconSize: 14,
                      //   iconEnabledColor: Colors.black,
                      //   iconDisabledColor: Colors.grey,
                      // ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 400,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                        ),
                        offset: const Offset(20, 0),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: WidgetStateProperty.all(6),
                          thumbVisibility: WidgetStateProperty.all(true),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 80,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  selectedItems.isEmpty
                      ? Text(
                          'Danh sách dịch vụ đang trống',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                          textAlign: TextAlign.center,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Danh sách dịch vụ đang chọn:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 192, 244, 210),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListView.builder(
                                  itemCount: selectedItems.length,
                                  itemBuilder: (context, index) {
                                    // int listJobItemFindId =
                                    //     jobItemsSelected.indexWhere((element) =>
                                    //         selectedItems.contains(element));
                                    // print(listJobItemFindId);
                                    // var jobItemCount = listJobItemFindId;
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Card(
                                        color: Colors.white,
                                        child: ListTile(
                                          tileColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                          subtitle: Row(children: [
                                            IconButton(
                                                onPressed: () {
                                                  jobItemsSelected[index].qt -=
                                                      1;
                                                  setState(() {});

                                                  if (jobItemsSelected[index]
                                                          .qt >
                                                      1) {
                                                    setState(() {
                                                      tempTotalPrice -=
                                                          int.parse(
                                                              jobItemsSelected[
                                                                      index]
                                                                  .price);
                                                    });
                                                  }
                                                  // getPriceFunc();
                                                  if (jobItemsSelected[index]
                                                          .qt <=
                                                      1) {
                                                    jobItemsSelected[index].qt =
                                                        1;
                                                    setState(() {
                                                      tempTotalPrice =
                                                          int.parse(
                                                              jobItemsSelected[
                                                                      index]
                                                                  .price);
                                                    });
                                                  }
                                                },
                                                icon: const Icon(
                                                    Icons.arrow_left_outlined,
                                                    size: 35,
                                                    color: Colors.green)),
                                            Text(jobItemsSelected[index]
                                                .qt
                                                .toString()),
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    jobItemsSelected[index]
                                                        .qt += 1;
                                                    tempTotalPrice += int.parse(
                                                        jobItemsSelected[index]
                                                            .price);
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.arrow_right_outlined,
                                                    size: 35,
                                                    color: Colors.green)),
                                          ]),
                                          title: Text(
                                            '${selectedItems[index]} - ${basic.StringUtils.reverse(prePriceReserve(index))} VNĐ ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                ),
                                          ),
                                          trailing: Container(
                                            decoration: const BoxDecoration(
                                                border: Border(
                                                    left: BorderSide(
                                                        color: Colors.grey))),
                                            child: IconButton(
                                              onPressed: () async {
                                                setState(() {
                                                  selectedItems.remove(
                                                      selectedItems[index]);
                                                  tempTotalPrice -= int.parse(
                                                          jobItemsSelected[
                                                                  index]
                                                              .price) *
                                                      jobItemsSelected[index]
                                                          .qt;
                                                });
                                                serviceSelected = '';

                                                jobItemsSelected.remove(
                                                    jobItemsSelected[index]);
                                                selectedItemsId.remove(
                                                    selectedItemsId[index]);

                                                // await getPriceFunc();
                                              },
                                              icon: const FaIcon(
                                                FontAwesomeIcons.trashCan,
                                                size: 18,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                  const SizedBox(height: 20),
                  Text(
                    'Mô tả:',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 192, 244, 210)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 15, right: 15),
                      child: TextFormField(
                        controller: bookJob.descriptionController,
                        decoration: const InputDecoration(
                          hintText:
                              'Viết vài dòng mô tả chi tiết công việc ...',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.multiline,
                        autocorrect: false,
                        maxLines: 5,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('required!'),
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            bookJob.imageFileList!.length < 3
                                ? _showChoiceDialog(context)
                                : null;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(38, 166, 83, 1),
                            foregroundColor: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              'Thêm ảnh chụp',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: Colors.white,
                                    fontFamily:
                                        GoogleFonts.poppins(fontSize: 20)
                                            .fontFamily,
                                  ),
                            ),
                          ),
                        ),
                        Row(children: [
                          Text(
                            'Hình ảnh : ${bookJob.imageFileList!.length}/3',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: Colors.black,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                ),
                          ),
                          IconButton(
                            onPressed: () async {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return bookJob.imageFileList!.isEmpty
                                        ? Center(
                                            child: Text(
                                              'Danh sách hình ảnh trống',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                    color: const Color.fromRGBO(
                                                        38, 166, 83, 1),
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                  ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: GridView.builder(
                                              itemCount:
                                                  bookJob.imageFileList!.length,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                mainAxisSpacing: 5.0,
                                                crossAxisSpacing: 5.0,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Stack(children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: Image.file(
                                                            File(bookJob
                                                                .imageFileList![
                                                                    index]
                                                                .path),
                                                          ).image,
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    child: OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        shape:
                                                            const CircleBorder(),
                                                        side: const BorderSide(
                                                            width: 2.0,
                                                            color: Colors.red),
                                                        foregroundColor:
                                                            Colors.red,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          bookJob.imageFileList!
                                                              .remove(bookJob
                                                                      .imageFileList![
                                                                  index]);
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: const FaIcon(
                                                          FontAwesomeIcons
                                                              .trashCan,
                                                          size: 20,
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ]);
                                              },
                                            ),
                                          );
                                  });
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.image,
                              size: 20,
                              color: Color.fromRGBO(38, 166, 83, 1),
                            ),
                          ),
                        ]),
                      ]),
                  const SizedBox(
                    height: 20,
                  ),

                  const SizedBox(height: 30),
//
                  getPrice.code == ''
                      ? const SizedBox()
                      : Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Giảm giá:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                              const SizedBox(width: 10),
                              // Text('${getPrice.dataPrice.sumPrice} VND',
                              //     style: Theme.of(context)
                              //         .textTheme
                              //         .titleMedium!
                              //         .copyWith(
                              //           fontFamily: GoogleFonts.poppins().fontFamily,
                              //         )),
                              Text('${getPrice.dataPrice.discount} VND',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                      )),
                            ],
                          ),
                        ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Color.fromARGB(91, 158, 158, 158),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Phí dịch vụ tạm tính:',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(width: 10),
                        // Text('${getPrice.dataPrice.sumPrice} VND',
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .titleMedium!
                        //         .copyWith(
                        //           fontFamily: GoogleFonts.poppins().fontFamily,
                        //         )),
                        Text(
                            '${basic.StringUtils.reverse(priceReserve(tempTotalPrice.toString()))} VND',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                )),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.075),
                  // Center(
                  //   child: MaterialButton(
                  //     onPressed: () {
                  //       bookJobV3();
                  //     },
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 24, vertical: 10),
                  //     elevation: 10.0,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10.0),
                  //     ),
                  //     height: 40.0,
                  //     minWidth: 100.0,
                  //     color: const Color.fromRGBO(38, 166, 83, 1),
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(
                  //           horizontal: 30, vertical: 8),
                  //       child: Text(
                  //         'Đặt thợ',
                  //         style: Theme.of(context)
                  //             .textTheme
                  //             .bodyLarge!
                  //             .copyWith(
                  //               fontFamily: GoogleFonts.poppins().fontFamily,
                  //               fontSize: 20,
                  //               color: Colors.white,
                  //             ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Center(
                    child: MaterialButton(
                      onPressed: () async {
                        // bookJobV3();
                        getPrice.isNext = true;
                        await getPriceFunc();
                      },
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 40.0,
                      minWidth: 100.0,
                      color: const Color.fromRGBO(38, 166, 83, 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                        child: Text(
                          'Tiếp theo',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
