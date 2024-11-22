import 'dart:convert';

// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/data/get_orders_user_data.dart';
import 'package:chotot/models/get_orders_user_model.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

class GetOrdersUser extends GetxController {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // final _storage = const FlutterSecureStorage();
  // bool isLoading = true;
  bool isLastPage = false;
  bool isLoading = false;
  LoginController loginController = Get.put(LoginController());

  Future<void> getOrdersUser(int index) async {
    final headers = {
      'x-access-token': loginController.tokenString,
    };

    // try {
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.getOrdersUser);
    Map body = {
      'index': index.toString(),
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
        final data = json['data'];

        for (var i = 0; i < data.length; i++) {
          ordersUser.add(
            GetOrdersUserModel(
              id: data[i]['_id'].toString(),
              orderId: data[i]['order_id'].toString(),
              amountOrder: data[i]['amount_order'].toString(),
              amountPaid: data[i]['amount_paid'].toString(),
              bankCode: data[i]['bank_code'].toString(),
              bankTransNo: data[i]['bank_trans_no'].toString(),
              cardType: data[i]['card_type'].toString(),
              createAt: data[i]['created_at'].toString(),
              createDate: data[i]['create_date'].toString(),
              currCode: data[i]['curr_code'].toString(),
              hashCheck: data[i]['hash_check'].toString(),
              orderInfo: data[i]['order_info'].toString(),
              orderType: data[i]['order_type'].toString(),
              payDate: data[i]['pay_date'].toString(),
              responseCode: data[i]['response_code'].toString(),
              status: data[i]['status'].toString(),
              supplier: data[i]['supplier'].toString(),
              transactionNo: data[i]['transaction_no'].toString(),
              transactionStatus: data[i]['transaction_status'].toString(),
              updatedAt: data[i]['updated_at'].toString(),
              userId: data[i]['user_id'].toString(),
              userIp: data[i]['user_ip'].toString(),
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
      } else {
        isLastPage = true;
      }

      // final SharedPreferences? prefs = await _prefs;
      // await prefs?.setString('token', token);
    }
    // } catch (error) {
    //   error.printError();
    //   showDialog(
    //       context: Get.context!,
    //       builder: (context) {
    //         return SimpleDialog(
    //           title: const Text(
    //             'Error',
    //             textAlign: TextAlign.center,
    //           ),
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
    // } finally {
    //   isLoading = false;
    // }
  }
}
