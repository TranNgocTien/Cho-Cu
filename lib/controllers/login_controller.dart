import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:chotot/controllers/register_notification.dart';
import 'package:chotot/models/place.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:chotot/data/default_information.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:chotot/screens/homeScreen.dart';
import 'package:chotot/utils/api_endpoints.dart';
import 'package:chotot/screens/screen_04.dart';

class LoginController extends GetxController {
  // LyLichController lyLichController = Get.put(LyLichController());
  TextEditingController phoneNumberController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  // NotiController notiController = Get.put(NotiController());
  final _storage = const FlutterSecureStorage();
  double latitude = 16.0;
  double longitude = 106.0;
  String _savePassword = '';
  bool isLogin = false;
  var isLoading = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String tokenString = '';
  String hostId = '';
  Future<void> _readFromStorage() async {
    phoneNumberController.text = await _storage.read(key: "KEY_USERNAME") ?? '';
    passwordController.text = await _storage.read(key: "KEY_PASSWORD") ?? '';
    tokenString = await _storage.read(key: "TOKEN") ?? '';
  }

  Future<void> loginWithEmail() async {
    _savePassword = await _storage.read(key: 'Save_Password') ?? '';
    final SharedPreferences prefs = await _prefs;

    if (_savePassword == 'true'
        // && isLogin == true
        ) {
      await _readFromStorage();
    } else {
      await prefs.clear();
      // await prefs.setString('token', token.toString());
      tokenString = '';
      hostId = '';
      await _storage.delete(key: "KEY_USERNAME");
      await _storage.delete(key: "KEY_PASSWORD");
      await _storage.delete(key: "ADDRESS_DEFAULT");
      await _storage.delete(key: "NAME_DEFAULT");
      await _storage.delete(key: "NUMBER_DEFAULT");
      await _storage.delete(key: "TOKEN");
      if (isLogin == false) {
        return;
      }
    }
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName = "";
    // if (phoneNumberController.text == '' || passwordController.text == '') {
    //   showDialog(
    //       context: Get.context!,
    //       builder: (context) {
    //         return const SimpleDialog(
    //           title: Text(
    //             'Lỗi đăng nhập',
    //             textAlign: TextAlign.center,
    //           ),
    //           contentPadding: EdgeInsets.all(20),
    //           children: [
    //             Center(
    //               child: Text(
    //                 'Vui lòng điền đầy đủ thông tin đăng nhập',
    //               ),
    //             ),
    //           ],
    //         );
    //       });
    //   return;
    // }
    // Get device information
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = androidInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.name;
      }
    } on PlatformException {
      throw Exception('get device name failed');
    }
    var headers = {'Content-Type': 'application/json'};
    try {
      isLoading = true;
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.loginEmail);
      Map body = {
        'user_id': phoneNumberController.text.trim(),
        'password': passwordController.text,
        'device': deviceName,
        'token': 'anhkhongdoiqua',
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == 'ok') {
          if (currentHostID != json['data']['_id']) {
            addressDefault = '';
          }
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
          tokenString = json['data']['token'];
          hostId = json['data']['_id'];
          // isLogin = false;
          final SharedPreferences prefs = await _prefs;
          // RegisterNotiController().registerNoti();
          // lyLichController.getInfo();
          // notiController.getNoti(0);
          // await prefs.setString('token', token.toString());

          await prefs.setString('host_id', json['data']['_id']);
          await prefs.setString('token', json['data']['token']);
          await prefs.setString('host_name', json['data']['name']);
          await prefs.setString('address', json['data']['address']);
          await _storage.write(key: 'TOKEN', value: json['data']['token']);
          nameDefault = json['data']['name'];
          currentHostID = json['data']['_id'];
          numberPhoneDefault = json['data']['phone'];

          // addressDefault = json['data']['address'];
          isLoading = false;
          final addressFromPref =
              await _storage.read(key: "ADDRESS_DEFAULT") ?? '';
          final nameFromPref = await _storage.read(key: "NAME_DEFAULT") ?? '';
          final numberFromPref =
              await _storage.read(key: "NUMBER_DEFAULT") ?? '';

          if (nameFromPref != '' || numberFromPref != '') {
            nameDefault = nameFromPref;
            numberPhoneDefault = numberFromPref;
          }
          // print('=========================');
          // print(
          //   prefs.getString('token'),
          // );
          phoneNumberController.clear();
          passwordController.clear();
          await RegisterNotiController().registerNoti();
          if (addressFromPref == '') {
            AwesomeDialog(
                context: Get.context!,
                animType: AnimType.scale,
                dialogType: DialogType.info,
                body: Center(
                  child: Text(
                    'Vui lòng cho chúng tôi biết địa điểm của bạn để tối ưu các dịch vụ.',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily),
                    textAlign: TextAlign.center,
                  ),
                ),
                title: 'This is Ignored',
                desc: 'This is also Ignored',
                btnOk: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent),
                  onPressed: () {
                    Get.offAll(
                      const OnboardingScreenFour(),
                    );
                  },
                  child: Text(
                    'Chọn địa điểm',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                btnCancel: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(5, 109, 101, 1)),
                  onPressed: () async {
                    // await _storage.write(
                    //     key: "ADDRESS_DEFAULT", value: currentAddress);
                    // addressDefault = currentAddress;
                    // _convertCoordinatefromAddress(addressDefault);
                    // Get.offAll(const MainScreen());
                    await _getCurrentLocation();
                    Get.offAll(
                      OnboardingScreenFour(
                        currentLocation: PlaceLocation(
                            latitude: latitude,
                            longitude: longitude,
                            address: currentAddress),
                      ),
                    );
                  },
                  child: Text(
                    'Vị trí hiện tại',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                btnOkOnPress: () {
                  Get.offAll(OnboardingScreenFour(
                    currentLocation: PlaceLocation(
                        latitude: latitude,
                        longitude: longitude,
                        address: currentAddress),
                  ));
                },
                btnCancelOnPress: () async {
                  await _getCurrentLocation();
                  Get.offAll(OnboardingScreenFour(
                    currentLocation: PlaceLocation(
                        latitude: latitude,
                        longitude: longitude,
                        address: currentAddress),
                  ));
                }).show();
          } else {
            addressDefault = addressFromPref;
            _convertCoordinatefromAddress(addressDefault);
            Get.offAll(const MainScreen());
          }
        } else if (json['status'] == "error") {
          isLoading = false;
          showDialog(
              context: Get.context!,
              builder: (context) {
                return SimpleDialog(
                  title: const Text(
                    'Error',
                    textAlign: TextAlign.center,
                  ),
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
          throw jsonDecode(response.body)['error']['message'] ??
              'Unknown Error Occured';
        }
      } else {
        throw jsonDecode(response.body)['Message'] ?? 'Unknown Error Occured';
      }
    } catch (error) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: const Text(
                'Error',
                textAlign: TextAlign.center,
              ),
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
      return;
    }
  }

  Future<void> _convertCoordinateToAddress(double lat, double lng) async {
    final url = Uri.parse(
        'https://rsapi.goong.io/Geocode?latlng=$lat,$lng&api_key=WOXLNGkieaqVH3DPxcDpJoInSLk7QQajAHdzmyhB');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];
    currentAddress = address;

    final SharedPreferences prefs = await _prefs;

    await prefs.setString('currentAddress', address);
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return;
    }

    final SharedPreferences prefs = await _prefs;

    // await prefs.setString('token', token.toString());
    await _convertCoordinateToAddress(lat, lng);
    latitude = lat;
    longitude = lng;
    await prefs.setDouble('lat', lat);
    await prefs.setDouble('lng', lng);
  }

  Future<void> _convertCoordinatefromAddress(String address) async {
    final url = Uri.parse(
        'https://rsapi.goong.io/geocode?address=$address&api_key=WOXLNGkieaqVH3DPxcDpJoInSLk7QQajAHdzmyhB');
    final response = await http.get(url);
    final resData = json.decode(response.body);

    final latlng = resData['results'][0]['geometry'];
    final lat = latlng['location']['lat'];
    final lng = latlng['location']['lng'];

    final SharedPreferences prefs = await _prefs;
    await prefs.setDouble('lat', lat);
    await prefs.setDouble('lng', lng);
  }
}
