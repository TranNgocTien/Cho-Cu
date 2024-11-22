import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/data/login_data.dart';
import 'package:chotot/screens/homeScreen.dart';
// import 'package:chotot/screens/homeScreen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/utils/api_endpoints.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:chotot/models/ly_lich.dart';
import 'package:chotot/data/ly_lich.dart';

class UpdateInfoController extends GetxController {
  LoginController loginController = Get.put(LoginController());
  TextEditingController nameController =
      TextEditingController(text: loginData[0].name);
  TextEditingController addressController =
      TextEditingController(text: loginData[0].address);
  late double lat;
  late double lng;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> updateInfo() async {
    // Get device information
    final SharedPreferences prefs = await _prefs;

    // try {
    if (lat == null || lng == null) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Tọa độ không lấy được',
        titleTextStyle: GoogleFonts.poppins(),
        autoHide: const Duration(milliseconds: 800),
      ).show();

      return;
    }
    if (nameController.text.isEmpty) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Nhập tên chủ tài khoản',
        titleTextStyle: GoogleFonts.poppins(),
        autoHide: const Duration(milliseconds: 800),
      ).show();

      return;
    }

    var headers = {
      'Content-Type': 'application/json',
      "x-access-token": prefs.getString('token').toString().trim(),
    };
    var url =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.updateInfo);
    Map body = {
      'name': nameController.text.toString(),
      'address': addressController.text.toString(),
      'lat': lat.toString(),
      'lng': lng.toString(),
      'token': 'anhkhongdoiqua',
    };
    http.Response response =
        await http.post(url, body: jsonEncode(body), headers: headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json['status'] == 'ok') {
        lyLichInfo.clear();
        var data = json['data'];
        lyLichInfo.add(LyLich(
          wf: data['WF'].toString(),
          lat: data['lat'].toString(),
          lng: data['lng'].toString(),
          name: data['name'].toString(),
          id: data['_id'].toString(),
          address: data['address'].toString(),
          emailAuthen: data['email_authen'].toString(),
          profileImage: data['profile_image'].toString(),
          joinDate: data['join_date'].toString(),
          active: data['active'].toString(),
          phone: data['phone'].toString(),
          type: data['type'].toString(),
          status: data['status'].toString(),
          wallet: data['wallet'].toString(),
          ccid: data['ccid'].toString(),
          email: data['email'].toString(),
          workerAuthen: data['worker_authen'].toString(),
        ));
        await AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Cập nhật tài khoản thành công',
          titleTextStyle: GoogleFonts.poppins(),
          autoHide: const Duration(milliseconds: 800),
        ).show();
        // showDialog(
        //     context: Get.context!,
        //     builder: (context) {
        //       return const SimpleDialog(
        //         contentPadding: EdgeInsets.all(20),
        //         children: [
        //           Center(
        //             child: Text(
        //               'Cập nhật tài khoản thành công',
        //             ),
        //           ),
        //         ],
        //       );
        //     });
        // nameController.clear();
        // addressController.clear();
        lat = 0;
        lng = 0;
        Get.offAll(() => const MainScreen());
      } else if (json['status'] == 'error') {
        await AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.warning,
          animType: AnimType.rightSlide,
          title: json['error']['message'],
          titleTextStyle: GoogleFonts.poppins(),
          autoHide: const Duration(milliseconds: 800),
        ).show();
      }
    } else {
      throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured';
    }
    // } catch (error) {
    //   Get.back();
    //   showDialog(
    //     context: Get.context!,
    //     builder: (context) {
    //       return SimpleDialog(
    //         title: const Text('Error', textAlign: TextAlign.center),
    //         contentPadding: const EdgeInsets.all(20),
    //         children: [
    //           Center(
    //             child: Text(
    //               error.toString(),
    //             ),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
  }
}
