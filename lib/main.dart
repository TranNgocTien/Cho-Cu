import 'dart:convert';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chotot/controllers/get_a_job.dart';
import 'package:chotot/controllers/get_a_stuff.dart';
// import 'package:chotot/controllers/get_job_type.dart';
import 'package:chotot/controllers/get_jobservice.dart';
import 'package:chotot/controllers/get_ly_lich.dart';
import 'package:chotot/controllers/get_news.dart';
import 'package:chotot/controllers/get_notis.dart';
import 'package:chotot/controllers/get_reg.dart';
import 'package:chotot/controllers/get_stuffs.dart';
import 'package:chotot/controllers/get_vouchers_valid.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/controllers/register_notification.dart';
import 'package:chotot/data/a_stuff_data.dart';

// import 'package:chotot/controllers/register_notification.dart';
import 'package:chotot/screens/choScreen.dart';
import 'package:chotot/screens/congViecScreen.dart';
import 'package:chotot/screens/homeScreen.dart';
import 'package:chotot/screens/thongTinSanPham.dart';
import 'package:chotot/screens/thong_tin_job_screen.dart';
// import 'package:chotot/screens/thongBaoScreen.dart';
import 'package:chotot/screens/timThoScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:chotot/data/data_listener.dart';

// import 'package:permission_handler/permission_handler.dart';
RegisterNotification registerNotification = Get.put(RegisterNotification());
NotiController notiController = Get.put(NotiController());
GetAJob getAJob = Get.put(GetAJob());
GetAStuff getAStuff = Get.put(GetAStuff());
LyLichController lyLichController = Get.put(LyLichController());
GetStuffs getStuffs = Get.put(GetStuffs());
final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(107, 184, 137, 255),
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
);

//Function to listen to background changes
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  Map payload = {};

  payload = message.data;

  await notiController.getNoti(0);

  var actionType = payload['action_type'];

  switch (actionType) {
    case 'post_stuff':
      // print('stuff noti');

      var stuffId = payload['action'];
      await getAStuff.getAStuff(stuffId);

      await getStuffs.getStuffs(0);
      marketListen.value++;
      Get.to(() => ThongTinSanPhamScreen(docu: aStuff[0]));
      break;
    case 'post_job':
    case 'book_job':
    case 'worker_accept_job':
    case 'worker_cancel_job':
    case 'worker_done':
    case 'finish_job':
    case 'apply_job':
    case 'accept_worker':
    case 'cancel_worker':
    case 'job_time_expired':
    case 'job_time_next':
      // print('job noti');
      jobListen.value = 1.0;
      var jobId = payload['action'];
      await getAJob.getAJob(jobId);
      // await getPostJobs.getPostJobs(0);

      final dateTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(getAJob.jobInfo[0].workDate),
          isUtc: true);
      var date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      var time = '${dateTime.hour}:${dateTime.minute}';
      Get.to(
        () => ThongTinJobScreen(
          jobInfo: getAJob.jobInfo,
          date: date,
          time: time,
        ),
      );
      break;
    case 'host_fee':
    case 'worker_fee':
    case 'charge_money':
      await lyLichController.getInfo();
    case 'worker_active':
    case 'cancel_register_worker':
    case 'worker_update':
    case 'host_bonus':
      // await lyLichController.getInfo();
      notiListen.value++;
      break;
    default:
      break;
  }
}

// Future<void> setupInteractedMessage() async {
//   // Get any messages which caused the application to open from
//   // a terminated state.
//   RemoteMessage? initialMessage =
//       await FirebaseMessaging.instance.getInitialMessage();

//   // If the message also contains a data property with a "type" of "chat",
//   // navigate to a chat screen
//   if (initialMessage != null) {
//     _firebaseBackgroundMessage(initialMessage);
//   }
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     String payloadData = jsonEncode(message.data);

//     if (message.notification != null) {
//       RegisterNotification.showSimpleNotification(
//           title: message.notification!.title!,
//           body: message.notification!.body!,
//           payload: payloadData);
//     }
//   });
//   // Also handle any interaction when the app is in the background via a
//   // Stream listener
//   FirebaseMessaging.onMessageOpenedApp.listen(_firebaseBackgroundMessage);
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //on background notification taped

  registerNotification.init();
  registerNotification.localNotiInit();

  //to handle foreground notifications

  //Listen to background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);

    if (message.notification != null) {
      RegisterNotification.showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payloadData);
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen(_firebaseBackgroundMessage);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    const GetMaterialApp(
      debugShowCheckedModeBanner: false,
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
        debugShowCheckedModeBanner: false,
        title: 'Tho4.0',
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

  GetVouchersValid getVouchersValid = Get.put(GetVouchersValid());
  GetJobService jobService = Get.put(GetJobService());
  GetNews getNews = Get.put(GetNews());
  @override
  void initState() {
    loginController.loginWithEmail();
    getVouchersValid.getVouchers();
    getNews.getNewsData();
    jobService.getJobService();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        widthFactor: 300,
        child: Image.asset('image/logo_tho_thong_minh.jpeg'),
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
