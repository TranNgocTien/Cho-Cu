import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chotot/controllers/get_stuffs_suggestion.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/data/docu_suggestion.dart';
import 'package:chotot/screens/login.dart';
// import 'package:chotot/widgets/docu_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:chotot/models/cho_do_cu.dart';

import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chotot/controllers/stuff_sold_out.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ThongTinSanPhamScreen extends StatefulWidget {
  const ThongTinSanPhamScreen({super.key, required this.docu});
  final DoCu docu;

  @override
  State<ThongTinSanPhamScreen> createState() => _ThongTinSanPhamScreenState();
}

class _ThongTinSanPhamScreenState extends State<ThongTinSanPhamScreen> {
  LoginController loginController = Get.put(LoginController());
  final GetStuffsSuggestion _getStuffsSuggestion =
      Get.put(GetStuffsSuggestion());
  SoldOutStuffs soldOut = Get.put(SoldOutStuffs());
  Future<void> _makePhoneCall(String phoneNumber, String method) async {
    final Uri launchUri = Uri(
      scheme: method,
      path: phoneNumber,
    );
    await launchUrl(launchUri);
    Get.back();
  }

  int curIndexSlide = 0;
  bool isLoading = false;
  void showOverlay(str) {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: const Color.fromARGB(113, 0, 0, 0),
            // contentPadding: const EdgeInsets.all(20),
            children: [
              Image.network(str,
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.width * 0.9),
            ],
          );
        });
  }

  Future<void> _showContactMethod(BuildContext context) {
    final widthDevice = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.info,
      body: Center(
        child: Text(
          'Vui lòng chọn phương thức liên hệ:',
          style: TextStyle(
              color: Colors.black,
              fontSize: widthDevice * 0.04,
              fontFamily: GoogleFonts.poppins().fontFamily),
          textAlign: TextAlign.center,
        ),
      ),
      btnOk: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(
            38,
            166,
            83,
            1,
          ),
        ),
        onPressed: () {
          _makePhoneCall(widget.docu.phone, 'sms');
        },
        child: Text(
          'Tin nhắn',
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: widthDevice * 0.03,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      btnCancel: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(38, 166, 83, 1)),
        onPressed: () async {
          _makePhoneCall(widget.docu.phone, 'tel');
        },
        child: Text(
          'Gọi trực tiếp',
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: widthDevice * 0.03,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ).show();
  }

  // Future<void> _showContactMethod(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           content: Container(
  //             width: MediaQuery.of(context).size.width * 0.7,
  //             height: MediaQuery.of(context).size.height * 0.2,
  //             padding: const EdgeInsets.all(20),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 const SizedBox(
  //                   height: 20,
  //                 ),
  //                 Container(
  //                   decoration: const BoxDecoration(
  //                       border: Border(
  //                           bottom: BorderSide(width: 1, color: Colors.black))),
  //                   child: Text(
  //                     'Liên hệ:',
  //                     style: Theme.of(context).textTheme.titleMedium!.copyWith(
  //                           fontFamily: GoogleFonts.poppins().fontFamily,
  //                           color: Colors.black,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 20),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                   children: [
  //                     GestureDetector(
  //                       onTap: () {
  //                         _makePhoneCall(widget.docu.phone, 'sms');
  //                       },
  //                       child: Column(
  //                         children: [
  //                           const Icon(FontAwesomeIcons.message,
  //                               color: Color.fromARGB(255, 2, 219, 134)),
  //                           const SizedBox(height: 5),
  //                           Text(
  //                             'Tin nhắn',
  //                             style: Theme.of(context)
  //                                 .textTheme
  //                                 .labelLarge!
  //                                 .copyWith(
  //                                   fontFamily:
  //                                       GoogleFonts.poppins().fontFamily,
  //                                   color: Colors.black,
  //                                   fontWeight: FontWeight.w600,
  //                                 ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     const SizedBox(width: 20),
  //                     GestureDetector(
  //                       onTap: () {
  //                         _makePhoneCall(widget.docu.phone, 'tel');
  //                       },
  //                       child: Column(
  //                         children: [
  //                           const Icon(FontAwesomeIcons.phone,
  //                               color: Color.fromARGB(255, 2, 219, 134)),
  //                           const SizedBox(height: 5),
  //                           Text(
  //                             'Gọi trực tiếp',
  //                             style: Theme.of(context)
  //                                 .textTheme
  //                                 .labelLarge!
  //                                 .copyWith(
  //                                   fontFamily:
  //                                       GoogleFonts.poppins().fontFamily,
  //                                   color: Colors.black,
  //                                   fontWeight: FontWeight.w600,
  //                                 ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  bool isFavorite = false;
  @override
  void initState() {
    curIndexSlide = 0;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    curIndexSlide = 0;
    itemsSuggestion.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthDevice = MediaQuery.of(context).size.width;
    var dateSubmit = widget.docu.name
        .substring(widget.docu.name.indexOf('-'))
        .replaceFirst('-', '');
    var nameStuff =
        widget.docu.name.substring(0, widget.docu.name.indexOf('-'));
    final priceReverse = StringUtils.addCharAtPosition(
        StringUtils.reverse(widget.docu.price), ".", 3,
        repeat: true);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color.fromRGBO(38, 166, 83, 1),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: loginController.hostId == widget.docu.hostId &&
                      widget.docu.status != 'sold_out'
                  ? MaterialButton(
                      elevation: 10.0,
                      color: const Color.fromRGBO(38, 166, 83, 1),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        soldOut.soldOutStuffs(widget.docu.id);

                        setState(() {});
                      },
                      child: Text(
                        'Thông báo đã bán',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: widthDevice * 0.035,
                            ),
                      ),
                    )
                  : Text(
                      widget.docu.status == 'sold_out' ? 'Đã Bán' : 'Có Sẵn',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: widget.docu.status == 'sold_out'
                                ? Colors.red
                                : const Color.fromRGBO(38, 166, 83, 1),
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: widthDevice * 0.035,
                          ),
                    ),
            )
          ]),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Card(
            //   // color: const Color.fromRGBO(139, 233, 141, 1),
            //   color: Colors.grey,
            //   shadowColor: Colors.black,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(10.0),
            //   ),
            //   elevation: 10,
            // child:
            CarouselSlider(
              options: CarouselOptions(
                height: 400.0,
                autoPlay: true,
                enableInfiniteScroll: false,
                viewportFraction: 1,
              ),
              items: widget.docu.photos.map((photo) {
                return InstaImageViewer(
                  child: Container(
                    // margin: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.2,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Builder(
                      builder: (BuildContext context) {
                        return Stack(children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Image.network(
                              photo.split('"').join(''),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: MediaQuery.of(context).size.width * 0.95,
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(93, 0, 0, 0),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${widget.docu.photos.indexOf(photo) + 1}/${widget.docu.photos.length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: widthDevice * 0.04,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ]);
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            // ),
            const SizedBox(height: 10),
            Container(
              color: const Color.fromARGB(255, 242, 242, 242),
              // height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 10.0,
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                nameStuff,
                                softWrap: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color:
                                          const Color.fromRGBO(38, 166, 83, 1),
                                      fontWeight: FontWeight.w700,
                                      fontSize: widthDevice * 0.04,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Ngày đăng:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontSize: widthDevice * 0.035,
                                      ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  dateSubmit,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Colors.grey,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontSize: widthDevice * 0.035,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Địa chỉ:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontSize: widthDevice * 0.035,
                                      ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    softWrap: true,
                                    widget.docu.address,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.grey,
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: widthDevice * 0.035,
                                        ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Giá mong muốn:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: widthDevice * 0.035,
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                        ),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    child: Text(
                                      '${StringUtils.reverse(priceReverse)} VNĐ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: Colors.grey,
                                            fontSize: widthDevice * 0.035,
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                          ),
                                    ),
                                  ),
                                ]),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 10.0,
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                // height: MediaQuery.of(context).size.height * 0.1,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Các sản phẩm mới:',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: widthDevice * 0.035,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        setState(() {
                                          isLoading = true;
                                          curIndexSlide++;
                                        });
                                        await _getStuffsSuggestion
                                            .getStuffs(curIndexSlide);
                                        Timer(const Duration(seconds: 3), () {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        });
                                      },
                                      child: Text(
                                        'Xem thêm',
                                        style: GoogleFonts.poppins(
                                          fontSize: widthDevice * 0.035,
                                          color: const Color.fromRGBO(
                                              38, 166, 83, 1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              isLoading == false
                                  ? itemsSuggestion.isEmpty
                                      ? Center(
                                          child: Text(
                                            'Không còn sản phẩm',
                                            style: GoogleFonts.poppins(
                                              fontSize: widthDevice * 0.035,
                                            ),
                                          ),
                                        )
                                      : SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              ...itemsSuggestion.map((item) {
                                                final priceReverse = StringUtils
                                                    .addCharAtPosition(
                                                        StringUtils.reverse(
                                                            item.price),
                                                        ".",
                                                        3,
                                                        repeat: true);

                                                final name = item.name
                                                        .contains('-')
                                                    ? item.name.substring(0,
                                                        item.name.indexOf('-'))
                                                    : item.name;

                                                return widget.docu.id != item.id
                                                    ? Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        ThongTinSanPhamScreen(
                                                                      docu:
                                                                          item,
                                                                    ),
                                                                  ));
                                                              // Get.to(
                                                              //   () =>
                                                              //       ThongTinSanPhamScreen(
                                                              //     docu: item,
                                                              //   ),
                                                              // );
                                                            },
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.4,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        127,
                                                                        158,
                                                                        158,
                                                                        158)),
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  AspectRatio(
                                                                    aspectRatio:
                                                                        487 /
                                                                            451,
                                                                    child: CachedNetworkImage(
                                                                        imageUrl: item.photos[0].split('"').join(''),
                                                                        imageBuilder: (context, imageProvider) => Container(
                                                                              decoration: BoxDecoration(
                                                                                image: DecorationImage(
                                                                                  image: imageProvider,
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                        memCacheWidth: 200,
                                                                        maxHeightDiskCache: 200,
                                                                        maxWidthDiskCache: 200),
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8),
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          name,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .titleMedium!
                                                                              .copyWith(
                                                                                fontFamily: GoogleFonts.poppins().fontFamily,
                                                                                fontSize: widthDevice * 0.035,
                                                                                fontWeight: FontWeight.bold,
                                                                                overflow: TextOverflow.ellipsis,
                                                                              ),
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              'Giá bán:',
                                                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                                                                    color: Colors.black,
                                                                                    fontSize: widthDevice * 0.03,
                                                                                  ),
                                                                              textAlign: TextAlign.start,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 5),
                                                                              child: Text(
                                                                                '${StringUtils.reverse(priceReverse)} Đ',
                                                                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                                                                      color: Colors.red,
                                                                                      fontWeight: FontWeight.w900,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      fontSize: widthDevice * 0.03,
                                                                                    ),
                                                                                textAlign: TextAlign.start,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                        ],
                                                      )
                                                    : const SizedBox();
                                              }).toList(),
                                            ],
                                          ),
                                        )
                                  : Center(
                                      child: LoadingAnimationWidget.waveDots(
                                        color:
                                            const Color.fromRGBO(1, 142, 33, 1),
                                        size: 30,
                                      ),
                                    ),
                            ],
                          )),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      color: Colors.white,
                      elevation: 20.0,
                      surfaceTintColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                softWrap: true,
                                'Thông tin sản phẩm:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: widthDevice * 0.035,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                    ),
                                // textAlign: TextAlign.start,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(left: 20.0),
                              // decoration: BoxDecoration(
                              //     border: Border.all(color: Colors.grey, width: 1),
                              //     borderRadius:
                              //         const BorderRadius.all(Radius.circular(20))),
                              child:
                                  Flex(direction: Axis.horizontal, children: [
                                Flexible(
                                  child: Text(
                                    widget.docu.description,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.grey,
                                          fontSize: widthDevice * 0.035,
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                        ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ]),
                            ),
                            const SizedBox(height: 50),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: MaterialButton(
                                color: const Color.fromRGBO(38, 166, 83, 1),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 24.0,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 10.0,
                                onPressed: loginController.tokenString != ''
                                    ? () {
                                        widget.docu.status == 'sold_out'
                                            ? AwesomeDialog(
                                                context: Get.context!,
                                                dialogType:
                                                    DialogType.infoReverse,
                                                animType: AnimType.rightSlide,
                                                title: 'Sản phẩm đã bán',
                                                titleTextStyle:
                                                    GoogleFonts.poppins(
                                                  fontSize: widthDevice * 0.035,
                                                ),
                                                autoHide: const Duration(
                                                    milliseconds: 800),
                                              ).show()
                                            : _showContactMethod(context);
                                      }
                                    : () {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.info,
                                          animType: AnimType.rightSlide,
                                          title: 'Vui lòng đăng nhập',
                                          titleTextStyle: GoogleFonts.poppins(
                                            fontSize: widthDevice * 0.035,
                                          ),
                                          btnOkText: 'Đăng nhập',
                                          btnOkOnPress: () {
                                            Get.to(() => const LoginScreen());
                                          },
                                        ).show();
                                      },
                                child: Text(
                                  'Liên hệ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: widthDevice * 0.035,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
