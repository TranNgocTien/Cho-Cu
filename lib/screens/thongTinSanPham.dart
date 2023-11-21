import 'package:chotot/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:chotot/models/cho_do_cu.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chotot/controllers/stuff_sold_out.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ThongTinSanPhamScreen extends StatefulWidget {
  const ThongTinSanPhamScreen({super.key, required this.docu});
  final DoCu docu;

  @override
  State<ThongTinSanPhamScreen> createState() => _ThongTinSanPhamScreenState();
}

class _ThongTinSanPhamScreenState extends State<ThongTinSanPhamScreen> {
  LoginController loginController = Get.put(LoginController());

  bool isFavorite = false;

  SoldOutStuffs soldOut = Get.put(SoldOutStuffs());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: loginController.hostId == widget.docu.hostId &&
                  widget.docu.status != 'sold_out'
              ? TextButton(
                  onPressed: () {
                    soldOut.soldOutStuffs(widget.docu.id);

                    setState(() {});
                  },
                  child: Text(
                    'Thông báo đã bán',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: const Color.fromRGBO(122, 191, 149, 1),
                          fontFamily: GoogleFonts.rubik().fontFamily,
                          fontSize: 15,
                        ),
                  ),
                )
              : Text(
                  widget.docu.status == 'sold_out' ? 'Đã Bán' : 'Có Sẵn',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: widget.docu.status == 'sold_out'
                            ? Colors.red
                            : const Color.fromRGBO(122, 191, 149, 1),
                        fontFamily: GoogleFonts.rubik().fontFamily,
                        fontSize: 15,
                      ),
                ),
        )
      ]),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white12,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Card(
              // color: const Color.fromRGBO(139, 233, 141, 1),
              color: Colors.grey,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 300.0,
                    enableInfiniteScroll: false,
                    autoPlay: true,
                    viewportFraction: 0.9,
                  ),
                  items: widget.docu.photos.map((photo) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Stack(children: [
                          Image.network(
                            photo.split('"').join(''),
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
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ]);
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.docu.name,
                    softWrap: true,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontFamily: GoogleFonts.rubik().fontFamily),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: Text(
                              '${widget.docu.price} VNĐ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily:
                                          GoogleFonts.rubik().fontFamily),
                            ),
                          ),
                          IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.heart,
                              size: 20,
                              color: isFavorite ? Colors.red : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
                          ),
                        ]),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                        ),
                        child: Text(
                          'Địa chỉ:',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.rubik().fontFamily),
                          textAlign: TextAlign.start,
                        ),
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
                                  color: Colors.black,
                                  fontFamily: GoogleFonts.rubik().fontFamily),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                        ),
                        child: Text(
                          softWrap: true,
                          'Số điện thoại:',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.rubik().fontFamily),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.docu.phone,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Colors.black,
                                fontFamily: GoogleFonts.rubik().fontFamily),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                        ),
                        child: Text(
                          softWrap: true,
                          'Mô tả:',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.rubik().fontFamily),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          widget.docu.description,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Colors.black,
                                  fontFamily: GoogleFonts.rubik().fontFamily),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            width: 1.0, color: Color.fromRGBO(5, 109, 101, 1)),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'Liên hệ',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.rubik().fontFamily,
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}