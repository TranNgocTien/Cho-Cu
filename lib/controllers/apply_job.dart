import 'dart:convert';

import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/data/ly_lich.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

class ApplyJob extends GetxController {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // final _storage = const FlutterSecureStorage();
  // bool isLoading = true;
  // bool isLastPage = false;
  TextEditingController description = TextEditingController(text: '--');
  LoginController loginController = Get.put(LoginController());
  bool registerSuccess = false;
  Future<void> applyJob(String jobId, String workerId) async {
    final headers = {
      'x-access-token': loginController.tokenString,
    };

    // try {
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.applyJob);
    Map body = {
      'job_id': jobId,
      'worker_id': loginController.hostId,
      'description': description.text,
      'lat': lyLichInfo[0].lat,
      'lng': lyLichInfo[0].lng,
      'token': 'anhkhongdoiqua',
    };

    http.Response response = await http.post(
      url,
      body: body,
      headers: headers,
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (json['status'] == 'ok') {
        registerSuccess = true;
      } else {
        throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured';
      }

      // final SharedPreferences? prefs = await _prefs;
      // await prefs?.setString('token', token);
    } else {
      throw jsonDecode(response.body)['message'] ?? 'Unknown Error Occured';
    }
    // } catch (error) {
    //   error.printError();
    //   showDialog(
    //       context: Get.context!,
    //       builder: (context) {
    //         return SimpleDialog(
    //           title: const Text(
    //             'Error',
    //             textAlign: TextAlign.center,
    //           ),
    //           contentPadding: const EdgeInsets.all(20),
    //           children: [
    //             Center(
    //               child: Text(
    //                 error.toString(),
    //               ),
    //             ),
    //           ],
    //         );
    //       });
    // } finally {
    //   isLoading = false;
    // }
  }
}
