import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/controllers/login_controller.dart';

import 'package:get/get.dart';
import 'package:chotot/data/login_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';
import 'package:chotot/data/reg_profile_data.dart';
import 'package:chotot/models/reg_profile.dart';

class GetReg extends GetxController {
  LoginController loginController = Get.put(LoginController());

  Future<void> getReg() async {
    final headers = {
      'x-access-token': loginController.tokenString,
    };

    var url =
        Uri.parse(ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.getReg);
    Map body = {
      "reg_id": loginData[0].regProfile,
      "token": "anhkhongdoiqua",
    };

    http.Response response = await http.post(
      url,
      body: body,
      headers: headers,
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final data = json['data'];
      if (json['status'] == 'ok') {
        regProfile.clear();

        final List<CcidImage> ccidList = [];
        final List<Cert> certList = [];
        for (var i = 0; i < data['ccid_img'].length; i++) {
          ccidList.add(
            CcidImage(
              name: data['ccid_img'][i]['name'],
              img: data['ccid_img'][i]['img'],
            ),
          );
        }

        for (var i = 0; i < data['certificates'].length; i++) {
          certList.add(
            Cert(
              name: data['certificates'][i]['name'],
              img: data['certificates'][i]['img'],
            ),
          );
        }

        regProfile.add(
          RegProfile(
            avatar: data['avatar'].toString(),
            id: data['_id'].toString(),
            userId: data['user_id'].toString(),
            address: data['address'].toString(),
            ccid: data['ccid'].toString(),
            ccidList: ccidList,
            description: data['description'].toString(),
            experience: data['experience'].toString(),
            lat: data['lat'].toString(),
            lng: data['lng'].toString(),
            name: data['name'].toString(),
            regId: data['reg_id'].toString(),
            status: data['status'].toString(),
            time: data['time'].toString(),
            type: data['type'].toString(),
            certList: certList,
            workerType: data['worker_type'].toString(),
          ),
        );
      } else if (json['status'] == 'error') {
        regProfile = [];
        await AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.warning,
          animType: AnimType.rightSlide,
          title: json['error']['message'],
          titleTextStyle: GoogleFonts.poppins(),
          autoHide: const Duration(milliseconds: 800),
        ).show();
      }
    } else {
      throw jsonDecode(response.body)['message'] ?? 'Unknown Error Occured';
    }
  }
}
