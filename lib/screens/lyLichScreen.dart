import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chotot/controllers/get_a_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chotot/screens/capNhatTaiKhoan.dart';

import 'package:chotot/data/ly_lich.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

// import 'package:loading_animation_widget/loading_animation_widget.dart';

class LyLichScreen extends StatefulWidget {
  const LyLichScreen({
    super.key,
  });

  @override
  State<LyLichScreen> createState() => _LyLichScreenState();
}

class _LyLichScreenState extends State<LyLichScreen> {
  // LyLichController lyLichController = Get.put(LyLichController());
  GetAUserController getAUserController = Get.put(GetAUserController());

  Image img = Image.network(lyLichInfo[0].profileImage);
  void showOverlay(str) {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.all(20),
            children: [
              CachedNetworkImage(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 200,
                  imageUrl: str,
                  // placeholder: (context, url) =>
                  //     const CircularProgressIndicator(strokeWidth: 5.0),
                  errorWidget: (context, url, error) => Image.asset(
                        'image/logo_tho_thong_minh.jpeg',
                        width: 150,
                        height: 200,
                      ),
                  imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  memCacheWidth: 200,
                  maxHeightDiskCache: 200,
                  maxWidthDiskCache:
                      (MediaQuery.of(context).size.width * 0.5).toInt()),
            ],
          );
        });
  }

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final widthDevice = MediaQuery.of(context).size.width;
    final priceReverse = StringUtils.addCharAtPosition(
        StringUtils.reverse(lyLichInfo[0].wallet), ".", 3,
        repeat: true);
    return lyLichInfo[0].workerAuthen == 'false'
        ? Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                // height: MediaQuery.of(context).size.height * 0.2,
                height: MediaQuery.of(context).size.height,

                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFBFE299), // Background color

                  // gradient: LinearGradient(
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  //   colors: [
                  //     Color.fromARGB(255, 108, 227, 191),
                  //     Color.fromARGB(255, 109, 246, 102),
                  //   ],
                  //   stops: [0.0, 0.74], // 0% and 74%
                  // ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                    colors: [
                      Color.fromRGBO(39, 166, 82, 1),
                      Color.fromRGBO(1, 142, 33, 1),
                      Color.fromRGBO(23, 162, 73, 1),
                      Color.fromRGBO(84, 181, 111, 1),
                    ],
                    // stops: [0.0, 0.74], // 0% and 74%
                  ),
                ),
              ),
              Positioned(
                  top: 40,
                  left: 10,
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white))),
              Positioned(
                top: 150,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Text(
                        lyLichInfo[0].name,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.black,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: widthDevice * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      // const SizedBox(
                      //   height: 30,
                      // ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  width: double.infinity,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 2.0,
                          surfaceTintColor: Colors.white,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 24.0),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Địa chỉ:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                            fontSize: widthDevice * 0.035,
                                            color: Colors.black),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Text(
                                      lyLichInfo[0].address,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                            fontSize: widthDevice * 0.035,
                                            color: Colors.black26,
                                          ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Card(
                          elevation: 2.0,
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 24.0),
                            child: Row(children: [
                              Text(
                                'Số điện thoại:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontSize: widthDevice * 0.035,
                                        color: Colors.black),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                lyLichInfo[0].phone,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      color: Colors.black26,
                                      fontSize: widthDevice * 0.035,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Card(
                          elevation: 2.0,
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 24.0),
                            child: Row(children: [
                              Text(
                                'Email:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontSize: widthDevice * 0.035,
                                        color: Colors.black),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                lyLichInfo[0].emailAuthen == 'false'
                                    ? 'Email chưa xác thực'
                                    : lyLichInfo[0].email,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: widthDevice * 0.035,
                                      color: Colors.black26,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Card(
                          elevation: 2.0,
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 24.0),
                            child: Row(children: [
                              Text(
                                'Ví:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontSize: widthDevice * 0.035,
                                        color: Colors.black),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${StringUtils.reverse(priceReverse)} GP',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: widthDevice * 0.035,
                                      color: Colors.black26,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                            ]),
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: MaterialButton(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 10),
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            height: 40.0,
                            minWidth: 100.0,
                            color: const Color.fromRGBO(38, 166, 83, 1),
                            child: Text(
                              'Cập nhật tài khoản',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize: widthDevice * 0.035,
                                    color: Colors.white,
                                  ),
                            ), // B,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      const CapNhatTaiKhoanScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 75,
                // left: 130,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: img.image,
                  ),
                ),
              ),
            ],
          )
        : Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFBFE299), // Background color
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                    colors: [
                      Color.fromRGBO(39, 166, 82, 1),
                      Color.fromRGBO(1, 142, 33, 1),
                      Color.fromRGBO(23, 162, 73, 1),
                      Color.fromRGBO(84, 181, 111, 1),
                    ],
                    // stops: [0.0, 0.74], // 0% and 74%
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color.fromRGBO(39, 166, 82, 1),
                  ),
                ),
              ),
              Positioned(
                top: 140,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Text(
                        lyLichInfo[0].name,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.black,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: widthDevice * 0.035,
                            ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RatingBar.builder(
                        initialRating: (double.tryParse(
                                getAUserController.aUser[0].worker.ds)! /
                            20),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        ignoreGestures: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFBFE299), // Background color
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFBFE299),
                              Color(0xFF66B5F6),
                            ],
                            stops: [0.0, 0.74], // 0% and 74%
                          ),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          double.tryParse(
                                  getAUserController.aUser[0].worker.ds)!
                              .ceilToDouble()
                              .toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                color: Colors.white,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: widthDevice * 0.035,
                              ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.only(left: 5),
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(
                              'Số CMND/CCCD:',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: widthDevice * 0.035,
                                      color: Colors.black),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              getAUserController.aUser[0].worker.ccid,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize: widthDevice * 0.035,
                                    color: Colors.black26,
                                  ),
                              textAlign: TextAlign.start,
                            ),
                          ]),
                          const SizedBox(height: 10),
                          Row(children: [
                            Text(
                              'Địa chỉ:',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: widthDevice * 0.035,
                                      color: Colors.black),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Text(
                                getAUserController.aUser[0].worker.address,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: widthDevice * 0.035,
                                      color: Colors.black26,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ]),
                          const SizedBox(height: 10),
                          Row(children: [
                            Text(
                              'Số điện thoại:',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: widthDevice * 0.035,
                                      color: Colors.black),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              lyLichInfo[0].phone,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize: widthDevice * 0.035,
                                    color: Colors.black26,
                                  ),
                              textAlign: TextAlign.start,
                            ),
                          ]),
                          const SizedBox(height: 10),
                          Row(children: [
                            const SizedBox(height: 10),
                            Text(
                              'Email:',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: widthDevice * 0.035,
                                      color: Colors.black),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              lyLichInfo[0].emailAuthen == 'false'
                                  ? 'Email chưa xác thực'
                                  : lyLichInfo[0].email,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize: widthDevice * 0.035,
                                    color: Colors.black26,
                                  ),
                              textAlign: TextAlign.start,
                            ),
                          ]),
                          const SizedBox(height: 10),
                          Row(children: [
                            Text(
                              'Ví:',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: widthDevice * 0.035,
                                      color: Colors.black),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${StringUtils.reverse(priceReverse)} VNĐ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize: widthDevice * 0.035,
                                    color: Colors.black26,
                                  ),
                              textAlign: TextAlign.start,
                            ),
                          ]),
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              'Ảnh CMND/CCCD',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize: widthDevice * 0.035,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ), // B,,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  InstaImageViewer(
                                    child: Material(
                                      color: Colors.white,
                                      child: CachedNetworkImage(
                                          fit: BoxFit.fitWidth,
                                          width: widthDevice * 0.48,
                                          height: 200,
                                          imageUrl: getAUserController
                                              .aUser[0].worker.ccidImg.truoc,
                                          // placeholder: (context, url) =>
                                          //     const CircularProgressIndicator(strokeWidth: 5.0),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  'image/logo_tho_thong_minh.jpeg',
                                                  width: widthDevice * 0.48,
                                                  height: 200,
                                                  fit: BoxFit.contain),
                                          imageBuilder: (context,
                                                  imageProvider) =>
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10)),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ),
                                              ),
                                          memCacheWidth: 200,
                                          maxHeightDiskCache: 200,
                                          maxWidthDiskCache:
                                              (widthDevice * 0.48).toInt()),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Mặt trước',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: widthDevice * 0.035,
                                          color: Colors.black,
                                        ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  InstaImageViewer(
                                    child: Material(
                                      color: Colors.white,
                                      child: CachedNetworkImage(
                                          fit: BoxFit.fitWidth,
                                          width: widthDevice * 0.48,
                                          height: 200,
                                          imageUrl: getAUserController
                                              .aUser[0].worker.ccidImg.sau,
                                          // placeholder: (context, url) =>
                                          //     const CircularProgressIndicator(strokeWidth: 5.0),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  'image/logo_tho_thong_minh.jpeg',
                                                  width: widthDevice * 0.48,
                                                  height: 200,
                                                  fit: BoxFit.fitWidth),
                                          imageBuilder: (context,
                                                  imageProvider) =>
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10)),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ),
                                              ),
                                          memCacheWidth: 200,
                                          maxHeightDiskCache: 200,
                                          maxWidthDiskCache:
                                              (widthDevice * 0.48).toInt()),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Mặt sau',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: widthDevice * 0.035,
                                          color: Colors.black,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              'Bằng cấp - Chứng chỉ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    color: Colors.black,
                                    fontSize: widthDevice * 0.035,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ), // B,,
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ...getAUserController
                                    .aUser[0].worker.certificate
                                    .map((cert) {
                                  return InstaImageViewer(
                                    child: Material(
                                      color: Colors.white,
                                      child: CachedNetworkImage(
                                          fit: BoxFit.fitWidth,
                                          width: widthDevice * 0.48,
                                          height: 200,
                                          imageUrl: cert.img,
                                          // placeholder: (context, url) =>
                                          //     const CircularProgressIndicator(strokeWidth: 5.0),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  'image/logo_tho_thong_minh.jpeg',
                                                  width: widthDevice * 0.48,
                                                  height: 200,
                                                  fit: BoxFit.fitWidth),
                                          imageBuilder: (context,
                                                  imageProvider) =>
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10)),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ),
                                              ),
                                          memCacheWidth: 200,
                                          maxHeightDiskCache: 200,
                                          maxWidthDiskCache:
                                              (widthDevice * 0.48).toInt()),
                                    ),
                                  );
                                }),
                                // Material(
                                //   color: Colors.white,
                                //   child: InkWell(
                                //     onTap: () {
                                //       showOverlay(getAUserController
                                //           .aUser[0].worker.certificate[1].img);
                                //     },
                                //     child: CachedNetworkImage(
                                //         fit: BoxFit.fitWidth,
                                //         width: widthDevice * 0.48,
                                //         height: 200,
                                //         imageUrl: getAUserController
                                //             .aUser[0].worker.certificate[1].img,
                                //         // placeholder: (context, url) =>
                                //         //     const CircularProgressIndicator(strokeWidth: 5.0),
                                //         errorWidget: (context, url, error) =>
                                //             Image.asset(
                                //                 'image/logo_tho_thong_minh.jpeg',
                                //                 width: widthDevice * 0.48,
                                //                 height: 200,
                                //                 fit: BoxFit.fitWidth),
                                //         imageBuilder: (context, imageProvider) =>
                                //             Container(
                                //               decoration: BoxDecoration(
                                //                 borderRadius:
                                //                     const BorderRadius.only(
                                //                         topLeft:
                                //                             Radius.circular(10),
                                //                         topRight:
                                //                             Radius.circular(10)),
                                //                 image: DecorationImage(
                                //                   image: imageProvider,
                                //                   fit: BoxFit.fitWidth,
                                //                 ),
                                //               ),
                                //             ),
                                //         memCacheWidth: 200,
                                //         maxHeightDiskCache: 200,
                                //         maxWidthDiskCache:
                                //             (widthDevice * 0.48).toInt()),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: MaterialButton(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 10),
                              elevation: 10.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              height: 40.0,
                              minWidth: 100.0,
                              color: const Color.fromRGBO(38, 166, 83, 1),
                              child: Text(
                                'Cập nhật tài khoản',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: widthDevice * 0.035,
                                      color: Colors.white,
                                    ),
                              ), // B,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) =>
                                        const CapNhatTaiKhoanScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 75,
                left: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: img.image,
                  ),
                ),
              ),
            ],
          );
  }
}
