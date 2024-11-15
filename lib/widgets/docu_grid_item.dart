import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:chotot/models/cho_do_cu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chotot/screens/thongTinSanPham.dart';
// import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DoCuGridItem extends StatefulWidget {
  const DoCuGridItem({
    super.key,
    required this.docu,
  });
  final DoCu docu;

  @override
  State<DoCuGridItem> createState() => _DoCuGridItemState();
}

class _DoCuGridItemState extends State<DoCuGridItem> {
  // bool isLoading = true;
  @override
  void initState() {
    // Timer(const Duration(seconds: 6), () {
    //   setState(() {
    //     isLoading = false;
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Widget centerLoading = const Center(
    //   child: CircularProgressIndicator(),
    // );
    final widthDevice = MediaQuery.of(context).size.width;
    final priceReverse = StringUtils.addCharAtPosition(
        StringUtils.reverse(widget.docu.price), ".", 3,
        repeat: true);
    DateTime dateTime = DateTime.parse(widget.docu.createdAt);

    // Create a DateFormat instance
    DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");

    // Format the DateTime
    String formattedDate = dateFormat.format(dateTime.toLocal());
    var nameStuff = widget.docu.name.contains('-')
        ? widget.docu.name.substring(0, widget.docu.name.indexOf('-'))
        : widget.docu.name;

    // final dateTime = widget.docu.name.contains('-')
    //     ? widget.docu.name.substring(widget.docu.name.indexOf('-'))
    //     : widget.docu.name;

    // final date = dateTime.contains(' ')
    //     ? dateTime.substring(1, dateTime.lastIndexOf(' '))
    //     : dateTime;

    return
        // isLoading
        //     ? centerLoading
        //     :
        GestureDetector(
      onTap: () {
        // Get.to(
        //   ThongTinSanPhamScreen(
        //     docu: widget.docu,
        //   ),
        // );

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ThongTinSanPhamScreen(
                docu: widget.docu,
              ),
            ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(127, 158, 158, 158)),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center(
            //   child: AspectRatio(
            //     aspectRatio: 487 / 451,
            //     child: Container(
            //       clipBehavior: Clip.antiAlias,
            //       decoration: BoxDecoration(
            //         borderRadius: const BorderRadius.only(
            //             topLeft: Radius.circular(10),
            //             topRight: Radius.circular(10)),
            //         image: DecorationImage(
            //             fit: BoxFit.cover,
            //             alignment: FractionalOffset.topCenter,
            //             image: CachedNetworkImage(
            //               imageUrl: widget.docu.photos[0].split('"').join(''),
            //             )),
            //       ),
            //       width: 400,
            //       height: 400,
            //       child: const SizedBox(),
            //     ),
            //   ),
            // ),
            AspectRatio(
              aspectRatio: 487 / 451,
              child: CachedNetworkImage(
                  imageUrl: widget.docu.photos[0].split('"').join(''),
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
                  errorWidget: (context, url, error) =>
                      Image.asset('image/logo_tho_thong_minh.jpeg'),
                  placeholder: (context, url) => Container(
                        alignment: Alignment.center,
                        child: Center(
                          child: LoadingAnimationWidget.waveDots(
                            color: const Color.fromRGBO(1, 142, 33, 1),
                            size: 30,
                          ),
                        ),
                      ),
                  memCacheWidth: 200,
                  maxHeightDiskCache: 200,
                  maxWidthDiskCache: 200),
            ),

            Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(nameStuff,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: widthDevice * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Giá bán:',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: widthDevice * 0.028,
                              color: Colors.black,
                            ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          widget.docu.price == 'Giá liên hệ'
                              ? 'Giá liên hệ'
                              : '${StringUtils.reverse(priceReverse)} VNĐ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: Colors.red,
                                fontWeight: FontWeight.w900,
                                fontSize: widthDevice * 0.028,
                              ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.locationPin,
                        size: 15,
                        color: Color.fromRGBO(39, 166, 82, 1),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.docu.province,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: widthDevice * 0.03,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.clock,
                        size: 15,
                        color: Color.fromRGBO(39, 166, 82, 1),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: widthDevice * 0.03,
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
    );
  }
}

//  Card(
//               clipBehavior: Clip.antiAlias,
//               borderOnForeground: false,
//               semanticContainer: false,
//               elevation: 0,
//               color: Colors.transparent,
//               child: Image.network(
//                 docu.photos[0].split('"').join(''),
//                 width: 200,
//                 height: 300,
//                 scale: 1.5,
//               ),
//             ),



//  NetworkImage(
//                         widget.docu.photos[0].split('"').join(''),
//                         scale: 2,
//                       ),