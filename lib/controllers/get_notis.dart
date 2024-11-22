import 'dart:convert';

// import 'package:flutter/material.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';
import 'package:chotot/models/noti.dart';
import 'package:chotot/data/noti_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotiController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> getNoti(int index) async {
    // Get device information
    final SharedPreferences prefs = await _prefs;

    try {
      var headers = {
        'Content-Type': 'application/json',
        "x-access-token": prefs.getString('token').toString().trim(),
      };
      var url = Uri.parse(
          ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.getNotis);
      Map body = {
        'index': '$index',
        'token': 'anhkhongdoiqua',
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == 'ok') {
          // notification.clear();
          var data = json['data'];
          for (int i = 0; i < data.length; i++) {
            notification.add(
              Noti(
                id: data[i]['_id'].toString(),
                userId: data[i]['user_id'].toString(),
                title: data[i]['title'].toString(),
                message: data[i]['message'].toString(),
                time: data[i]['time'].toString(),
                action: data[i]['action'].toString(),
                actionType: data[i]['action_type'].toString(),
                isRead: data[i]['read'].toString(),
              ),
            );
          }
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
