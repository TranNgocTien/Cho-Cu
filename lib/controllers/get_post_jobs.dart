import 'dart:convert';
import 'package:chotot/data/get_post_job_data.dart';
import 'package:chotot/data/version_app.dart';
import 'package:chotot/models/get_post_job_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// import 'dart:io';
import 'package:chotot/controllers/login_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

// import 'package:shared_preferences/shared_preferences.dart';

import 'package:chotot/utils/api_endpoints.dart';

class GetPostJobs extends GetxController {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // final headers = {
  //   'Content-Type': 'application/json',
  // };
  final _storage = const FlutterSecureStorage();
  // bool isLoading = true;
  bool isLastPage = false;
  LoginController loginController = Get.put(LoginController());
  Future<void> getPostJobs(int index) async {
    // final SharedPreferences prefs = await _prefs;

    // String token = prefs.getString('token')!;
    // var itemsStuffIdOwner = itemsOwner.map((item) => item.id);
    // var itemsStuffId = items.map((item) => item.id);
    final tokenLogin = await _storage.read(key: "TOKEN") ?? '';

    // try {
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.getPostJobs);
    Map body = {
      'version': version,
      'index': '$index',
      'token': 'anhkhongdoiqua',
    };

    http.Response response = await http.post(
      url,
      body: body,
      headers: {
        tokenLogin != ''
            ? "x-access-token"
            : loginController.tokenString.toString(): '',
      },
    );
    final json = jsonDecode(response.body);
    print(json);
    if (response.statusCode == 200) {
      if (json['status'] == 'ok') {
        var photos = [];
        var tempPhoto = [];
        postJobData.clear();
        // seviceList.clear();
        // contractsList.clear();
        // workersList.clear();
        var data = json['data'];
        if (json['error']['code'] == 'NO_JOB_FOUND') {
          isLastPage = true;
        } else {
          isLastPage = false;
        }
        if (data == null) {
          return;
        }
        for (int i = 0; i < data.length; i++) {
          List<Service> seviceList = [];
          List<Contracts> contractsList = [];
          List<WorkersPostJob> workersList = [];

          tempPhoto = data[i]['job']['photos'].toList();

          if (tempPhoto.isEmpty || data[i]['job']['photos'][0] == '[]') {
            photos = [];
          } else if (tempPhoto[0].contains(']')) {
            photos = jsonDecode(tempPhoto[0].replaceAll(RegExp(r'^\[\]$'), ''));
          } else {
            photos = [...data[i]['photos']];
          }
          for (int j = 0; j < data[i]['job']['services'].length; j++) {
            seviceList.add(
              Service(
                description:
                    data[i]['job']['services'][j]['description'].toString(),
                code: data[i]['job']['services'][j]['code'].toString(),
                qt: data[i]['job']['services'][j]['qt'],
                sum: data[i]['job']['services'][j]['sum'].toString(),
                unitPrice:
                    data[i]['job']['services'][j]['unit_price'].toString(),
                name: data[i]['job']['services'][j]['name'].toString(),
              ),
            );
          }

          for (int c = 0; c < data[i]['contracts'].length; c++) {
            contractsList.add(Contracts(
              id: data[i]['contracts'][c]['_id'].toString(),
              contractId: data[i]['contracts'][c]['contract_id'].toString(),
              createdAt: data[i]['contracts'][c]['created_at'].toString(),
              description: data[i]['contracts'][c]['description'].toString(),
              employeeId: data[i]['contracts'][c]['employee_id'].toString(),
              employeeName: data[i]['contracts'][c]['employee_name'].toString(),
              hostId: data[i]['contracts'][c]['host_id'].toString(),
              hostName: data[i]['contracts'][c]['host_name'].toString(),
              jobId: data[i]['contracts'][c]['job_id'].toString(),
              jobName: data[i]['contracts'][c]['job_name'].toString(),
              status: data[i]['contracts'][c]['status'].toString(),
              updatedAt: data[i]['contracts'][c]['updated_at'].toString(),
              v: data[i]['contracts'][c]['__v'].toString(),
            ));
          }
          if (data[i].containsKey('workers')) {
            for (int w = 0; w < data[i]['workers'].length; w++) {
              workersList.add(
                WorkersPostJob(
                  id: data[i]['workers'][w]['_id'].toString(),
                  ds: data[i]['workers'][w]['DS'].toString(),
                  wf: data[i]['workers'][w]['WF'].toString(),
                  address: data[i]['workers'][w]['address'].toString(),
                  email: data[i]['workers'][w]['email'].toString(),
                  lat: data[i]['workers'][w]['lat'].toString(),
                  lng: data[i]['workers'][w]['lng'].toString(),
                  name: data[i]['workers'][w]['name'].toString(),
                  phone: data[i]['workers'][w]['phone'].toString(),
                  profileImg: data[i]['workers'][w]['profile_image'].toString(),
                ),
              );
            }
          }
          postJobData.add(
            PostJob(
              job: Job(
                prices: Prices(
                  id: data[i]['job']['prices']['_id'].toString(),
                  priceId: data[i]['job']['prices']['id'].toString(),
                ),
                workerId: data[i]['job']['worker_id'].toString(),
                sumPrice: data[i]['job']['sum_price'].toString(),
                name: data[i]['job']['name'].toString(),
                id: data[i]['job']['_id'].toString(),
                price: data[i]['job']['price'].toString(),
                address: data[i]['job']['address'].toString(),
                agentBonus: data[i]['job']['agent_bonus'].toString(),
                amount: data[i]['job']['amount'].toString(),
                createdAt: data[i]['job']['created_at'].toString(),
                discount: data[i]['job']['discount'].toString(),
                discription: data[i]['job']['discription'].toString(),
                duration: data[i]['job']['duration'].toString(),
                hostId: data[i]['job']['host_id'].toString(),
                jobId: data[i]['job']['job_id'].toString(),
                movingFee: data[i]['job']['moving_fee'].toString(),
                phone: data[i]['job']['phone'].toString(),
                photos: photos,
                services: seviceList,
                status: data[i]['job']['status'].toString(),
                updatedAt: data[i]['job']['updated_at'].toString(),
                v: data[i]['job']['__v'].toString(),
                voucher: data[i]['job']['voucher'].toString(),
                workDate: data[i]['job']['work_date'],
                workHour: data[i]['job']['work_hour'].toString(),
                workerFee: data[i]['job']['worker_fee'].toString(),
                agentVoucher: data[i]['job']['agent_voucher'].toString(),
                agentVoucherBonus:
                    data[i]['job']['agent_voucher_bonus'].toString(),
                description: data[i]['job']['description'].toString(),
              ),
              jobserviceid: data[i]['job']['services'][0]['jobservice_id'],
              contract: data[i]['contract'].toString(),
              contracts: contractsList,
              employee: data[i]['employee'],
              host: Host(
                id: data[i]['host']['_id'].toString(),
                name: data[i]['host']['_id'].toString(),
                phone: data[i]['host']['_id'].toString(),
                email: data[i]['host']['_id'].toString(),
                address: data[i]['host']['_id'].toString(),
                lat: data[i]['host']['_id'].toString(),
                lng: data[i]['host']['_id'].toString(),
                profileImage: data[i]['host']['_id'].toString(),
              ),
              rate: data[i]['rate'],
              workers: workersList,
            ),
          );
        }
      } else if (json['status'] == 'error') {
        // if (json['error']['message'] == 'Không có công việc') {
        //   showDialog(
        //       context: Get.context!,
        //       builder: (context) {
        //         return SimpleDialog(
        //           contentPadding: const EdgeInsets.all(20),
        //           children: [
        //             Center(
        //               child: Text('Không còn công việc',
        //                   style:
        //                       Theme.of(context).textTheme.bodyLarge!.copyWith(
        //                             fontFamily: GoogleFonts.lato().fontFamily,
        //                           )),
        //             ),
        //           ],
        //         );
        //       });
        //   return;
        // }
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
