import 'dart:convert';
import 'package:chotot/data/docu_data.dart';
import 'package:chotot/models/cho_do_cu.dart';
// import 'dart:io';
import 'package:chotot/controllers/login_controller.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

// import 'package:shared_preferences/shared_preferences.dart';

import 'package:chotot/utils/api_endpoints.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class GetStuffs extends GetxController {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // final headers = {
  //   'Content-Type': 'application/json',
  // };
  bool isLoading = true;
  LoginController loginController = Get.put(LoginController());
  Future<void> getStuffs(int index) async {
    // final SharedPreferences prefs = await _prefs;

    // String token = prefs.getString('token')!;
    var itemsStuffId = itemsOwner.map((item) => item.id);
    try {
      var url = Uri.parse(
          ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.getStuffs);
      Map body = {
        'version': 'test',
        'index': '$index',
        'token': 'anhkhongdoiqua',
      };
      http.Response response = await http.post(
        url,
        body: body,
        headers: {
          "x-access-token": loginController.tokenString.toString(),
        },
      );
      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (json['status'] == 'ok') {
          var data = json['data'];
          var photos = [];
          var tempPhoto = [];

          for (int i = 0; i < data.length; i++) {
            tempPhoto = data[i]['photos'].toList();

            // print(photos);
            if (tempPhoto[0].contains(']')) {
              photos =
                  jsonDecode(tempPhoto[0].replaceAll(RegExp(r'^\[\]$'), ''));
            } else {
              photos = [...data[i]['photos']];
            }
            if (loginController.hostId == data[i]['host_id'] &&
                itemsStuffId.contains(data[i]['stuff_id']) == false) {
              itemsOwner.add(
                DoCu(
                  name: data[i]['name'].toString(),
                  price: data[i]["sum_price"].toString(),
                  description: data[i]["description"].toString(),
                  id: data[i]['stuff_id'].toString(),
                  address: data[i]['address'].toString(),
                  province: data[i]['province'].toString(),
                  district: data[i]['district'].toString(),
                  ward: data[i]['ward'].toString(),
                  phone: data[i]['phone'].toString(),
                  photos: photos,
                  hostId: data[i]['host_id'],
                  status: data[i]['status'],
                ),
              );
            }
            items.add(
              DoCu(
                name: data[i]['name'].toString(),
                price: data[i]["sum_price"].toString(),
                description: data[i]["description"].toString(),
                id: data[i]['stuff_id'].toString(),
                address: data[i]['address'].toString(),
                province: data[i]['province'].toString(),
                district: data[i]['district'].toString(),
                ward: data[i]['ward'].toString(),
                phone: data[i]['phone'].toString(),
                photos: photos,
                hostId: data[i]['host_id'],
                status: data[i]['status'],
              ),
            );
          }
        } else if (json['status'] == 'error') {
          if (json['error']['message'] == 'Không có hàng') {}
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
        // final SharedPreferences? prefs = await _prefs;
        // await prefs?.setString('token', token);
      } else {
        throw jsonDecode(response.body)['message'] ?? 'Unknown Error Occured';
      }
    } catch (error) {
      error.printError();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Error'),
              contentPadding: const EdgeInsets.all(20),
              children: [
                Text(
                  error.toString(),
                ),
              ],
            );
          });
    } finally {
      isLoading = false;
    }
  }
}
