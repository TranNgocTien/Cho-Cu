import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/data/acceptorker_data.dart';
import 'package:chotot/data/version_app.dart';
// import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

class Workerdone extends GetxController {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // final headers = {
  //   'Content-Type': 'application/json',
  // };
  LoginController loginController = Get.put(LoginController());
  Future<void> workerDone(
      {contractId = '', jobId = '', employeeId = '', employeeName = ''}) async {
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.workerDone);
    Map body = {
      'version': version,
      'contract_id':
          contractId == '' ? acceptWorkerData[0].contractId : contractId,
      'job_id': jobId == '' ? acceptWorkerData[0].jobId : jobId,
      'employee_id': employeeId == '' ? acceptWorkerData[0].employeeId : '',
      'employee_name':
          employeeName == '' ? acceptWorkerData[0].employeeName : '',
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
          await AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.warning,
            animType: AnimType.leftSlide,
            title: 'Không còn công việc',
            titleTextStyle: GoogleFonts.poppins(),
            autoHide: const Duration(milliseconds: 800),
          ).show();

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
