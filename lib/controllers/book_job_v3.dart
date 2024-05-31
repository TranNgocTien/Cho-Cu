import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/controllers/get_price_v2.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:chotot/data/default_information.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

// import 'package:shared_preferences/shared_preferences.dart';

import 'package:chotot/utils/api_endpoints.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

class BookJob extends GetxController {
  final _storage = const FlutterSecureStorage();
  TextEditingController addressController =
      TextEditingController(text: addressDefault);
  LoginController loginController = Get.put(LoginController());
  TextEditingController descriptionController = TextEditingController();
  GetPrice getPrice = Get.put(GetPrice());
  TextEditingController phoneController =
      TextEditingController(text: numberPhoneDefault);
  TextEditingController nameController =
      TextEditingController(text: nameDefault);
  String tokenString = '';
  double? lat;
  double? lng;

  List<XFile>? imageFileList = [];
  List<File> imageConvertedFile = [];
  List imageLink = [];

  String? province;
  convertXFileToFile() {
    for (int i = 0; i < imageFileList!.length; i++) {
      File file = File(imageFileList![i].path);
      imageConvertedFile.add(file);
    }
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> bookJob(
      String name, String workDate, String workHour, String priceId) async {
    List<String> adressList = addressController.text.split(',');
    tokenString = await _storage.read(key: "TOKEN") ?? '';
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
    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    try {
      var url = Uri.parse(
          ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.bookJobV3);

      Map body = {
        'name': name.toString(),
        'price_id': priceId.toString(),
        'host_id': hostId,
        'host_name': hostName,
        'address': addressController.text,
        'province': province,
        'district': district,
        'ward': ward,
        'phone': phoneController.text,
        'lat': lat.toString(),
        'lng': lng.toString(),
        'work_date': workDate.toString(),
        'work_hour': workHour.toString(),
        'description': descriptionController.text,
        'photos': json.encode(imageLink),
        'version': 'test',
        "token": "anhkhongdoiqua",
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

        if (json['status'] == 'ok') {
          descriptionController.clear();

          imageLink.clear();
          await AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            title: 'Đặt việc thành công',
            titleTextStyle: GoogleFonts.poppins(),
            autoHide: const Duration(milliseconds: 600),
          ).show();
          getPrice.code = '';
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

    // try {
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
        // showDialog(
        //     context: Get.context!,
        //     builder: (context) {
        //       return SimpleDialog(
        //         contentPadding: const EdgeInsets.all(20),
        //         children: [
        //           Text(
        //             json['error']['message'],
        //           ),
        //         ],
        //       );
        //     });
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
    //             Text(
    //               error.toString(),
    //             ),
    //           ],
    //         );
    //       });
    // }
  }
}
