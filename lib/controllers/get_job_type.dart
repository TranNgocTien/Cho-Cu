import 'dart:convert';

import 'package:chotot/data/job_type_data.dart';
import 'package:chotot/models/job_type.dart';
// import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

import 'package:chotot/controllers/login_controller.dart';

class GetJobTypeController extends GetxController {
  LoginController loginController = Get.put(LoginController());
  Future<void> getJobType() async {
    try {
      var headers = {
        "x-access-token": loginController.tokenString,
      };
      var url = Uri.parse(
          ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.getJobType);
      Map body = {
        'token': 'anhkhongdoiqua',
      };
      http.Response response = await http.post(
        url,
        body: body,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == 'ok') {
          final data = json['data'];

          for (int i = 0; i < data.length; i++) {
            jobTypeList.add(
              JobTypeModel(
                name: data[i]['name'],
                shortName: data[i]['short_name'],
                id: data[i]['_id'],
                item: data[i]['item'],
                jobtypeId: data[i]['jobtype_id'],
                fee: data[i]['fee'].toString(),
              ),
            );
          }

          throw jsonDecode(response.body)['error']['message'] ??
              'Unknown Error Occured';
        }
      } else {
        throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured';
      }
    } catch (error) {
      // Get.back();
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
