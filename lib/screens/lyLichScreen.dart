import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chotot/screens/capNhatTaiKhoan.dart';

import 'package:chotot/data/ly_lich.dart';
import 'package:chotot/controllers/get_ly_lich.dart';

class LyLichScreen extends StatefulWidget {
  const LyLichScreen({
    super.key,
  });

  @override
  State<LyLichScreen> createState() => _LyLichScreenState();
}

class _LyLichScreenState extends State<LyLichScreen> {
  LyLichController lyLichController = Get.put(LyLichController());

  Image img = Image.network(lyLichInfo[0].profileImage);
  void showOverlay(str) {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.all(20),
            children: [
              Image.asset(str),
            ],
          );
        });
  }

  @override
  void initState() {
    lyLichController.getInfo();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              ),
              Positioned(
                  top: 40,
                  left: 10,
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back))),
              Positioned(
                top: 150,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.45,
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
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.only(left: 15),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Địa chỉ:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        fontFamily:
                                            GoogleFonts.montserrat().fontFamily,
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
                                        fontFamily:
                                            GoogleFonts.montserrat().fontFamily,
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
                                        GoogleFonts.montserrat().fontFamily,
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
                                      GoogleFonts.montserrat().fontFamily,
                                  color: Colors.black26,
                                ),
                            textAlign: TextAlign.start,
                          ),
                        ]),
                        const SizedBox(height: 10),
                        Row(children: [
                          Text(
                            'Email:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
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
                                      GoogleFonts.montserrat().fontFamily,
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
                                        GoogleFonts.montserrat().fontFamily,
                                    color: Colors.black),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${lyLichInfo[0].wallet} VNĐ',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontFamily:
                                      GoogleFonts.montserrat().fontFamily,
                                  color: Colors.black26,
                                ),
                            textAlign: TextAlign.start,
                          ),
                        ]),
                        const SizedBox(height: 30),
                        Center(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(255, 2, 219, 134),
                              side: const BorderSide(
                                color: Color.fromARGB(255, 2, 219, 134),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                            ),
                            child: Text(
                              'Cập nhật tài khoản',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
                                    color:
                                        const Color.fromARGB(255, 2, 219, 134),
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
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFBFE299),
                      Color(0xFF66B5F6),
                    ],
                    stops: [0.0, 0.74], // 0% and 74%
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
                      icon: const Icon(Icons.arrow_back))),
              Positioned(
                top: 150,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.45,
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
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                            ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
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
                          '60.0',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                color: Colors.white,
                                fontFamily: GoogleFonts.montserrat().fontFamily,
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
                  height: MediaQuery.of(context).size.height * 0.45,
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
                                          GoogleFonts.montserrat().fontFamily,
                                      color: Colors.black),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '123123123',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
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
                                          GoogleFonts.montserrat().fontFamily,
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
                                      fontFamily:
                                          GoogleFonts.montserrat().fontFamily,
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
                                          GoogleFonts.montserrat().fontFamily,
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
                                        GoogleFonts.montserrat().fontFamily,
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
                                          GoogleFonts.montserrat().fontFamily,
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
                                        GoogleFonts.montserrat().fontFamily,
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
                                          GoogleFonts.montserrat().fontFamily,
                                      color: Colors.black),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${lyLichInfo[0].wallet} VNĐ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
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
                                        GoogleFonts.montserrat().fontFamily,
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
                                  Material(
                                    child: InkWell(
                                      onTap: () {
                                        showOverlay('image/the-can-cuoc.png');
                                      },
                                      child: Image.asset(
                                        'image/the-can-cuoc.png',
                                        width: 150,
                                        height: 100,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Mặt trước',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontFamily: GoogleFonts.montserrat()
                                              .fontFamily,
                                          color: Colors.black,
                                        ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Material(
                                    child: InkWell(
                                      onTap: () {
                                        showOverlay(
                                            'image/the-can-cuoc-mat-sau.png');
                                      },
                                      child: Image.asset(
                                        'image/the-can-cuoc-mat-sau.png',
                                        width: 150,
                                        height: 100,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Mặt sau',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontFamily: GoogleFonts.montserrat()
                                              .fontFamily,
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
                              'Tiểu sử - Kinh nghiệm làm việc',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ), // B,,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Material(
                                child: InkWell(
                                  onTap: () {
                                    showOverlay('image/profile.jpg');
                                  },
                                  child: Image.asset(
                                    'image/profile.jpg',
                                    width: 150,
                                    height: 200,
                                  ),
                                ),
                              ),
                              Material(
                                child: InkWell(
                                  onTap: () {
                                    showOverlay('image/profile.jpg');
                                  },
                                  child: Image.asset(
                                    'image/profile.jpg',
                                    width: 150,
                                    height: 200,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    const Color.fromARGB(255, 2, 219, 134),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 2, 219, 134),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                              ),
                              child: Text(
                                'Cập nhật tài khoản',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.montserrat().fontFamily,
                                      color: const Color.fromARGB(
                                          255, 2, 219, 134),
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
