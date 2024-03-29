import 'package:basic_utils/basic_utils.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:chotot/models/cho_do_cu.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chotot/controllers/stuff_sold_out.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ThongTinSanPhamScreen extends StatefulWidget {
  const ThongTinSanPhamScreen({super.key, required this.docu});
  final DoCu docu;

  @override
  State<ThongTinSanPhamScreen> createState() => _ThongTinSanPhamScreenState();
}

class _ThongTinSanPhamScreenState extends State<ThongTinSanPhamScreen> {
  LoginController loginController = Get.put(LoginController());

  SoldOutStuffs soldOut = Get.put(SoldOutStuffs());
  Future<void> _makePhoneCall(String phoneNumber, String method) async {
    final Uri launchUri = Uri(
      scheme: method,
      path: phoneNumber,
    );
    await launchUrl(launchUri);
    Get.back();
  }

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
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.2,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.black))),
                    child: Text(
                      'Liên hệ:',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _makePhoneCall(widget.docu.phone, 'sms');
                        },
                        child: Column(
                          children: [
                            const Icon(FontAwesomeIcons.message,
                                color: Color.fromARGB(255, 2, 219, 134)),
                            const SizedBox(height: 5),
                            Text(
                              'Tin nhắn',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          _makePhoneCall(widget.docu.phone, 'tel');
                        },
                        child: Column(
                          children: [
                            const Icon(FontAwesomeIcons.phone,
                                color: Color.fromARGB(255, 2, 219, 134)),
                            const SizedBox(height: 5),
                            Text(
                              'Gọi trực tiếp',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
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

  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    var dateSubmit = widget.docu.name
        .substring(widget.docu.name.indexOf('-'))
        .replaceFirst('-', '');
    var nameStuff =
        widget.docu.name.substring(0, widget.docu.name.indexOf('-'));
    final priceReverse = StringUtils.addCharAtPosition(
        StringUtils.reverse(widget.docu.price), ".", 3,
        repeat: true);
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
                          fontFamily: GoogleFonts.montserrat().fontFamily,
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
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        fontSize: 15,
                      ),
                ),
        )
      ]),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white12,
          ),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 300.0,
                    autoPlay: true,
                    enableInfiniteScroll: false,
                    viewportFraction: 0.95,
                  ),
                  items: widget.docu.photos.map((photo) {
                    return InstaImageViewer(
                      child: Container(
                        // margin: const EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.2,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Center(
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
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
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
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ]);
                            },
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        widthFactor: double.infinity,
                        child: Text(
                          nameStuff,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 25,
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                              ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
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
                                        GoogleFonts.montserrat().fontFamily,
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
                                        GoogleFonts.montserrat().fontFamily,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
                                  ),
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
                                    color: Colors.grey,
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
                                  ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Giá mong muốn:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily:
                                          GoogleFonts.montserrat().fontFamily,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                child: Text(
                                  '${StringUtils.reverse(priceReverse)} Đ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Colors.grey,
                                        fontSize: 20,
                                        fontFamily:
                                            GoogleFonts.montserrat().fontFamily,
                                      ),
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
                      const SizedBox(height: 15),
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
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                              ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: Flex(direction: Axis.horizontal, children: [
                          Flexible(
                            child: Text(
                              widget.docu.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Colors.grey,
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
                                  ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: OutlinedButton(
                          onPressed: loginController.tokenString != ''
                              ? () {
                                  widget.docu.status == 'sold_out'
                                      ? showDialog(
                                          context: Get.context!,
                                          builder: (context) {
                                            return const SimpleDialog(
                                              contentPadding:
                                                  EdgeInsets.all(20),
                                              children: [
                                                Center(
                                                  child: Text(
                                                    'Sản phẩm đã bán',
                                                  ),
                                                ),
                                              ],
                                            );
                                          })
                                      : _showContactMethod(context);
                                }
                              : () {
                                  showDialog(
                                      context: Get.context!,
                                      builder: (context) {
                                        return SimpleDialog(
                                          title: const Text(
                                            'Vui lòng đăng nhập',
                                            textAlign: TextAlign.center,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(20),
                                          children: [
                                            Center(
                                              child: TextButton(
                                                  onPressed: () {
                                                    Get.to(() =>
                                                        const LoginScreen());
                                                  },
                                                  child:
                                                      const Text('Đăng nhập')),
                                            ),
                                          ],
                                        );
                                      });
                                },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                width: 1.0,
                                color: Color.fromRGBO(5, 109, 101, 1)),
                            backgroundColor: Colors.white,
                          ),
                          child: Text(
                            'Liên hệ',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily:
                                      GoogleFonts.montserrat().fontFamily,
                                ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
