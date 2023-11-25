import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:chotot/models/ly_lich.dart';
import 'package:chotot/data/ly_lich.dart';

class LyLichController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> getInfo() async {
    // Get device information
    final SharedPreferences prefs = await _prefs;

    try {
      var headers = {
        'Content-Type': 'application/json',
        "x-access-token": prefs.getString('token').toString().trim(),
      };
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.updateInfo);
      Map body = {
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
          ));
        } else if (json['status'] == "error") {
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
}
