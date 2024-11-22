import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/models/get_job_by_type_2_model.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

class GetJobByType2 extends GetxController {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // final _storage = const FlutterSecureStorage();

  // bool isLastPage = false;

  List<Rate> rateList = [];
  List<Contract> contractList = [];
  bool isLastPage = false;
  Future<void> getJobByType2(String workerId, String index) async {
    // try {
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.getJobsByType2);
    Map body = {
      'type': 'require_job',
      'user_id': workerId.toString(),
      'index': index,
      'status': 'finish',
      'token': 'anhkhongdoiqua',
    };

    http.Response response = await http.post(
      url,
      body: body,
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (json['status'] == 'ok') {
        var data = json['data'];

        isLastPage = false;
        for (int i = 0; i < data.length; i++) {
          List rate = data[i]['rate'];
          List contract = data[i]['contract'];
          for (int z = 0; z < contract.length; z++) {
            contractList.add(
              Contract(
                jobId: contract[z]['job_id'],
                jobName: contract[z]['job_name'],
                hostId: contract[z]['host_id'],
                hostName: contract[z]['host_name'],
                employeeId: contract[z]['employee_id'],
                employeeName: contract[z]['employee_name'],
                createdAt: contract[z]['created_at'],
                contractId: contract[z]['contract_id'],
              ),
            );
          }
          if (rate.isNotEmpty) {
            for (int j = 0; j < rate.length; j++) {
              if (rate[j]['type'] == 'worker') {
                rateList.add(
                  Rate(
                    id: rate[j]['_id'],
                    contractId: rate[j]['contract_id'],
                    type: rate[j]['type'],
                    content: rate[j]['content'],
                    d1: rate[j]['d1'],
                    d2: rate[j]['d2'],
                    d3: rate[j]['d3'],
                    d4: rate[j]['d4'],
                    d5: rate[j]['d5'],
                    ds: rate[j]['ds'],
                    hostId: rate[j]['host_id'],
                    jobId: rate[j]['job_id'],
                    time: rate[j]['time'],
                    workerId: rate[j]['worker_id'],
                  ),
                );
              }
            }
          } else {
            rateList.add(Rate(
                id: '',
                contractId: '',
                type: '',
                content: '',
                d1: '',
                d2: '',
                d3: '',
                d4: '',
                d5: '',
                ds: '',
                hostId: '',
                jobId: '',
                time: '',
                workerId: ''));
          }
        }
      } else if (json['error']['code'] == 'NO_JOB_FOUND') {
        isLastPage = true;
        await AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          title: 'Không còn đánh giá khác',
          titleTextStyle: GoogleFonts.poppins(),
          autoHide: const Duration(milliseconds: 800),
        ).show();
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
    } else {}
  }
}
