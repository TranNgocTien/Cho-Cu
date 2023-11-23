import 'dart:io';
import 'package:chotot/models/addressUpdate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chotot/widgets/location_input.dart';
import 'package:chotot/models/place.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CapNhatTaiKhoanScreen extends StatefulWidget {
  const CapNhatTaiKhoanScreen({super.key});

  @override
  State<CapNhatTaiKhoanScreen> createState() => _CapNhatTaiKhoanScreenState();
}

class _CapNhatTaiKhoanScreenState extends State<CapNhatTaiKhoanScreen> {
  File? imageFile;
  PlaceLocation? _selectedLocation;
  TextEditingController addressToCoordinate = TextEditingController();

  void _convertAddressToCoordinate(string) async {
    List<Location> location = await locationFromAddress(string);

    final lat = location.last.latitude;

    final lng = location.last.longitude;

    if (lat == null || lng == null) {
      return;
    }
    setState(() {
      _selectedLocation = PlaceLocation(
        latitude: lat,
        longitude: lng,
        address: string,
      );
    });
  }

  _openGallery() async {
    try {
      final imageFileGallery = await ImagePicker()
          .pickImage(source: ImageSource.gallery, maxWidth: 600);
      if (imageFileGallery == null) return;
      final imageTemp = File(imageFileGallery.path);
      setState(() {
        imageFile = imageTemp;
      });
    } on PlatformException catch (e) {
      AlertDialog(
        content: Text(
          e.toString(),
        ),
      );
    }
  }

  _openCamera() async {
    try {
      final imageFileGallery = await ImagePicker()
          .pickImage(source: ImageSource.camera, maxWidth: 600);
      if (imageFileGallery == null) return;
      final imageTemp = File(imageFileGallery.path);
      setState(() {
        imageFile = imageTemp;
      });
    } on PlatformException catch (e) {
      AlertDialog(
        content: Text(
          e.toString(),
        ),
      );
    }
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.2,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Lựa chọn tải ảnh:',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontFamily: GoogleFonts.rubik().fontFamily,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _openGallery();
                        },
                        child: Column(
                          children: [
                            const Icon(FontAwesomeIcons.image),
                            const SizedBox(height: 5),
                            Text(
                              'Thư viện',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    fontFamily: GoogleFonts.rubik().fontFamily,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _openCamera();
                        },
                        child: Column(
                          children: [
                            const Icon(FontAwesomeIcons.camera),
                            const SizedBox(height: 5),
                            Text(
                              'Chụp ảnh',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    fontFamily: GoogleFonts.rubik().fontFamily,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cập nhật tài khoản',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontFamily: GoogleFonts.rubik().fontFamily,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(54, 92, 69, 1),
              ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            imageFile != null
                ? Image.file(
                    imageFile!,
                    width: 400,
                    height: 400,
                  )
                : Container(
                    height: 400,
                    width: 400,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color.fromARGB(37, 0, 0, 0),
                          width: 1.0,
                        )),
                    child: Center(
                      child: Text(
                        'Không có ảnh!',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontFamily: GoogleFonts.rubik().fontFamily,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
            TextButton.icon(
              onPressed: () {
                _showChoiceDialog(context);
              },
              icon: const Icon(FontAwesomeIcons.camera),
              label: Text(
                'Tải ảnh',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontFamily: GoogleFonts.rubik().fontFamily,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 243, 241, 241),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 5,
                  ),
                  child: TextFormField(
                    // controller: loginController.passwordController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      label: Row(
                        children: [
                          const Icon(FontAwesomeIcons.person),
                          const SizedBox(width: 20),
                          Text(
                            'Tên',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  fontFamily: GoogleFonts.rubik().fontFamily,
                                ),
                          ),
                        ],
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.trim().length < 6) {
                        return 'Password must be at least 6 characters long.';
                      }
                      return null;
                    },
                    // onSaved: (value) {
                    //   _enteredPassword = value!;
                    // },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    bottom: 10.0,
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 243, 241, 241),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TypeAheadField<AddressUpdate?>(
                      hideOnError: true,
                      debounceDuration: const Duration(milliseconds: 500),
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: addressToCoordinate,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          label: Row(
                            children: [
                              const Icon(FontAwesomeIcons.locationDot),
                              const SizedBox(width: 20),
                              Text(
                                'Địa chỉ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.rubik().fontFamily,
                                    ),
                              ),
                            ],
                          ),
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
                                  fontFamily: GoogleFonts.rubik().fontFamily,
                                  fontSize: 18,
                                ),
                          ),
                        ),
                      ),
                      onSuggestionSelected: (AddressUpdate? suggestion) {
                        final address = suggestion!;
                        setState(() {});
                        addressToCoordinate.text = address.description;

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
                  onPressed: () {
                    if (addressToCoordinate.text.isEmpty) {
                      showDialog(
                          context: Get.context!,
                          builder: (context) {
                            return const SimpleDialog(
                              contentPadding: EdgeInsets.all(20),
                              children: [
                                Text(
                                  'Vui lòng nhập địa chỉ',
                                ),
                              ],
                            );
                          });
                      return;
                    }
                    _convertAddressToCoordinate(addressToCoordinate.text);
                  },
                  icon: const FaIcon(FontAwesomeIcons.locationPin),
                  style: IconButton.styleFrom(
                      iconSize: 20, foregroundColor: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 10),
            LocationInput(
              pickedLocationAdress: _selectedLocation,
              onSelectLocation: (location) {
                _selectedLocation = location;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 2, 219, 134),
                  side: const BorderSide(
                    color: Color.fromARGB(255, 2, 219, 134),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                ),
                child: Text(
                  'Cập nhật',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontFamily: GoogleFonts.rubik().fontFamily,
                        color: const Color.fromARGB(255, 2, 219, 134),
                      ),
                ), // B,
                onPressed: () {},
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
