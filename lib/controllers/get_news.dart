import 'dart:convert';

// import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

import 'package:chotot/controllers/login_controller.dart';

class GetNews extends GetxController {
  LoginController loginController = Get.put(LoginController());
  Future<void> getNewsData() async {
    // try {
    // var headers = {
    //   "x-access-token": loginController.tokenString,

    // };
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.getNews);
    Map body = {
      'token': 'anhkhongdoiqua',
      'index': '0',
    };
    http.Response response = await http.post(
      url,
      body: body,
      // headers: headers,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print(json);
      if (json['status'] == 'ok') {
        throw jsonDecode(response.body)['error']['message'] ??
            'Unknown Error Occured';
      }
    } else {
      throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured';
    }
    // } catch (error) {
    //   Get.back();
    //   showDialog(
    //       context: Get.context!,
    //       builder: (context) {
    //         return SimpleDialog(
    //           title: const Text(
    //             'Error1234',
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
    // }
  }
}
