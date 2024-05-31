// import 'package:chotot/data/default_information.dart';
import 'package:chotot/models/place.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:chotot/models/addressUpdate.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:chotot/screens/mapScreen.dart';
// import 'package:chotot/models/get_otherfee.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangeDefaultInfo extends StatefulWidget {
  const ChangeDefaultInfo({super.key});

  @override
  State<ChangeDefaultInfo> createState() => _ChangeDefaultInfoState();
}

class _ChangeDefaultInfoState extends State<ChangeDefaultInfo> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameDefaultSetting = TextEditingController(text: '');
  TextEditingController addressDefaultSetting = TextEditingController(text: '');
  TextEditingController phoneDefaultSetting = TextEditingController(text: '');
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _storage = const FlutterSecureStorage();
  Future<void> _convertCoordinatefromAddress(double lat, double lng) async {
    final url = Uri.parse(
        'https://rsapi.goong.io/Geocode?latlng=$lat,$lng&api_key=WOXLNGkieaqVH3DPxcDpJoInSLk7QQajAHdzmyhB');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];
    setState(() {
      addressDefaultSetting.text = address;
    });
  }

  @override
  void dispose() {
    nameDefaultSetting.dispose();
    addressDefaultSetting.dispose();
    phoneDefaultSetting.dispose();

    super.dispose();
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
        appBar: AppBar(
          title: Text(
            'Thay đổi thông tin mặc định',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(54, 92, 69, 1),
                ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          foregroundColor: const Color.fromRGBO(54, 92, 69, 1),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tên mặc định',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: const Color.fromRGBO(5, 109, 101, 1),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 185, 184, 184)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 15, right: 15),
                      child: TextFormField(
                        controller: nameDefaultSetting,
                        decoration: const InputDecoration(
                          hintText: 'Họ và tên chủ đơn hàng',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.streetAddress,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('required!'),
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Địa chỉ của bạn: ',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: const Color.fromRGBO(5, 109, 101, 1),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Row(
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
                            border: Border.all(
                                width: 1,
                                color:
                                    const Color.fromARGB(255, 185, 184, 184)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TypeAheadField<AddressUpdate?>(
                            hideOnError: true,
                            debounceDuration: const Duration(milliseconds: 500),
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: addressDefaultSetting,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Địa chỉ (chọn địa chỉ gợi ý)',
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
                            onSuggestionSelected: (AddressUpdate? suggestion) {
                              final address = suggestion!;
                              setState(() {});
                              addressDefaultSetting.text = address.description;

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

                          _convertCoordinatefromAddress(pickedLocation.latitude,
                              pickedLocation.longitude);
                        },
                        icon: const FaIcon(FontAwesomeIcons.locationPin),
                        style: IconButton.styleFrom(
                            iconSize: 20, foregroundColor: Colors.red),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Số điện thoại mặc định:',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: const Color.fromRGBO(5, 109, 101, 1),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 185, 184, 184)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 15, right: 15),
                      child: TextFormField(
                        controller: phoneDefaultSetting,
                        decoration: const InputDecoration(
                          hintText: 'Số điện thoại của bạn! (Bắt buộc)',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.phone,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Phone input is required!'),
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.075),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _storage.write(
                            key: "ADDRESS_DEFAULT",
                            value: addressDefaultSetting.text);
                        await _storage.write(
                            key: "NAME_DEFAULT",
                            value: nameDefaultSetting.text);
                        await _storage.write(
                            key: "NUMBER_DEFAULT",
                            value: phoneDefaultSetting.text);

                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(5, 109, 101, 1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                        child: Text(
                          'Lưu thông tin',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                color: Colors.white,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: 20,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
