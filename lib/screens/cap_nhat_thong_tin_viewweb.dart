import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chotot/controllers/dang_ky_tho.dart';
import 'package:chotot/controllers/get_reg.dart';
import 'package:chotot/data/job_service_data.dart';
import 'package:chotot/data/reg_profile_data.dart';
import 'package:chotot/models/addressUpdate.dart';
import 'package:chotot/models/job_service.dart';
import 'package:chotot/models/place.dart';
import 'package:chotot/screens/mapScreen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
// ignore: depend_on_referenced_packages

class CapNhatThongTinTho extends StatefulWidget {
  const CapNhatThongTinTho({super.key});

  @override
  State<CapNhatThongTinTho> createState() => _CapNhatThongTinThoState();
}

class _CapNhatThongTinThoState extends State<CapNhatThongTinTho> {
  final ImagePicker imagePicker = ImagePicker();
  GetReg getRegController = Get.put(GetReg());
  final _formKey = GlobalKey<FormState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final DangKyTho _dangKyThoController = Get.put(DangKyTho());
  List<XFile> selectedImages = [];
  XFile? selectedImagesCcid;
  final controller = MultiSelectController<JobService>();
  XFile? selectedImageCcidFront;
  XFile? selectedImageCcidBack;
  Widget center = Center(
    child: LoadingAnimationWidget.waveDots(
      color: const Color.fromRGBO(1, 142, 33, 1),
      size: 30,
    ),
  );

  final List<String> experienceList = [
    "Chưa có kinh nghiệm",
    "1 năm kinh nghiệm",
    "2 năm kinh nghiệm",
    "3 năm kinh nghiệm",
    "4 năm kinh nghiệm",
    "5 năm kinh nghiệm",
    "Trên 5 năm kinh nghiệm",
  ];

  var items = [
    ...jobServiceList.map(
      (jobService) => DropdownItem(
          label: jobService.name,
          value: JobService(
              id: jobService.id,
              code: jobService.code,
              version: jobService.version,
              v: jobService.v,
              fee: jobService.fee,
              img: jobService.img,
              name: jobService.name,
              shortName: jobService.shortName,
              type: jobService.type)),
    )
  ];

  var selectedItem = [];
  var selectedText = '';

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

  _openCameraCcid(context, isFront) async {
    if (selectedImageCcidFront != null && isFront) {
      return;
    }
    if (selectedImageCcidBack != null && isFront == false) {
      return;
    }
    var status = await Permission.camera.status;
    var random = Random();
    if (status.isPermanentlyDenied) {
      showAlertDialog(context);
      return;
    }
    try {
      final imageFileGallery = await ImagePicker()
          .pickImage(source: ImageSource.camera, maxWidth: 600);
      if (imageFileGallery == null) return;
      // Tạo tên file mới
      int randomInt = random.nextInt(100);
      Directory appDir = await getApplicationDocumentsDirectory();
      String newFileName = isFront ? 'front${randomInt}' : 'back${randomInt}';
      String newFilePath = path.join(appDir.path, newFileName);

      // Đổi tên ảnh bằng cách sao chép sang đường dẫn mới
      final imageTemp = await File(imageFileGallery.path).copy(newFilePath);
      // final imageTemp = XFile(imageFileGallery.path);

      setState(() {
        isFront
            ? selectedImageCcidFront = XFile(imageTemp.path)
            : selectedImageCcidBack = XFile(imageTemp.path);
      });
    } on PlatformException catch (e) {
      AlertDialog(
        content: Text(
          e.toString(),
        ),
      );
    }
  }

  _openCamera(context, bool isCcid, bool isAvatar) async {
    var status = await Permission.camera.status;
    var random = Random();
    if (status.isPermanentlyDenied) {
      showAlertDialog(context);
      return;
    }
    if (isAvatar) {
      try {
        final imageFileGallery = await ImagePicker()
            .pickImage(source: ImageSource.camera, maxWidth: 600);
        if (imageFileGallery == null) return;
        int randomInt = random.nextInt(100);
        Directory appDir = await getApplicationDocumentsDirectory();
        String newFileName = 'avatar${randomInt}';
        String newFilePath = path.join(appDir.path, newFileName);

        final imageTemp = await File(imageFileGallery.path).copy(newFilePath);

        setState(() {
          _dangKyThoController.imageAvatar = imageTemp;
        });
      } on PlatformException catch (e) {
        AlertDialog(
          content: Text(
            e.toString(),
          ),
        );
      }
      return;
    }
    try {
      final imageFileGallery = await ImagePicker()
          .pickImage(source: ImageSource.camera, maxWidth: 600);
      if (imageFileGallery == null) return;

      Directory appDir = await getApplicationDocumentsDirectory();
      String newFileName = 'cert${DateTime.now().millisecondsSinceEpoch}';
      String newFilePath = path.join(appDir.path, newFileName);

      final imageTemp = await File(imageFileGallery.path).copy(newFilePath);

      selectedImages.add(XFile(imageTemp.path));
      _dangKyThoController.imageFileList!.clear();
      setState(() {
        _dangKyThoController.imageFileList!.addAll(selectedImages);
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

  _openGallery(bool isCcid, bool isFront, bool isAvatar) async {
    final List<XFile> selectedImagesTemp =
        isCcid || isAvatar ? [] : await imagePicker.pickMultiImage();
    final XFile? selectedImageTemp = isCcid == false
        ? null
        : await imagePicker.pickImage(source: ImageSource.gallery);
    var random = Random();
    if (isAvatar) {
      final XFile? selectedImageTemp =
          await imagePicker.pickImage(source: ImageSource.gallery);
      int randomInt = random.nextInt(100);
      if (selectedImageTemp != null) {
        Directory appDir = await getApplicationDocumentsDirectory();
        String newFileName = 'avatar${randomInt}';
        String newFilePath = path.join(appDir.path, newFileName);

        // Sao chép file với tên mới
        final renamedImage =
            await File(selectedImageTemp.path).copy(newFilePath);
        setState(() {
          _dangKyThoController.imageAvatar = renamedImage;
        });
      }
      return;
    }
    if (isCcid) {
      // Nếu là CCID, tiến hành đổi tên ảnh
      int randomInt = random.nextInt(100);
      if (selectedImageTemp != null) {
        Directory appDir = await getApplicationDocumentsDirectory();
        String newFileName = isFront ? 'front${randomInt}' : 'back${randomInt}';
        String newFilePath = path.join(appDir.path, newFileName);

        // Sao chép file với tên mới
        final renamedImage =
            await File(selectedImageTemp.path).copy(newFilePath);
        selectedImagesCcid = XFile(renamedImage.path);
      }
    } else {
      // Nếu không phải CCID, xử lý danh sách nhiều ảnh
      for (var image in selectedImagesTemp) {
        Directory appDir = await getApplicationDocumentsDirectory();
        String newFileName = 'cert${DateTime.now().millisecondsSinceEpoch}';
        String newFilePath = path.join(appDir.path, newFileName);

        // Sao chép từng file với tên mới
        final renamedImage = await File(image.path).copy(newFilePath);
        selectedImages.add(XFile(renamedImage.path));
      }
    }

    // Gán giá trị hình ảnh vào các biến tương ứng
    if (selectedImages.isNotEmpty || selectedImagesCcid != null) {
      if (isCcid) {
        if (isFront) {
          selectedImageCcidFront = selectedImagesCcid;
        } else {
          selectedImageCcidBack = selectedImagesCcid;
        }
      } else {
        _dangKyThoController.imageFileList!.clear();
        _dangKyThoController.imageFileList!.addAll(selectedImages);
      }
    }
    setState(() {});
  }

  Future<void> _showChoiceDialog(
      BuildContext context, bool isCcid, bool isFront, bool isAvatar) {
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
              onPressed: () async {
                await _openGallery(isCcid, isFront, isAvatar);
                setState(() {});
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
                isCcid == true
                    ? await _openCameraCcid(context, isFront)
                    : await _openCamera(context, isCcid, isAvatar);
                setState(() {});
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

  Future<void> registerWorker() async {
    if (_dangKyThoController.nameController.text.isEmpty) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Quý khách vui lòng nhập tên.',
        titleTextStyle: GoogleFonts.poppins(),
      ).show();
      return;
    }
    if (_dangKyThoController.addressController.text.isEmpty) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Quý khách vui lòng nhập địa chỉ.',
        titleTextStyle: GoogleFonts.poppins(),
      ).show();
      return;
    }
    if (_dangKyThoController.ccidController.text.isEmpty) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Quý khách vui lòng nhập căn cước công dân.',
        titleTextStyle: GoogleFonts.poppins(),
      ).show();
      return;
    }
    if (_dangKyThoController.descriptionController.text.isEmpty) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Quý khách vui lòng nhập mô tả.',
        titleTextStyle: GoogleFonts.poppins(),
      ).show();
      return;
    }
    if (_dangKyThoController.imageFileList!.isEmpty) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Quý khách vui lòng nhập hình ảnh chứng chỉ.',
        titleTextStyle: GoogleFonts.poppins(),
      ).show();
      return;
    }
    if (selectedImageCcidBack == null || selectedImageCcidFront == null) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Quý khách vui lòng thêm hình ảnh căn cước.',
        titleTextStyle: GoogleFonts.poppins(),
      ).show();
      return;
    }
    setState(() {
      _dangKyThoController.isLoading = true;
    });
    if (_dangKyThoController.isUpdateCcid == true) {
      _dangKyThoController.imageFileListCcid!.add(selectedImageCcidFront!);
      _dangKyThoController.imageFileListCcid!.add(selectedImageCcidBack!);
    }

    // await _dangKyThoController.uploadCcidImages();
    // await _dangKyThoController.uploadCertPhoto();
    await _dangKyThoController.dangKyTho();
    setState(() {
      _dangKyThoController.isLoading = false;
    });
  }

  selectedItemFunc() {
    final arraytemp = regProfile[0].workerType.split(',');
    for (var i = 0; i < arraytemp.length; i++) {
      for (var j = 0; j < jobServiceList.length; j++) {
        if (arraytemp[i] == jobServiceList[j].code) {
          selectedItem.add(jobServiceList[j].name);
        }
      }
    }
    selectedText = selectedItem.join(', ');
  }

  var statusForm = '';
  statusFormRegister() {
    switch (regProfile[0].status) {
      case 'pending':
        statusForm = 'Đơn đăng ký đang đợi duyệt';
        break;
      case 'cancel':
        statusForm = 'Đơn đăng ký đã hủy';
        break;
      case 'accept':
        statusForm = 'Đơn đăng ký đã duyệt';
        break;
    }
  }

  @override
  void initState() {
    selectedItemFunc();
    statusFormRegister();
    _dangKyThoController.addressController.text = regProfile[0].address;
    _dangKyThoController.nameController.text = regProfile[0].name;
    _dangKyThoController.ccidController.text = regProfile[0].ccid;
    _dangKyThoController.descriptionController.text = regProfile[0].description;
    _dangKyThoController.experienceChoosen = regProfile[0].experience;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60.0,
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
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Cập nhật thông tin thợ',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: Colors.white,
              fontSize: widthDevice * 0.055),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // foregroundColor: Color.fromRGBO(54, 92, 69, 1),
        elevation: 3,
      ),
      body: _dangKyThoController.isLoading
          ? center
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                        child: Text(
                      statusForm,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Họ và tên',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color:
                                      const Color.fromARGB(255, 192, 244, 210),
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  left: 15,
                                  right: 15,
                                ),
                                child: TextFormField(
                                  controller:
                                      _dangKyThoController.nameController,
                                  decoration: const InputDecoration(
                                    hintText: 'Họ và tên',
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.text,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.none,
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: const Color.fromARGB(
                                              255, 192, 244, 210)),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: TypeAheadField<AddressUpdate?>(
                                      hideOnError: true,
                                      debounceDuration:
                                          const Duration(milliseconds: 500),
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        controller: _dangKyThoController
                                            .addressController,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              'Địa chỉ (chọn địa chỉ gợi ý)',
                                        ),
                                      ),
                                      suggestionsCallback: AddressUpdateApi
                                          .getAddressSuggestions,
                                      itemBuilder:
                                          (context, AddressUpdate? suggestion) {
                                        final address = suggestion!;
                                        return ListTile(
                                          title: Text(address.description),
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
                                                  fontFamily:
                                                      GoogleFonts.poppins()
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
                                        _dangKyThoController.addressController
                                            .text = address.description;

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
                                            currentLocation: PlaceLocation(
                                                latitude: lat,
                                                longitude: lng,
                                                address: '')),
                                      ),
                                    );

                                    if (pickedLocation == null) {
                                      return;
                                    }
                                    _dangKyThoController.addressController
                                        .text = pickedLocation;
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
                                  child: const FaIcon(
                                      FontAwesomeIcons.locationPin,
                                      size: 25,
                                      color: Color.fromRGBO(38, 166, 83, 1)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Kinh nghiệm của bạn: ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Text(
                                  _dangKyThoController.experienceChoosen == ''
                                      ? regProfile[0].experience
                                      : _dangKyThoController.experienceChoosen,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily),
                                ),
                                items: experienceList
                                    .map(
                                      (String experience) =>
                                          DropdownMenuItem<String>(
                                        value: experience,
                                        child: Card(
                                          color: Colors.white,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: const Color.fromRGBO(
                                                    38, 166, 83, 1),
                                              ),
                                            ),
                                            child: Text(
                                              experience,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _dangKyThoController.experienceChoosen =
                                        value!;
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 192, 244, 210),
                                    ),
                                    color: Colors.white,
                                  ),
                                  height: 40,
                                  width: double.infinity,
                                ),
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
                                    thumbVisibility:
                                        WidgetStateProperty.all(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 60,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Tải hình ảnh khuôn mặt:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _dangKyThoController.imageAvatar == null &&
                                        _dangKyThoController.isUpdateAvatar ==
                                            true
                                    ? InkWell(
                                        onTap: () {
                                          _showChoiceDialog(
                                              context, false, false, true);
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 192, 244, 210)),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Ảnh đại diện',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily,
                                                      color: Colors.grey,
                                                    ),
                                              ),
                                              const Icon(
                                                  FontAwesomeIcons.camera,
                                                  color: Colors.grey,
                                                  size: 50)
                                            ],
                                          ),
                                        ),
                                      )
                                    : Stack(children: [
                                        InstaImageViewer(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 10.0),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: _dangKyThoController
                                                        .isUpdateAvatar ==
                                                    true
                                                ? Image.file(
                                                    File(
                                                      _dangKyThoController
                                                          .imageAvatar!.path,
                                                    ),
                                                    fit: BoxFit.cover)
                                                : Image.network(
                                                    regProfile[0].avatar,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                        _dangKyThoController.isUpdateAvatar ==
                                                true
                                            ? Positioned(
                                                top: 22,
                                                child: OutlinedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    shape: const CircleBorder(),
                                                    side: const BorderSide(
                                                        width: 2.0,
                                                        color: Colors.red),
                                                    foregroundColor: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      _dangKyThoController
                                                          .imageAvatar = null;
                                                    });
                                                  },
                                                  child: const FaIcon(
                                                      FontAwesomeIcons.trashCan,
                                                      size: 20,
                                                      color: Colors.red),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ]),
                              ],
                            ),
                            const SizedBox(height: 15),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _dangKyThoController.isUpdateAvatar = true;
                                });
                              },
                              child: Text(
                                'Cập nhật lại đại diện',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      color:
                                          const Color.fromRGBO(38, 166, 83, 1),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              regProfile[0].type == 'individual'
                                  ? 'Căn cước công dân của bạn:'
                                  : 'Số giấy phép kinh doanh:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color:
                                      const Color.fromARGB(255, 192, 244, 210),
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  left: 15,
                                  right: 15,
                                ),
                                child: TextFormField(
                                  controller:
                                      _dangKyThoController.ccidController,
                                  decoration: const InputDecoration(
                                    hintText: 'Số căn cước công dân',
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.text,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.none,
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
                            const SizedBox(height: 15),
                            Text(
                              regProfile[0].type == 'individual'
                                  ? 'Tải hình ảnh căn cước:'
                                  : 'Tải ảnh giấy phép kinh doanh',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  selectedImageCcidFront == null &&
                                          regProfile[0].ccidList[0].img.isEmpty
                                      ? InkWell(
                                          onTap: () {
                                            _showChoiceDialog(
                                                context, true, true, false);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 192, 244, 210)),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Mặt trước',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                        fontFamily: GoogleFonts
                                                                .poppins()
                                                            .fontFamily,
                                                        color: Colors.grey,
                                                      ),
                                                ),
                                                const Icon(
                                                    FontAwesomeIcons.camera,
                                                    color: Colors.grey,
                                                    size: 50)
                                              ],
                                            ),
                                          ),
                                        )
                                      : Stack(children: [
                                          InstaImageViewer(
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10.0),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              child: regProfile[0]
                                                      .ccidList[0]
                                                      .img
                                                      .isEmpty
                                                  ? Image.file(
                                                      File(
                                                        selectedImageCcidFront!
                                                            .path,
                                                      ),
                                                      fit: BoxFit.cover)
                                                  : Image.network(
                                                      regProfile[0]
                                                          .ccidList[0]
                                                          .img,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                          regProfile[0].ccidList[0].img.isEmpty
                                              ? Positioned(
                                                  top: 22,
                                                  child: OutlinedButton(
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
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
                                                        selectedImageCcidFront =
                                                            null;
                                                      });
                                                    },
                                                    child: const FaIcon(
                                                        FontAwesomeIcons
                                                            .trashCan,
                                                        size: 20,
                                                        color: Colors.red),
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ]),
                                  const SizedBox(width: 10),
                                  selectedImageCcidBack == null &&
                                          regProfile[0].ccidList[1].img.isEmpty
                                      ? InkWell(
                                          onTap: () {
                                            _showChoiceDialog(
                                                context, true, false, false);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 192, 244, 210)),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Mặt sau',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                        fontFamily: GoogleFonts
                                                                .poppins()
                                                            .fontFamily,
                                                        color: Colors.grey,
                                                      ),
                                                ),
                                                const Icon(
                                                    FontAwesomeIcons.camera,
                                                    color: Colors.grey,
                                                    size: 50)
                                              ],
                                            ),
                                          ),
                                        )
                                      : Stack(children: [
                                          InstaImageViewer(
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10.0),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              child: regProfile[0]
                                                      .ccidList[1]
                                                      .img
                                                      .isEmpty
                                                  ? Image.file(
                                                      File(
                                                        selectedImageCcidBack!
                                                            .path,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.network(
                                                      regProfile[0]
                                                          .ccidList[1]
                                                          .img,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                          regProfile[0].ccidList[1].img.isEmpty
                                              ? Positioned(
                                                  top: 22,
                                                  child: OutlinedButton(
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
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
                                                        selectedImageCcidBack =
                                                            null;
                                                      });
                                                    },
                                                    child: const FaIcon(
                                                        FontAwesomeIcons
                                                            .trashCan,
                                                        size: 20,
                                                        color: Colors.red),
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ]),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  regProfile[0].ccidList[0].img = '';
                                  regProfile[0].ccidList[1].img = '';
                                  _dangKyThoController.isUpdateCcid = true;
                                });
                              },
                              child: Text(
                                'Cập nhật lại ảnh',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      color:
                                          const Color.fromRGBO(38, 166, 83, 1),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Ảnh chứng chỉ:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            // Center(
                            //   child: ElevatedButton(
                            //     onPressed: () {

                            //     },
                            //     style: ElevatedButton.styleFrom(
                            //       backgroundColor: const Color.fromRGBO(38, 166, 83, 1),
                            //       foregroundColor: Colors.white,
                            //     ),
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(2.0),
                            //       child: Text(
                            //         'Thêm ảnh chụp chứng chỉ',
                            //         style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            //               color: Colors.white,
                            //               fontFamily: GoogleFonts.poppins().fontFamily,
                            //             ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(height: 15),
                            _dangKyThoController.imageFileList!.isEmpty &&
                                    regProfile[0].certList.isEmpty
                                ? const SizedBox()
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Ảnh đã tải lên:',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(
                                              color: Colors.black,
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                            ),
                                      ),
                                      const SizedBox(height: 15),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ...regProfile[0].certList.map(
                                                (cert) {
                                              return Stack(children: [
                                                InstaImageViewer(
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 10.0),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    child: CachedNetworkImage(
                                                        imageUrl: cert.img,
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                        // errorWidget: (context, url,
                                                        //         error) =>
                                                        //     Image.asset(
                                                        //         'image/logo_tho_thong_minh.jpeg'),
                                                        placeholder:
                                                            (context, url) =>
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Center(
                                                                    child: LoadingAnimationWidget
                                                                        .waveDots(
                                                                      color: const Color
                                                                          .fromRGBO(
                                                                          1,
                                                                          142,
                                                                          33,
                                                                          1),
                                                                      size: 30,
                                                                    ),
                                                                  ),
                                                                ),
                                                        memCacheWidth: 200,
                                                        maxHeightDiskCache: 200,
                                                        maxWidthDiskCache: 200),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 22,
                                                  child: OutlinedButton(
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
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
                                                        regProfile[0]
                                                            .certList
                                                            .remove(cert);
                                                      });
                                                      print(regProfile[0]
                                                          .certList);
                                                    },
                                                    child: const FaIcon(
                                                        FontAwesomeIcons
                                                            .trashCan,
                                                        size: 20,
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ]);
                                            }
                                                // ..._dangKyThoController.imageFileList!
                                                //     .map((image) {
                                                //   return Stack(children: [
                                                //     InstaImageViewer(
                                                //       child: Container(
                                                //         margin:
                                                //             const EdgeInsets.only(right: 10.0),
                                                //         width:
                                                //             MediaQuery.of(context).size.width *
                                                //                 0.6,
                                                //         height:
                                                //             MediaQuery.of(context).size.width *
                                                //                 0.5,
                                                //         child: Image.file(
                                                //           File(image.path),
                                                //           fit: BoxFit.cover,
                                                //         ),
                                                //       ),
                                                //     ),
                                                //     Positioned(
                                                //       top: 22,
                                                //       child: OutlinedButton(
                                                //         style: OutlinedButton.styleFrom(
                                                //           padding: const EdgeInsets.all(10),
                                                //           shape: const CircleBorder(),
                                                //           side: const BorderSide(
                                                //               width: 2.0, color: Colors.red),
                                                //           foregroundColor: Colors.red,
                                                //         ),
                                                //         onPressed: () {
                                                //           setState(() {
                                                //             _dangKyThoController.imageFileList!
                                                //                 .remove(image);
                                                //           });
                                                //         },
                                                //         child: const FaIcon(
                                                //             FontAwesomeIcons.trashCan,
                                                //             size: 20,
                                                //             color: Colors.red),
                                                //       ),
                                                //     ),
                                                //   ]);
                                                // }
                                                ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(height: 15),

                            _dangKyThoController.isUpdateCert
                                ? Text(
                                    'Hình ảnh chứng chỉ cập nhật:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 15),
                            _dangKyThoController.isUpdateCert
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ..._dangKyThoController.imageFileList!
                                            .map((image) {
                                          return Stack(children: [
                                            InstaImageViewer(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10.0),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: Image.file(
                                                  File(image.path),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 22,
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  shape: const CircleBorder(),
                                                  side: const BorderSide(
                                                      width: 2.0,
                                                      color: Colors.red),
                                                  foregroundColor: Colors.red,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _dangKyThoController
                                                        .imageFileList!
                                                        .remove(image);
                                                    selectedImages
                                                        .remove(image);
                                                  });
                                                },
                                                child: const FaIcon(
                                                    FontAwesomeIcons.trashCan,
                                                    size: 20,
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ]);
                                        }),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 15),
                            TextButton(
                              onPressed: () async {
                                _dangKyThoController.isUpdateCert = true;
                                await _showChoiceDialog(
                                    context, false, false, false);
                                setState(() {});
                              },
                              child: Text(
                                'Cập nhật ảnh',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      color:
                                          const Color.fromRGBO(38, 166, 83, 1),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              regProfile[0].type == 'individual'
                                  ? 'Thông tin chi tiết về bản thân:'
                                  : 'Thông tin chi tiết về doanh nghiệp:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.15,
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
                                  controller: _dangKyThoController
                                      .descriptionController,
                                  decoration: const InputDecoration(
                                    hintText: 'Viết vài dòng về bản thân',
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
                            const SizedBox(height: 15),
                            Text(
                              'Loại công việc của bạn đã chọn:  ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              selectedText,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            MultiDropdown<JobService>(
                              items: items,
                              controller: controller,
                              enabled: true,
                              searchEnabled: false,
                              chipDecoration: const ChipDecoration(
                                deleteIcon: Icon(FontAwesomeIcons.xmark,
                                    color: Colors.white, size: 14),
                                labelStyle: TextStyle(color: Colors.white),
                                backgroundColor: Color.fromRGBO(38, 166, 83, 1),
                                wrap: true,
                                runSpacing: 2,
                                spacing: 10,
                              ),
                              fieldDecoration: FieldDecoration(
                                hintText:
                                    'Vui lòng chọn lại để cập nhật hoặc sửa đổi:',
                                hintStyle:
                                    const TextStyle(color: Colors.black87),
                                prefixIcon: const Icon(
                                    CupertinoIcons.add_circled,
                                    color: Color.fromRGBO(38, 166, 83, 1)),
                                showClearIcon: false,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 192, 244, 210),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(38, 166, 83, 1),
                                  ),
                                ),
                              ),
                              dropdownDecoration: const DropdownDecoration(
                                marginTop: 2,
                                maxHeight: 500,
                                header: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Chọn loại công việc của bạn từ danh sách',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              dropdownItemDecoration: DropdownItemDecoration(
                                selectedIcon: const Icon(Icons.check_box,
                                    color: Colors.green),
                                disabledIcon: Icon(Icons.lock,
                                    color: Colors.grey.shade300),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng chọn công việc.';
                                }
                                return null;
                              },
                              onSelectionChange: (selectedItems) {
                                var temp = selectedItems
                                    .map((item) => item.code)
                                    .join(',');
                                _dangKyThoController.workerTypeList = temp;
                              },
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await registerWorker();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(38, 166, 83, 1),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 8),
                                  child: Text(
                                    'Gửi',
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
                  ],
                ),
              ),
            ),
    );
  }
}
