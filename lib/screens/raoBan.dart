import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:chotot/controllers/get_stuffs.dart';
// import 'package:chotot/data/default_information.dart';
import 'package:chotot/data/docu_data.dart';
import 'package:chotot/models/place.dart';
// import 'package:chotot/screens/change_default_info.dart';
import 'package:chotot/screens/homeScreen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:chotot/models/addressUpdate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:chotot/screens/mapScreen.dart';
// import 'package:chotot/models/get_otherfee.dart';
import 'package:chotot/data/get_otherFee_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:chotot/controllers/post_stuff.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RaoBanScreen extends StatefulWidget {
  const RaoBanScreen({super.key});

  @override
  State<RaoBanScreen> createState() => _RaoBanScreenState();
}

class _RaoBanScreenState extends State<RaoBanScreen> {
  final _formKey = GlobalKey<FormState>();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final GetStuffs _getStuffs = Get.put(GetStuffs());
  PostStuff postStuff = Get.put(PostStuff());
  final ImagePicker imagePicker = ImagePicker();
  String service = 'Chọn dịch vụ đăng tin';
  String serviceFee = '0';
  String insertPrice = '';

  final _storage = const FlutterSecureStorage();
  Future<void> _convertCoordinatefromAddress(double lat, double lng) async {
    final url = Uri.parse(
        'https://rsapi.goong.io/Geocode?latlng=$lat,$lng&api_key=WOXLNGkieaqVH3DPxcDpJoInSLk7QQajAHdzmyhB');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];
    setState(() {
      postStuff.addressController.text = address;
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
    postStuff.lat = lat;

    postStuff.lng = lng;

    if (postStuff.lat == null || postStuff.lng == null) {
      return;
    }
  }

  postStuffService() async {
    if (service == 'Chọn dịch vụ đăng tin') {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'Chọn dịch vụ đăng',
        titleTextStyle: GoogleFonts.poppins(fontSize: 16),
      ).show();
      // showDialog(
      //     context: Get.context!,
      //     builder: (context) {
      //       return const SimpleDialog(
      //         contentPadding: EdgeInsets.all(20),
      //         children: [
      //           Text(
      //             'Chọn dịch vụ đăng',
      //           ),
      //         ],
      //       );
      //     });
      return;
    }

    if (postStuff.addressController.text.isEmpty) {
      await AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Vui lòng chọn theo tên gợi ý!',
        titleTextStyle: GoogleFonts.poppins(),
      ).show();
      return;
    }
    if (postStuff.addressController.text.isEmpty ||
        postStuff.descriptionController.text.isEmpty ||
        postStuff.nameController.text.isEmpty ||
        postStuff.phoneController.text.isEmpty ||
        postStuff.sumPriceController.text.isEmpty) {
      await AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Vui lòng điền đầy đủ các thông tin',
        titleTextStyle: GoogleFonts.poppins(),
      ).show();
      return;
    }
    await _convertAddressToCoordinate(postStuff.addressController.text);

    if (postStuff.lat == null || postStuff.lng == null) {
      await AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Nhập lại địa chỉ',
        titleTextStyle: GoogleFonts.poppins(),
      ).show();
      return;
    }
    if (postStuff.imageFileList!.isEmpty ||
        postStuff.imageFileList!.length > 3) {
      await AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Đăng tối thiểu 1 ảnh, tối đa 3 ảnh',
        titleTextStyle: GoogleFonts.poppins(),
      ).show();
      return;
    }
    await postStuff.uploadJobPhoto();
    await postStuff.postItem(triggerWhenPost);
    items.clear();
    postStuff.imageFileList!.clear();
    await _getStuffs.getStuffs(0);
    Get.to(const MainScreen());
  }

  triggerWhenPost() async {
    setState(() {
      postStuff.isLoading = true;
    });
    await _getStuffs.getStuffs(0);
    postStuff.descriptionController.clear();
    postStuff.sumPriceController.clear();

    postStuff.imageLink.clear();
    setState(() {
      postStuff.isLoading = false;
    });
  }

  _openGallery() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages.isNotEmpty) {
      postStuff.imageFileList!.addAll(selectedImages);
    }
    setState(() {});
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
        postStuff.imageFileList!.addAll(selectedImages);
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
  }

  priceReverse(price) {
    return StringUtils.addCharAtPosition(StringUtils.reverse(price), ".", 3,
        repeat: true);
  }

  void showOverlay() {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.all(20),
            children: [
              Text(
                'Chọn dịch vụ đăng tin lên hot new',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: const Color.fromRGBO(38, 166, 83, 1),
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                textAlign: TextAlign.center,
              ),
              SingleChildScrollView(
                  child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.8,
                child: ListView.builder(
                  itemCount: otherFee.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        leading: const FaIcon(FontAwesomeIcons.servicestack),
                        trailing: Text(
                          '${StringUtils.reverse(priceReverse(otherFee[index].price))} GP',
                          softWrap: true,
                        ),
                        title: Text(
                          index == 3 ? 'Bình thường' : '${index + 1} ngày',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          setState(() {
                            service = otherFee[index].name;
                            serviceFee = otherFee[index].price;
                            postStuff.codeOtherFee = otherFee[index].idService;
                          });
                          Get.back();
                        });
                  },
                ),
              )),
            ],
          );
        });
  }

  List<dynamic> listOfLocation = [];
  @override
  void initState() {
    postStuff.addressController.addListener(() {
      _onChange();
    });
    super.initState();
  }

  void placeSuggestion(String input) async {
    try {
      String request =
          'https://rsapi.goong.io/Place/AutoComplete?api_key=WOXLNGkieaqVH3DPxcDpJoInSLk7QQajAHdzmyhB&input=$input';
      var response = await http.get(Uri.parse(request));
      var data = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          listOfLocation = json.decode(response.body)['predictions'];
        });
      } else {}
      throw Exception("Fail to load");
    } catch (e) {
      print(e.toString());
    }
  }

  _onChange() {
    placeSuggestion(postStuff.addressController.text);
  }

  @override
  void dispose() {
    FocusScope.of(context).unfocus();
    super.dispose();
  }

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _showOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
    }
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)!.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        left: offset.dx,
        top: offset.dy + size.height,
        child: Material(
          elevation: 4.0,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: 200, // Giới hạn chiều cao cho danh sách
            ),
            child: ListView.builder(
              itemCount: listOfLocation.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Xử lý khi chọn địa điểm
                    postStuff.addressController.text =
                        listOfLocation[index]["description"]!;
                    _hideOverlay(); // Ẩn overlay khi chọn địa điểm
                  },
                  child: ListTile(
                    title: Text(listOfLocation[index]["description"]!),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          centerTitle: true,
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
            'Đăng tin chợ',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          elevation: 0,
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
                    'Tên đơn hàng: ',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
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
                        controller: postStuff.nameController,
                        decoration: const InputDecoration(
                          hintText: 'Tên đơn hàng',
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
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          // left: 5.0,
                          // right: 5.0,
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
                              controller: postStuff.addressController,
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
                              postStuff.addressController.text =
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
                      MaterialButton(
                        onPressed: () async {
                          final SharedPreferences prefs = await _prefs;

                          // await prefs.setString('token', token.toString());

                          final lat = prefs.getDouble('lat')!;
                          final lng = prefs.getDouble('lng')!;
                          print(lat);
                          print(lng);
                          final pickedLocation =
                              await Navigator.of(context).push<String>(
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
                          postStuff.addressController.text = pickedLocation;
                          // _convertCoordinatefromAddress(pickedLocation.latitude,
                          //     pickedLocation.longitude);
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
                        // style: IconButton.styleFrom(
                        //   iconSize: 25,
                        //     foregroundColor:

                        //     ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Số điện thoại liên hệ:',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
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
                        controller: postStuff.phoneController,
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
                    'Thông tin chi tiết về sản phẩm:',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: Colors.black,
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
                        controller: postStuff.descriptionController,
                        decoration: const InputDecoration(
                          hintText:
                              'Viết vài dòng về chi tiết thông tin sản phẩm',
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
                  const SizedBox(height: 20),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      // value: 'Thêm dịch vụ:',
                      hint: Text(
                        insertPrice == ''
                            ? 'Chọn phương thức nhập giá tiền:'
                            : insertPrice,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily),
                      ),
                      items: [
                        DropdownMenuItem<String>(
                            value: 'Giá liên hệ',
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              // color: const Color.fromRGBO(23, 162, 73, 1),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromRGBO(23, 162, 73, 1),
                              ),
                              child: Text(
                                'Giá liên hệ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            onTap: () async {
                              setState(() {
                                postStuff.sumPriceController.text =
                                    'Giá liên hệ';
                              });
                            }),
                        DropdownMenuItem<String>(
                          value: 'Nhập giá tiền',
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            // color: const Color.fromRGBO(23, 162, 73, 1),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromRGBO(23, 162, 73, 1),
                            ),
                            child: Text(
                              'Nhập giá tiền',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          // onTap: () async {
                          //   setState(() {
                          //     insertPrice = 'Nhập giá tiền';
                          //   });
                          // }
                        )
                      ],
                      onChanged: (value) {
                        setState(() {
                          insertPrice = value!;
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
                        maxHeight: 200,
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
                        height: 50,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  insertPrice == 'Nhập giá tiền'
                      ? Text(
                          'Giá mong muốn: (VNĐ)',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                        )
                      : const SizedBox(),
                  insertPrice == 'Nhập giá tiền'
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color:
                                    const Color.fromARGB(255, 192, 244, 210)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 15, right: 15),
                            child: TextFormField(
                              controller: postStuff.sumPriceController,
                              decoration: const InputDecoration(
                                hintText: '0',
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    int.parse(value.trim()) <= 1000) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Price must be higher!'),
                                    ),
                                  );
                                }
                                return null;
                              },
                            ),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            postStuff.imageFileList!.length < 3
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
                                        GoogleFonts.poppins().fontFamily,
                                  ),
                            ),
                          ),
                        ),
                        Row(children: [
                          Text(
                            'Hình ảnh : ${postStuff.imageFileList!.length}/3',
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
                                    return postStuff.imageFileList!.isEmpty
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
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                  ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: GridView.builder(
                                              itemCount: postStuff
                                                  .imageFileList!.length,
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
                                                            File(postStuff
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
                                                          postStuff
                                                              .imageFileList!
                                                              .remove(postStuff
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
                            icon: const FaIcon(FontAwesomeIcons.image,
                                size: 20,
                                color: Color.fromRGBO(38, 166, 83, 1)),
                          ),
                        ]),
                      ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await postStuff.getOtherfee();
                            if (otherFee.isNotEmpty) {
                              showOverlay();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(38, 166, 83, 1),
                            foregroundColor: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              'Dịch vụ đăng tin',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: Colors.white,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                  ),
                            ),
                          ),
                        ),
                        Text(
                          service,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                color: Colors.black,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                        ),
                      ]),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Phí đăng:',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                color: Colors.black,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                        ),
                        Text(
                          '${StringUtils.reverse(priceReverse(serviceFee))} GP',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                color: Colors.black,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                        ),
                      ]),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.075),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        postStuffService();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(38, 166, 83, 1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                        child: postStuff.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Text(
                                'Đăng tin',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color: Colors.white,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
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
