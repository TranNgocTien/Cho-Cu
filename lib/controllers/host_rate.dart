import 'dart:convert';

import 'package:chotot/data/acceptorker_data.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

class HostRate extends GetxController {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // final headers = {
  //   'Content-Type': 'application/json',
  // };
  // LoginController loginController = Get.put(LoginController());
  TextEditingController contentController = TextEditingController(text: '');
  Future<void> hostRate(
      double d1, double d2, double d3, double d4, double d5) async {
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.hostRate);
    Map body = {
      'version': 'test',
      'contract_id': acceptWorkerData[0].contractId,
      'job_id': acceptWorkerData[0].jobId,
      'worker_id': acceptWorkerData[0].employeeId,
      'host_id': acceptWorkerData[0].employeeName,
      'content': contentController.text,
      'd1': d1.toString(),
      'd2': d2.toString(),
      'd3': d3.toString(),
      'd4': d4.toString(),
      'd5': d5.toString(),
      'ds': ((d1 + d2 + d3 + d4 + d5) / 5).toString(),
      'token': 'anhkhongdoiqua',
    };

    http.Response response = await http.post(
      url,
      body: body,
    );
    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (json['status'] == 'ok') {
        // var data = json['data'];
      } else if (json['status'] == 'error') {
        if (json['error']['message'] == 'Không có công việc') {
          showDialog(
              context: Get.context!,
              builder: (context) {
                return SimpleDialog(
                  contentPadding: const EdgeInsets.all(20),
                  children: [
                    Center(
                      child: Text('Không còn công việc',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                  )),
                    ),
                  ],
                );
              });
          return;
        }
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
    // }
    // finally {
    //   isLoading = false;
    // }
  }
}
