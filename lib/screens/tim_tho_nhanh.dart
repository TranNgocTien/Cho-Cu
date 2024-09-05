// import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:chotot/controllers/get_job_item.dart';
import 'package:chotot/controllers/get_worker_by_location_controller.dart';
import 'package:chotot/data/get_job_item_data.dart';
import 'package:chotot/data/get_worker_by_location_data.dart';
import 'package:chotot/data/job_service_data.dart';
import 'package:chotot/data/selected_items.dart';
import 'package:chotot/models/addressUpdate.dart';
import 'package:chotot/models/get_worker_by_location_model.dart';
import 'package:chotot/models/job_item.dart';
import 'package:chotot/models/place.dart';
import 'package:chotot/screens/job_item_screen.dart';
import 'package:chotot/screens/mapScreen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:basic_utils/basic_utils.dart' as basic;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;

import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class TimThoNhanh extends StatefulWidget {
  const TimThoNhanh(
      {super.key,
      required this.cameraPositionLat,
      required this.cameraPositionLng});
  final double cameraPositionLat;
  final double cameraPositionLng;

  @override
  State<TimThoNhanh> createState() => _TimThoNhanhState();
}

class _TimThoNhanhState extends State<TimThoNhanh>
    with SingleTickerProviderStateMixin {
  GetWorkerByLocation getLocationWorker = Get.put(GetWorkerByLocation());
  GetJobItem getJobItem = Get.put(GetJobItem());
  GoogleMapController? _controller;
  final List<Marker> _markers = [];
  double currentLat = 0, curentlng = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late BitmapDescriptor customIcon;
  bool isOnDrag = true;

  List<XFile>? imageFileList = [];
  List<DateTime?> initialDate = [
    DateTime.now(),
  ];
  final _formKey = GlobalKey<FormState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _onCameraMove(CameraPosition position) {
    _animationController.forward(); // Start the animation when dragging starts
    currentLat = position.target.latitude;
    curentlng = position.target.longitude;
  }

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
  String dateConvertToString = '';
  List<String> selectedItemsId = [];
  String serviceSelected = '';
  int tempTotalPrice = 0;
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

  String hourConvertToString = '';
  String workHour = '';
  int timeStampWorkhour = 0;
  var time = DateTime.now();
  bool isConfirmBookWorker = false;
  prePriceReserve(index) {
    var price =
        int.parse(jobItemsSelected[index].price) * jobItemsSelected[index].qt;
    return basic.StringUtils.addCharAtPosition(
        basic.StringUtils.reverse(price.toString()), ".", 3,
        repeat: true);
  }

  Future<void> _showConfirmBookWorkerInfomation() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full screen height
      backgroundColor: Colors.transparent, // Make background transparent
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5, // 50% of screen height
          minChildSize: 0.5, // Minimum size (50%)
          maxChildSize: 1, // Full-screen size
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16.0),
                ),
              ),
              child: Column(
                children: [
                  // A small indicator to show draggable behavior
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        // Replace with your content

                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tên chủ đơn hàng: ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: const Color.fromARGB(
                                              255, 192, 244, 210)),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 15, right: 15),
                                      child: TextFormField(
                                        // controller: bookJob.nameController,
                                        decoration: const InputDecoration(
                                          hintText: 'Họ và tên chủ đơn hàng',
                                          border: InputBorder.none,
                                        ),
                                        keyboardType:
                                            TextInputType.streetAddress,
                                        autocorrect: false,
                                        textCapitalization:
                                            TextCapitalization.none,
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty ||
                                              value.trim().length <= 1) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          // left: 5.0,
                                          // right: 5.0,
                                          bottom: 10.0,
                                        ),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: const Color.fromARGB(
                                                    255, 192, 244, 210)),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: TypeAheadField<AddressUpdate?>(
                                            hideOnError: true,
                                            debounceDuration: const Duration(
                                                milliseconds: 500),
                                            textFieldConfiguration:
                                                TextFieldConfiguration(
                                              // controller: bookJob.addressController,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    'Địa chỉ (chọn địa chỉ gợi ý)',
                                              ),
                                            ),
                                            suggestionsCallback:
                                                AddressUpdateApi
                                                    .getAddressSuggestions,
                                            itemBuilder: (context,
                                                AddressUpdate? suggestion) {
                                              final address = suggestion!;
                                              return ListTile(
                                                title:
                                                    Text(address.description),
                                              );
                                            },
                                            noItemsFoundBuilder: (context) =>
                                                SizedBox(
                                              height: 100,
                                              child: Center(
                                                child: Text(
                                                  'Không tìm thấy địa chỉ.',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontFamily: GoogleFonts
                                                                .poppins()
                                                            .fontFamily,
                                                        fontSize: 18,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            onSuggestionSelected:
                                                (AddressUpdate? suggestion) {
                                              final address = suggestion!;
                                              setState(() {});
                                              // bookJob.addressController.text =
                                              //     address.description;

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
                                          final SharedPreferences prefs =
                                              await _prefs;

                                          // await prefs.setString('token', token.toString());

                                          final lat = prefs.getDouble('lat')!;
                                          final lng = prefs.getDouble('lng')!;

                                          final pickedLocation =
                                              await Navigator.of(context)
                                                  .push<String>(
                                            MaterialPageRoute(
                                              builder: (ctx) => MapScreen(
                                                  currentLocation:
                                                      PlaceLocation(
                                                          latitude: lat,
                                                          longitude: lng,
                                                          address: '')),
                                            ),
                                          );

                                          if (pickedLocation == null) {
                                            return;
                                          }
                                          // bookJob.addressController.text = pickedLocation;
                                        },
                                        shape: const CircleBorder(
                                            eccentricity: 0.0,
                                            side: BorderSide(
                                              color: Color.fromRGBO(
                                                  38, 166, 83, 1),
                                              width: 2.0,
                                            )),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 10),
                                        elevation: 20.0,
                                        child: const FaIcon(
                                            FontAwesomeIcons.locationPin,
                                            size: 25,
                                            color:
                                                Color.fromRGBO(38, 166, 83, 1)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Số điện thoại liên hệ:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: const Color.fromARGB(
                                              255, 192, 244, 210)),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 15, right: 15),
                                      child: TextFormField(
                                        // controller: bookJob.phoneController,
                                        decoration: const InputDecoration(
                                          hintText:
                                              'Số điện thoại của bạn! (Bắt buộc)',
                                          border: InputBorder.none,
                                        ),
                                        keyboardType: TextInputType.phone,
                                        autocorrect: false,
                                        textCapitalization:
                                            TextCapitalization.none,
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty ||
                                              value.trim().length <= 1) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Phone input is required!'),
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        padding: const EdgeInsets.only(
                                            top: 8, bottom: 8, right: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 192, 244, 210)),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                                icon: const FaIcon(
                                                    FontAwesomeIcons
                                                        .calendarDay),
                                                onPressed: () async {
                                                  initialDate =
                                                      (await showCalendarDatePicker2Dialog(
                                                    context: context,
                                                    config:
                                                        CalendarDatePicker2WithActionButtonsConfig(),
                                                    dialogSize:
                                                        const Size(325, 400),
                                                    value: initialDate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ))!;
                                                  setState(() {});
                                                }),
                                            Text(
                                              _getValueText(config.calendarType,
                                                  initialDate),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        padding: const EdgeInsets.only(
                                            top: 8, bottom: 8, right: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 192, 244, 210)),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const FaIcon(
                                                  FontAwesomeIcons.clock),
                                              onPressed: () async {
                                                picker.DatePicker
                                                    .showTimePicker(context,
                                                        showTitleActions: true,
                                                        onConfirm: (date) {
                                                  setState(() {
                                                    time = date;
                                                    workHour =
                                                        ' ${date.hour < 10 ? 0 : ''}${date.hour.toString()}:${date.minute < 10 ? 0 : ''}${date.minute.toString()}';

                                                    timeStampWorkhour =
                                                        date.hour * 3600 +
                                                            date.minute * 60;
                                                    hourConvertToString =
                                                        ' ${date.hour < 10 ? 0 : ''}${date.hour.toString()}:${date.minute < 10 ? 0 : ''}${date.minute.toString()}:${date.second < 10 ? 0 : ''}${date.second.toString()}';
                                                  });
                                                  // print('confirm $date');
                                                }, currentTime: DateTime.now());
                                              },
                                            ),
                                            Text(
                                              DateFormat('Hm')
                                                  .format(time)
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily),
                                      ),
                                      items: nameService
                                          .map((String item) => DropdownMenuItem<
                                                  String>(
                                              value: item,
                                              child: GFListTile(
                                                  avatar: GFAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape: GFAvatarShape.square,
                                                    child: Image.network(
                                                      imgService[nameService
                                                          .indexOf(item)],
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
                                                              GoogleFonts
                                                                      .poppins()
                                                                  .fontFamily,
                                                        ),
                                                  ),
                                                  // icon: Icon(Icons.home, color: Colors.red),
                                                  padding: EdgeInsets.zero,
                                                  radius: 50,
                                                  onTap: () async {
                                                    if (dateConvertToString ==
                                                            '' &&
                                                        hourConvertToString ==
                                                            '') {
                                                      AwesomeDialog(
                                                        context: Get.context!,
                                                        dialogType:
                                                            DialogType.warning,
                                                        animType:
                                                            AnimType.rightSlide,
                                                        title:
                                                            'Vui lòng chọn thời gian đặt thợ',
                                                        titleTextStyle:
                                                            GoogleFonts
                                                                .poppins(),
                                                      ).show();

                                                      return;
                                                    }
                                                    if (serviceSelected == '' ||
                                                        serviceSelected ==
                                                            item) {
                                                      await getJobItem.getJobItem(
                                                          jobServiceList[
                                                                  nameService
                                                                      .indexOf(
                                                                          item)]
                                                              .code);
                                                      // idSevice = jobServiceList[
                                                      //         nameService.indexOf(item)]
                                                      //     .id;

                                                      var jobItemName =
                                                          await showBarModalBottomSheet(
                                                        expand: false,
                                                        context: Get.context!,
                                                        builder: (context) =>
                                                            JobItemScreen(
                                                          nameService: item,
                                                        ),
                                                      );

                                                      if (jobItemName != null) {
                                                        Get.back();
                                                      }
                                                      setState(() {
                                                        if (jobItemName !=
                                                            null) {
                                                          selectedItems.add(
                                                              '$item - ${jobItemName[1]}');
                                                          List<JobItems> id =
                                                              jobItemList
                                                                  .where((element) =>
                                                                      element
                                                                          .id ==
                                                                      jobItemName[
                                                                          0])
                                                                  .toList();
                                                          int index = jobItemList
                                                              .indexWhere(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      jobItemName[
                                                                          0]);

                                                          jobItemsSelected.add(
                                                              jobItemList[
                                                                  index]);
                                                          selectedItemsId
                                                              .add(id[0].id);
                                                          serviceSelected =
                                                              item;

                                                          tempTotalPrice =
                                                              tempTotalPrice +
                                                                  int.parse(jobItemList[
                                                                          index]
                                                                      .price);
                                                        }
                                                      });
                                                    } else {
                                                      AwesomeDialog(
                                                        context: Get.context!,
                                                        dialogType:
                                                            DialogType.info,
                                                        animType:
                                                            AnimType.rightSlide,
                                                        title:
                                                            'Quý khách đã chọn $serviceSelected. Vui lòng tạo đơn đặt mới để sử dụng thêm dịch vụ khác',
                                                        titleTextStyle:
                                                            GoogleFonts
                                                                .poppins(),
                                                      ).show();
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
                                        print(selectedItems);
                                      },
                                      //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                                      // value: selectedItems.isEmpty ? null : selectedItems.last,

                                      buttonStyleData: ButtonStyleData(
                                        padding: const EdgeInsets.only(
                                            left: 14, right: 14),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 192, 244, 210),
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
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          color: Colors.white,
                                        ),
                                        offset: const Offset(20, 0),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness: WidgetStateProperty.all(6),
                                          thumbVisibility:
                                              WidgetStateProperty.all(true),
                                        ),
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 80,
                                        padding: EdgeInsets.only(
                                            left: 14, right: 14),
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
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                              ),
                                          textAlign: TextAlign.center,
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Danh sách dịch vụ đang chọn:',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily),
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 192, 244, 210),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: ListView.builder(
                                                  itemCount:
                                                      selectedItems.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    // int listJobItemFindId =
                                                    //     jobItemsSelected.indexWhere((element) =>
                                                    //         selectedItems.contains(element));
                                                    // print(listJobItemFindId);
                                                    // var jobItemCount = listJobItemFindId;
                                                    return Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5.0),
                                                      child: Card(
                                                        color: Colors.white,
                                                        child: ListTile(
                                                          tileColor:
                                                              Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                          subtitle: Row(
                                                              children: [
                                                                IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      jobItemsSelected[
                                                                              index]
                                                                          .qt -= 1;
                                                                      setState(
                                                                          () {});

                                                                      if (jobItemsSelected[index]
                                                                              .qt >
                                                                          1) {
                                                                        setState(
                                                                            () {
                                                                          tempTotalPrice -=
                                                                              int.parse(jobItemsSelected[index].price);
                                                                        });
                                                                      }
                                                                      // getPriceFunc();
                                                                      if (jobItemsSelected[index]
                                                                              .qt <=
                                                                          1) {
                                                                        jobItemsSelected[index]
                                                                            .qt = 1;
                                                                        setState(
                                                                            () {
                                                                          tempTotalPrice =
                                                                              int.parse(jobItemsSelected[index].price);
                                                                        });
                                                                      }
                                                                    },
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .arrow_left_outlined,
                                                                        size:
                                                                            35,
                                                                        color: Colors
                                                                            .green)),
                                                                Text(jobItemsSelected[
                                                                        index]
                                                                    .qt
                                                                    .toString()),
                                                                IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        jobItemsSelected[index]
                                                                            .qt += 1;
                                                                        tempTotalPrice +=
                                                                            int.parse(jobItemsSelected[index].price);
                                                                      });
                                                                    },
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .arrow_right_outlined,
                                                                        size:
                                                                            35,
                                                                        color: Colors
                                                                            .green)),
                                                              ]),
                                                          title: Text(
                                                            '${selectedItems[index]} - ${basic.StringUtils.reverse(prePriceReserve(index))} VNĐ ',
                                                            style:
                                                                Theme.of(
                                                                        context)
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
                                                                        color: Colors
                                                                            .grey))),
                                                            child: IconButton(
                                                              onPressed:
                                                                  () async {
                                                                setState(() {
                                                                  selectedItems.remove(
                                                                      selectedItems[
                                                                          index]);
                                                                  tempTotalPrice -= int.parse(
                                                                          jobItemsSelected[index]
                                                                              .price) *
                                                                      jobItemsSelected[
                                                                              index]
                                                                          .qt;
                                                                });
                                                                serviceSelected =
                                                                    '';

                                                                jobItemsSelected.remove(
                                                                    jobItemsSelected[
                                                                        index]);
                                                                selectedItemsId.remove(
                                                                    selectedItemsId[
                                                                        index]);

                                                                // await getPriceFunc();
                                                              },
                                                              icon:
                                                                  const FaIcon(
                                                                FontAwesomeIcons
                                                                    .trashCan,
                                                                size: 18,
                                                                color: Colors
                                                                    .redAccent,
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: const Color.fromARGB(
                                              255, 192, 244, 210)),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 15, right: 15),
                                      child: TextFormField(
                                        // controller: bookJob.descriptionController,
                                        decoration: const InputDecoration(
                                          hintText:
                                              'Viết vài dòng mô tả chi tiết công việc ...',
                                          border: InputBorder.none,
                                        ),
                                        keyboardType: TextInputType.multiline,
                                        autocorrect: false,
                                        maxLines: 5,
                                        textCapitalization:
                                            TextCapitalization.none,
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty ||
                                              value.trim().length <= 1) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    38, 166, 83, 1),
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
                                                        GoogleFonts.poppins(
                                                                fontSize: 20)
                                                            .fontFamily,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        Row(children: [
                                          Text(
                                            'Hình ảnh : ${0}/3',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .copyWith(
                                                  color: Colors.black,
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                ),
                                          ),
                                          // IconButton(
                                          //   onPressed: () async {
                                          //     showModalBottomSheet(
                                          //         context: context,
                                          //         builder: (context) {
                                          //           return bookJob.imageFileList!.isEmpty
                                          //               ? Center(
                                          //                   child: Text(
                                          //                     'Danh sách hình ảnh trống',
                                          //                     style: Theme.of(context)
                                          //                         .textTheme
                                          //                         .labelLarge!
                                          //                         .copyWith(
                                          //                           color: const Color.fromRGBO(
                                          //                               38, 166, 83, 1),
                                          //                           fontFamily: GoogleFonts.poppins()
                                          //                               .fontFamily,
                                          //                         ),
                                          //                   ),
                                          //                 )
                                          //               : Padding(
                                          //                   padding: const EdgeInsets.all(10.0),
                                          //                   child: GridView.builder(
                                          //                     itemCount: bookJob.imageFileList!.length,
                                          //                     gridDelegate:
                                          //                         const SliverGridDelegateWithFixedCrossAxisCount(
                                          //                       crossAxisCount: 3,
                                          //                       mainAxisSpacing: 5.0,
                                          //                       crossAxisSpacing: 5.0,
                                          //                     ),
                                          //                     itemBuilder:
                                          //                         (BuildContext context, int index) {
                                          //                       return Stack(children: [
                                          //                         Container(
                                          //                           decoration: BoxDecoration(
                                          //                             image: DecorationImage(
                                          //                                 image: Image.file(
                                          //                                   File(bookJob
                                          //                                       .imageFileList![index]
                                          //                                       .path),
                                          //                                 ).image,
                                          //                                 fit: BoxFit.cover),
                                          //                           ),
                                          //                         ),
                                          //                         Positioned(
                                          //                           child: OutlinedButton(
                                          //                             style: OutlinedButton.styleFrom(
                                          //                               padding:
                                          //                                   const EdgeInsets.all(10),
                                          //                               shape: const CircleBorder(),
                                          //                               side: const BorderSide(
                                          //                                   width: 2.0,
                                          //                                   color: Colors.red),
                                          //                               foregroundColor: Colors.red,
                                          //                             ),
                                          //                             onPressed: () {
                                          //                               setState(() {
                                          //                                 bookJob.imageFileList!.remove(
                                          //                                     bookJob.imageFileList![
                                          //                                         index]);
                                          //                               });
                                          //                               Navigator.pop(context);
                                          //                             },
                                          //                             child: const FaIcon(
                                          //                                 FontAwesomeIcons.trashCan,
                                          //                                 size: 20,
                                          //                                 color: Colors.red),
                                          //                           ),
                                          //                         ),
                                          //                       ]);
                                          //                     },
                                          //                   ),
                                          //                 );
                                          //         });
                                          //   },
                                          //   icon: const FaIcon(
                                          //     FontAwesomeIcons.image,
                                          //     size: 20,
                                          //     color: Color.fromRGBO(38, 166, 83, 1),
                                          //   ),
                                          // ),
                                        ]),
                                      ]),
                                  const SizedBox(
                                    height: 20,
                                  ),

                                  const SizedBox(height: 30),
//
                                  // getPrice.code == ''
                                  //     ? const SizedBox()
                                  //     : Container(
                                  //         width: double.infinity,
                                  //         padding: const EdgeInsets.only(top: 10),
                                  //         child: Row(
                                  //           mainAxisAlignment: MainAxisAlignment.end,
                                  //           children: [
                                  //             Text(
                                  //               'Giảm giá:',
                                  //               style: Theme.of(context)
                                  //                   .textTheme
                                  //                   .titleMedium!
                                  //                   .copyWith(
                                  //                     fontFamily: GoogleFonts.poppins().fontFamily,
                                  //                     fontWeight: FontWeight.w900,
                                  //                   ),
                                  //             ),
                                  //             const SizedBox(width: 10),
                                  //             // Text('${getPrice.dataPrice.sumPrice} VND',
                                  //             //     style: Theme.of(context)
                                  //             //         .textTheme
                                  //             //         .titleMedium!
                                  //             //         .copyWith(
                                  //             //           fontFamily: GoogleFonts.poppins().fontFamily,
                                  //             //         )),
                                  //             Text('${getPrice.dataPrice.discount} VND',
                                  //                 style: Theme.of(context)
                                  //                     .textTheme
                                  //                     .titleMedium!
                                  //                     .copyWith(
                                  //                       fontFamily:
                                  //                           GoogleFonts.poppins().fontFamily,
                                  //                     )),
                                  //           ],
                                  //         ),
                                  //       ),
                                  // Container(
                                  //   width: double.infinity,
                                  //   padding: const EdgeInsets.only(top: 10),
                                  //   decoration: const BoxDecoration(
                                  //     border: Border(
                                  //       top: BorderSide(
                                  //         color: Color.fromARGB(91, 158, 158, 158),
                                  //       ),
                                  //     ),
                                  //   ),
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.end,
                                  //     children: [
                                  //       Text(
                                  //         'Phí dịch vụ tạm tính:',
                                  //         style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  //               fontFamily: GoogleFonts.poppins().fontFamily,
                                  //               fontWeight: FontWeight.w900,
                                  //             ),
                                  //       ),
                                  //       const SizedBox(width: 10),
                                  //       // Text('${getPrice.dataPrice.sumPrice} VND',
                                  //       //     style: Theme.of(context)
                                  //       //         .textTheme
                                  //       //         .titleMedium!
                                  //       //         .copyWith(
                                  //       //           fontFamily: GoogleFonts.poppins().fontFamily,
                                  //       //         )),
                                  //       Text(
                                  //           '${basic.StringUtils.reverse(priceReserve(tempTotalPrice.toString()))} VND',
                                  //           style:
                                  //               Theme.of(context).textTheme.titleMedium!.copyWith(
                                  //                     fontFamily: GoogleFonts.poppins().fontFamily,
                                  //                   )),
                                  //     ],
                                  //   ),
                                  // ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.075),

                                  Center(
                                    child: MaterialButton(
                                      onPressed: () async {},
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 10),
                                      elevation: 10.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      height: 40.0,
                                      minWidth: 100.0,
                                      color:
                                          const Color.fromRGBO(38, 166, 83, 1),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 8),
                                        child: Text(
                                          'Tiếp theo',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
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
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showWorkerDetailsModal(WorkerByLocation worker) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full screen height
      backgroundColor: Colors.transparent, // Make background transparent
      builder: (context) {
        final widthDevice = MediaQuery.of(context).size.width;
        return DraggableScrollableSheet(
          initialChildSize: 0.3, // 50% of screen height
          minChildSize: 0.3, // Minimum size (50%)
          maxChildSize: 0.8, // Full-screen size
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16.0),
                ),
              ),
              child: Column(
                children: [
                  // A small indicator to show draggable behavior
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        // Replace with your content

                        Container(
                          padding: const EdgeInsets.all(16.0),
                          color: Colors.transparent,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  worker.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'image/star.png',
                                    height: 40,
                                    width: 40,
                                  ),
                                  const SizedBox(width: 10),
                                  Text('Điểm đánh giá:',
                                      style: GoogleFonts.poppins(
                                          fontSize: widthDevice * 0.04)),
                                  const SizedBox(width: 20),
                                  Text(
                                      (double.tryParse(worker.ds)! / 20)
                                          .toStringAsFixed(1),
                                      style: GoogleFonts.poppins(
                                          fontSize: widthDevice * 0.04)),
                                  Image.asset(
                                    'image/star.png',
                                    height: 20,
                                    width: 20,
                                  ),
                                  Text(
                                      '(${double.parse(worker.ds).toStringAsFixed(1)})',
                                      style: GoogleFonts.poppins(
                                          fontSize: widthDevice * 0.04)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Color.fromARGB(126, 158, 158, 158),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Mô tả:',
                                    style: GoogleFonts.poppins(
                                      fontSize: widthDevice * 0.04,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    worker.description,
                                    style: GoogleFonts.poppins(
                                      fontSize: widthDevice * 0.04,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Kinh nghiệm:',
                                    style: GoogleFonts.poppins(
                                      fontSize: widthDevice * 0.04,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    worker.experience,
                                    style: GoogleFonts.poppins(
                                      fontSize: widthDevice * 0.04,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: MaterialButton(
                                  onPressed: () async {
                                    await _showConfirmBookWorkerInfomation();
                                  },
                                  elevation: 1.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  height: 60.0,
                                  minWidth: widthDevice * 0.5,
                                  color: const Color.fromRGBO(23, 162, 73, 1),
                                  child: Text(
                                    'Đặt thợ',
                                    style: GoogleFonts.poppins(
                                      fontSize: widthDevice * 0.04,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _onMarkerTapped(WorkerByLocation worker) async {
    isOnDrag = false;
    await _showWorkerDetailsModal(worker);

    isOnDrag = true;
  }

  Future<void> getWorkerMarker(double lat, double lng) async {
    await getLocationWorker.getWorkerLocation(lat, lng);
    _markers.clear();

    for (var i = 0; i < workerByLocationList.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId(workerByLocationList[i].id),
          position: LatLng(
            double.parse(workerByLocationList[i].lat),
            double.parse(
              workerByLocationList[i].lng,
            ),
          ),
          icon: customIcon,
          onTap: () => _onMarkerTapped(workerByLocationList[i]),
        ),
      );
    }
    setState(() {});
  }

  void _onCameraIdle() async {
    _animationController.reverse();
    if (isOnDrag) {
      await getWorkerMarker(currentLat, curentlng);
    }
  }

  void setCustomMarkerIcon() async {
    final ByteData data = await rootBundle.load('image/worker_marker.png');
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 100, // Set the desired width
      targetHeight: 100, // Set the desired height
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? byteData =
        await fi.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedMarker = byteData!.buffer.asUint8List();

    customIcon = BitmapDescriptor.fromBytes(resizedMarker);
  }

  @override
  void initState() {
    getWorkerMarker(widget.cameraPositionLat, widget.cameraPositionLng);
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(
          milliseconds: 100), // Adjust animation duration as needed
      vsync: this,
    );

    // Animate the vertical translation (e.g., -20.0 pixels up and back to 0.0)
    _animation = Tween<double>(begin: 0.0, end: -30.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    setCustomMarkerIcon();
  }

  @override
  void dispose() {
    _markers.clear();

    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Tìm thợ xung quanh',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
          textAlign: TextAlign.end,
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: GoogleMap(
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      widget.cameraPositionLat, widget.cameraPositionLng),
                  zoom: 14,
                ),
                onMapCreated: _onMapCreated,
                markers: Set.of(_markers),
                onCameraMove: _onCameraMove,
                onCameraIdle: _onCameraIdle,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                    0, _animation.value), // Apply the vertical translation
                child: Image.asset(
                  'image/pin.png',
                  height: 55,
                  width: 55,
                  // color: Color.fromRGBO(23, 162, 73, 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
