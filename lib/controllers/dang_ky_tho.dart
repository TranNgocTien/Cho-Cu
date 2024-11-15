import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/data/reg_profile_data.dart';
import 'package:chotot/screens/homeScreen.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DangKyTho extends GetxController {
  LoginController loginController = Get.put(LoginController());
  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController addressController = TextEditingController(text: '');
  TextEditingController ccidController = TextEditingController(text: '');
  TextEditingController descriptionController = TextEditingController(text: '');
  String type = 'individual';
  bool isUpdateCcid = false;
  bool isUpdateCert = false;
  bool isUpdateAvatar = false;
  bool isRegister = false;

  String workerTypeList = '';
  bool isRegisterSuccess = false;
  var latTho = 0.0;
  var lngTho = 0.0;
  String experienceChoosen = '';
  // NotiController notiController = Get.put(NotiController());
  List<XFile>? imageFileList = [];
  List<File> imageConvertedFile = [];
  List imageLink = [];

  List<XFile>? imageFileListCcid = [];
  List<File> imageConvertedFileCcid = [];
  List imageLinkCcid = [];
  bool isLoading = false;
  File? imageAvatar;
  File? imageAvatarConvert;
  var imageAvatarLink = '';
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  convertXFileToFile(imageFileList, imageConvertedFile) {
    for (int i = 0; i < imageFileList!.length; i++) {
      File file = File(imageFileList![i].path);
      imageConvertedFile.add(file);
    }
  }

  Future<void> uploadCcidImages() async {
    final SharedPreferences prefs = await _prefs;
    if (imageFileListCcid!.length > 2 ||
        imageFileListCcid!.length < 2 ||
        imageFileListCcid!.isEmpty ||
        imageFileListCcid == null) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title:
            'Quý khách vui lòng cung cấp ảnh căn cước công dân(Mặt trước, Mặt sau).',
        titleTextStyle: GoogleFonts.poppins(fontSize: 16),
      ).show();
      imageFileListCcid!.clear();
      return;
    }
    final hostId = prefs.getString('host_id');

    convertXFileToFile(imageFileListCcid, imageConvertedFileCcid);
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.uploadCcidPhoto);

    var request = http.MultipartRequest('POST', url);

    request.headers["Content-Type"] = "multipart/form-data";
    request.headers["x-access-token"] = 'anhkhongdoiqua';

    for (File file in imageConvertedFileCcid) {
      request.files.add(http.MultipartFile(
          'file',
          File(file.path).readAsBytes().asStream(),
          File(file.path).lengthSync(),
          filename: file.path.split("/").last));
    }

    Map<String, String> obj = {"code": hostId!};

    request.fields.addAll(obj);

    var res = await request.send();
    var response = await http.Response.fromStream(res);
    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = json['data'];
      if (json['status'] == 'ok') {
        imageLinkCcid = data;

        imageConvertedFileCcid.clear();
        imageFileListCcid!.clear();
      } else if (json['status'] == 'error') {
        imageConvertedFileCcid.clear();
        imageFileListCcid!.clear();
        await AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.warning,
          animType: AnimType.leftSlide,
          title: json['error']['message'],
          titleTextStyle: GoogleFonts.poppins(),
          autoHide: const Duration(milliseconds: 800),
        ).show();
      }
    } else {
      throw jsonDecode(response.body)['message'] ?? 'Unknown Error Occured';
    }
  }

  Future<void> uploadAvatarImages() async {
    final SharedPreferences prefs = await _prefs;
    if (imageAvatar == null) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Quý khách vui lòng cung cấp ảnh gương mặt.',
        titleTextStyle: GoogleFonts.poppins(fontSize: 16),
      ).show();
      imageFileListCcid!.clear();
      return;
    }
    final hostId = prefs.getString('host_id');

    File file = File(imageAvatar!.path);
    imageAvatarConvert = file;
    var url = Uri.parse(ApiEndPoints.servicesUrl +
        ApiEndPoints.authEndPoints.uploadAvatarPhoto);

    var request = http.MultipartRequest('POST', url);

    request.headers["Content-Type"] = "multipart/form-data";
    request.headers["x-access-token"] = 'anhkhongdoiqua';

    request.files.add(http.MultipartFile(
        'file',
        File(imageAvatarConvert!.path).readAsBytes().asStream(),
        File(imageAvatarConvert!.path).lengthSync(),
        filename: imageAvatarConvert!.path.split("/").last));

    Map<String, String> obj = {"code": hostId!};

    request.fields.addAll(obj);

    var res = await request.send();
    var response = await http.Response.fromStream(res);
    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = json['data'];
      if (json['status'] == 'ok') {
        imageAvatarLink = data;

        imageAvatarConvert = null;
        imageAvatar = null;
        isUpdateAvatar = false;
      } else if (json['status'] == 'error') {
        imageConvertedFileCcid.clear();
        imageFileListCcid!.clear();
        await AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.warning,
          animType: AnimType.leftSlide,
          title: json['error']['message'],
          titleTextStyle: GoogleFonts.poppins(),
          autoHide: const Duration(milliseconds: 800),
        ).show();
      }
    } else {
      throw jsonDecode(response.body)['message'] ?? 'Unknown Error Occured';
    }
  }

  Future<void> uploadCertPhoto() async {
    final SharedPreferences prefs = await _prefs;
    // Get device information
    if (imageFileList!.isEmpty || imageFileList == null) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Hình ảnh chưa được chọn ảnh. Xin chọn lại!',
        titleTextStyle: GoogleFonts.poppins(fontSize: 16),
      ).show();
      imageFileList!.clear();
      return;
    }
    final hostId = prefs.getString('host_id');

    // try {
    convertXFileToFile(imageFileList, imageConvertedFile);
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.uploadCertPhoto);

    var request = http.MultipartRequest('POST', url);

    request.headers["Content-Type"] = "multipart/form-data";
    request.headers["x-access-token"] = 'anhkhongdoiqua';

    for (File file in imageConvertedFile) {
      request.files.add(http.MultipartFile(
          'file',
          File(file.path).readAsBytes().asStream(),
          File(file.path).lengthSync(),
          filename: file.path.split("/").last));
    }
    Map<String, String> obj = {"code": hostId!};

    request.fields.addAll(obj);

    var res = await request.send();
    var response = await http.Response.fromStream(res);

    final json = jsonDecode(response.body);
    // print(json);
    if (response.statusCode == 200) {
      var data = json['data'];
      if (json['status'] == 'ok') {
        if (isUpdateCert) {
          for (var i = 0; i < data.length; i++) {
            imageLink.add(data[i]);
          }
        } else {
          imageLink = data;
        }

        imageConvertedFile.clear();
        imageFileList!.clear();
      } else if (json['status'] == 'error') {
        imageConvertedFile.clear();
        imageFileList!.clear();
        await AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.warning,
          animType: AnimType.leftSlide,
          title: json['error']['message'],
          titleTextStyle: GoogleFonts.poppins(),
          autoHide: const Duration(milliseconds: 800),
        ).show();
      }
    } else {
      throw jsonDecode(response.body)['message'] ?? 'Unknown Error Occured';
    }
  }

  Future<void> dangKyTho() async {
    if (isRegister) {
      await uploadCertPhoto();
      await uploadAvatarImages();
      await uploadCcidImages();
    }

    if (isUpdateAvatar == true) {
      await uploadAvatarImages();
    } else {
      if (regProfile.isNotEmpty) {
        imageAvatarLink = regProfile[0].avatar;
      }
    }

    if (isUpdateCcid == true) {
      await uploadCcidImages();
    } else {
      if (regProfile.isNotEmpty) {
        for (var i = 0; i < regProfile[0].ccidList.length; i++) {
          imageLinkCcid.add({
            'name': regProfile[0].ccidList[i].name,
            'img': regProfile[0].ccidList[i].img,
          });
        }
      }
    }

    if (isUpdateCert) {
      for (var i = 0; i < regProfile[0].certList.length; i++) {
        imageLink.add({
          'name': regProfile[0].certList[i].name,
          'img': regProfile[0].certList[i].img,
        });
      }

      await uploadCertPhoto();
    } else {
      if (regProfile.isNotEmpty) {
        for (var i = 0; i < regProfile[0].certList.length; i++) {
          imageLink.add({
            'name': regProfile[0].certList[i].name,
            'img': regProfile[0].certList[i].img,
          });
        }
      }
    }

    if (addressController.text.isNotEmpty &&
        imageLink.isNotEmpty &&
        imageLinkCcid.isNotEmpty &&
        nameController.text.isNotEmpty &&
        experienceChoosen.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        workerTypeList.isNotEmpty) {
      await _convertAddressToCoordinate(addressController.text);
    } else {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Quý khách vui lòng nhập đầy đủ thông tin.',
        // barrierColor: const Color.fromRGBO(38, 166, 83, 1),
        titleTextStyle: GoogleFonts.poppins(),
      ).show();

      return;
    }
    final SharedPreferences prefs = await _prefs;
    final userId = prefs.getString('host_id');
    var headers = {
      'Content-Type': 'application/json',
      "x-access-token": loginController.tokenString.toString(),
    };
    try {
      var url = Uri.parse(
          ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.registerWorker);

      Map body = {
        "user_id": userId,
        "name": nameController.text.trim(),
        "address": addressController.text.trim(),
        "lat": latTho,
        "lng": lngTho,
        "avatar": imageAvatarLink,
        "ccid": ccidController.text.trim(),
        "ccid_img": imageLinkCcid,
        "certificates": imageLink,
        "experience": experienceChoosen,
        "description": descriptionController.text,
        "worker_type": workerTypeList,
        "type": type,
        'token': 'anhkhongdoiqua',
      };
      print(body);

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (json['status'] == 'ok') {
          imageLink.clear();
          imageLinkCcid.clear();
          imageAvatar = null;
          isRegisterSuccess = true;
          isRegister = false;
          isUpdateCcid = false;
          isUpdateCert = false;
          isUpdateAvatar = false;
          await AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.success,
            animType: AnimType.leftSlide,
            title: 'Gửi đơn đăng ký thành công',
            titleTextStyle: GoogleFonts.poppins(),
            autoHide: const Duration(milliseconds: 800),
          ).show();
          Get.to(() => const MainScreen());
        } else if (json['status'] == "error") {
          throw jsonDecode(response.body)['error']['message'] ??
              'Unknown Error Occured';
        }
      } else {
        throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured';
      }
    } catch (error) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: error.toString(),
        // barrierColor: const Color.fromRGBO(38, 166, 83, 1),
        titleTextStyle: GoogleFonts.poppins(),
      ).show();

      return;
    }
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
    latTho = lat;

    lngTho = lng;

    if (lat == null || lng == null) {
      return;
    }
  }
}
