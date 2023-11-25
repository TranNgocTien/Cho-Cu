import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:chotot/screens/homeScreen.dart';
import 'package:chotot/utils/api_endpoints.dart';

class LoginController extends GetxController {
  TextEditingController phoneNumberController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  var isLoading = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String tokenString = '';
  String hostId = '';
  Future<void> loginWithEmail() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName = "";
    if (phoneNumberController.text == '' || passwordController.text == '') {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              title: Text('Lỗi đăng nhập'),
              contentPadding: EdgeInsets.all(20),
              children: [
                Text(
                  'Điền đầy đủ thông tin đăng nhập',
                ),
              ],
            );
          });
      return;
    }
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
      isLoading = true;
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.loginEmail);
      Map body = {
        'user_id': phoneNumberController.text.trim(),
        'password': passwordController.text,
        'device': deviceName,
        'token': 'anhkhongdoiqua',
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == 'ok') {
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
          tokenString = json['data']['token'];
          hostId = json['data']['_id'];
          final SharedPreferences prefs = await _prefs;

          // await prefs.setString('token', token.toString());
          await _getCurrentLocation();
          await prefs.setString('host_id', json['data']['_id']);
          await prefs.setString('token', json['data']['token']);
          await prefs.setString('host_name', json['data']['name']);
          isLoading = false;

          // print('=========================');
          // print(
          //   prefs.getString('token'),
          // );
          phoneNumberController.clear();
          passwordController.clear();
          Get.offAll(const MainScreen());
        } else if (json['status'] == "error") {
          isLoading = false;
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
          throw jsonDecode(response.body)['error']['message'] ??
              'Unknown Error Occured';
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
              title: const Text('Error'),
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

  Future<void> _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return;
    }

    final SharedPreferences prefs = await _prefs;

    // await prefs.setString('token', token.toString());

    await prefs.setDouble('lat', lat);
    await prefs.setDouble('lng', lng);
  }
}
