import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/data/acceptorker_data.dart';
import 'package:chotot/data/version_app.dart';
import 'package:chotot/models/acceptWorker_model.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

class AcceptWorker extends GetxController {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // final _storage = const FlutterSecureStorage();
  // bool isLoading = true;
  // bool isLastPage = false;

  LoginController loginController = Get.put(LoginController());
  Future<void> acceptWorker(
      String jobId, String contractId, String priceId) async {
    final headers = {
      'x-access-token': loginController.tokenString,
    };

    // try {
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.acceptWorker);
    Map body = {
      'job_id': jobId,
      'contract_id': contractId,
      'price_id': priceId,
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
        acceptWorkerData.clear();

        var data = json['data'];
        acceptWorkerData.add(
          AcceptWorkerModel(
            contractId: data['contract_id'].toString(),
            createdAt: data['created_at'].toString(),
            description: data['description'].toString(),
            employeeId: data['employee_id'].toString(),
            employeeName: data['employee_name'].toString(),
            hostId: data['host_id'].toString(),
            hostName: data['host_name'].toString(),
            id: data['_id'].toString(),
            jobId: data['job_id'].toString(),
            status: data['status'].toString(),
          ),
        );
        await AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Chọn thợ thành công',
          titleTextStyle: GoogleFonts.poppins(),
          dismissOnTouchOutside: true,
        ).show();
        Get.back();
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
