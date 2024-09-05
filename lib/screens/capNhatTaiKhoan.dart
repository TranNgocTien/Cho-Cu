import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:chotot/data/ly_lich.dart';
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
import 'package:chotot/controllers/update_info.dart';
import 'package:chotot/controllers/change_avatar.dart';

class CapNhatTaiKhoanScreen extends StatefulWidget {
  const CapNhatTaiKhoanScreen({super.key});

  @override
  State<CapNhatTaiKhoanScreen> createState() => _CapNhatTaiKhoanScreenState();
}

class _CapNhatTaiKhoanScreenState extends State<CapNhatTaiKhoanScreen> {
  File? imageFile;
  PlaceLocation? _selectedLocation;
  ChangeAvatarController changeAvatarController =
      Get.put(ChangeAvatarController());
  // TextEditingController addressToCoordinate = TextEditingController();
  UpdateInfoController updateInfoController = Get.put(UpdateInfoController());

  void _convertAddressToCoordinate(string) async {
    List<Location> location = await locationFromAddress(string);

    final lat = location.last.latitude;

    final lng = location.last.longitude;

    if (lat == null || lng == null) {
      return;
    }
    updateInfoController.lat = lat;
    updateInfoController.lng = lng;

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
        changeAvatarController.imageFileUpdate = imageFile;
      });
    } on PlatformException catch (e) {
      AlertDialog(
        content: Text(
          e.toString(),
        ),
      );
    }
    Get.back();
  }

  _openCamera() async {
    try {
      final imageFileGallery = await ImagePicker()
          .pickImage(source: ImageSource.camera, maxWidth: 600);
      if (imageFileGallery == null) return;
      final imageTemp = File(imageFileGallery.path);
      setState(() {
        imageFile = imageTemp;
        changeAvatarController.imageFileUpdate = imageFile;
      });
    } on PlatformException catch (e) {
      AlertDialog(
        content: Text(
          e.toString(),
        ),
      );
    }
    Get.back();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return AwesomeDialog(
            width: double.infinity,
            context: Get.context!,
            animType: AnimType.scale,
            dialogType: DialogType.info,
            body: Center(
              child: Text(
                'Lựa chọn tải ảnh',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: GoogleFonts.poppins().fontFamily),
                textAlign: TextAlign.center,
              ),
            ),
            btnOk: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(39, 166, 82, 1),
              ),
              onPressed: () {
                _openGallery();
              },
              icon: const FaIcon(FontAwesomeIcons.image, color: Colors.white),
              label: Text(
                'Thư viện',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            btnCancel: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(39, 166, 82, 1),
              ),
              onPressed: () async {
                _openCamera();
              },
              icon: const FaIcon(
                FontAwesomeIcons.camera,
                color: Colors.white,
              ),
              label: Text(
                'Máy ảnh',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            btnOkOnPress: () {},
            btnCancelOnPress: () async {})
        .show();

    // return showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         content: Container(
    //           width: MediaQuery.of(context).size.width * 0.3,
    //           height: MediaQuery.of(context).size.height * 0.2,
    //           padding: const EdgeInsets.all(20),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               const SizedBox(
    //                 height: 20,
    //               ),
    //               Text(
    //                 'Lựa chọn tải ảnh:',
    //                 style: Theme.of(context).textTheme.titleMedium!.copyWith(
    //                       fontFamily: GoogleFonts.poppins().fontFamily,
    //                       color: Colors.black,
    //                       fontWeight: FontWeight.w600,
    //                     ),
    //                 textAlign: TextAlign.center,
    //               ),
    //               const SizedBox(height: 20),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   GestureDetector(
    //                     onTap: () {
    //                       _openGallery();
    //                     },
    //                     child: Column(
    //                       children: [
    //                         const Icon(FontAwesomeIcons.image),
    //                         const SizedBox(height: 5),
    //                         Text(
    //                           'Thư viện',
    //                           style: Theme.of(context)
    //                               .textTheme
    //                               .labelLarge!
    //                               .copyWith(
    //                                 fontFamily:
    //                                     GoogleFonts.poppins().fontFamily,
    //                                 color: Colors.black,
    //                                 fontWeight: FontWeight.w600,
    //                               ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                   GestureDetector(
    //                     onTap: () {
    //                       _openCamera();
    //                     },
    //                     child: Column(
    //                       children: [
    //                         const Icon(FontAwesomeIcons.camera),
    //                         const SizedBox(height: 5),
    //                         Text(
    //                           'Chụp ảnh',
    //                           style: Theme.of(context)
    //                               .textTheme
    //                               .labelLarge!
    //                               .copyWith(
    //                                 fontFamily:
    //                                     GoogleFonts.poppins().fontFamily,
    //                                 color: Colors.black,
    //                                 fontWeight: FontWeight.w600,
    //                               ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromRGBO(39, 166, 82, 1),
                Color.fromRGBO(1, 142, 33, 1),
                Color.fromRGBO(23, 162, 73, 1),
                Color.fromRGBO(84, 181, 111, 1),
              ],
            ),
          ),
        ),
        title: Text(
          'Cập nhật tài khoản',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
                    child: Image.network(lyLichInfo[0].profileImage),
                    // Center(
                    //   child: Text(
                    //     'Cập nhật ảnh đại diện',
                    //     style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    //           fontFamily: GoogleFonts.poppins().fontFamily,
                    //           color: Colors.black,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //   ),
                    // ),
                  ),
            TextButton.icon(
              onPressed: () {
                _showChoiceDialog(context);
              },
              icon: const Icon(FontAwesomeIcons.camera,
                  color: Color.fromRGBO(38, 166, 83, 1)),
              label: Text(
                'Tải ảnh',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: const Color.fromRGBO(38, 166, 83, 1),
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
                    controller: updateInfoController.nameController,
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
                                  fontFamily: GoogleFonts.poppins().fontFamily,
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
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 243, 241, 241),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TypeAheadField<AddressUpdate?>(
                      hideOnError: true,
                      debounceDuration: const Duration(milliseconds: 500),
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: updateInfoController.addressController,
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
                                          GoogleFonts.poppins().fontFamily,
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
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: 18,
                                ),
                          ),
                        ),
                      ),
                      onSuggestionSelected: (AddressUpdate? suggestion) {
                        final address = suggestion!;
                        setState(() {});
                        updateInfoController.addressController.text =
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
                MaterialButton(
                  onPressed: () {
                    if (updateInfoController.addressController.text.isEmpty) {
                      AwesomeDialog(
                        context: Get.context!,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Vui lòng nhập địa chỉ',
                        titleTextStyle: GoogleFonts.poppins(),
                        autoHide: const Duration(milliseconds: 800),
                      ).show();

                      return;
                    }
                    _convertAddressToCoordinate(
                        updateInfoController.addressController.text);
                  },
                  shape: const CircleBorder(
                      eccentricity: 0.0,
                      side: BorderSide(
                        color: Color.fromRGBO(38, 166, 83, 1),
                        width: 2.0,
                      )),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  elevation: 20.0,
                  child: const FaIcon(FontAwesomeIcons.locationPin,
                      size: 25, color: Color.fromRGBO(38, 166, 83, 1)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            LocationInput(
              pickedLocationAdress: _selectedLocation,
              onSelectLocation: (location) {
                _selectedLocation = location;
              },
              state: 'capnhat',
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: MaterialButton(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                height: 40.0,
                minWidth: 100.0,
                color: const Color.fromRGBO(38, 166, 83, 1),
                child: Text(
                  'Cập nhật',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: Colors.white,
                      ),
                ), // B,
                onPressed: () async {
                  await updateInfoController.updateInfo();
                  await changeAvatarController.updateAvatar();
                },
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
