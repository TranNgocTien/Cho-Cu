import 'package:chotot/controllers/registeration_controller.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestOtpScreen extends StatefulWidget {
  const RequestOtpScreen({super.key});

  @override
  State<RequestOtpScreen> createState() => _RequestOtpScreenState();
}

class _RequestOtpScreenState extends State<RequestOtpScreen> {
  final _form = GlobalKey<FormState>();

  final token = "anhkhongdoiqua";

  RegisterationController requestController =
      Get.put(RegisterationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                        Text(
                          'Nhập số điện thoại',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: const Color.fromRGBO(38, 166, 83, 1),
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                          textAlign: TextAlign.start,
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
                                  requestController.phoneNumberController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  label: Row(
                                    children: [
                                      const Icon(FontAwesomeIcons.user),
                                      const SizedBox(width: 20),
                                      Text(
                                        'Số điện thoại',
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
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length <= 1 ||
                                    value.trim().length > 10) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Phone number is required!'),
                                    ),
                                  );
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            await requestController.requestOtp();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(38, 166, 83, 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 16.0),
                            child: Text(
                              'Gửi mã otp',
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
