import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/data/version_app.dart';
import 'package:chotot/models/get_price_model.dart';
import 'package:chotot/screens/confirm_book_worker.dart';
import 'package:chotot/utils/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GetPrice extends GetxController {
  final _storage = const FlutterSecureStorage();
  String tokenString = '';
  String hostId = '';
  bool isSuccess = false;
  bool isNext = false;
  dynamic code = '';
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//  late Services services;
  Price dataPrice = Price();
  Future<void> getPrice(
    String priceId,
    String miliseconds,
    List jobItem,
    Function bookJobV3,
  ) async {
    final SharedPreferences prefs = await _prefs;
    tokenString = await _storage.read(key: "TOKEN") ?? '';
    hostId = prefs.getString('host_id')!;

    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.getPriceV2);
    var headers = {
      'Content-Type': 'application/json',
      'x-access-token': tokenString,
    };
    // Map<String, dynamic> toJson() => {
    //       'name': name,
    //       'price': price,
    //     };

    Map body = {
      'id': priceId,
      'host_id': hostId,
      'work_date': miliseconds,
      'services': jobItem,
      'voucher': code,
      'token': 'anhkhongdoiqua',
      'version': version,
    };

    http.Response response =
        await http.post(url, body: jsonEncode(body), headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json['status'] == 'ok') {
        final data = json['data'];

        // for (int i = 0; i < data['services'].length; i++) {
        //   services = Services(
        //       id: data['services'][i]['_id'].toString(),
        //       jobitemId: data['services'][i]['jobitem_id'].toString(),
        //       description: data['services'][i]['description'].toString(),
        //       fee: data['services'][i]['fee'].toString(),
        //       jobserviceId: data['services'][i]['jobservice_id'].toString(),
        //       name: data['services'][i]['name'].toString(),
        //       price: data['services'][i]['price'].toString(),
        //       unit: data['services'][i]['unit'].toString());
        // }
        dataPrice = Price(
          id: data['_id'],
          priceId: data['id'],
          createAt: data['created_at'],
          discount: data['discount'].toString(),
          distance: data['distance'].toString(),
          holiday: Holiday(
              name: data['holiday']['name'].toString(),
              value: data['holiday']['value'].toString(),
              sum: data['holiday']['sum'].toString()),
          hostId: data['host_id'],
          movingFee: data['moving_fee'].toString(),
          price: data['price'].toString(),
          sumPrice: data['sum_price'].toString(),
          workDate: data['work_date'].toString(),
          // services: services
        );
        isSuccess = true;
        if (isNext == true) {
          Get.to(ConfirmBookWorkerScreen(
            dataPrice: dataPrice,
            bookJob: bookJobV3,
            miliseconds: miliseconds,
            jobItemConfirm: jobItem,
          ));
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
