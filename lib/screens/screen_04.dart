import 'dart:async';
// import 'dart:ui' as ui;
// import 'package:chotot/data/default_information.dart';
import 'package:chotot/data/default_information.dart';
import 'package:chotot/models/addressUpdate.dart';
import 'package:chotot/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:chotot/models/place.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreenFour extends StatefulWidget {
  const OnboardingScreenFour({
    super.key,
    this.location = const PlaceLocation(
        latitude: 10.762622, longitude: 106.660172, address: ''),
    this.currentLocation = const PlaceLocation(
        latitude: 10.762622, longitude: 106.660172, address: ''),
    this.isSelecting = true,
    required this.isMap,
  });
  final isMap;
  final PlaceLocation currentLocation;
  final PlaceLocation location;
  final bool isSelecting;
  @override
  State<OnboardingScreenFour> createState() {
    return _OnboardingScreenFourState();
  }
}

class _OnboardingScreenFourState extends State<OnboardingScreenFour> {
  TextEditingController addressMap =
      TextEditingController(text: currentAddress);
  final Completer<GoogleMapController> _controller = Completer();
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // late Uint8List markerIcon;
  final _storage = const FlutterSecureStorage();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _savePassword = true;
  LatLng? _pickedLocation;
  final List<Marker> _markers = [];
  double? cameraPositionLat;
  double? cameraPositionLng;
  // Future<Uint8List> getBytesFromAsset(String path, int width) async {
  //   ByteData data = await rootBundle.load(path);
  //   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
  //       targetWidth: width);
  //   ui.FrameInfo fi = await codec.getNextFrame();
  //   return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
  //       .buffer
  //       .asUint8List();
  // }

  // void getMarkerIcon() async {
  //   markerIcon =
  //       await getBytesFromAsset('image/icon/thong_tin_review_1.png', 100);
  // }

  @override
  void initState() {
    // getMarkerIcon();

    _markers.add(
      Marker(
          markerId: const MarkerId('Current position'),
          position: LatLng(
            widget.currentLocation.latitude,
            widget.currentLocation.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(240)),
    );

    super.initState();
  }

  @override
  void dispose() {
    addressMap.dispose();

    super.dispose();
  }

  _onFormSubmit() async {
    if (_savePassword) {
      // Write values

      setState(() {
        addressDefault = addressMap.text;
      });
      await _storage.write(key: "ADDRESS_DEFAULT", value: addressMap.text);
      if (widget.isMap) {
        final SharedPreferences prefs = await _prefs;
        await prefs.setDouble('lat', _pickedLocation!.latitude);
        await prefs.setDouble('lng', _pickedLocation!.longitude);
      }
    } else {
      addressDefault = addressMap.text;
      await _storage.write(key: "ADDRESS_DEFAULT", value: '');
    }
  }

  void moveToCurrentLocation() async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(
          widget.currentLocation.latitude, widget.currentLocation.longitude),
      zoom: 18,
    )));
    setState(() {
      _pickedLocation = LatLng(
        widget.currentLocation.latitude,
        widget.currentLocation.longitude,
      );
    });
  }

  Future<void> _convertCoordinatefromAddress(double lat, double lng) async {
    final url = Uri.parse(
        'https://rsapi.goong.io/Geocode?latlng=$lat,$lng&api_key=WOXLNGkieaqVH3DPxcDpJoInSLk7QQajAHdzmyhB');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];
    setState(() {
      addressMap.text = address;
      if (widget.isMap) {
        _pickedLocation = LatLng(lat, lng);
      }
    });
  }

  Future<void> _convertAddressToCoordinate(string) async {
    List<Location> location = await locationFromAddress(string);

    final lat = location.last.latitude;

    final lng = location.last.longitude;

    if (lat == null || lng == null) {
      return;
    }

    cameraPositionLat = lat;
    cameraPositionLng = lng;

    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(cameraPositionLat!, cameraPositionLng!),
      zoom: 18,
    )));

    _markers.add(
      Marker(
        markerId: const MarkerId('m1'),
        position: LatLng(
          cameraPositionLat!,
          cameraPositionLng!,
        ),
      ),
    );
    setState(() {
      _pickedLocation = LatLng(lat, lng);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'Thiết lập vị trí mặc định',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
            textAlign: TextAlign.end,
          ),
          // actions: [
          //   if (widget.isSelecting)
          //     IconButton(
          //       onPressed: () {
          //         Navigator.of(context).pop(_pickedLocation);
          //       },
          //       icon: const Icon(Icons.save),
          //     ),
          // ],
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: GoogleMap(
                  onTap: (position) {
                    setState(() {
                      _pickedLocation = position;

                      _markers.add(
                        Marker(
                            markerId: const MarkerId('m1'),
                            position: _pickedLocation!),
                      );
                      _convertCoordinatefromAddress(_pickedLocation!.latitude,
                          _pickedLocation!.longitude);
                    });
                  },
                  zoomControlsEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  myLocationButtonEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.currentLocation.latitude,
                        widget.currentLocation.longitude),
                    zoom: 18,
                  ),
                  markers: Set.of(_markers),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: 25,
              child: Card(
                elevation: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.grey),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TypeAheadField<AddressUpdate?>(
                            hideOnError: true,
                            debounceDuration: const Duration(milliseconds: 500),
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: addressMap,
                              decoration: const InputDecoration(
                                focusColor: Colors.white,
                                border: InputBorder.none,
                                hintText: 'Tìm kiếm',
                              ),
                            ),
                            suggestionsCallback:
                                AddressUpdateApi.getAddressSuggestions,
                            itemBuilder: (context, AddressUpdate? suggestion) {
                              final address = suggestion!;
                              return ListTile(
                                title: Text(address.description),
                              );
                            },
                            noItemsFoundBuilder: (context) => SizedBox(
                              height: 100,
                              child: Center(
                                child: Text(
                                  'Không tìm thấy địa chỉ.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontSize: 18,
                                      ),
                                ),
                              ),
                            ),
                            onSuggestionSelected:
                                (AddressUpdate? suggestion) async {
                              final address = suggestion!;
                              addressMap.text = address.description;
                              await _convertAddressToCoordinate(
                                  address.description);

                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: CheckboxListTile(
                          value: _savePassword,
                          onChanged: (bool? newValue) {
                            setState(() {
                              _savePassword = newValue!;
                            });
                          },
                          title: Text(
                            "Ghi nhớ địa chỉ",
                            style: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                          ),
                          activeColor: const Color.fromRGBO(39, 166, 82, 1),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await _onFormSubmit();
                          Get.offAll(() => const MainScreen());
                        },
                        icon: const FaIcon(FontAwesomeIcons.locationPin,
                            color: Colors.redAccent),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(38, 166, 83, 1),
                        ),
                        label: Text(
                          'Lưu vị trí',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
