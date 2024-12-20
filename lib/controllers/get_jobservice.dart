import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/data/job_service_data.dart';
// import 'package:chotot/data/version_app.dart';
import 'package:chotot/models/job_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
// import 'package:chotot/utils/api_endpoints.dart';
import 'package:get/get.dart';

class GetJobService extends GetxController {
  Future<void> getJobService() async {
    var url = Uri.parse('https://vstserver.com/services/get_jobservice');
    Map body = {
      // 'version': version,
      'token': 'anhkhongdoiqua',
    };

    http.Response response = await http.post(url, body: body);

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (json['status'] == 'ok') {
        final data = json['data'];
        nameService.clear();
        imgService.clear();
        jobServiceList.clear();
        for (int i = 0; i < data.length; i++) {
          jobServiceList.add(
            JobService(
              id: data[i]['_id'].toString(),
              code: data[i]['code'],
              version: data[i]['version'],
              v: data[i]['__v'].toString(),
              fee: data[i]['fee'].toString(),
              img: data[i]['img'],
              name: data[i]['name'],
              shortName: data[i]['short_name'],
              type: data[i]['type'],
            ),
          );
          nameService.add(data[i]['name']);
          imgService.add(data[i]['img']);
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
    // else {
    //   throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured';
    // }
  }
}
