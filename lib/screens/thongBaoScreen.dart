import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:chotot/controllers/get_notis.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chotot/data/noti_data.dart';
import 'package:intl/intl.dart';

class ThongBaoScreen extends StatefulWidget {
  const ThongBaoScreen({super.key});
  static const route = '/lib/screens/thongBaoScreen.dart';
  @override
  State<ThongBaoScreen> createState() => _ThongBaoScreenState();
}

class _ThongBaoScreenState extends State<ThongBaoScreen>
    with SingleTickerProviderStateMixin {
  NotiController notiController = Get.put(NotiController());
  LoginController loginController = Get.put(LoginController());
  late AnimationController _animationController;

  int index = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();
    if (loginController.tokenString != '') {
      getData();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  getData() async {
    notification.clear();
    await notiController.getNoti(index);
    if (notification.isNotEmpty) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Thông báo',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontFamily: GoogleFonts.montserrat().fontFamily),
          ),
        ),
        body: loginController.tokenString == ''
            ? Center(
                child: Card(
                  color: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Vui lòng đăng nhập để sử dụng dịch vụ',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                              onPressed: () {
                                Get.to(() => const LoginScreen());
                              },
                              child: Text(
                                'Đăng nhập',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        fontFamily:
                                            GoogleFonts.lato().fontFamily,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green),
                              )),
                        ]),
                  ),
                ),
              )
            : notification.isNotEmpty
                ? AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) => SlideTransition(
                      position: Tween(
                        begin: const Offset(0, 0.4),
                        end: const Offset(0, 0),
                      ).animate(
                        CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeInOut),
                      ),
                      child: child,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...notification
                              .map(
                                (i) => Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Card(
                                      color: Colors.transparent,
                                      elevation: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            right: BorderSide(
                                              color: i.actionType == 'host_fee'
                                                  ? Colors.redAccent
                                                  : Colors.green,
                                              width: 10,
                                            ),
                                            left: BorderSide(
                                              color: i.actionType == 'host_fee'
                                                  ? Colors.redAccent
                                                  : Colors.green,
                                              width: 1,
                                            ),
                                            top: BorderSide(
                                              color: i.actionType == 'host_fee'
                                                  ? Colors.redAccent
                                                  : Colors.green,
                                              width: 1,
                                            ),
                                            bottom: BorderSide(
                                              color: i.actionType == 'host_fee'
                                                  ? Colors.redAccent
                                                  : Colors.green,
                                              width: 1,
                                            ),
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: ListTile(
                                          leading: Text(
                                            DateFormat.yMd().format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                int.parse(
                                                  i.time,
                                                ),
                                              ),
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .copyWith(
                                                  fontFamily:
                                                      GoogleFonts.montserrat()
                                                          .fontFamily,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                          title: Text(
                                            i.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontFamily:
                                                      GoogleFonts.montserrat()
                                                          .fontFamily,
                                                ),
                                          ),
                                          subtitle: Text(
                                            i.message,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  fontFamily:
                                                      GoogleFonts.montserrat()
                                                          .fontFamily,
                                                  color: Colors.grey,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    index = (index == 0 ? index : index - 1);
                                    getData();
                                  });
                                },
                                child: const Icon(Icons.arrow_left,
                                    size: 30, color: Colors.black),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: null,
                                child: Text(
                                  '${index + 1}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontFamily:
                                            GoogleFonts.montserrat().fontFamily,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (notification.length < 10) return;
                                      index += 1;
                                      getData();
                                    });
                                  },
                                  child: const Icon(Icons.arrow_right,
                                      size: 30, color: Colors.black)),
                            ],
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ));
  }
}
