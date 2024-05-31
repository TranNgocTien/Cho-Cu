import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chotot/controllers/deactive_user.dart';
import 'package:chotot/data/ly_lich.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DeactiveUserScreen extends StatefulWidget {
  const DeactiveUserScreen({super.key});

  @override
  State<DeactiveUserScreen> createState() => _DeactiveUserScreenState();
}

class _DeactiveUserScreenState extends State<DeactiveUserScreen>
    with TickerProviderStateMixin {
  final _formkey = GlobalKey<FormState>();
  late TabController _controller;
  List<Widget> tabList = [
    Tab(
      child: Text(
        "Nhập mật khẩu",
        style: GoogleFonts.poppins(
          fontSize: 15,
        ),
      ),
    ),
    Tab(
      child: Text(
        "Nhập mã OTP",
        style: GoogleFonts.poppins(
          fontSize: 15,
        ),
      ),
    ),
  ];

  @override
  void initState() {
    _controller = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
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
          title: Text(
            'Xóa tài khoản',
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
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 15,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 65,
                      backgroundColor: const Color.fromRGBO(39, 166, 82, 1),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            NetworkImage(lyLichInfo[0].profileImage),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      lyLichInfo[0].name,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Tạm thời vô hiệu hóa tài khoản của bạn thay vì xóa tài khoản',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        'Sau 30 ngày khi vô hiệu hóa tài khoản nếu không kích hoạt lại, tài khoản sẽ bị xóa',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Card(
                        child: Container(
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
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      child: Column(
                        children: [
                          TabBar(
                              dividerColor: Colors.grey,
                              labelColor: Colors.white,
                              indicatorColor:
                                  const Color.fromRGBO(38, 166, 83, 1),
                              indicatorSize: TabBarIndicatorSize.label,
                              unselectedLabelColor: Colors.grey,
                              onTap: (index) {
                                // setState(() {});
                              },
                              isScrollable: false,
                              controller: _controller,
                              tabs: tabList),
                        ],
                      ),
                    )),
                    Card(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: TabBarView(
                          controller: _controller,
                          children: [
                            DeactiveUserTabPassword(
                              formkey: _formkey,
                            ),
                            DeactiveUserTabOTP(
                              formkey: _formkey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeactiveUserTabOTP extends StatelessWidget {
  const DeactiveUserTabOTP({super.key, required this.formkey});
  final dynamic formkey;
  @override
  Widget build(BuildContext context) {
    DeactiveUser deactiveUser = Get.put(DeactiveUser());
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 192, 244, 210),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      controller: deactiveUser.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        label: Row(
                          children: [
                            const Icon(FontAwesomeIcons.phone),
                            const SizedBox(width: 20),
                            Text(
                              'Nhập sô điện thoại',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length > 10) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Vui lòng nhập số điện thoại!'),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 192, 244, 210),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: deactiveUser.otp,
                      keyboardType: TextInputType.phone,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          label: Row(
                            children: [
                              const Icon(FontAwesomeIcons.penClip),
                              const SizedBox(width: 20),
                              Text(
                                'Nhập mã otp',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                    ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  TextButton(
                      child: Text(
                        'Gửi mã OTP',
                        style: GoogleFonts.poppins(
                          color: const Color.fromRGBO(39, 166, 82, 1),
                          fontSize: 15,
                        ),
                      ),
                      onPressed: () {
                        if (deactiveUser.phone.text == '') {
                          AwesomeDialog(
                            context: Get.context!,
                            dialogType: DialogType.warning,
                            animType: AnimType.scale,
                            title: 'Vui lòng nhập số điện thoại',
                            titleTextStyle: GoogleFonts.poppins(),
                            autoHide: const Duration(milliseconds: 800),
                          ).show();
                          return;
                        }
                        deactiveUser.getOtp();
                      }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          MaterialButton(
            onPressed: () {
              if (deactiveUser.otp.text == '') {
                AwesomeDialog(
                  context: Get.context!,
                  dialogType: DialogType.warning,
                  animType: AnimType.scale,
                  title: 'Vui lòng nhập đủ thông tin ',
                  titleTextStyle: GoogleFonts.poppins(),
                  autoHide: const Duration(milliseconds: 800),
                ).show();
                return;
              }

              deactiveUser.deactiveUser();
            },
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 40.0,
            minWidth: 200.0,
            color: const Color.fromRGBO(38, 166, 83, 1),
            child: Text(
              'Vô hiệu hóa tài khoản',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: Colors.white,
                    fontSize: 18,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeactiveUserTabPassword extends StatelessWidget {
  const DeactiveUserTabPassword({super.key, required this.formkey});
  final dynamic formkey;
  @override
  Widget build(BuildContext context) {
    DeactiveUser deactiveUser = Get.put(DeactiveUser());
    return Column(
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 192, 244, 210),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: deactiveUser.password,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        label: Row(
                          children: [
                            const Icon(FontAwesomeIcons.pen),
                            const SizedBox(width: 20),
                            Text(
                              'Nhập mật khẩu',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                  ),
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        MaterialButton(
          onPressed: () {
            if (deactiveUser.password.text == '') {
              AwesomeDialog(
                context: Get.context!,
                dialogType: DialogType.warning,
                animType: AnimType.scale,
                title: 'Vui lòng nhập đủ thông tin ',
                titleTextStyle: GoogleFonts.poppins(),
                autoHide: const Duration(milliseconds: 800),
              ).show();
              return;
            }

            deactiveUser.deactiveUser();
          },
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          height: 40.0,
          minWidth: 200.0,
          color: const Color.fromRGBO(38, 166, 83, 1),
          child: Text(
            'Vô hiệu hóa tài khoản',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Colors.white,
                  fontSize: 18,
                ),
          ),
        ),
      ],
    );
  }
}
