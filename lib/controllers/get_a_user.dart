import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/data/version_app.dart';
import 'package:chotot/models/get_a_user_model.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

import 'package:chotot/controllers/login_controller.dart';

class GetAUserController extends GetxController {
  LoginController loginController = Get.put(LoginController());
  late User user;
  late WorkerAUser worker;
  bool isLoading = false;
  List<AUser> aUser = [];
  Future<void> getAUser() async {
    // Get device information
    print(loginController.tokenString);
    // try {
    var headers = {
      'Content-Type': 'application/json',
      "x-access-token": loginController.tokenString,
    };
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.getAUser);
    Map body = {
      'token': 'anhkhongdoiqua',
      'version': version,
    };
    http.Response response =
        await http.post(url, body: jsonEncode(body), headers: headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print(json);
      if (json['status'] == 'ok') {
        aUser.clear();
        final userJson = json['data']['user'];
        final workerJson = json['data']['worker'];
        List<Certificate> certificate = [];

        if (userJson['worker_authen'] != 'false') {
          for (int i = 0; i < workerJson['certificate'].length; i++) {
            certificate.add(
              Certificate(
                img: workerJson['certificate'][i]['img'],
              ),
            );
          }
        }

        // for (int i = 0; i < workerJson['certificates'].length; i++) {
        //   certificates.add(
        //     Certificates(
        //       img: workerJson['certificates'][i]['img'],
        //     ),
        //   );
        // }
        aUser.add(AUser(
          user: User(
            id: userJson['_id'],
            name: userJson['name'],
            phone: userJson['phone'],
            ccid: userJson['ccid'],
            email: userJson['email'],
            emailAuthen: userJson['email_authen'],
            address: userJson['address'],
            lat: userJson['lat'],
            lng: userJson['lng'],
            wf: userJson['WF'].toString(),
            profileImage: userJson['profile_image'],
            type: userJson['type'],
            joinDate: userJson['join_date'],
            phoneAuthen: userJson['phone_authen'],
            workerAuthen: userJson['worker_authen'],
            documentStatus: userJson['document_status'],
            salt: userJson['salt'],
            checksum: userJson['checksum'],
            createdAt: userJson['created_at'],
            password: userJson['password'],
            wallet: userJson['wallet'].toString(),
          ),
          worker: userJson['worker_authen'] == 'true'
              ? WorkerAUser(
                  id: workerJson['_id'],
                  userId: workerJson['user_id'],
                  ds: workerJson['DS'],
                  wf: workerJson['WF'],
                  address: workerJson['address'],
                  agent: workerJson['agent'],
                  ccid: workerJson['ccid'],
                  ccidImg: CcidImg(
                    truoc: workerJson['ccid_img']['truoc'],
                    sau: workerJson['ccid_img']['sau'],
                  ),
                  certificate: certificate,
                  // certificates: certificates,
                  cost: workerJson['cost'].toString(),
                  description: workerJson['description'],
                  experience: workerJson['experience'],
                  name: workerJson['name'],
                  workerLevel: workerJson['worker_level'].toString(),
                  workerType: workerJson['worker_type'],
                )
              : WorkerAUser(
                  id: 'id',
                  userId: 'userId',
                  ds: 'ds',
                  wf: 'wf',
                  address: 'address',
                  agent: 'agent',
                  ccid: 'ccid',
                  ccidImg: CcidImg(truoc: 'truoc', sau: 'sau'),
                  certificate: certificate,
                  cost: 'cost',
                  description: 'description',
                  experience: 'experience',
                  name: 'name',
                  workerLevel: 'workerLevel',
                  workerType: [],
                ),
        ));
        print(aUser);
      } else if (json['status'] == "error") {
        AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.warning,
          animType: AnimType.rightSlide,
          title: json['error']['message'],
          titleTextStyle: GoogleFonts.poppins(),
          autoHide: const Duration(milliseconds: 800),
        ).show();

        throw jsonDecode(response.body)['error']['message'] ??
            'Unknown Error Occured';
      }
    }
    // else {
    //   throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured';
    // }
    // } catch (error) {
    //   Get.back();
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
    // }
  }
}
