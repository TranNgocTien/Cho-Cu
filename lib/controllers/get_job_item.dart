import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/data/get_job_item_data.dart';
import 'package:chotot/data/version_app.dart';
import 'package:chotot/models/job_item.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

class GetJobItem extends GetxController {
  Future<void> getJobItem(String jobServiceId) async {
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.getJobItem);
    Map body = {
      'jobservice_id': jobServiceId,
      'token': 'anhkhongdoiqua',
      // 'version': version,
    };
    http.Response response = await http.post(
      url,
      body: body,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      // print(json);
      if (json['status'] == 'ok') {
        jobItemList.clear();
        final data = json['data'];

        for (int i = 0; i < data.length; i++) {
          jobItemList.add(
            JobItems(
              img: data[i]['img'].toString(),
              id: data[i]['_id'].toString(),
              jobItemId: data[i]['jobitem_id'].toString(),
              description: data[i]['description'].toString(),
              fee: data[i]['fee'].toString(),
              jobserviceId: data[i]['jobservice_id'].toString(),
              name: data[i]['name'].toString(),
              price: data[i]['price'].toString(),
              unit: data[i]['unit'].toString(),
              workerId: data[i]['worker_id'].toString(),
              qt: 1,
              v: data[i]['__v'].toString(),
              version: data[i]['version'].toString(),
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
