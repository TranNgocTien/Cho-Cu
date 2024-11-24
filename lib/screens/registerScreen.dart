import 'dart:async';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chotot/controllers/registeration_controller.dart';
import 'package:chotot/screens/PDF_View.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // final Uri _url =
  //     Uri.parse('//https://www.thothongminh.com/chinh-sach-bao-mat');
  final _form = GlobalKey<FormState>();
  var isAgree = false;
  final token = "anhkhongdoiqua";
  String pathPDF = "";
  // Future<void> _launchUrl() async {
  //   if (!await launchUrl(_url)) {
  //     throw Exception('Could not launch $_url');
  //   }
  // }

  RegisterationController registerController =
      Get.put(RegisterationController());
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

  @override
  void initState() {
    fromAsset(
      'image/chinh_sach_bao_mat.pdf',
      'chinh_sach_bao_mat.pdf',
    ).then((f) {
      setState(() {
        pathPDF = f.path;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 300,
                child: Image.asset(
                  'image/logo_tho_thong_minh.jpeg',
                ),
              ),
              const SizedBox(height: 50),
              // SizedBox(
              //   width: double.infinity,
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(
              //       vertical: 8,
              //       horizontal: 25,
              //     ),
              //     child: Text(
              //       'Login',
              //       textAlign: TextAlign.start,
              //       style: Theme.of(context).textTheme.titleLarge!.copyWith(
              //             fontFamily: GoogleFonts.rubik().fontFamily,
              //             fontWeight: FontWeight.bold,
              //             fontSize: 25,
              //             color: const Color.fromRGBO(8, 14, 10, 1),
              //           ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(
                    16,
                  ),
                  child: Form(
                    key: _form,
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 192, 244, 210),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 15, right: 15),
                            child: TextFormField(
                              controller: registerController.nameController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  label: Row(
                                    children: [
                                      const Icon(FontAwesomeIcons.person),
                                      const SizedBox(width: 20),
                                      Text(
                                        'Họ và tên',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                            ),
                                      ),
                                    ],
                                  )),
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length <= 1) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Name is required!'),
                                    ),
                                  );
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 192, 244, 210),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 15, right: 15),
                            child: TextFormField(
                              controller: registerController.addressController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  label: Row(
                                    children: [
                                      const Icon(FontAwesomeIcons.user),
                                      const SizedBox(width: 20),
                                      Text(
                                        'Địa chỉ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                            ),
                                      ),
                                    ],
                                  )),
                              keyboardType: TextInputType.streetAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length <= 1) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Address is required!'),
                                    ),
                                  );
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 192, 244, 210),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 15, right: 15),
                            child: TextFormField(
                              controller: registerController.passwordController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  label: Row(
                                    children: [
                                      const Icon(FontAwesomeIcons.user),
                                      const SizedBox(width: 20),
                                      Text(
                                        'Mật khẩu',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                            ),
                                      ),
                                    ],
                                  )),
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length <= 1) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Password is required!'),
                                    ),
                                  );
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 192, 244, 210),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 15, right: 15),
                            child: TextFormField(
                              controller:
                                  registerController.rePasswordController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  label: Row(
                                    children: [
                                      const Icon(FontAwesomeIcons.user),
                                      const SizedBox(width: 20),
                                      Text(
                                        'Nhập lại mật khẩu',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                            ),
                                      ),
                                    ],
                                  )),
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length <= 1) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Password is required!'),
                                    ),
                                  );
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: <Widget>[
                            //SizedBox
                            TextButton(
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            PDFScreen(path: pathPDF)));
                              },
                              child: Text(
                                'Chính sách bảo mật',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color:
                                          const Color.fromRGBO(38, 166, 83, 1),
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
                        ), //Row
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (isAgree == false) {
                              AwesomeDialog(
                                context: Get.context!,
                                dialogType: DialogType.warning,
                                animType: AnimType.rightSlide,
                                title: 'Vui lòng chấp nhận chính sách bảo mật',
                                titleTextStyle: GoogleFonts.poppins(),
                                autoHide: const Duration(milliseconds: 800),
                              ).show();
                            }

                            isAgree == false
                                ? null
                                : registerController.registerAccount();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(38, 166, 83, 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 16.0),
                            child: Text(
                              'Đăng ký tài khoản',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                    color: Colors.white,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
