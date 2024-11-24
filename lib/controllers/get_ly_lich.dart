import 'dart:convert';

// import 'package:flutter/material.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

import 'package:chotot/models/ly_lich.dart';
import 'package:chotot/data/ly_lich.dart';
import 'package:chotot/controllers/login_controller.dart';

class LyLichController extends GetxController {
  LoginController loginController = Get.put(LoginController());
  bool isLoading = false;
  bool showWallet = false;
  Future<void> getInfo() async {
    // Get device information

    try {
      var headers = {
        'Content-Type': 'application/json',
        "x-access-token": loginController.tokenString,
      };
      var url = Uri.parse(
          ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.getAUser);
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
          var userData = data['user'];

          lyLichInfo.add(
            LyLich(
              wf: userData['WF'].toString(),
              lat: userData['lat'].toString(),
              lng: userData['lng'].toString(),
              name: userData['name'].toString(),
              id: userData['_id'].toString(),
              address: userData['address'].toString(),
              emailAuthen: userData['email_authen'].toString(),
              profileImage: userData['profile_image'].toString(),
              joinDate: userData['join_date'].toString(),
              active: userData['active'].toString(),
              phone: userData['phone'].toString(),
              type: userData['type'].toString(),
              status: userData['status'].toString(),
              wallet: userData['wallet'].toString(),
              ccid: userData['ccid'].toString(),
              email: userData['email'].toString(),
              workerAuthen: userData['worker_authen'].toString(),
            ),
          );
          showWallet = false;
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
      }
      // else {
      //   throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured';
      // }
    } catch (error) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: const Text(
                'Error',
                textAlign: TextAlign.center,
              ),
              contentPadding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Text(
                    error.toString(),
                  ),
                ),
              ],
            );
          });
    }
  }
}
