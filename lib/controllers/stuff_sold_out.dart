import 'dart:convert';

// import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/controllers/login_controller.dart';

// import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

// import 'package:shared_preferences/shared_preferences.dart';

import 'package:chotot/utils/api_endpoints.dart';

// import 'package:shared_preferences/shared_preferences.dart';

class SoldOutStuffs extends GetxController {
  // final headers = {
  //   'Content-Type': 'application/json',
  // };
  bool isLoading = true;
  LoginController loginController = Get.put(LoginController());

  Future<void> soldOutStuffs(String id) async {
    // final SharedPreferences prefs = await _prefs;

    // String token = prefs.getString('token')!;

    try {
      var url = Uri.parse(
          ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.soldOut);
      Map body = {
        'stuff_id': id,
        'token': 'anhkhongdoiqua',
      };
      http.Response response = await http.post(
        url,
        body: body,
        headers: {
          "x-access-token": loginController.tokenString.toString(),
        },
      );
      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (json['status'] == 'ok') {
          await AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            title: 'Đã cập nhật thông tin lên hệ thống.',
            titleTextStyle: GoogleFonts.poppins(),
            autoHide: const Duration(milliseconds: 800),
          ).show();
        } else if (json['status'] == 'error') {
          if (json['error']['message'] == 'Không có hàng') {
            await AwesomeDialog(
              context: Get.context!,
              dialogType: DialogType.info,
              animType: AnimType.rightSlide,
              title: 'Không tìm thấy sản phẩm, vui lòng thử lại sau giây lát.',
              titleTextStyle: GoogleFonts.poppins(),
              autoHide: const Duration(milliseconds: 800),
            ).show();
          } else {
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
        // final SharedPreferences? prefs = await _prefs;
        // await prefs?.setString('token', token);
      } else {
        throw jsonDecode(response.body)['message'] ?? 'Unknown Error Occured';
      }
    } catch (error) {
      // error.printError();
      // showDialog(
      //     context: Get.context!,
      //     builder: (context) {
      //       return SimpleDialog(
      //         title: const Text('Error', textAlign: TextAlign.center),
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
    } finally {
      isLoading = false;
    }
  }
}
