import 'dart:convert';

import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/data/a_stuff_data.dart';
import 'package:chotot/models/cho_do_cu.dart';
import 'package:http/http.dart' as http;
import 'package:chotot/utils/api_endpoints.dart';
import 'package:get/get.dart';

class GetAStuff extends GetxController {
  LoginController loginController = Get.put(LoginController());
  Future<void> getAStuff(String stuffId) async {
    final headers = {
      "x-access-token": loginController.tokenString,
    };
 

    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.getAStuff);

    Map body = {
      'stuff_id': stuffId,
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
        aStuff.clear();
        var photos = [];
        var tempPhoto = [];
        tempPhoto = json['data']['photos'].toList();

        if (tempPhoto[0].contains(']')) {
          photos = jsonDecode(tempPhoto[0].replaceAll(RegExp(r'^\[\]$'), ''));
        } else {
          photos = [...json['data']['photos']];
        }
        var stuff = DoCu(
          name: json['data']['name'],
          price: json['data']['sum_price'],
          description: json['data']['description'],
          id: json['data']['_id'],
          address: json['data']['address'],
          province: json['data']['province'],
          district: json['data']['district'],
          ward: json['data']['ward'],
          photos: photos,
          phone: json['data']['phone'],
          hostId: json['data']['host_id'],
          status: json['data']['status'],
          createdAt: json['data']['created_at'],
        );

        aStuff.add(stuff);
      }
    }
  }
}
