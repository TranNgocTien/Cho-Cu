import 'dart:convert';

import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/data/acceptorker_data.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

class HostDone extends GetxController {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // final headers = {
  //   'Content-Type': 'application/json',
  // };
  LoginController loginController = Get.put(LoginController());
  Future<void> hostDone() async {
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.hostDone);
    Map body = {
      'version': 'test',
      'contract_id': acceptWorkerData[0].contractId,
      'job_id': acceptWorkerData[0].jobId,
      'host_id': acceptWorkerData[0].hostId,
      'host_name': acceptWorkerData[0].hostName,
      'token': 'anhkhongdoiqua',
    };

    http.Response response = await http.post(
      url,
      body: body,
      headers: {
        'x-access-token': loginController.tokenString.toString(),
      },
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
