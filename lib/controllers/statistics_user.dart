import 'dart:convert';

// import 'package:chotot/controllers/login_controller.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/data/version_app.dart';
import 'package:chotot/models/statistics_user_model.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

class StatisticsUser extends GetxController {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // final _storage = const FlutterSecureStorage();
  bool isLoading = true;
  // bool isLastPage = false;
  LoginController loginController = Get.put(LoginController());
  // LoginController loginController = Get.put(LoginController());
  late Statistics statisticsUser;
  Future<void> getStatisticsUser(
      String type, String startDate, String endDate) async {
    try {
      var url = Uri.parse(
          ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.statisticsUser);

      final headers = {'x-access-token': loginController.tokenString};
      Map body = {
        'type': type,
        'status': '',
        'start_date': startDate,
        'end_date': endDate,
        'token': 'anhkhongdoiqua',
        'version': version,
      };

      http.Response response = await http.post(
        url,
        body: body,
        headers: headers,
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (json['status'] == 'ok') {
          var data = json['data'];
          statisticsUser = Statistics(
              count: data['count'],
              sum: data['sum'],
              workerFee: data['worker_fee']);
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
      } else {
        throw jsonDecode(response.body)['message'] ?? 'Unknown Error Occured';
      }
    } catch (error) {
      // error.printError();
      // showDialog(
      //     context: Get.context!,
      //     builder: (context) {
      //       return SimpleDialog(
      //         title: const Text(
      //           'Error',
      //           textAlign: TextAlign.center,
      //         ),
      //         contentPadding: const EdgeInsets.all(20),
      //         children: [
      //           Center(
      //             child: Text(
      //               error.toString(),
      //             ),
      //           ),
      //         ],
      //       );
      //     });
    } finally {
      isLoading = false;
    }
  }
}
