import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/data/version_app.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chotot/data/docu_data.dart';
import 'package:chotot/models/cho_do_cu.dart';
// import 'dart:io';
import 'package:chotot/controllers/login_controller.dart';

// import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

// import 'package:shared_preferences/shared_preferences.dart';

import 'package:chotot/utils/api_endpoints.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class GetStuffs extends GetxController {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // final headers = {
  //   'Content-Type': 'application/json',
  // };
  final _storage = const FlutterSecureStorage();
  bool isLoading = true;
  bool isLastPage = false;
  LoginController loginController = Get.put(LoginController());
  Future<void> getStuffs(int index) async {
    // final SharedPreferences prefs = await _prefs;

    // String token = prefs.getString('token')!;
    var itemsStuffIdOwner = itemsOwner.map((item) => item.id);
    var itemsStuffId = items.map((item) => item.id);
    final tokenLogin = await _storage.read(key: "TOKEN") ?? '';
    try {
      var url = Uri.parse(
          ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.getStuffs);
      Map body = {
        'version': version,
        'index': '$index',
        'status': 'posting',
        // 'index': '0',
        'token': 'anhkhongdoiqua',
      };

      http.Response response = await http.post(
        url,
        body: body,
        headers: {
          tokenLogin != ''
              ? "x-access-token"
              : loginController.tokenString.toString(): '',
        },
      );
      final json = jsonDecode(response.body);
      // print(json);
      if (response.statusCode == 200) {
        if (json['status'] == 'ok') {
          var data = json['data'];

          var photos = [];
          var tempPhoto = [];
          if (json['error']['code'] == 'NO_STUFF_FOUND') {
            isLastPage = true;
          } else {
            isLastPage = false;
          }
          if (data == null) {
            return;
          }
          for (int i = 0; i < data.length; i++) {
            tempPhoto = data[i]['photos'].toList();

            if (tempPhoto[0].contains(']')) {
              photos =
                  jsonDecode(tempPhoto[0].replaceAll(RegExp(r'^\[\]$'), ''));
            } else {
              photos = [...data[i]['photos']];
            }

            if (loginController.hostId == data[i]['host_id'] &&
                itemsStuffIdOwner.contains(data[i]['stuff_id']) == false) {
              itemsOwner.add(
                DoCu(
                  name: data[i]['name'].toString(),
                  price: data[i]["sum_price"].toString(),
                  description: data[i]["description"].toString(),
                  id: data[i]['stuff_id'].toString(),
                  address: data[i]['address'].toString(),
                  province: data[i]['province'].toString(),
                  district: data[i]['district'].toString(),
                  ward: data[i]['ward'].toString(),
                  phone: data[i]['phone'].toString(),
                  photos: photos,
                  hostId: data[i]['host_id'],
                  status: data[i]['status'],
                  createdAt: data[i]['created_at'],
                ),
              );
            }
            if (itemsStuffId.contains(data[i]['stuff_id']) == false &&
                data[i]['status'] == 'posting') {
              items.add(
                DoCu(
                    name: data[i]['name'].toString(),
                    price: data[i]["sum_price"].toString(),
                    description: data[i]["description"].toString(),
                    id: data[i]['stuff_id'].toString(),
                    address: data[i]['address'].toString(),
                    province: data[i]['province'].toString(),
                    district: data[i]['district'].toString(),
                    ward: data[i]['ward'].toString(),
                    phone: data[i]['phone'].toString(),
                    photos: photos,
                    hostId: data[i]['host_id'],
                    status: data[i]['status'],
                    createdAt: data[i]['created_at']),
              );
            }
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
    } finally {
      isLoading = false;
    }
  }
}
