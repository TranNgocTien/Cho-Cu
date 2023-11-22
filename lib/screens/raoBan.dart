import 'dart:io';

import 'package:chotot/data/docu_data.dart';
import 'package:chotot/models/place.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:chotot/models/addressUpdate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:chotot/screens/mapScreen.dart';
// import 'package:chotot/models/get_otherfee.dart';
import 'package:chotot/data/get_otherFee_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chotot/controllers/post_stuff.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RaoBanScreen extends StatefulWidget {
  const RaoBanScreen({super.key});

  @override
  State<RaoBanScreen> createState() => _RaoBanScreenState();
}

class _RaoBanScreenState extends State<RaoBanScreen> {
  final _formKey = GlobalKey<FormState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // File? imageFile;

  PostStuff postStuff = Get.put(PostStuff());
  final ImagePicker imagePicker = ImagePicker();
  String service = 'Chọn dịch vụ đăng tin';
  String serviceFee = '0';
  LatLng? _pickedLocation;

  Future<void> _convertCoordinatefromAddress(double lat, double lng) async {
    final url = Uri.parse(
        'https://rsapi.goong.io/Geocode?latlng=$lat,$lng&api_key=WOXLNGkieaqVH3DPxcDpJoInSLk7QQajAHdzmyhB');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];
    setState(() {
      postStuff.addressController.text = address;
    });
  }

  Future<void> _convertAddressToCoordinate(string) async {
    List<Location> location = await locationFromAddress(string);

    postStuff.lat = location.last.latitude;

    postStuff.lng = location.last.longitude;

    if (postStuff.lat == null || postStuff.lng == null) {
      return;
    }
  }

  postStuffService() async {
    if (service == 'Chọn dịch vụ đăng tin') {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              contentPadding: EdgeInsets.all(20),
              children: [
                Text(
                  'Chọn dịch vụ đăng',
                ),
              ],
            );
          });
      return;
    }

    if (postStuff.imageFileList!.isEmpty ||
        postStuff.imageFileList!.length > 3) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              contentPadding: EdgeInsets.all(20),
              children: [
                Text(
                  'Đăng tối thiểu 1 ảnh, tối đa 3 ảnh',
                ),
              ],
            );
          });
      return;
    }
    await postStuff.uploadJobPhoto();

    if (postStuff.addressController.text.isEmpty ||
        postStuff.descriptionController.text.isEmpty ||
        postStuff.nameController.text.isEmpty ||
        postStuff.phoneController.text.isEmpty ||
        postStuff.sumPriceController.text.isEmpty) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              contentPadding: EdgeInsets.all(20),
              children: [
                Text(
                  'Điền đầy đủ các thông tin',
                ),
              ],
            );
          });
    }
    await _convertAddressToCoordinate(postStuff.addressController.text);

    if (postStuff.lat == null || postStuff.lng == null) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              contentPadding: EdgeInsets.all(20),
              children: [
                Text(
                  'Nhập lại địa chỉ',
                ),
              ],
            );
          });
    }
    await postStuff.postItem();
    items.clear();
    postStuff.imageFileList!.clear();
    Get.back();
  }

  _openGallery() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages.isNotEmpty) {
      postStuff.imageFileList!.addAll(selectedImages);
    }
    setState(() {});
    // try {
    //   final imageFileGallery = await ImagePicker()
    //       .pickImage(source: ImageSource.gallery, maxWidth: 600);
    //   if (imageFileGallery == null) return;
    //   final imageTemp = File(imageFileGallery.path);
    //   setState(() {
    //     imageFile = imageTemp;
    //   });
    // } on PlatformException catch (e) {
    //   AlertDialog(
    //     content: Text(
    //       e.toString(),
    //     ),
    //   );
    // }
  }

  void showOverlay() {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.all(20),
            children: [
              Text(
                'Chọn dịch vụ đăng tin',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: const Color.fromRGBO(5, 109, 101, 1),
                    ),
                textAlign: TextAlign.center,
              ),
              SingleChildScrollView(
                  child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.8,
                child: ListView.builder(
                  itemCount: otherFee.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        leading: const FaIcon(FontAwesomeIcons.servicestack),
                        trailing: Text('${otherFee[index].price} VNĐ'),
                        title: Text(otherFee[index].name),
                        onTap: () {
                          setState(() {
                            service = otherFee[index].name;
                            serviceFee = otherFee[index].price;
                            postStuff.codeOtherFee = otherFee[index].idService;
                          });
                          Get.back();
                        });
                  },
                ),
              )),
            ],
          );
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
        appBar: AppBar(
          title: Text(
            'Rao bán',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontFamily: GoogleFonts.rubik().fontFamily,
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
                    'Tên chủ đơn hàng: ',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.rubik().fontFamily,
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
                        controller: postStuff.nameController,
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
                          fontFamily: GoogleFonts.rubik().fontFamily,
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
                              controller: postStuff.addressController,
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
                                            GoogleFonts.rubik().fontFamily,
                                        fontSize: 18,
                                      ),
                                ),
                              ),
                            ),
                            onSuggestionSelected: (AddressUpdate? suggestion) {
                              final address = suggestion!;
                              setState(() {});
                              postStuff.addressController.text =
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
                          final pickedLocation =
                              await Navigator.of(context).push<LatLng>(
                            MaterialPageRoute(
                              builder: (ctx) => const MapScreen(),
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
                    'Số điện thoại liên hệ:',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.rubik().fontFamily,
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
                        controller: postStuff.phoneController,
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
                  const SizedBox(height: 20),
                  Text(
                    'Mô tả:',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.rubik().fontFamily,
                          color: const Color.fromRGBO(5, 109, 101, 1),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
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
                        controller: postStuff.descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Viết vài dòng mô tả sản phẩm ...',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.multiline,
                        autocorrect: false,
                        maxLines: 5,
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
                    'Giá mong muốn: (VNĐ)',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.rubik().fontFamily,
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
                        controller: postStuff.sumPriceController,
                        decoration: const InputDecoration(
                          hintText: '0',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.parse(value.trim()) <= 1000) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Price must be higher!'),
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            postStuff.imageFileList!.length < 3
                                ? _openGallery()
                                : null;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(5, 109, 101, 1),
                            foregroundColor: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              'Thêm Ảnh Chụp',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: Colors.white,
                                    fontFamily: GoogleFonts.rubik().fontFamily,
                                  ),
                            ),
                          ),
                        ),
                        Row(children: [
                          Text(
                            'Hình ảnh : ${postStuff.imageFileList!.length}/3',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: const Color.fromRGBO(5, 109, 101, 1),
                                  fontFamily: GoogleFonts.rubik().fontFamily,
                                ),
                          ),
                          IconButton(
                            onPressed: () async {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return postStuff.imageFileList!.isEmpty
                                        ? Center(
                                            child: Text(
                                              'Danh sách hình ảnh trống',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                    color: const Color.fromRGBO(
                                                        5, 109, 101, 1),
                                                    fontFamily:
                                                        GoogleFonts.rubik()
                                                            .fontFamily,
                                                  ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: GridView.builder(
                                              itemCount: postStuff
                                                  .imageFileList!.length,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                mainAxisSpacing: 5.0,
                                                crossAxisSpacing: 5.0,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Stack(children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: Image.file(
                                                            File(postStuff
                                                                .imageFileList![
                                                                    index]
                                                                .path),
                                                          ).image,
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    child: OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        shape:
                                                            const CircleBorder(),
                                                        side: const BorderSide(
                                                            width: 2.0,
                                                            color: Colors.red),
                                                        foregroundColor:
                                                            Colors.red,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          postStuff
                                                              .imageFileList!
                                                              .remove(postStuff
                                                                      .imageFileList![
                                                                  index]);
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: const FaIcon(
                                                          FontAwesomeIcons
                                                              .minus,
                                                          size: 20,
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ]);
                                              },
                                            ),
                                          );
                                  });
                            },
                            icon: const FaIcon(FontAwesomeIcons.image,
                                size: 20,
                                color: Color.fromRGBO(5, 109, 101, 1)),
                          ),
                        ]),
                      ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await postStuff.getOtherfee();
                            if (otherFee.isNotEmpty) {
                              showOverlay();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(5, 109, 101, 1),
                            foregroundColor: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              'Dịch vụ đăng tin',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: Colors.white,
                                    fontFamily: GoogleFonts.rubik().fontFamily,
                                  ),
                            ),
                          ),
                        ),
                        Text(
                          service,
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: const Color.fromRGBO(5, 109, 101, 1),
                                    fontFamily: GoogleFonts.rubik().fontFamily,
                                  ),
                        ),
                      ]),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Phí đăng:',
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: const Color.fromRGBO(5, 109, 101, 1),
                                    fontFamily: GoogleFonts.rubik().fontFamily,
                                  ),
                        ),
                        Text(
                          '$serviceFee GP',
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: const Color.fromRGBO(5, 109, 101, 1),
                                    fontFamily: GoogleFonts.rubik().fontFamily,
                                  ),
                        ),
                      ]),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.075),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        postStuffService();
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
                          'Đăng tin',
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Colors.white,
                                    fontFamily: GoogleFonts.rubik().fontFamily,
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
