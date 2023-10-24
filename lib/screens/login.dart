import 'dart:convert';

import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/screens/requestOtp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chotot/screens/homeScreen.dart';
import 'package:chotot/models/login.dart';
import 'dart:io' show Platform;
import 'package:chotot/screens/forgotPasswordScreen.dart';
import 'package:http/http.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  LoginPost? _loginPost;

  var _enteredEmail = '';
  var _enteredPassword = '';
  final token = "anhkhongdoiqua";

  LoginController loginController = Get.put(LoginController());

  // final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  // Future<Response> loginUsers() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   String deviceName = "";

  //   // Get device information
  //   try {
  //     if (Platform.isAndroid) {
  //       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //       deviceName = androidInfo.model;
  //     } else if (Platform.isIOS) {
  //       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //       deviceName = iosInfo.name;
  //     }
  //     print(deviceName);
  //   } on PlatformException {
  //     throw Exception('get device name failed');
  //   }
  //   if (_form.currentState!.validate()) {
  //     //show snackbar to indicate loading
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: const Text('Processing Data'),
  //       backgroundColor: Colors.green.shade300,
  //     ));

  //     //get response from ApiClient
  //     // final response = await http.post(Uri.parse('https://vstserver.com/login'),
  //     //     headers: {
  //     //       'Content-Type': 'application/json',
  //     //       'Authorization': 'Bearer $token',
  //     //     },
  //     //     body: jsonEncode(
  //     //       {
  //     //         'user_id': _enteredEmail,
  //     //         'password': _enteredPassword,
  //     //         'device': deviceName,
  //     //       },
  //     //     ));

  //     // if (response.statusCode == 200) {
  //     //   return response.body;
  //     // } else {
  //     //   ScaffoldMessenger.of(context).clearSnackBars();
  //     //   //if an error occurs, show snackbar with error message
  //     //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     //     content: Text('Error: ${response.reasonPhrase}'),
  //     //     backgroundColor: Colors.red.shade300,
  //     //   ));
  //     //   throw Exception(response.reasonPhrase);
  //     // }

  //     try {
  //       Response response = post(Uri.parse('https://vstserver.com/login'),
  //           body: jsonEncode(
  //             {
  //               'user_id': _enteredEmail,
  //               'password': _enteredPassword,
  //               'device': deviceName,
  //             },
  //           )) as Response;
  //       if (response.statusCode == 200) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (ctx) => MainScreen(),
  //           ),
  //         );
  //         return response;
  //       }
  //     } catch (e) {
  //       print(e.toString());
  //     }
  //   }
  // }

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
                  'image/MedenDx_green-slogan.png',
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 211, 210, 210),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 15, right: 15),
                            child: TextFormField(
                              controller: loginController.phoneNumberController,
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
                                              fontFamily: GoogleFonts.rubik()
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
                                      content: Text('Login input is required!'),
                                    ),
                                  );
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredEmail = value!;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 211, 210, 210),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 5,
                            ),
                            child: TextFormField(
                              controller: loginController.passwordController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                label: Row(
                                  children: [
                                    const Icon(FontAwesomeIcons.userShield),
                                    const SizedBox(width: 20),
                                    Text(
                                      'Mật khẩu',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontFamily:
                                                GoogleFonts.rubik().fontFamily,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return 'Password must be at least 6 characters long.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredPassword = value!;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            loginController.loginWithEmail();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(5, 109, 101, 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 16.0),
                            child: Text(
                              'Login',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                    color: Colors.white,
                                    fontFamily: GoogleFonts.rubik().fontFamily,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.to(const RequestOtpScreen());
                              },
                              child: Text(
                                'Tạo tài khoản',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color:
                                          const Color.fromRGBO(5, 109, 101, 1),
                                    ),
                              ),
                            ),
                            const SizedBox(width: 25),
                            TextButton(
                              onPressed: () {
                                Get.to(const ForgotPasswordScreen());
                              },
                              child: Text(
                                'Quên mật khẩu',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color:
                                          const Color.fromRGBO(5, 109, 101, 1),
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
            ],
          ),
        ),
      ),
    );
  }
}
