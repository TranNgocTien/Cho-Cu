import 'package:chotot/controllers/get_host_job.dart';
import 'package:chotot/controllers/get_ly_lich.dart';
import 'package:chotot/controllers/login_controller.dart';
// import 'package:chotot/controllers/register_notification.dart';
import 'package:chotot/screens/requestOtp.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:chotot/screens/forgotPasswordScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _storage = const FlutterSecureStorage();
  final _form = GlobalKey<FormState>();
  LyLichController lyLichController = Get.put(LyLichController());
  bool _savePassword = false;
  // LoginPost? _loginPost;

  // var _enteredEmail = '';
  // var _enteredPassword = '';
  GetHostJob getHostJobController = Get.put(GetHostJob());
  LoginController loginController = Get.put(LoginController());
  Future<void> _readFromStorage() async {
    loginController.phoneNumberController.text =
        await _storage.read(key: "KEY_USERNAME") ?? '';
    loginController.passwordController.text =
        await _storage.read(key: "KEY_PASSWORD") ?? '';
  }

  _onFormSubmit() async {
    loginController.isLogin = true;
    if (_savePassword) {
      // Write values
      await _storage.write(
          key: "KEY_USERNAME",
          value: loginController.phoneNumberController.text);
      await _storage.write(
          key: "KEY_PASSWORD", value: loginController.passwordController.text);
    } else {
      await _storage.write(key: "KEY_USERNAME", value: '');
      await _storage.write(key: "KEY_PASSWORD", value: '');
    }
  }

  autoLogin() async {
    await _readFromStorage();

    if (loginController.phoneNumberController.text == '' ||
        loginController.passwordController.text == '') return;

    await loginController.loginWithEmail();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  'image/logo/logo.png',
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
                                              fontFamily:
                                                  GoogleFonts.montserrat()
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
                                      content: Text('Nhập tên đăng nhập!'),
                                    ),
                                  );
                                }
                                return null;
                              },
                              // onSaved: (value) {
                              //   _enteredEmail = value!;
                              // },
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
                                            fontFamily: GoogleFonts.montserrat()
                                                .fontFamily,
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
                              // onSaved: (value) {
                              //   _enteredPassword = value!;
                              // },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            await _onFormSubmit();
                            loginController.isLoading == true
                                ? null
                                : loginController.loginWithEmail();

                            if (loginController.tokenString != '') {
                              await lyLichController.getInfo();
                              await getHostJobController.getHostJob(0);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(5, 109, 101, 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 16.0),
                            child: loginController.isLoading == true
                                ? const CircularProgressIndicator()
                                : Text(
                                    'Đăng nhập',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge!
                                        .copyWith(
                                          color: Colors.white,
                                          fontFamily: GoogleFonts.montserrat()
                                              .fontFamily,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: CheckboxListTile(
                            value: _savePassword,
                            onChanged: (bool? newValue) async {
                              setState(() {
                                _savePassword = newValue!;
                              });
                              await _storage.write(
                                  key: "Save_Password",
                                  value: _savePassword.toString());
                            },
                            title: Text(
                              "Ghi nhớ đăng nhập",
                              style: TextStyle(
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                              ),
                            ),
                            activeColor: const Color.fromRGBO(5, 109, 101, 1),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                                      fontFamily:
                                          GoogleFonts.montserrat().fontFamily,
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
                                      fontFamily:
                                          GoogleFonts.montserrat().fontFamily,
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
