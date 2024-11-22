import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/data/version_app.dart';
import 'package:chotot/models/get_a_job_model.dart';

import 'package:chotot/models/job_item.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import 'package:chotot/utils/api_endpoints.dart';

class GetAJob extends GetxController {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // final _storage = const FlutterSecureStorage();
  bool isLoading = true;
  // bool isLastPage = false;
  List<GetAJobModel> jobInfo = [];
  LoginController loginController = Get.put(LoginController());
  Future<void> getAJob(String jobId) async {
    final headers = {
      'x-access-token': loginController.tokenString,
    };

    // try {
    var url = Uri.parse(
        ApiEndPoints.servicesUrl + ApiEndPoints.authEndPoints.getAJob);

    Map body = {
      'job_id': jobId,
      'token': 'anhkhongdoiqua',
      'version': version,
    };

    http.Response response = await http.post(
      url,
      body: body,
      headers: headers,
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (json['status'] == 'ok') {
        jobInfo.clear();
        List<JobItems> serviceList = [];
        var photos = [];
        var tempPhoto = [];
        var data = json['data'];

        tempPhoto = data['job']['photos'].toList();

        if (tempPhoto.isEmpty || data['job']['photos'][0] == '[]') {
          photos = [];
        } else if (tempPhoto[0].contains(']')) {
          photos = jsonDecode(tempPhoto[0].replaceAll(RegExp(r'^\[\]$'), ''));
        } else {
          photos = [...data['photos']];
        }
        List<Contracts> contracts = [];
        List<WorkerAJob> workers = [];
        List<Rate> rate = [];
        if (data['workers'] != null) {
          for (int i = 0; i < data['workers'].length; i++) {
            workers.add(
              WorkerAJob(
                id: data['workers'][i]['_id'].toString(),
                name: data['workers'][i]['name'].toString(),
                phone: data['workers'][i]['phone'].toString(),
                email: data['workers'][i]['email'].toString(),
                adress: data['workers'][i]['address'].toString(),
                lat: data['workers'][i]['lat'].toString(),
                lng: data['workers'][i]['lng'].toString(),
                profileImage: data['workers'][i]['profile_image'].toString(),
                ds: data['workers'][i]['DS'].toString(),
                wf: data['workers'][i]['WF'].toString(),
              ),
            );
          }
        }

        for (int i = 0; i < data['contracts'].length; i++) {
          contracts.add(
            Contracts(
              id: data['contracts'][i]['_id'].toString(),
              jobId: data['contracts'][i]['job_id'].toString(),
              contractId: data['contracts'][i]['contract_id'].toString(),
              jobName: data['contracts'][i]['job_name'].toString(),
              hostId: data['contracts'][i]['host_id'].toString(),
              hostName: data['contracts'][i]['host_name'].toString(),
              employeeId: data['contracts'][i]['employee_id'].toString(),
              employeeName: data['contracts'][i]['employee_name'].toString(),
              description: data['contracts'][i]['description'].toString(),
              createAt: data['contracts'][i]['created_at'].toString(),
              status: data['contracts'][i]['status'].toString(),
            ),
          );
        }
        for (int i = 0; i < data['job']['services'].length; i++) {
          serviceList.add(
            JobItems(
              img: '',
              id: data['job']['services'][i]['_id'].toString(),
              jobItemId: data['job']['services'][i]['jobitem_id'].toString(),
              version: data['job']['services'][i]['version'].toString(),
              v: data['job']['services'][i]['__v'].toString(),
              description: data['job']['services'][i]['description'].toString(),
              fee: data['job']['services'][i]['fee'].toString(),
              jobserviceId:
                  data['job']['services'][i]['jobservice_id'].toString(),
              name: data['job']['services'][i]['name'].toString(),
              price: data['job']['services'][i]['unit_price'].toString(),
              unit: data['job']['services'][i]['unit'].toString(),
              workerId: data['job']['services'][i]['worker_id'].toString(),
              qt: data['job']['services'][i]['qt'],
            ),
          );
        }

        for (int i = 0; i < json['data']['rate'].length; i++) {
          if (json['data']['rate'][i]['type'] == 'worker') {
            var data = json['data']['rate'][i];
            rate.add(
              Rate(
                id: data['_id'],
                contractId: data['contract_id'],
                type: data['type'],
                content: data['content'],
                d1: data['d1'],
                d2: data['d2'],
                d3: data['d3'],
                d4: data['d4'],
                d5: data['d5'],
                ds: data['ds'],
                hostId: data['host_id'],
                jobId: data['job_id'],
                time: data['time'],
                workerId: data['worker_id'],
              ),
            );
          }
        }
        jobInfo.add(
          GetAJobModel(
              workers: workers,
              rate: rate,
              employee: Employee(
                id: data['employee']['_id'].toString(),
                name: data['employee']['name'].toString(),
                phone: data['employee']['phone'].toString(),
                address: data['employee']['address'].toString(),
                lat: data['employee']['lat'].toString(),
                lng: data['employee']['lng'].toString(),
                profileImage: data['employee']['profile_image'].toString(),
              ),
              contract: data['contract'] == null
                  ? Contract(
                      id: '',
                      jobId: '',
                      jobName: '',
                      hostId: '',
                      hostName: '',
                      employeeId: '',
                      employeeName: '',
                      contractId: '')
                  : Contract(
                      id: data['contract']['_id'].toString(),
                      jobId: data['contract']['job_id'].toString(),
                      jobName: data['contract']['job_name'].toString(),
                      hostId: data['contract']['host_id'].toString(),
                      hostName: data['contract']['host_name'].toString(),
                      employeeId: data['contract']['employee_id'].toString(),
                      employeeName:
                          data['contract']['employee_name'].toString(),
                      contractId: data['contract']['contract_id'].toString(),
                    ),
              priceId: data['job']['price_id'].toString(),
              contracts: contracts,
              name: data['job']['name'].toString(),
              sumPrice: data['job']['sum_price'].toString(),
              movingFee: data['job']['moving_fee'].toString(),
              discount: data['job']['discount'].toString(),
              price: data['job']['price'].toString(),
              holidayPrice:
                  data['job']['prices']?['holiday']?['sum'].toString() ?? '0',
              description: data['job']['description'].toString(),
              id: data['job']['id'].toString(),
              address: data['job']['address'].toString(),
              province: data['job']['province'].toString(),
              district: data['job']['district'].toString(),
              ward: data['job']['ward'].toString(),
              photos: photos,
              phone: data['job']['phone'].toString(),
              hostId: data['job']['host_id'].toString(),
              workerId: data['job']['worker_id'].toString(),
              status: data['job']['status'].toString(),
              jobId: data['job']['job_id'].toString(),
              service: serviceList,
              workDate: data['job']['work_date'].toString(),
              host: Host(
                id: data['host']['_id'].toString(),
                name: data['host']['name'].toString(),
                phone: data['host']['phone'].toString(),
                email: data['host']['email'].toString(),
                address: data['host']['address'].toString(),
                lat: data['host']['lat'].toString(),
                lng: data['host']['lng'].toString(),
                profileImage: data['host']['profile_image'].toString(),
              )),
        );
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

      // final SharedPreferences? prefs = await _prefs;
      // await prefs?.setString('token', token);
    } else {
      throw jsonDecode(response.body)['message'] ?? 'Unknown Error Occured';
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
