import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'package:chotot/screens/homeScreen.dart';
import 'package:chotot/utils/api_endpoints.dart';

class LoginController extends GetxController {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> loginWithEmail() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName = "";

    // Get device information
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = androidInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.name;
      }
    } on PlatformException {
      throw Exception('get device name failed');
    }
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.loginEmail);
      Map body = {
        'user_id': int.parse(phoneNumberController.text.trim()),
        'password': int.parse(passwordController.text),
        'device': deviceName,
        'token': 'anhkhongdoiqua',
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        // final json = jsonDecode(response.body);
        // if (json['code']) {
        // var token = json['data']['Token'];
        // final SharedPreferences? prefs = await _prefs;
        // await prefs?.setString('token', token);
        phoneNumberController.clear();
        passwordController.clear();
        Get.off(const MainScreen());
        // } else if (json['code'] == "A1") {
        //   print(jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured');
        //   throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured';
        // }
      } else {
        print(jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured');
        throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured';
      }
    } catch (error) {
      print(error);
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: Text('Error'),
              contentPadding: EdgeInsets.all(20),
              children: [
                Text(
                  error.toString(),
                ),
              ],
            );
          });
    }
  }
}
