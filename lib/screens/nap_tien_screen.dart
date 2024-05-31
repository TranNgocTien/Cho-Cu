import 'dart:async';

// import 'package:basic_utils/basic_utils.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/controllers/get_orders_user.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/data/get_orders_user_data.dart';

import 'package:chotot/data/ly_lich.dart';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:chotot/screens/PDF_View.dart';

import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';

import 'package:url_launcher/url_launcher.dart';

class NapTienScreen extends StatefulWidget {
  const NapTienScreen({super.key});

  @override
  State<NapTienScreen> createState() => _NapTienScreenState();
}

class _NapTienScreenState extends State<NapTienScreen>
    with SingleTickerProviderStateMixin {
  // NapTienController napTienController = Get.put(NapTienController());
  LoginController loginController = Get.put(LoginController());
  TextEditingController amountController = TextEditingController();
  late AnimationController _animationController;
  TextEditingController orderInfoController = TextEditingController(text: '');
  GetOrdersUser getOrdersUser = Get.put(GetOrdersUser());
  bool onLoading = false;
  bool isLoading = true;
  var currentIndex = 0;
  var tempOrderInfo = '';
  var isAgree = false;
  String pathPDF = "";

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  getData() async {
    await getOrdersUser.getOrdersUser(
      currentIndex,
    );
    if (ordersUser.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  List<String> pricePaySuggestion = ['100.000', '200.000', '500.000'];

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0,
      upperBound: 1,
    );

    currentIndex = 0;
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
    _animationController.forward();

    fromAsset(
      'image/CSTT.pdf',
      'CSTT.pdf',
    ).then((f) {
      setState(() {
        pathPDF = f.path;
      });
    });
    super.initState();
  }

  Widget centerLoading = Center(
    child: LoadingAnimationWidget.waveDots(
      color: const Color.fromRGBO(1, 142, 33, 1),
      size: 30,
    ),
  );
  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
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
        backgroundColor: Colors.white,
        appBar: AppBar(
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
          centerTitle: true,
          title: Text(
            'Nạp tiền',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Nạp Tiền',
                //     style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                //         fontFamily: GoogleFonts.poppins().fontFamily,
                //         color: Colors.black87)),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Số tiền cần nạp: ',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: const Color.fromARGB(255, 185, 184, 184)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                    child: TextFormField(
                      enabled: true,
                      controller: amountController,
                      decoration: const InputDecoration(
                        hintText: '0',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      onChanged: (str) {
                        // var price = int.parse(str);
                        // var comma = NumberFormat('###,###,###,###');
                        // TextController.text =
                        //     comma.format(price).replaceAll(' ', '');
                        setState(() {
                          tempOrderInfo =
                              'Nap tien cho tai khoan ${lyLichInfo[0].phone}. So tien: ${amountController.text} VND';
                          orderInfoController.text = tempOrderInfo;
                        });
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isNum ||
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
                const SizedBox(
                  height: 30,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...pricePaySuggestion.map((price) {
                        return GestureDetector(
                          onTap: () {
                            amountController.text = price.replaceAll('.', '');
                            setState(() {
                              tempOrderInfo =
                                  'Nap tien cho tai khoan ${lyLichInfo[0].phone}. So tien: ${amountController.text} VND';
                              orderInfoController.text = tempOrderInfo;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            color: const Color.fromARGB(255, 192, 244, 210),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            child: Text(
                              '$price Đ',
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Nội dung nạp tiền',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontFamily: GoogleFonts.poppins().fontFamily,
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
                    padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                    child: TextFormField(
                      controller: orderInfoController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: '...',
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
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: <Widget>[
                    //SizedBox
                    TextButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PDFScreen(path: pathPDF)));
                      },
                      child: Text(
                        'Chính sách bảo mật',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: const Color.fromRGBO(38, 166, 83, 1),
                            ),
                      ),
                    ),
                    const SizedBox(width: 10), //SizedBox
                    /** Checkbox Widget **/
                    Checkbox(
                      activeColor: const Color.fromRGBO(38, 166, 83, 1),
                      value: isAgree,
                      onChanged: (bool? value) {
                        setState(() {
                          isAgree = value!;
                        });
                      },
                    ), //Checkbox
                  ], //<Widget>[]
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: MaterialButton(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    height: 40.0,
                    minWidth: 100.0,
                    color: const Color.fromRGBO(38, 166, 83, 1),
                    onPressed: () {
                      isAgree == false
                          ? AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              title:
                                  'Vui lòng xem và chấp nhận chính sách bảo mật trước khi nạp tiền',
                              titleTextStyle: GoogleFonts.poppins(),
                            ).show()
                          : _launchUrl(Uri.parse(
                              'https://vstserver.com/services/get_vnpay_payment/${loginController.hostId}?token=anhkhongdoiqua&amount=${amountController.text}&order_info=${orderInfoController.text}'));
                    },
                    child: Text(
                      'Nạp tiền',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Text(
                  'Lịch sử nạp tiền',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: const Color.fromRGBO(38, 166, 83, 1),
                      ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: isLoading
                      ? centerLoading
                      : ordersUser.isNotEmpty
                          ? AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) => SlideTransition(
                                position: Tween(
                                  begin: const Offset(0, 1),
                                  end: const Offset(0, 0),
                                ).animate(
                                  CurvedAnimation(
                                      parent: _animationController,
                                      curve: Curves.easeInOut),
                                ),
                                child: child,
                              ),
                              child: RefreshLoadmore(
                                onRefresh: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  ordersUser.clear();
                                  currentIndex = 1;

                                  _animationController.forward();

                                  getData();
                                },
                                noMoreWidget: Center(
                                  child: Text(
                                    'Không còn lịch sử giao dịch',
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                                onLoadmore: () async {
                                  if (onLoading == false) {
                                    currentIndex += 1;
                                    await getData();
                                    // await getOrdersUser
                                    //     .getOrdersUser(currentIndex);
                                    if (mounted) {
                                      setState(() {
                                        // _animationController.forward();
                                      });
                                    }
                                  }
                                },
                                isLastPage: getOrdersUser.isLastPage,
                                child: ordersUser.isNotEmpty
                                    ? SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            ...ordersUser.map(
                                              (order) {
                                                // final priceReverse =
                                                //     StringUtils
                                                //         .addCharAtPosition(
                                                //             StringUtils.reverse(
                                                //               order.amountOrder
                                                //                           .length >
                                                //                       2
                                                //                   ? order
                                                //                       .amountOrder
                                                //                       .substring(
                                                //                           0,
                                                //                           order.amountOrder.length -
                                                //                               2)
                                                //                   : order
                                                //                       .amountOrder,
                                                //             ),
                                                //             ".",
                                                //             3,
                                                //             repeat: true);
                                                var dateTime = DateTime.parse(
                                                        order.createAt)
                                                    .toLocal();

                                                return order.status ==
                                                        "Giao dịch thành công"
                                                    ? Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.1,
                                                        margin: const EdgeInsets
                                                            .only(bottom: 10.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: const Color
                                                                .fromRGBO(
                                                                38, 166, 83, 1),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            const SizedBox(
                                                                width: 5.0),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.2,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    '${dateTime.hour < 10 ? 0 : ''}${dateTime.hour}:${dateTime.minute < 10 ? 0 : ''}${dateTime.minute}',
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontSize:
                                                                          11,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '${dateTime.day < 10 ? 0 : ''}${dateTime.day}/${dateTime.month < 10 ? 0 : ''}${dateTime.month}/${dateTime.year}',
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontSize:
                                                                          11,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.05,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                border: Border(
                                                                  right:
                                                                      BorderSide(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                      38,
                                                                      166,
                                                                      83,
                                                                      1,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 10.0),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.5,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    order
                                                                        .orderInfo,
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            11),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 11,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.05,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                border: Border(
                                                                  right:
                                                                      BorderSide(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                      38,
                                                                      166,
                                                                      83,
                                                                      1,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 10.0),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.1,
                                                              child: Text(
                                                                order.supplier,
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 11,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : const SizedBox();
                                              },
                                            ).toList(),
                                          ],
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                            'Không còn lịch sử giao dịch',
                                            style: GoogleFonts.poppins()),
                                      ),
                              ),
                            )
                          : Center(
                              child: Text(
                                'không có lịch sử giao dịch',
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
