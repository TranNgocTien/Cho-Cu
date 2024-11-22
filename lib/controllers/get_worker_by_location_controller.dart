import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/data/get_worker_by_location_data.dart';
import 'package:chotot/models/get_worker_by_location_model.dart';
import 'package:chotot/utils/api_endpoints.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class GetWorkerByLocation extends GetxController {
  LoginController loginController = Get.put(LoginController());
  bool isLoadding = false;

  Future<void> getWorkerLocation(
    double lat,
    double lng,
  ) async {
    var headers = {
      'x-access-token': loginController.tokenString,
    };

    var url = Uri.parse(ApiEndPoints.servicesUrl +
        ApiEndPoints.authEndPoints.getWorkerByLocation);

    Map body = {
      'lat': lat.toString(),
      'lng': lng.toString(),
      'distance': 2.toString(),
      'version': 'test',
      // 'job_type': '',
      'token': 'anhkhongdoiqua'
    };

    http.Response response = await http.post(url, body: body, headers: headers);

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (json['status'] == 'ok') {
        workerByLocationList.clear();
        var data = json['data'];

        for (var i = 0; i < data.length; i++) {
          var certificateData = data[i]['certificate'];
          List<Certificate> certificate = [];
          if (certificateData.length > 0) {
            for (var j = 0; j < certificateData.length; j++) {
              certificate.add(
                Certificate(image: certificateData[j]['img']),
              );
            }
          }

          workerByLocationList.add(
            WorkerByLocation(
              description: data[i]['description'].toString(),
              experience: data[i]['experience'].toString(),
              id: data[i]['_id'].toString(),
              userId: data[i]['user_id'].toString(),
              ds: data[i]['DS'].toString(),
              wf: data[i]['wf'].toString(),
              address: data[i]['address'].toString(),
              ccid: data[i]['ccid'].toString(),
              ccidImg: CcidImg(
                  truoc: data[i]['ccid_img']['truoc'].toString(),
                  sau: data[i]['ccid_img']['sau'].toString()),
              certificate: certificate,
              lat: data[i]['lat'].toString(),
              lng: data[i]['lng'].toString(),
              name: data[i]['name'].toString(),
            ),
          );
        }
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
    }
  }
}
