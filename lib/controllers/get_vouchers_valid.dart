import 'dart:convert';

import 'package:chotot/data/get_vouchers_valid_data.dart';
import 'package:chotot/models/get_vouchers_valid_models.dart';
// import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

import 'package:chotot/controllers/login_controller.dart';

class GetVouchersValid extends GetxController {
  LoginController loginController = Get.put(LoginController());
  Future<void> getVouchers() async {
    // try {
    // var headers = {
    //   "x-access-token": loginController.tokenString,

    // };
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.getVouchersValid);
    Map body = {'token': 'anhkhongdoiqua', 'version': 'publish'};
    http.Response response = await http.post(
      url,
      body: body,
      // headers: headers,
    );
    // print(response.statusCode);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final data = json['data'];

      for (int i = 0; i < data.length; i++) {
        vouchersValid.add(
          VouchersValid(
            id: data[i]['_id'].toString(),
            code: data[i]['code'].toString(),
            count: data[i]['count'].toString(),
            description: data[i]['description'].toString(),
            from: data[i]['from'].toString(),
            img: data[i]['img'].toString(),
            jobType: data[i]['job_type'],
            limit: data[i]['limit'].toString(),
            name: data[i]['name'].toString(),
            price: data[i]['price'].toString(),
            status: data[i]['status'].toString(),
            sum: data[i]['sum'].toString(),
            to: data[i]['to'].toString(),
            type: data[i]['type'].toString(),
            userId: data[i]['user_id'].toString(),
            value: data[i]['value'].toString(),
          ),
        );
      }
    }
    // else {
    //   throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured';
    // }
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
