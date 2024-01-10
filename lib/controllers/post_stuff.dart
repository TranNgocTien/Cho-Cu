import 'dart:convert';
import 'dart:io';
import 'package:chotot/controllers/get_stuffs.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:chotot/data/default_information.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:chotot/models/get_otherfee.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:chotot/data/get_otherFee_data.dart';

import 'package:chotot/utils/api_endpoints.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PostStuff extends GetxController {
  final GetStuffs _getStuffs = Get.put(GetStuffs());

  TextEditingController addressController =
      TextEditingController(text: addressDefault);
  LoginController loginController = Get.put(LoginController());
  TextEditingController descriptionController = TextEditingController();
  TextEditingController sumPriceController = TextEditingController();
  TextEditingController phoneController =
      TextEditingController(text: numberPhoneDefault);
  TextEditingController nameController =
      TextEditingController(text: nameDefault);

  double? lat;
  double? lng;

  List<XFile>? imageFileList = [];
  List<File> imageConvertedFile = [];
  List imageLink = [];
  String codeOtherFee = '';
  String? province;
  convertXFileToFile() {
    for (int i = 0; i < imageFileList!.length; i++) {
      File file = File(imageFileList![i].path);
      imageConvertedFile.add(file);
    }
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> postItem() async {
    List<String> adressList = addressController.text.split(',');

    if (adressList.length < 4) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              contentPadding: EdgeInsets.all(20),
              children: [
                Text(
                    'Kiểm tra lại thông tin địa chỉ (gồm tên số nhà, tên đường, phường/xã, thành phố, tỉnh thành).'),
              ],
            );
          });
      return;
    }
    String district = adressList[2];
    String ward = adressList[1];
    String province = adressList[3];
    final SharedPreferences prefs = await _prefs;
    // Get device information

    final hostId = prefs.getString('host_id');
    final hostName = prefs.getString('host_name');
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    try {
      var url = Uri.parse(
          ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.postStuffs);
      Map body = {
        'version': 'test',
        "description": descriptionController.text,
        "sum_price": sumPriceController.text,
        "host_fee_code": codeOtherFee,
        "phone": phoneController.text,
        "host_id": hostId,
        "host_name": hostName,
        "address": addressController.text,
        "lat": lat.toString(),
        "lng": lng.toString(),
        "name": ' ${nameController.text} - $formattedDate',
        "photos": json.encode(imageLink),
        "province": province,
        "district": district,
        "ward": ward,
        "token": "anhkhongdoiqua"
      };
      http.Response response = await http.post(
        url,
        body: body,
        headers: {
          "x-access-token": loginController.tokenString.toString(),
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        // print(json);
        if (json['status'] == 'ok') {
          await _getStuffs.getStuffs(0);
          descriptionController.clear();
          sumPriceController.clear();

          imageLink.clear();
          Get.back();
        } else if (json['status'] == "error") {
          imageLink.clear();
          showDialog(
              context: Get.context!,
              builder: (context) {
                return SimpleDialog(
                  title: const Text('Error'),
                  contentPadding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      json['error']['message'],
                    ),
                  ],
                );
              });
        }
      } else {
        throw jsonDecode(response.body)['message'] ?? 'Unknown Error Occured';
      }
    } catch (error) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              contentPadding: const EdgeInsets.all(20),
              children: [
                Text(
                  error.toString(),
                ),
              ],
            );
          });
    }
  }

  Future<void> uploadJobPhoto() async {
    final SharedPreferences prefs = await _prefs;
    // Get device information
    // if (imageFileList!.length > 3 ||
    //     imageFileList!.isEmpty ||
    //     imageFileList == null) {
    //   showDialog(
    //       context: Get.context!,
    //       builder: (context) {
    //         return const SimpleDialog(
    //           contentPadding: EdgeInsets.all(20),
    //           children: [
    //             Text(
    //               'Hình ảnh đã chọn nhiều hơn 3 hoặc chưa chọn ảnh. Xin chọn lại!',
    //             ),
    //           ],
    //         );
    //       });

    //   return;
    // }
    final hostId = prefs.getString('host_id');

    try {
      convertXFileToFile();
      var url = Uri.parse(
          ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.uploadJobPhoto);

      var request = http.MultipartRequest('POST', url);

      request.headers["Content-Type"] = "multipart/form-data";
      request.headers["x-access-token"] = 'anhkhongdoiqua';
      // request.fields['user_id'] = hostId.toString();

      for (File file in imageConvertedFile) {
        // request.files.add(http.MultipartFile.fromBytes(
        //     'file', File(file.path).readAsBytesSync(),
        //     filename: file.path));
        request.files.add(http.MultipartFile(
            'file',
            File(file.path).readAsBytes().asStream(),
            File(file.path).lengthSync(),
            filename: file.path.split("/").last));
      }
      Map<String, String> obj = {"user_id": hostId!};

      request.fields.addAll(obj);

      // request.headers.clear();
      // request.headers.addEntries(headers.entries);
      var res = await request.send();
      var response = await http.Response.fromStream(res);

      // if (imageFileList!.isEmpty) {
      //   showDialog(
      //     context: Get.context!,
      //     builder: (context) {
      //       return const SimpleDialog(
      //         contentPadding: EdgeInsets.all(20),
      //         children: [
      //           Text('Take at least 1 picture'),
      //         ],
      //       );
      //     },
      //   );
      //   return;
      // }
      final json = jsonDecode(response.body);
      // print(json);
      if (response.statusCode == 200) {
        var data = json['data'];
        if (json['status'] == 'ok') {
          imageLink = data["photos"];
          imageConvertedFile.clear();
          imageFileList!.clear();
        } else if (json['status'] == 'error') {
          imageConvertedFile.clear();
          imageFileList!.clear();
          showDialog(
              context: Get.context!,
              builder: (context) {
                return SimpleDialog(
                  contentPadding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      json['error']['message'],
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
    } catch (error) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              contentPadding: const EdgeInsets.all(20),
              children: [
                Text(
                  error.toString(),
                ),
              ],
            );
          });
    }
  }

  Future<void> getOtherfee() async {
    // final SharedPreferences prefs = await _prefs;
    // Get device information

    try {
      var url = Uri.parse('https://vstserver.com/services/get_otherfee');
      Map body = {
        'token': 'anhkhongdoiqua',
      };
      // var headers = {'token': 'anhkhongdoiqua'};
      http.Response response = await http.post(
        url,
        // body: jsonEncode(body),
        body: body,
        // headers: headers,
      );
      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (json['status'] == 'ok') {
          // print(json);
          otherFee.clear();
          var data = json['data'];

          for (int i = 0; i < data.length; i++) {
            otherFee.add(
              OtherFee(
                name: data[i]['name'].toString(),
                price: data[i]["value"].toString(),
                idService: data[i]["id"].toString(),
                id: data[i]['_id'].toString(),
                workerId: data[i]['worker_id'].toString(),
                v: data[i]['__v'].toString(),
              ),
            );
          }
        } else if (json['status'] == "error") {
          showDialog(
              context: Get.context!,
              builder: (context) {
                return SimpleDialog(
                  title: const Text('Error'),
                  contentPadding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      json['error']['message'],
                    ),
                  ],
                );
              });
        }
      } else {
        throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured';
      }
    } catch (error) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              contentPadding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Text(
                    error.toString(),
                  ),
                ),
              ],
            );
          });
    }
  }
}
