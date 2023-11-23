import 'dart:convert';

import 'package:chotot/screens/login.dart';
import 'package:chotot/screens/verifyOtp.dart';
import 'package:chotot/utils/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        'ID': phoneNumberController.text,
        'type': 'phone',
        'token': 'anhkhongdoiqua',
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == 'ok') {
          Get.to(const VerifyOtpScreen());
        } else if (json['status'] == "error") {
          showDialog(
              context: Get.context!,
              builder: (context) {
                return SimpleDialog(
                  title: const Text('Lỗi đăng ký'),
                  contentPadding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      json['error']['message'],
                    ),
                  ],
                );
              });
          throw jsonDecode(response.body)['error']['message'] ??
              'Unknown Error Occured';
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
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Error'),
              contentPadding: const EdgeInsets.all(20),
              children: [
                Text(
                  e.toString(),
                ),
              ],
            );
          });
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
        'token': 'anhkhongdoiqua',
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == 'ok') {
          Get.to(const VerifyOtpScreen());
        } else if (json['status'] == "error") {
          showDialog(
              context: Get.context!,
              builder: (context) {
                return SimpleDialog(
                  title: const Text('Lỗi đăng ký'),
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
        throw jsonDecode(response.body)['message'] ?? 'Unknown Error occured';
      }
    } catch (e) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Error'),
              contentPadding: const EdgeInsets.all(20),
              children: [
                Text(
                  e.toString(),
                ),
              ],
            );
          });
    }
  }

  Future<void> verifyOTP() async {
    if (otpCodeController.text.isEmpty) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              title: Text('Lỗi đăng ký'),
              contentPadding: EdgeInsets.all(20),
              children: [
                Text(
                  'Nhập mã OTP',
                ),
              ],
            );
          });
      return;
    }
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.verifyOtp);
      Map body = {
        'ID': phoneNumberController.text.trim(),
        'code': otpCodeController.text.trim(),
        'token': 'anhkhongdoiqua',
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == 'ok') {
          Get.to(const RegisterScreen());
        } else if (json['status'] == 'error') {
          showDialog(
              context: Get.context!,
              builder: (context) {
                return SimpleDialog(
                  title: const Text('Error'),
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
      } else {
        throw jsonDecode(response.body)['message'] ?? 'Unknown Error occured';
      }
    } catch (e) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Error'),
              contentPadding: const EdgeInsets.all(20),
              children: [
                Text(
                  e.toString(),
                ),
              ],
            );
          });
    }
  }

  Future<void> registerAccount() async {
    if (nameController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        addressController.text.isEmpty ||
        passwordController.text.isEmpty) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              title: Text('Lỗi đăng ký'),
              contentPadding: EdgeInsets.all(20),
              children: [
                Text(
                  'Nhập đầy đủ thông tin đăng ký',
                ),
              ],
            );
          });
      return;
    }
    if (passwordController.text != rePasswordController.text) {
      return showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              title: Text('Error'),
              contentPadding: EdgeInsets.all(20),
              children: [
                Text(
                  'Mật khẩu không đúng. Nhập lại mật khẩu',
                ),
              ],
            );
          });
    }
    try {
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
          Get.off(const LoginScreen());
        } else if (json['status'] == 'error') {
          showDialog(
              context: Get.context!,
              builder: (context) {
                return SimpleDialog(
                  title: const Text('Error'),
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
        throw jsonDecode(response.body)['message'] ?? 'Unknown Error occured';
      }
    } catch (e) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Error'),
              contentPadding: const EdgeInsets.all(20),
              children: [
                Text(
                  e.toString(),
                ),
              ],
            );
          });
    }
  }
}
