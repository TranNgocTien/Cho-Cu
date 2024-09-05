import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/data/acceptorker_data.dart';
import 'package:chotot/data/version_app.dart';
import 'package:chotot/screens/homeScreen.dart';
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
  Future<void> hostRate(double d1, double d2, double d3, double d4, double d5,
      contractId, jobId, employeeId, hostId) async {
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.hostRate);
    Map body = {
      'version': version,
      'contract_id':
          contractId == '' ? acceptWorkerData[0].contractId : contractId,
      'job_id': jobId == "" ? acceptWorkerData[0].jobId : jobId,
      'worker_id':
          employeeId == "" ? acceptWorkerData[0].employeeId : employeeId,
      'host_id': hostId == "" ? acceptWorkerData[0].hostId : hostId,
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
        await AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Đã gửi đánh giá thành công',
          titleTextStyle: GoogleFonts.poppins(),
          autoHide: const Duration(milliseconds: 800),
        ).show();
        Get.offAll(() => const MainScreen());
      } else if (json['status'] == 'error') {
        if (json['error']['message'] == 'Không có công việc') {
          await AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.warning,
            animType: AnimType.rightSlide,
            title: 'Không có công việc',
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
