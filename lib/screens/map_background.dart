import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/data/default_information.dart';
import 'package:chotot/models/place.dart';
import 'package:chotot/screens/screen_04.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart' as permission;

class MapBackgroundScreen extends StatefulWidget {
  const MapBackgroundScreen({super.key});

  @override
  State<MapBackgroundScreen> createState() => _MapBackgroundScreenState();
}

class _MapBackgroundScreenState extends State<MapBackgroundScreen> {
  bool isEnableTracking = false;
  double latitude = 14.0583;
  double longitude = 106.6297;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  showAlertDialog(context) => AwesomeDialog(
      // autoDismiss: false,
      context: Get.context!,
      animType: AnimType.scale,
      dialogType: DialogType.info,
      body: Center(
        child: Text(
          'Cấp phép truy cập vị trí',
          style: TextStyle(
              color: Colors.black,
              fontFamily: GoogleFonts.poppins().fontFamily),
          textAlign: TextAlign.center,
        ),
      ),
      btnOk: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(39, 166, 82, 1),
        ),
        onPressed: () => permission.openAppSettings(),
        child: Text(
          'Cài đặt',
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      btnCancel: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(39, 166, 82, 1)),
        onPressed: () {
          Get.back();
        },
        child: Text(
          'Hủy bỏ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      btnOkOnPress: () => permission.openAppSettings(),
      btnCancelOnPress: () {
        Get.back();
      }).show();

  Future<void> _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();

      isEnableTracking = false;
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        showAlertDialog(Get.context!);

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
    isEnableTracking = true;
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

  showOptions() {
    return AwesomeDialog(
        // autoDismiss: false,
        dismissOnTouchOutside: false,
        dialogBackgroundColor: Colors.white,
        context: Get.context!,
        animType: AnimType.scale,
        dialogType: DialogType.info,
        body: Center(
          child: Text(
            'Vui lòng cho chúng tôi biết địa điểm của bạn để tối ưu các dịch vụ.',
            style: TextStyle(
                color: Colors.black,
                fontFamily: GoogleFonts.poppins().fontFamily),
            textAlign: TextAlign.center,
          ),
        ),
        btnOk: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(39, 166, 82, 1),
          ),
          onPressed: () {
            Get.offAll(
              const OnboardingScreenFour(isMap: true),
            );
          },
          child: Text(
            'Bản đồ',
            style: TextStyle(
              color: Colors.white,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        btnCancel: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(39, 166, 82, 1)),
          onPressed: () async {
            // await _storage.write(
            //     key: "ADDRESS_DEFAULT", value: currentAddress);
            // addressDefault = currentAddress;
            // _convertCoordinatefromAddress(addressDefault);
            // Get.offAll(const MainScreen());
            await _getCurrentLocation();
            if (isEnableTracking) {
              Get.offAll(
                OnboardingScreenFour(
                  isMap: false,
                  currentLocation: PlaceLocation(
                      latitude: latitude,
                      longitude: longitude,
                      address: currentAddress),
                ),
              );
            }
            // else {
            //   await AwesomeDialog(
            //     context: Get.context!,
            //     dialogType: DialogType.info,
            //     animType: AnimType.rightSlide,
            //     title: 'Vui lòng cho phép ứng dụng theo dõi',
            //     // barrierColor: const Color.fromRGBO(38, 166, 83, 1),
            //     autoHide: const Duration(milliseconds: 600),
            //     titleTextStyle: GoogleFonts.poppins(),
            //   ).show();
            //   Get.back();
            // }
          },
          child: Text(
            'Vị trí hiện tại',
            style: TextStyle(
              color: Colors.white,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        btnOkOnPress: () async {
          Get.offAll(OnboardingScreenFour(
            isMap: true,
            currentLocation: PlaceLocation(
                latitude: latitude,
                longitude: longitude,
                address: currentAddress),
          ));
        },
        btnCancelOnPress: () async {
          await _getCurrentLocation();
          if (isEnableTracking) {
            Get.offAll(OnboardingScreenFour(
              isMap: false,
              currentLocation: PlaceLocation(
                  latitude: latitude,
                  longitude: longitude,
                  address: currentAddress),
            ));
          }
          // else {
          //   await AwesomeDialog(
          //     context: Get.context!,
          //     dialogType: DialogType.info,
          //     animType: AnimType.rightSlide,
          //     title: 'Vui lòng cho phép ứng dụng theo dõi',
          //     // barrierColor: const Color.fromRGBO(38, 166, 83, 1),
          //     autoHide: const Duration(milliseconds: 600),
          //     titleTextStyle: GoogleFonts.poppins(),
          //   ).show();
          //   Get.back();
          // }
        }).show();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        showOptions();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 6.0,
        ),
      ),
    );
  }
}
