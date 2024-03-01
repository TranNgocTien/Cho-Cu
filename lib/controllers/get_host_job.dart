import 'dart:convert';

import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/data/get_host_job_data.dart';
import 'package:chotot/models/get_host_job_model.dart';
import 'package:chotot/models/job_item.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

class GetHostJob extends GetxController {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // final _storage = const FlutterSecureStorage();

  List<String> hostJobDataPostingIndex = [];
  List<String> hostJobDataApplyIndex = [];
  List<String> hostJobDataAcceptIndex = [];
  List<String> hostJobDataCancelIndex = [];
  List<String> hostJobDataWorkerDoneIndex = [];
  List<String> hostJobDataFinishJobIndex = [];

  bool isLoading = true;
  bool isLastPage = false;
  String statusHostJob = '';
  LoginController loginController = Get.put(LoginController());
  Future<void> getHostJob(int index) async {
    final headers = {
      'x-access-token': loginController.tokenString,
    };

    // try {
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.getHostJobs);
    Map body = {
      'index': '$index',
      'status': statusHostJob,
      'from': '',
      'to': '',
      'token': 'anhkhongdoiqua',
      'version': 'test',
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

        statusHostJob = '';
        hostJobDataAll.clear();

        for (int i = 0; i < data.length; i++) {
          tempPhoto = data[i]['photos'].toList();

          if (data[i]['photos'][0] == '[]') {
            photos = [];
          } else if (tempPhoto[0].contains(']')) {
            photos = jsonDecode(tempPhoto[0].replaceAll(RegExp(r'^\[\]$'), ''));
          } else {
            photos = [...data[i]['photos']];
          }
          hostJobDataAll.add(
            HostJob(
              id: data[i]['_id'].toString(),
              jobId: data[i]['job_id'].toString(),
              name: data[i]['name'].toString(),
              type: data[i]['type'].toString(),
              price: data[i]['price'].toString(),
              address: data[i]['address'].toString(),
              workDate: data[i]['work_date'].toString(),
              description: data[i]['description'].toString(),
              service: JobItems(
                  id: data[i]['services'][0]['_id'].toString(),
                  jobItemId: data[i]['services'][0]['jobitem_id'].toString(),
                  version: data[i]['services'][0]['version'].toString(),
                  v: data[i]['services'][0]['__v'].toString(),
                  description: data[i]['services'][0]['description'].toString(),
                  fee: data[i]['services'][0]['fee'].toString(),
                  jobserviceId:
                      data[i]['services'][0]['jobservice_id'].toString(),
                  name: data[i]['services'][0]['name'].toString(),
                  price: data[i]['services'][0]['price'].toString(),
                  unit: data[i]['services'][0]['unit'].toString(),
                  workerId: data[i]['services'][0]['THOTHONGMINH'].toString(),
                  qt: data[i]['services'][0]['qt']),
              photos: photos,
              status: data[i]['status'].toString(),
              workHour: data[i]['work_hour'].toString(),
              priceHostJob: PriceHostJob(
                id: data[i]['prices']['_id'].toString(),
                createAt: data[i]['prices']['created_at'].toString(),
                discount: data[i]['prices']['discount'].toString(),
                distance: data[i]['prices']['distance'].toString(),
                priceId: data[i]['prices']['id'].toString(),
              ),
            ),
          );

          if (data[i]['status'] == 'posting' &&
              hostJobDataPostingIndex.contains(data[i]['_id']) == false) {
            hostJobDataPostingIndex.add(data[i]['_id']);
            hostJobDataPosting.add(
              HostJob(
                id: data[i]['_id'].toString(),
                jobId: data[i]['job_id'].toString(),
                name: data[i]['name'].toString(),
                type: data[i]['type'].toString(),
                price: data[i]['price'].toString(),
                address: data[i]['address'].toString(),
                workDate: data[i]['work_date'].toString(),
                description: data[i]['description'].toString(),
                service: JobItems(
                    id: data[i]['services'][0]['_id'].toString(),
                    jobItemId: data[i]['services'][0]['jobitem_id'].toString(),
                    version: data[i]['services'][0]['version'].toString(),
                    v: data[i]['services'][0]['__v'].toString(),
                    description:
                        data[i]['services'][0]['description'].toString(),
                    fee: data[i]['services'][0]['fee'].toString(),
                    jobserviceId:
                        data[i]['services'][0]['jobservice_id'].toString(),
                    name: data[i]['services'][0]['name'].toString(),
                    price: data[i]['services'][0]['price'].toString(),
                    unit: data[i]['services'][0]['unit'].toString(),
                    workerId: data[i]['services'][0]['THOTHONGMINH'].toString(),
                    qt: data[i]['services'][0]['qt']),
                photos: photos,
                status: data[i]['status'].toString(),
                workHour: data[i]['work_hour'].toString(),
                priceHostJob: PriceHostJob(
                  id: data[i]['prices']['_id'].toString(),
                  createAt: data[i]['prices']['created_at'].toString(),
                  discount: data[i]['prices']['discount'].toString(),
                  distance: data[i]['prices']['distance'].toString(),
                  priceId: data[i]['prices']['id'].toString(),
                ),
              ),
            );
          }
          if (data[i]['status'] == 'apply' &&
              hostJobDataApplyIndex.contains(data[i]['_id']) == false) {
            hostJobDataApplyIndex.add(data[i]['_id']);
            hostJobDataApply.add(
              HostJob(
                id: data[i]['_id'].toString(),
                jobId: data[i]['job_id'].toString(),
                name: data[i]['name'].toString(),
                type: data[i]['type'].toString(),
                price: data[i]['price'].toString(),
                address: data[i]['address'].toString(),
                workDate: data[i]['work_date'].toString(),
                description: data[i]['description'].toString(),
                service: JobItems(
                    id: data[i]['services'][0]['_id'].toString(),
                    jobItemId: data[i]['services'][0]['jobitem_id'].toString(),
                    version: data[i]['services'][0]['version'].toString(),
                    v: data[i]['services'][0]['__v'].toString(),
                    description:
                        data[i]['services'][0]['description'].toString(),
                    fee: data[i]['services'][0]['fee'].toString(),
                    jobserviceId:
                        data[i]['services'][0]['jobservice_id'].toString(),
                    name: data[i]['services'][0]['name'].toString(),
                    price: data[i]['services'][0]['price'].toString(),
                    unit: data[i]['services'][0]['unit'].toString(),
                    workerId: data[i]['services'][0]['THOTHONGMINH'].toString(),
                    qt: data[i]['services'][0]['qt']),
                photos: photos,
                status: data[i]['status'].toString(),
                workHour: data[i]['work_hour'].toString(),
                priceHostJob: PriceHostJob(
                  id: data[i]['prices']['_id'].toString(),
                  createAt: data[i]['prices']['created_at'].toString(),
                  discount: data[i]['prices']['discount'].toString(),
                  distance: data[i]['prices']['distance'].toString(),
                  priceId: data[i]['prices']['id'].toString(),
                ),
              ),
            );
          }
          if (data[i]['status'] == 'accept' &&
              hostJobDataAcceptIndex.contains(data[i]['_id']) == false) {
            hostJobDataAcceptIndex.add(data[i]['_id']);
            hostJobDataAccept.add(
              HostJob(
                id: data[i]['_id'].toString(),
                jobId: data[i]['job_id'].toString(),
                name: data[i]['name'].toString(),
                type: data[i]['type'].toString(),
                price: data[i]['price'].toString(),
                address: data[i]['address'].toString(),
                workDate: data[i]['work_date'].toString(),
                description: data[i]['description'].toString(),
                service: JobItems(
                    id: data[i]['services'][0]['_id'].toString(),
                    jobItemId: data[i]['services'][0]['jobitem_id'].toString(),
                    version: data[i]['services'][0]['version'].toString(),
                    v: data[i]['services'][0]['__v'].toString(),
                    description:
                        data[i]['services'][0]['description'].toString(),
                    fee: data[i]['services'][0]['fee'].toString(),
                    jobserviceId:
                        data[i]['services'][0]['jobservice_id'].toString(),
                    name: data[i]['services'][0]['name'].toString(),
                    price: data[i]['services'][0]['price'].toString(),
                    unit: data[i]['services'][0]['unit'].toString(),
                    workerId: data[i]['services'][0]['THOTHONGMINH'].toString(),
                    qt: data[i]['services'][0]['qt']),
                photos: photos,
                status: data[i]['status'].toString(),
                workHour: data[i]['work_hour'].toString(),
                priceHostJob: PriceHostJob(
                  id: data[i]['prices']['_id'].toString(),
                  createAt: data[i]['prices']['created_at'].toString(),
                  discount: data[i]['prices']['discount'].toString(),
                  distance: data[i]['prices']['distance'].toString(),
                  priceId: data[i]['prices']['id'].toString(),
                ),
              ),
            );
          }
          if (data[i]['status'] == 'cancel' &&
              hostJobDataCancelIndex.contains(data[i]['_id']) == false) {
            hostJobDataCancelIndex.add(data[i]['_id']);
            hostJobDataCancel.add(
              HostJob(
                id: data[i]['_id'].toString(),
                jobId: data[i]['job_id'].toString(),
                name: data[i]['name'].toString(),
                type: data[i]['type'].toString(),
                price: data[i]['price'].toString(),
                address: data[i]['address'].toString(),
                workDate: data[i]['work_date'].toString(),
                description: data[i]['description'].toString(),
                service: JobItems(
                    id: data[i]['services'][0]['_id'].toString(),
                    jobItemId: data[i]['services'][0]['jobitem_id'].toString(),
                    version: data[i]['services'][0]['version'].toString(),
                    v: data[i]['services'][0]['__v'].toString(),
                    description:
                        data[i]['services'][0]['description'].toString(),
                    fee: data[i]['services'][0]['fee'].toString(),
                    jobserviceId:
                        data[i]['services'][0]['jobservice_id'].toString(),
                    name: data[i]['services'][0]['name'].toString(),
                    price: data[i]['services'][0]['price'].toString(),
                    unit: data[i]['services'][0]['unit'].toString(),
                    workerId: data[i]['services'][0]['THOTHONGMINH'].toString(),
                    qt: data[i]['services'][0]['qt']),
                photos: photos,
                status: data[i]['status'].toString(),
                workHour: data[i]['work_hour'].toString(),
                priceHostJob: PriceHostJob(
                  id: data[i]['prices']['_id'].toString(),
                  createAt: data[i]['prices']['created_at'].toString(),
                  discount: data[i]['prices']['discount'].toString(),
                  distance: data[i]['prices']['distance'].toString(),
                  priceId: data[i]['prices']['id'].toString(),
                ),
              ),
            );
          }
          if (data[i]['status'] == 'worker_done' &&
              hostJobDataWorkerDoneIndex.contains(data[i]['_id']) == false) {
            hostJobDataWorkerDoneIndex.add(data[i]['_id']);
            hostJobDataWorkerDone.add(
              HostJob(
                id: data[i]['_id'].toString(),
                jobId: data[i]['job_id'].toString(),
                name: data[i]['name'].toString(),
                type: data[i]['type'].toString(),
                price: data[i]['price'].toString(),
                address: data[i]['address'].toString(),
                workDate: data[i]['work_date'].toString(),
                description: data[i]['description'].toString(),
                service: JobItems(
                    id: data[i]['services'][0]['_id'].toString(),
                    jobItemId: data[i]['services'][0]['jobitem_id'].toString(),
                    version: data[i]['services'][0]['version'].toString(),
                    v: data[i]['services'][0]['__v'].toString(),
                    description:
                        data[i]['services'][0]['description'].toString(),
                    fee: data[i]['services'][0]['fee'].toString(),
                    jobserviceId:
                        data[i]['services'][0]['jobservice_id'].toString(),
                    name: data[i]['services'][0]['name'].toString(),
                    price: data[i]['services'][0]['price'].toString(),
                    unit: data[i]['services'][0]['unit'].toString(),
                    workerId: data[i]['services'][0]['THOTHONGMINH'].toString(),
                    qt: data[i]['services'][0]['qt']),
                photos: photos,
                status: data[i]['status'].toString(),
                workHour: data[i]['work_hour'].toString(),
                priceHostJob: PriceHostJob(
                  id: data[i]['prices']['_id'].toString(),
                  createAt: data[i]['prices']['created_at'].toString(),
                  discount: data[i]['prices']['discount'].toString(),
                  distance: data[i]['prices']['distance'].toString(),
                  priceId: data[i]['prices']['id'].toString(),
                ),
              ),
            );
          }
          if (data[i]['status'] == 'finish' &&
              hostJobDataFinishJobIndex.contains(data[i]['_id']) == false) {
            hostJobDataFinishJobIndex.add(data[i]['_id']);
            hostJobDataFinishJob.add(
              HostJob(
                id: data[i]['_id'].toString(),
                jobId: data[i]['job_id'].toString(),
                name: data[i]['name'].toString(),
                type: data[i]['type'].toString(),
                price: data[i]['price'].toString(),
                address: data[i]['address'].toString(),
                workDate: data[i]['work_date'].toString(),
                description: data[i]['description'].toString(),
                service: JobItems(
                    id: data[i]['services'][0]['_id'].toString(),
                    jobItemId: data[i]['services'][0]['jobitem_id'].toString(),
                    version: data[i]['services'][0]['version'].toString(),
                    v: data[i]['services'][0]['__v'].toString(),
                    description:
                        data[i]['services'][0]['description'].toString(),
                    fee: data[i]['services'][0]['fee'].toString(),
                    jobserviceId:
                        data[i]['services'][0]['jobservice_id'].toString(),
                    name: data[i]['services'][0]['name'].toString(),
                    price: data[i]['services'][0]['price'].toString(),
                    unit: data[i]['services'][0]['unit'].toString(),
                    workerId: data[i]['services'][0]['THOTHONGMINH'].toString(),
                    qt: data[i]['services'][0]['qt']),
                photos: photos,
                status: data[i]['status'].toString(),
                workHour: data[i]['work_hour'].toString(),
                priceHostJob: PriceHostJob(
                  id: data[i]['prices']['_id'].toString(),
                  createAt: data[i]['prices']['created_at'].toString(),
                  discount: data[i]['prices']['discount'].toString(),
                  distance: data[i]['prices']['distance'].toString(),
                  priceId: data[i]['prices']['id'].toString(),
                ),
              ),
            );
          }
        }
      }
      if (json['status'] == 'error' &&
          json['error']['code'] == 'NO_JOB_FOUND') {
        showDialog(
            context: Get.context!,
            builder: (context) {
              return SimpleDialog(
                contentPadding: const EdgeInsets.all(20),
                children: [
                  Center(
                    child: Text('Không tìm thấy công việc',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontFamily: GoogleFonts.lato().fontFamily,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                  ),
                ],
              );
            });
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
