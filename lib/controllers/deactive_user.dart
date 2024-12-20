import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/data/ly_lich.dart';
import 'package:chotot/data/version_app.dart';
import 'package:chotot/screens/homeScreen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

class DeactiveUser extends GetxController {
  TextEditingController phone = TextEditingController(text: '');
  TextEditingController password = TextEditingController(text: '');
  TextEditingController otp = TextEditingController(text: '');
  Future<void> deactiveUser() async {
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.deactiveUser);
    if (password.text != '' && otp.text != '') {
      await AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Chọn xóa tài khoản bằng mật khẩu hoặc mã OTP.',
        titleTextStyle: GoogleFonts.poppins(),
      ).show();
      return;
    }
    Map body = {
      'user_id': lyLichInfo[0].id.toString(),
      'password': password.text.toString(),
      'otp': otp.text.toString(),
      'token': 'anhkhongdoiqua',
      'version': version,
    };

    http.Response response = await http.post(
      url,
      body: body,
    );
    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (json['status'] == 'ok') {
        await AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Đã vô hiệu hóa tài khoản',
          titleTextStyle: GoogleFonts.poppins(),
          autoHide: const Duration(milliseconds: 800),
        ).show();

        Get.offAll(const MainScreen());
      } else if (json['status'] == 'error') {
        await AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.warning,
          animType: AnimType.rightSlide,
          title: json['error']['message'],
          titleTextStyle: GoogleFonts.poppins(),
          autoHide: const Duration(milliseconds: 800),
        ).show();
        Get.back();
      }
    }
  }

  Future<void> getOtp() async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.requestOtpAccount);

    Map body = {
      'ID': phone.text,
      'type': 'phone',
      'action': 'remove',
      'token': 'anhkhongdoiqua',
    };
    http.Response response = await http.post(
      url,
      body: body,
    );
    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (json['status'] == 'ok') {
        // var data = json['data'];
      }
    }
  }
}
