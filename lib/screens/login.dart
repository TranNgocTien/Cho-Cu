import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chotot/screens/homeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();

  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
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
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  label: Text(
                                    'User name',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontFamily:
                                              GoogleFonts.rubik().fontFamily,
                                        ),
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
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                label: Text(
                                  'Password',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontFamily:
                                            GoogleFonts.rubik().fontFamily,
                                      ),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(5, 109, 101, 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 16.0),
                            child: Text(
                              _isLogin ? 'Login' : 'Signup',
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
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(
                            _isLogin
                                ? 'Create an account'
                                : 'I already have an account',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: const Color.fromRGBO(5, 109, 101, 1),
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
