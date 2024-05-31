import 'dart:convert';

import 'package:chotot/controllers/login_controller.dart';

import 'package:chotot/data/get_worker_job_data.dart';

import 'package:chotot/models/get_worker_job_model.dart';

// import 'package:flutter/material.dart';

import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

class GetWorkerJob extends GetxController {
  bool isLoading = true;
  bool isLastPage = false;

  LoginController loginController = Get.put(LoginController());
  Future<void> getWorkerJob(
      int index, String statusWorkerJobs, bool isClear) async {
    final headers = {
      'x-access-token': loginController.tokenString,
    };

    // try {
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.getWorkerJobs);

    Map body = {
      'index': index.toString(),
      'status': statusWorkerJobs,
      // 'from': '',
      // 'to': null,
      'token': 'anhkhongdoiqua',
      'version': 'publish'
    };

    http.Response response = await http.post(
      url,
      body: body,
      headers: headers,
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (json['status'] == 'ok') {
        final data = json['data'];

        var photos = [];
        var tempPhoto = [];
        if (json['error']['code'] == 'NO_JOB_FOUND') {
          isLastPage = true;
        } else {
          isLastPage = false;
        }
        if (data == null) {
          return;
        }

        if (isClear) {
          workerJobData.clear();
        }
        for (int i = 0; i < data.length; i++) {
          tempPhoto = data[i]['photos'].toList();
          List<Services> services = [];

          if (tempPhoto.isEmpty || data[i]['photos'][0] == '[]') {
            photos = [];
          } else if (tempPhoto[0].contains(']')) {
            photos = jsonDecode(tempPhoto[0].replaceAll(RegExp(r'^\[\]$'), ''));
          } else {
            photos = [...data[i]['photos']];
          }
          for (int j = 0; j < data[i]['services'].length; j++) {
            services.add(
              Services(
                id: data[i]['services'][j]['_id'].toString(),
                jobitemId: data[i]['services'][j]['jobitem_id'].toString(),
                description: data[i]['services'][j]['description'].toString(),
                fee: data[i]['services'][j]['fee'].toString(),
                jobserviceId:
                    data[i]['services'][j]['jobservice_id'].toString(),
                name: data[i]['services'][j]['name'].toString(),
                price: data[i]['services'][j]['price'].toString(),
                qt: data[i]['services'][j]['qt'].toString(),
                sum: data[i]['services'][j]['sum'].toString(),
                unitPrice: data[i]['services'][j]['unit_price'].toString(),
              ),
            );
          }

          workerJobData.add(
            WorkerJob(
              id: data[i]['_id'].toString(),
              name: data[i]['name'],
              type: data[i]['type'],
              typeId: data[i]['type_id'],
              unitPrice: data[i]['unit_price'],
              priceId: data[i]['price_id'].toString(),
              price: data[i]['price'].toString(),
              movingFee: data[i]['moving_fee'].toString(),
              sumPrice: data[i]['sum_price'].toString(),
              amount: data[i]['amount'].toString(),
              hostId: data[i]['hostId'].toString(),
              workerId: data[i]['worker_id'].toString(),
              phone: data[i]['phone'].toString(),
              address: data[i]['address'].toString(),
              workDate: data[i]['work_date'].toString(),
              description: data[i]['description'],
              status: data[i]['status'],
              services: services,
              photos: photos,
              priceWorkerJob: PriceWorkerJob(
                id: data[i]['prices']['_id'].toString(),
                createAt: data[i]['prices']['created_at'].toString(),
                discount: data[i]['prices']['discount'].toString(),
                distance: data[i]['prices']['distance'].toString(),
                priceId: data[i]['prices']['id'].toString(),
              ),
              jobId: data[i]['job_id'].toString(),
            ),
          );
        }

        isLoading = false;
      }
      if (json['status'] == 'error' &&
          json['error']['code'] == 'NO_JOB_FOUND') {
        if (isClear) {
          workerJobData.clear();
        }

        isLastPage = true;

        isLoading = false;
        // showDialog(
        //     context: Get.context!,
        //     builder: (context) {
        //       return SimpleDialog(
        //         contentPadding: const EdgeInsets.all(20),
        //         children: [
        //           Center(
        //             child: Text('Không tìm thấy công việc',
        //                 style: Theme.of(context).textTheme.titleSmall!.copyWith(
        //                     fontFamily: GoogleFonts.lato().fontFamily,
        //                     fontWeight: FontWeight.w600,
        //                     color: Colors.black87)),
        //           ),
        //         ],
        //       );
        //     });
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
