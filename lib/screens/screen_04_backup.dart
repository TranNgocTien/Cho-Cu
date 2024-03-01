import 'package:chotot/models/addressUpdate.dart';
import 'package:chotot/models/place.dart';
import 'package:chotot/screens/homeScreen.dart';
import 'package:chotot/screens/mapScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_fonts/google_fonts.dart';
// import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chotot/data/default_information.dart';

class OnboardingScreenFour extends StatefulWidget {
  const OnboardingScreenFour({super.key});

  @override
  State<OnboardingScreenFour> createState() => _OnboardingScreenFourState();
}

class _OnboardingScreenFourState extends State<OnboardingScreenFour> {
  TextEditingController nameDefaultController = TextEditingController(text: '');

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController addressDefaultController =
      TextEditingController(text: '');

  Future<void> _convertCoordinatefromAddress(double lat, double lng) async {
    final url = Uri.parse(
        'https://rsapi.goong.io/Geocode?latlng=$lat,$lng&api_key=WOXLNGkieaqVH3DPxcDpJoInSLk7QQajAHdzmyhB');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];
    setState(() {
      addressDefaultController.text = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image(
                  width: MediaQuery.of(context).size.width,
                  height: size.height * 0.65,
                  fit: BoxFit.fitHeight,
                  image: const AssetImage('image/onboard5.jpeg'),
                ),
                Transform(
                  alignment: Alignment.bottomCenter,
                  transform: Matrix4.rotationY(math.pi),
                  child: Container(
                    height: size.height * 0.35,
                    color: const Color.fromRGBO(5, 109, 101, 1),
                  ),
                )
              ],
            ),
            Positioned(
              top: size.height * 0.7,
              child: Container(
                width: size.width,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Thiết lập địa chỉ mặc định',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                            bottom: 10.0,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 1,
                                  color:
                                      const Color.fromARGB(255, 185, 184, 184)),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: TypeAheadField<AddressUpdate?>(
                              hideOnError: true,
                              debounceDuration:
                                  const Duration(milliseconds: 500),
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: addressDefaultController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Địa chỉ (chọn địa chỉ gợi ý)',
                                ),
                              ),
                              suggestionsCallback:
                                  AddressUpdateApi.getAddressSuggestions,
                              itemBuilder:
                                  (context, AddressUpdate? suggestion) {
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
                                          fontFamily: GoogleFonts.montserrat()
                                              .fontFamily,
                                          fontSize: 18,
                                        ),
                                  ),
                                ),
                              ),
                              onSuggestionSelected:
                                  (AddressUpdate? suggestion) {
                                final address = suggestion!;
                                setState(() {});
                                addressDefaultController.text =
                                    address.description;

                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Selected address: ${address.description}'),
                                    ),
                                  );
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final SharedPreferences prefs = await _prefs;

                            // await prefs.setString('token', token.toString());

                            final lat = prefs.getDouble('lat')!;
                            final lng = prefs.getDouble('lng')!;

                            final pickedLocation =
                                await Navigator.of(context).push<LatLng>(
                              MaterialPageRoute(
                                builder: (ctx) => MapScreen(
                                    currentLocation: PlaceLocation(
                                        latitude: lat,
                                        longitude: lng,
                                        address: '')),
                              ),
                            );

                            if (pickedLocation == null) {
                              return;
                            }

                            _convertCoordinatefromAddress(
                                pickedLocation.latitude,
                                pickedLocation.longitude);
                          },
                          icon: const FaIcon(FontAwesomeIcons.locationPin),
                          style: IconButton.styleFrom(
                              iconSize: 20, foregroundColor: Colors.red),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    ElevatedButton(
                      onPressed: () async {
                        addressDefault = addressDefaultController.text;
                        Get.offAll(const MainScreen());
                      },
                      child: Text(
                        'Lưu điạ chỉ',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                              color: const Color.fromRGBO(5, 109, 101, 1),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  ],
                ),
              ),
            ),
            // Positioned(
            //   bottom: 15,
            //   left: 0,
            //   right: 0,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Container(
            //         margin: const EdgeInsets.symmetric(horizontal: 20 / 4),
            //         width: 15,
            //         height: 15,
            //         decoration: BoxDecoration(
            //             border: Border.all(color: Colors.black, width: 2),
            //             shape: BoxShape.circle,
            //             color: const Color.fromRGBO(54, 92, 69, 1)),
            //       ),
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 20.0 * 2),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Container(
            //         alignment: Alignment.centerRight,
            //         child: TextButton(
            //           onPressed: () => Get.offAll(const MainScreen()),
            //           child: const Text(
            //             'X',
            //             style: TextStyle(
            //               color: Colors.black,
            //               fontSize: 20.0,
            //             ),
            //           ),
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(right: 20.0),
            //         child: FloatingActionButton(
            //           onPressed: () {
            //             Navigator.push(
            //               context,
            //               PageTransition(
            //                 type: PageTransitionType.rightToLeft,
            //                 duration: const Duration(milliseconds: 400),
            //                 child: const MainScreen(),
            //               ),
            //             );
            //           },
            //           backgroundColor: Colors.white,
            //           child: Icon(
            //             Icons.navigate_next_rounded,
            //             color: Colors.black,
            //             size: 30,
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
