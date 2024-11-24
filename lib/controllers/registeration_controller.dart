import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/data/version_app.dart';
import 'package:chotot/screens/login.dart';
import 'package:chotot/screens/verifyOtp.dart';
import 'package:chotot/utils/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:chotot/screens/registerScreen.dart';

class RegisterationController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool isVerifyScreen = false;
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> requestOtp() async {
    if (phoneNumberController.text.isEmpty) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Vui lòng nhập số điện thoại',
        titleTextStyle: GoogleFonts.poppins(),
        autoHide: const Duration(milliseconds: 1000),
      ).show();

      return;
    }
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.requestOtp);

      Map body = {
        'ID': phoneNumberController.text,
        'action': 'register',
        'type': 'phone',
        'token': 'anhkhongdoiqua',
        'version': version,
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (json['status'] == 'ok') {
          Get.to(const VerifyOtpScreen());
        } else if (json['status'] == "error") {
          AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.warning,
            animType: AnimType.rightSlide,
            title: json['error']['message'],
            titleTextStyle: GoogleFonts.poppins(),
            autoHide: const Duration(milliseconds: 3000),
          ).show();
        }

        // phoneNumberController.clear();
        // passwordController.clear();
        // } else {
        //   throw jsonDecode(response.body)['message'] ?? 'Unknown Error occured';
        // }
      } else {
        throw jsonDecode(response.body)['message'] ?? 'Unknown Error occured';
      }
    } catch (e) {
      // showDialog(
      //     context: Get.context!,
      //     builder: (context) {
      //       return SimpleDialog(
      //         title: const Text('Error'),
      //         contentPadding: const EdgeInsets.all(20),
      //         children: [
      //           Text(
      //             e.toString(),
      //           ),
      //         ],
      //       );
      //     });
    }
  }

  Future<void> reRequestOtp() async {
    if (phoneNumberController.text.isEmpty) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              title: Text('Lỗi đăng ký'),
              contentPadding: EdgeInsets.all(20),
              children: [
                Text(
                  'Nhập số điện thoại',
                ),
              ],
            );
          });
      return;
    }
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.requestOtp);
      Map body = {
        'ID': phoneNumberController.text.trim(),
        'type': 'phone',
        'action': 'register',
        'token': 'anhkhongdoiqua',
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (json['status'] == 'ok') {
          Get.to(const VerifyOtpScreen());
        } else if (json['status'] == "error") {
          AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.warning,
            animType: AnimType.rightSlide,
            title: json['error']['message'],
            titleTextStyle: GoogleFonts.poppins(),
            autoHide: const Duration(milliseconds: 3000),
          ).show();
        }
      } else {
        throw jsonDecode(response.body)['message'] ?? 'Unknown Error occured';
      }
    } catch (e) {
      // showDialog(
      //     context: Get.context!,
      //     builder: (context) {
      //       return SimpleDialog(
      //         title: const Text('Error'),
      //         contentPadding: const EdgeInsets.all(20),
      //         children: [
      //           Text(
      //             e.toString(),
      //           ),
      //         ],
      //       );
      //     });
    }
  }

  Future<void> verifyOTP() async {
    if (otpCodeController.text.isEmpty) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Nhập mã OTP',
        titleTextStyle: GoogleFonts.poppins(),
        autoHide: const Duration(milliseconds: 800),
      ).show();
    }
    // try {
    var headers = {'Content-Type': 'application/json'};
    var url =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.verifyOtp);
    Map body = {
      'ID': phoneNumberController.text.trim(),
      'code': otpCodeController.text.trim(),
      'token': 'anhkhongdoiqua',
    };
    print(body);
    http.Response response =
        await http.post(url, body: jsonEncode(body), headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print(json);
      if (json['status'] == 'ok') {
        await AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: json['error']['message'],
          titleTextStyle: GoogleFonts.poppins(),
          autoHide: const Duration(milliseconds: 800),
        ).show();
        Get.off(() => const RegisterScreen());
      } else if (json['status'] == 'error') {
        AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.warning,
          animType: AnimType.rightSlide,
          title: json['error']['message'],
          titleTextStyle: GoogleFonts.poppins(),
          autoHide: const Duration(milliseconds: 800),
        ).show();

        return;
      }
      // final json = jsonDecode(response.body);
    } else {
      throw jsonDecode(response.body)['message'] ?? 'Unknown Error occured';
    }
    // } catch (e) {
    //   Get.back();
    //   AwesomeDialog(
    //     context: Get.context!,
    //     dialogType: DialogType.warning,
    //     animType: AnimType.rightSlide,
    //     title: e.toString(),
    //     titleTextStyle: GoogleFonts.poppins(),
    //     autoHide: const Duration(milliseconds: 800),
    //   ).show();
    // }
  }

  Future<void> registerAccount() async {
    if (nameController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        addressController.text.isEmpty ||
        passwordController.text.isEmpty) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Nhập đầy đủ thông tin đăng ký',
        titleTextStyle: GoogleFonts.poppins(),
        autoHide: const Duration(milliseconds: 800),
      ).show();

      return;
    }
    if (passwordController.text != rePasswordController.text) {
      return AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Mật khẩu không đúng. Nhập lại mật khẩu',
        titleTextStyle: GoogleFonts.poppins(),
        autoHide: const Duration(milliseconds: 800),
      ).show();
    }
    // try {
    var headers = {'Content-Type': 'application/json'};
    var url =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.register);
    Map body = {
      'name': nameController.text,
      'phone': phoneNumberController.text.trim(),
      'address': addressController.text,
      'password': passwordController.text,
      'verify': 'phone',
      'token': 'anhkhongdoiqua',
    };
    http.Response response =
        await http.post(url, body: jsonEncode(body), headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json['status'] == 'ok') {
        nameController.clear();
        phoneNumberController.clear();
        addressController.clear();
        passwordController.clear();
        otpCodeController.clear();
        await AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: json['error']['message'],
          titleTextStyle: GoogleFonts.poppins(),
          autoHide: const Duration(milliseconds: 800),
        ).show();

        Navigator.pushReplacement(
          Get.context!,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        // } else if (json['status'] == 'error') {
        //   AwesomeDialog(
        //     context: Get.context!,
        //     dialogType: DialogType.warning,
        //     animType: AnimType.rightSlide,
        //     title: json['error']['message'],
        //     titleTextStyle: GoogleFonts.poppins(),
        //     autoHide: const Duration(milliseconds: 800),
        //   ).show();

        //   return;
      }
    } else {
      throw jsonDecode(response.body)['message'] ?? 'Unknown Error occured';
    }
    // } catch (e) {
    //   Get.back();
    //   showDialog(
    //       context: Get.context!,
    //       builder: (context) {
    //         return SimpleDialog(
    //           title: const Text('Error'),
    //           contentPadding: const EdgeInsets.all(20),
    //           children: [
    //             Text(
    //               e.toString(),
    //             ),
    //           ],
    //         );
    //       });
    // }
  }
}
