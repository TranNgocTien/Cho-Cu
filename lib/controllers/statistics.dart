import 'dart:convert';

// import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/data/statistics_data.dart';
import 'package:chotot/models/statictics_model.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

class Statistics extends GetxController {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // final _storage = const FlutterSecureStorage();
  bool isLoading = true;
  // bool isLastPage = false;

  // LoginController loginController = Get.put(LoginController());
  Future<void> getStatistics() async {
    // try {
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.statistics);
    Map body = {
      'token': 'anhkhongdoiqua',
    };

    http.Response response = await http.post(
      url,
      body: body,
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (json['status'] == 'ok') {
        List<WorkersByType> workerTypeList = [];
        statisticsData.clear();
        var data = json['data'];
        // ignore: prefer_typing_uninitialized_variables

        for (int i = 0; i < data['workers_by_type'].length; i++) {
          workerTypeList.add(WorkersByType(
              amount: data['workers_by_type'][i]['JT${i + 1}'].toString(),
              name: 'JT${i + 1}'));
        }

        statisticsData.add(StatisticsModels(
            jobs: data['jobs'].toString(),
            workerTypeList: workerTypeList,
            workers: data['workers'].toString()));
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
