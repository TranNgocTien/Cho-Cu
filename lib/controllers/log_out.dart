import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/data/login_data.dart';
import 'package:chotot/data/reg_profile_data.dart';
import 'package:chotot/data/version_app.dart';
import 'package:chotot/screens/homeScreen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/utils/api_endpoints.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LogOutController extends GetxController {
  LoginController loginController = Get.put(LoginController());

  final _storage = const FlutterSecureStorage();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> logOut() async {
    loginController.tokenString = await _storage.read(key: "TOKEN") ?? '';
    String deviceID = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // Get device information
    final SharedPreferences prefs = await _prefs;
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

        deviceID = androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

        deviceID = iosInfo.identifierForVendor!;
      }
    } on PlatformException {
      throw Exception('get device name failed');
    }
    var headers = {
      'Content-Type': 'application/json',
      "x-access-token": loginController.tokenString,
    };
    try {
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.logout);
      Map body = {
        'token': 'anhkhongdoiqua',
        'version': version,
        'device_id': deviceID,
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == 'ok') {
          await prefs.clear();
          // await prefs.setString('token', token.toString());
          loginController.tokenString = '';
          loginController.hostId = '';
          loginData.clear();
          regProfile.clear();
          await _storage.delete(key: "KEY_USERNAME");
          await _storage.delete(key: "KEY_PASSWORD");
          await _storage.delete(key: "ADDRESS_DEFAULT");
          await _storage.delete(key: "NAME_DEFAULT");
          await _storage.delete(key: "NUMBER_DEFAULT");
          await _storage.delete(key: "TOKEN");
          await _storage.delete(key: "Save_Password");
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
        }
      } else {
        throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured';
      }
    } catch (error) {
      Get.back();
      // showDialog(
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
      //     });
    }
  }
}
