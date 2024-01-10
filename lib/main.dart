import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chotot/controllers/get_job_type.dart';
import 'package:chotot/controllers/get_news.dart';
import 'package:chotot/controllers/get_vouchers_valid.dart';
import 'package:chotot/controllers/login_controller.dart';
// import 'package:chotot/controllers/register_notification.dart';
import 'package:chotot/screens/choScreen.dart';
import 'package:chotot/screens/congViecScreen.dart';
import 'package:chotot/screens/homeScreen.dart';
// import 'package:chotot/screens/thongBaoScreen.dart';
import 'package:chotot/screens/timThoScreen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    const GetMaterialApp(
      home: App(),
    ),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: 'MEDENDx',
        theme: theme,
        home: const SplashScreen(),
        routes: {
          TimThoScreen.route: (context) => const TimThoScreen(),
          CongViecScreen.route: (context) => const CongViecScreen(),
          ChoScreen.route: (context) => const ChoScreen(),
          // ThongBaoScreen.route: (context) => const ThongBaoScreen(),
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  LoginController loginController = Get.put(LoginController());
  GetJobTypeController getJobTypeController = Get.put(GetJobTypeController());
  GetVouchersValid getVouchersValid = Get.put(GetVouchersValid());
  GetNews getNews = Get.put(GetNews());
  @override
  void initState() {
    getJobTypeController.getJobType();
    getVouchersValid.getVouchers();
    getNews.getNewsData();
    loginController.loginWithEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        widthFactor: 300,
        child: Image.asset('image/logo/logo.png'),
      ),
      backgroundColor: Colors.white,
      nextScreen: const MainScreen(),
      splashIconSize: 550,
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: const Duration(seconds: 1),
    );
  }
}
