import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:chotot/screens/login.dart';
import 'package:get/get.dart';

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
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              title: Text('Lỗi xác thực'),
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
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.requestOtp);
      Map body = {
        'ID': phoneNumberController.text,
        'type': 'phone',
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
          showDialog(
              context: Get.context!,
              builder: (context) {
                return SimpleDialog(
                  title: const Text('Lỗi xác thực'),
                  contentPadding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      json['error']['message'],
                    ),
                  ],
                );
              });
          return;
        }
      } else {
        throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured';
      }
    } catch (error) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              contentPadding: const EdgeInsets.all(20),
              children: [
                Text(
                  error.toString(),
                ),
              ],
            );
          });
    }
  }

  Future<void> forgotPassword() async {
    if (newPasswordController.text.isEmpty || otpCodeController.text.isEmpty) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              title: Text('Lỗi xác thực'),
              contentPadding: EdgeInsets.all(20),
              children: [
                Text(
                  'Nhập đầy đủ thông tin',
                ),
              ],
            );
          });
      return;
    }
    // Get device information
    if (newPasswordController.text != reNewPasswordController.text) {
      return showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              title: Text('Lỗi mật khẩu'),
              contentPadding: EdgeInsets.all(20),
              children: [
                Text(
                  'Mật khẩu không đúng. Nhập lại mật khẩu',
                ),
              ],
            );
          });
    }
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.forgotPassword);
      Map body = {
        'ID': phoneNumberController.text,
        'code': int.parse(otpCodeController.text),
        'new_password': newPasswordController.text,
        'token': 'anhkhongdoiqua',
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == 'ok') {
          phoneNumberController.clear();
          otpCodeController.clear();
          newPasswordController.clear();
          isRequestOtp = 0.obs;
          Get.off(const LoginScreen());
        } else if (json['status'] == 'error') {
          showDialog(
              context: Get.context!,
              builder: (context) {
                return SimpleDialog(
                  contentPadding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      json['error']['message'],
                    ),
                  ],
                );
              });
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
    } catch (error) {
      Get.back();
      showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Error'),
            contentPadding: const EdgeInsets.all(20),
            children: [
              Text(
                error.toString(),
              ),
            ],
          );
        },
      );
    }
  }
}
