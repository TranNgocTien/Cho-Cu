import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:chotot/screens/login.dart';
// import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(107, 184, 137, 255),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  runApp(
    const GetMaterialApp(
      home: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
      },
      child: MaterialApp(
        title: 'MEDENDx',
        theme: theme,
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        widthFactor: 300,
        child: Image.asset('image/MedenDx_green-slogan.png'),
      ),
      backgroundColor: Colors.white,
      nextScreen: const LoginScreen(),
      splashIconSize: 550,
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: const Duration(seconds: 1),
    );
  }
}
