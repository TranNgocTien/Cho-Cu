import 'dart:convert';
// import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/data/version_app.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:chotot/screens/login.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

// import 'package:shared_preferences/shared_preferences.dart';

import 'package:chotot/utils/api_endpoints.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController reNewPasswordController = TextEditingController();
  var isRequestOtp = 0.obs;
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> requestOtpForgotPassword() async {
    // Get device information
    if (phoneNumberController.text.isEmpty) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Nhập số điện thoại',
        titleTextStyle: GoogleFonts.poppins(),
      ).show();

      return;
    }
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.requestOtp);
      Map body = {
        'ID': phoneNumberController.text,
        'type': 'phone',
        'action': 'forgot',
        'token': 'anhkhongdoiqua',
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == 'ok') {
          isRequestOtp = 1.obs;
          // Get.off(const ForgotPasswordScreen());
        } else if (json['status'] == 'error') {
          AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.warning,
            animType: AnimType.rightSlide,
            title: json['error']['message'],
            titleTextStyle: GoogleFonts.poppins(),
          ).show();

          return;
        }
      } else {
        throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured';
      }
    } catch (error) {
      Get.back();
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: error.toString(),
        titleTextStyle: GoogleFonts.poppins(),
      ).show();
    }
  }

  Future<void> forgotPassword() async {
    if (newPasswordController.text.isEmpty || otpCodeController.text.isEmpty) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Nhập đầy đủ thông tin',
        titleTextStyle: GoogleFonts.poppins(),
      ).show();

      return;
    }
    // Get device information
    if (newPasswordController.text != reNewPasswordController.text) {
      return AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Mật khẩu không đúng. Nhập lại mật khẩu',
        titleTextStyle: GoogleFonts.poppins(),
      ).show();
      // return showDialog(
      //     context: Get.context!,
      //     builder: (context) {
      //       return const SimpleDialog(
      //         title: Text(
      //           'Lỗi mật khẩu',
      //           textAlign: TextAlign.center,
      //         ),
      //         contentPadding: EdgeInsets.all(20),
      //         children: [
      //           Center(
      //             child: Text(
      //               'Mật khẩu không đúng. Nhập lại mật khẩu',
      //             ),
      //           ),
      //         ],
      //       );
      //     });
    }
    var headers = {'Content-Type': 'application/json'};
    // try {
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.forgotPassword);
    Map body = {
      'ID': phoneNumberController.text,
      'code': int.parse(otpCodeController.text),
      'new_password': newPasswordController.text,
      'token': 'anhkhongdoiqua',
      'version': version,
    };
    print(body);
    http.Response response =
        await http.post(url, body: jsonEncode(body), headers: headers);
    final json = jsonDecode(response.body);
    print(json);
    if (response.statusCode == 200) {
      if (json['status'] == 'ok') {
        phoneNumberController.clear();
        otpCodeController.clear();
        newPasswordController.clear();
        isRequestOtp = 0.obs;

        Get.off(() => const LoginScreen());
      } else if (json['status'] == 'error') {
        AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.warning,
          animType: AnimType.rightSlide,
          title: json['error']['message'],
          titleTextStyle: GoogleFonts.poppins(),
        ).show();

        return;
      }
      // final json = jsonDecode(response.body);
      // if (json['code']) {
      // var token = json['data']['Token'];
      // final SharedPreferences? prefs = await _prefs;
      // await prefs?.setString('token', token);

      // } else if (json['code'] == "A1") {
      //   print(jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured');
      //   throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured';
      // }
    } else {
      throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured';
    }
    // } catch (error) {
    //   Get.back();
    //   showDialog(
    //     context: Get.context!,
    //     builder: (context) {
    //       return SimpleDialog(
    //         title: const Text(
    //           'Error',
    //           textAlign: TextAlign.center,
    //         ),
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
