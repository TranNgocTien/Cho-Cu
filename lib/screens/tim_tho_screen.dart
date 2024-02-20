import 'dart:convert';
import 'dart:io';

// import 'package:basic_utils/basic_utils.dart';
import 'package:chotot/controllers/book_job_v3.dart';
import 'package:chotot/controllers/get_job_item.dart';
import 'package:chotot/controllers/get_jobservice.dart';
import 'package:chotot/controllers/get_price_v2.dart';

import 'package:chotot/data/get_job_item_data.dart';
import 'package:chotot/data/job_service_data.dart';

import 'package:chotot/models/addressUpdate.dart';
import 'package:chotot/models/job_item.dart';
import 'package:chotot/models/place.dart';
import 'package:chotot/screens/homeScreen.dart';
import 'package:chotot/screens/job_item_screen.dart';
import 'package:chotot/screens/mapScreen.dart';
import 'package:chotot/screens/voucher_valid_screen.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:dropdown_button2/dropdown_button2.dart';

class TimThoThongMinhScreen extends StatefulWidget {
  const TimThoThongMinhScreen({super.key});

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
    if (bookJob.imageFileList!.isEmpty || bookJob.imageFileList!.length > 3) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              contentPadding: EdgeInsets.all(20),
              children: [
                Text(
                  'Đăng tối thiểu 1 ảnh, tối đa 3 ảnh',
                ),
              ],
            );
          });
      return;
    }
    await bookJob.uploadJobPhoto();
    if (bookJob.addressController.text.isEmpty) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              contentPadding: EdgeInsets.all(20),
              children: [
                Text(
                  'Vui lòng chọn theo tên gợi ý!',
                ),
              ],
            );
          });
    }
    if (bookJob.addressController.text.isEmpty ||
        bookJob.descriptionController.text.isEmpty ||
        bookJob.nameController.text.isEmpty ||
        bookJob.phoneController.text.isEmpty) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              contentPadding: EdgeInsets.all(20),
              children: [
                Text(
                  'Vui lòng điền đầy đủ các thông tin',
                ),
              ],
            );
          });
    }
    await _convertAddressToCoordinate(bookJob.addressController.text);

    if (bookJob.lat == null || bookJob.lng == null) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              contentPadding: EdgeInsets.all(20),
              children: [
                Text(
                  'Nhập lại địa chỉ',
                ),
              ],
            );
          });
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

  _openCamera() async {
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
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.2,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Lựa chọn tải ảnh:',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _openGallery();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(FontAwesomeIcons.image),
                            Text(
                              'Thư viện',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _openCamera();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(FontAwesomeIcons.camera),
                            Text(
                              'Chụp ảnh',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  List<XFile>? imageFileList = [];
  List<DateTime?> initialDate = [
    DateTime.now(),
  ];
  var time = DateTime.now();
  var idSevice = '';
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
  ];
  List<String> selectedItems = [];
  List<String> selectedItemsId = [];
  String dateConvertToString = '';
  String hourConvertToString = '';

  List<JobItems> jobItemsSelected = [];
  dynamic code = '';
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

  getPriceFunc() async {
    if (code.runtimeType != String) code = '';
    var workDate = '$dateConvertToString$hourConvertToString'
        'Z';
    if (dateConvertToString != '' && hourConvertToString != '') {
      var milisecondsConvert = DateTime.parse(workDate);
      var timeStamp = milisecondsConvert.millisecondsSinceEpoch;

      await getPrice.getPrice(
          idSevice, timeStamp.toString(), jobItemsSelected, code);
      setState(() {});
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

  @override
  void initState() {
    hourConvertToString =
        ' ${time.hour < 10 ? 0 : ''}${time.hour.toString()}:${time.minute < 10 ? 0 : ''}${time.minute.toString()}:${time.second < 10 ? 0 : ''}${time.second.toString()}';

    super.initState();
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
        appBar: AppBar(
          title: Text(
            'Đặt thợ thông minh',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontFamily: GoogleFonts.montserrat().fontFamily),
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
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 185, 184, 184)),
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
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 5.0,
                          right: 5.0,
                          bottom: 10.0,
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color:
                                    const Color.fromARGB(255, 185, 184, 184)),
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
                                            GoogleFonts.montserrat().fontFamily,
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
                      IconButton(
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
                        icon: const FaIcon(FontAwesomeIcons.locationPin),
                        style: IconButton.styleFrom(
                            iconSize: 20, foregroundColor: Colors.red),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Số điện thoại liên hệ:',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 185, 184, 184)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chọn thời gian: ',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
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
                                        GoogleFonts.montserrat().fontFamily,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
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
                                        GoogleFonts.montserrat().fontFamily,
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
                            fontFamily: GoogleFonts.montserrat().fontFamily),
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
                                          fontFamily: GoogleFonts.montserrat()
                                              .fontFamily,
                                        ),
                                  ),
                                  // icon: Icon(Icons.home, color: Colors.red),
                                  padding: EdgeInsets.zero,
                                  radius: 50,
                                  onTap: () async {
                                    if (dateConvertToString == '' &&
                                        hourConvertToString == '') {
                                      showDialog(
                                          context: Get.context!,
                                          builder: (context) {
                                            return const SimpleDialog(
                                              contentPadding:
                                                  EdgeInsets.all(20),
                                              children: [
                                                Center(
                                                  child: Text(
                                                      'Vui lòng chọn thời gian đặt thợ'),
                                                ),
                                              ],
                                            );
                                          });
                                      return;
                                    }
                                    if (serviceSelected == '' ||
                                        serviceSelected == item) {
                                      await getJobItem.getJobItem(
                                          jobServiceList[
                                                  nameService.indexOf(item)]
                                              .code);
                                      idSevice = jobServiceList[
                                              nameService.indexOf(item)]
                                          .id;

                                      var jobItemName =
                                          await showBarModalBottomSheet(
                                        expand: true,
                                        context: Get.context!,
                                        builder: (context) => JobItemScreen(
                                          nameService: item,
                                        ),
                                      );
                                      setState(() {
                                        if (jobItemName != null) {
                                          selectedItems
                                              .add('$item - $jobItemName');
                                          List<JobItems> id = jobItemList
                                              .where((element) =>
                                                  element.name == jobItemName)
                                              .toList();
                                          int index = jobItemList.indexWhere(
                                              (element) =>
                                                  element.name == jobItemName);

                                          jobItemsSelected
                                              .add(jobItemList[index]);
                                          selectedItemsId.add(id[0].id);
                                          serviceSelected = item;
                                        }
                                      });
                                    } else {
                                      showDialog(
                                          context: Get.context!,
                                          builder: (context) {
                                            return SimpleDialog(
                                              contentPadding:
                                                  const EdgeInsets.all(20),
                                              children: [
                                                Text(
                                                    'Quý khách đã chọn $serviceSelected. Vui lòng tạo đơn đặt mới để sử dụng thêm dịch vụ khác',
                                                    textAlign:
                                                        TextAlign.center),
                                              ],
                                            );
                                          });
                                    }
                                    getPriceFunc();
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
                            color: Colors.black26,
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
                          thickness: MaterialStateProperty.all(6),
                          thumbVisibility: MaterialStateProperty.all(true),
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
                                  fontFamily:
                                      GoogleFonts.montserrat().fontFamily),
                          textAlign: TextAlign.center,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Danh sách dịch vụ đang đã chọn:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontFamily:
                                          GoogleFonts.montserrat().fontFamily),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
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
                                                  setState(() {
                                                    jobItemsSelected[index]
                                                        .qt -= 1;
                                                    getPriceFunc();
                                                  });
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
                                                    getPriceFunc();
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.arrow_right_outlined,
                                                    size: 35,
                                                    color: Colors.green)),
                                          ]),
                                          title: Text(
                                            selectedItems[index],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontFamily:
                                                      GoogleFonts.montserrat()
                                                          .fontFamily,
                                                ),
                                          ),
                                          trailing: Container(
                                            decoration: const BoxDecoration(
                                                border: Border(
                                                    left: BorderSide(
                                                        color: Colors.grey))),
                                            child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  selectedItems.remove(
                                                      selectedItems[index]);
                                                });
                                                serviceSelected = '';

                                                jobItemsSelected.remove(
                                                    jobItemsSelected[index]);
                                                selectedItemsId.remove(
                                                    selectedItemsId[index]);
                                              },
                                              icon: const FaIcon(
                                                FontAwesomeIcons.minus,
                                                size: 15,
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
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 185, 184, 184)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 15, right: 15),
                      child: TextFormField(
                        controller: bookJob.descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Viết vài dòng mô tả ...',
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
                        OutlinedButton(
                          onPressed: () {
                            bookJob.imageFileList!.length < 3
                                ? _showChoiceDialog(context)
                                : null;
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              width: 1.0,
                              style: BorderStyle.solid,
                              color: Colors.greenAccent,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              'Thêm ảnh chụp',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: Colors.black,
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
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
                                  fontFamily:
                                      GoogleFonts.montserrat().fontFamily,
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
                                                        5, 109, 101, 1),
                                                    fontFamily:
                                                        GoogleFonts.montserrat()
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
                                                              .minus,
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
                              color: Colors.black,
                            ),
                          ),
                        ]),
                      ]),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () async {
                            code = await showBarModalBottomSheet(
                              expand: true,
                              context: context,
                              builder: (context) =>
                                  const VoucherValidPageView(),
                            );
                            setState(() {});
                            getPriceFunc();
                            // var workDate =
                            //     '$dateConvertToString$hourConvertToString' 'Z';
                            // if (dateConvertToString != '' &&
                            //     hourConvertToString != '') {
                            //   var milisecondsConvert = DateTime.parse(workDate);
                            //   var timeStamp =
                            //       milisecondsConvert.millisecondsSinceEpoch;

                            //   if (code.runtimeType != String) code = '';

                            //   getPrice.getPrice(idSevice, timeStamp.toString(),
                            //       jobItemsSelected, code);
                            //   setState(() {});
                            // } else {
                            //   showDialog(
                            //       context: Get.context!,
                            //       builder: (context) {
                            //         return const SimpleDialog(
                            //           contentPadding: EdgeInsets.all(20),
                            //           children: [
                            //             Center(
                            //               child: Text(
                            //                   'Vui lòng chọn thời gian đặt thợ'),
                            //             ),
                            //           ],
                            //         );
                            //       });
                            //   return;
                            // }
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              width: 1.0,
                              color: Colors.greenAccent,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              'Mã giảm giá',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Colors.black,
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
                                  ),
                            ),
                          ),
                        ),
                        Row(children: [
                          Text(
                            code == '' ? 'Chưa áp dụng' : code,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: Colors.black,
                                  fontFamily:
                                      GoogleFonts.montserrat().fontFamily,
                                ),
                          ),
                        ]),
                      ]),
                  const SizedBox(height: 30),
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
                          'Phí di chuyển:',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(width: 10),
                        Text('${getPrice.dataPrice.movingFee} VND',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontFamily:
                                      GoogleFonts.montserrat().fontFamily,
                                )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Giảm giá:',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(width: 10),
                      Text('${getPrice.dataPrice.discount} VND',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                              )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Giá dịch vụ:',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(width: 10),
                      Text('${getPrice.dataPrice.price} VND',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                              )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Phụ thu ngày lễ:',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(width: 10),
                      Text('${getPrice.dataPrice.holiday.sum} VND',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                              )),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                          'Tổng:',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(width: 10),
                        Text('${getPrice.dataPrice.sumPrice} VND',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontFamily:
                                      GoogleFonts.montserrat().fontFamily,
                                )),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.075),
                  Center(
                    child: OutlinedButton(
                      onPressed: () {
                        bookJobV3();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          width: 1.0,
                          color: Colors.greenAccent,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                        child: Text(
                          'Đặt thợ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                fontSize: 20,
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
