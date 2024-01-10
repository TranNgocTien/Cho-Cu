import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/utils/api_endpoints.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ChangeAvatarController extends GetxController {
  LoginController loginController = Get.put(LoginController());

  File? imageFileUpdate;
  File? imageFileUpdateConvert;

  convertXFileToFile() {
    if (imageFileUpdate == null) {
      return;
    }
    File file = File(imageFileUpdate!.path);
    imageFileUpdateConvert = file;
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> updateAvatar() async {
    final SharedPreferences prefs = await _prefs;

    final hostId = prefs.getString('host_id');

    // try {
    convertXFileToFile();
    if (imageFileUpdateConvert == null) return;
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.changeAvatar);

    var request = http.MultipartRequest('POST', url);

    request.headers["Content-Type"] = "multipart/form-data";
    request.headers["x-access-token"] = 'anhkhongdoiqua';

    request.files.add(http.MultipartFile(
        'file',
        File(imageFileUpdateConvert!.path).readAsBytes().asStream(),
        File(imageFileUpdateConvert!.path).lengthSync(),
        filename: imageFileUpdateConvert!.path.split("/").last));

    Map<String, String> obj = {"user_id": hostId!};

    request.fields.addAll(obj);

    // request.headers.clear();
    // request.headers.addEntries(headers.entries);
    var res = await request.send();
    var response = await http.Response.fromStream(res);

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (json['status'] == 'ok') {
        imageFileUpdateConvert?.delete();
        imageFileUpdate?.delete();
      } else if (json['status'] == 'error') {
        showDialog(
            context: Get.context!,
            builder: (context) {
              return SimpleDialog(
                contentPadding: const EdgeInsets.all(20),
                children: [
                  Center(
                    child: Text(
                      json['error']['message'],
                    ),
                  ),
                ],
              );
            });
      }
      // final json = jsonDecode(res.body);
      // if (json['status'] == 'ok') {
      //   print(json);
      // } else if (json['status'] == "error") {
      //   showDialog(
      //       context: Get.context!,
      //       builder: (context) {
      //         return SimpleDialog(
      //           title: const Text('Error'),
      //           contentPadding: const EdgeInsets.all(20),
      //           children: [
      //             Text(
      //               json['error']['message'],
      //             ),
      //           ],
      //         );
      //       });
      //   throw jsonDecode(response.body)['error']['message'] ??
      //       'Unknown Error Occured';
      // }
    } else {
      throw jsonDecode(response.body)['message'] ?? 'Unknown Error Occured';
    }
    // throw jsonDecode(res.headers)['Message'] ?? 'Unknown Error Occured';
    // } catch (error) {
    //   showDialog(
    //       context: Get.context!,
    //       builder: (context) {
    //         return SimpleDialog(
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
    // }
  }
}
