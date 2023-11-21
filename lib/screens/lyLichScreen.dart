import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chotot/screens/capNhatTaiKhoan.dart';

class LyLichScreen extends StatefulWidget {
  const LyLichScreen({super.key});

  @override
  State<LyLichScreen> createState() => _LyLichScreenState();
}

class _LyLichScreenState extends State<LyLichScreen> {
  Image img = Image.asset('image/positive-asian-man-pointing-finger-aside.jpg');
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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.2,
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
                  'Name',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.black),
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
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 2, 219, 134),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 2, 219, 134),
                        ),
                      ),
                      child: Text(
                        'Nhập mã voucher',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontFamily: GoogleFonts.rubik().fontFamily,
                                  color: const Color.fromARGB(255, 2, 219, 134),
                                ),
                      ), // B,
                      onPressed: () {},
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 2, 219, 134),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 2, 219, 134),
                        ),
                      ),
                      child: Text(
                        'Mua voucher',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontFamily: GoogleFonts.rubik().fontFamily,
                                  color: const Color.fromARGB(255, 2, 219, 134),
                                ),
                      ), // B,
                      onPressed: () {},
                    ),
                  ],
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
                                fontFamily: GoogleFonts.rubik().fontFamily,
                                color: Colors.black),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '123123123',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontFamily: GoogleFonts.rubik().fontFamily,
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
                                fontFamily: GoogleFonts.rubik().fontFamily,
                                color: Colors.black),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                          '38 Đường Mai Đức Thọ, An Phú, Quận 2, Thành phố Hồ Chí Minh, Việt Nam',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontFamily: GoogleFonts.rubik().fontFamily,
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
                                fontFamily: GoogleFonts.rubik().fontFamily,
                                color: Colors.black),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '0979757026',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontFamily: GoogleFonts.rubik().fontFamily,
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
                                fontFamily: GoogleFonts.rubik().fontFamily,
                                color: Colors.black),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '--',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontFamily: GoogleFonts.rubik().fontFamily,
                                  color: Colors.black26,
                                ),
                        textAlign: TextAlign.start,
                      ),
                    ]),
                    Center(
                      child: Text(
                        'Ảnh CMND/CCCD',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontFamily: GoogleFonts.rubik().fontFamily,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                      ), // B,,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  width: 200,
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
                                    fontFamily: GoogleFonts.rubik().fontFamily,
                                    color: Colors.black,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Column(
                          children: [
                            Material(
                              child: InkWell(
                                onTap: () {
                                  showOverlay('image/the-can-cuoc-mat-sau.png');
                                },
                                child: Image.asset(
                                  'image/the-can-cuoc-mat-sau.png',
                                  width: 200,
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
                                    fontFamily: GoogleFonts.rubik().fontFamily,
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
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontFamily: GoogleFonts.rubik().fontFamily,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                      ), // B,,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Material(
                          child: InkWell(
                            onTap: () {
                              showOverlay('image/profile.jpg');
                            },
                            child: Image.asset(
                              'image/profile.jpg',
                              width: 200,
                              height: 200,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Material(
                          child: InkWell(
                            onTap: () {
                              showOverlay('image/profile.jpg');
                            },
                            child: Image.asset(
                              'image/profile.jpg',
                              width: 200,
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
                                fontFamily: GoogleFonts.rubik().fontFamily,
                                color: const Color.fromARGB(255, 2, 219, 134),
                              ),
                        ), // B,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const CapNhatTaiKhoanScreen(),
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
          left: 130,
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
