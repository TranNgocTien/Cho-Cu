import 'dart:convert';

import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/models/get_a_job_model.dart';
import 'package:chotot/models/job_item.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

class GetAJob extends GetxController {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // final _storage = const FlutterSecureStorage();
  bool isLoading = true;
  // bool isLastPage = false;
  List<GetAJobModel> jobInfo = [];
  LoginController loginController = Get.put(LoginController());
  Future<void> getAJob(String jobId) async {
    final headers = {
      'x-access-token': loginController.tokenString,
    };

    // try {
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.getAJob);
    Map body = {
      'job_id': jobId,
      'token': 'anhkhongdoiqua',
    };

    http.Response response = await http.post(
      url,
      body: body,
      headers: headers,
    );

    final json = jsonDecode(response.body);
 
    if (response.statusCode == 200) {
      if (json['status'] == 'ok') {
        jobInfo.clear();
        List<JobItems> serviceList = [];
        var photos = [];
        var tempPhoto = [];
        var data = json['data'];

        tempPhoto = data['job']['photos'].toList();

        if (data['job']['photos'][0] == '[]') {
          photos = [];
        } else if (tempPhoto[0].contains(']')) {
          photos = jsonDecode(tempPhoto[0].replaceAll(RegExp(r'^\[\]$'), ''));
        } else {
          photos = [...data['photos']];
        }
        for (int i = 0; i < data['job']['services'].length; i++) {
          serviceList.add(
            JobItems(
              id: data['job']['services'][i]['_id'].toString(),
              jobItemId: data['job']['services'][i]['jobitem_id'].toString(),
              version: data['job']['services'][i]['version'].toString(),
              v: data['job']['services'][i]['__v'].toString(),
              description: data['job']['services'][i]['description'].toString(),
              fee: data['job']['services'][i]['fee'].toString(),
              jobserviceId:
                  data['job']['services'][i]['jobservice_id'].toString(),
              name: data['job']['services'][i]['name'].toString(),
              price: data['job']['services'][i]['price'].toString(),
              unit: data['job']['services'][i]['unit'].toString(),
              workerId: data['job']['services'][i]['worker_id'].toString(),
              qt: data['job']['services'][i]['qt'],
            ),
          );
        }

        jobInfo.add(
          GetAJobModel(
            name: data['job']['name'].toString(),
            sumPrice: data['job']['sum_price'].toString(),
            description: data['job']['description'].toString(),
            id: data['job']['id'].toString(),
            address: data['job']['address'].toString(),
            province: data['job']['province'].toString(),
            district: data['job']['district'].toString(),
            ward: data['job']['ward'].toString(),
            photos: photos,
            phone: data['job']['phone'].toString(),
            hostId: data['job']['host_id'].toString(),
            status: data['job']['status'].toString(),
            service: serviceList,
          ),
        );
      } else {
        throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured';
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
