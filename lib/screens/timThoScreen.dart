import 'package:carousel_slider/carousel_slider.dart';
import 'package:chotot/controllers/get_ly_lich.dart';
import 'package:chotot/controllers/login_controller.dart';
import 'package:chotot/data/get_vouchers_valid_data.dart';
import 'package:chotot/data/job_type_data.dart';
import 'package:chotot/data/news_data.dart';
import 'package:chotot/screens/login.dart';
import 'package:chotot/widgets/news_grid_item.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:chotot/data/default_information.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:refresh_loadmore/refresh_loadmore.dart';
import 'package:chotot/data/ly_lich.dart';

class TimThoScreen extends StatefulWidget {
  const TimThoScreen({super.key});
  static const route = '/lib/screens/timThoScreen.dart';

  @override
  State<TimThoScreen> createState() => _TimThoScreenState();
}

class _TimThoScreenState extends State<TimThoScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> btnKey = GlobalKey();
  late AnimationController _animationController;
  LyLichController lyLichController = Get.put(LyLichController());
  LoginController loginController = Get.put(LoginController());
  // final _storage = const FlutterSecureStorage();

  bool showWallet = false;
  int _current = 0;
  final CarouselController _controller = CarouselController();
  final List<String> imgLink = [
    'image/slider_example_1.jpeg',
    'image/slider_example_2.jpeg'
  ];

  final List<String> newList = [];
  void onClickMenu(MenuItemProvider item) {
    // print('Click menu -> ${item.menuTitle}');
  }

  void onDismiss() {
    // print('Menu is dismiss');
  }

  void customBackground(context) {
    PopupMenu menu = PopupMenu(
        context: context,
        config: MenuConfig(
          itemWidth: MediaQuery.of(context).size.width * 0.5,
          type: MenuType.list,
          backgroundColor: Color.alphaBlend(
            const Color.fromRGBO(39, 166, 82, 1),
            const Color.fromRGBO(1, 142, 33, 1),
          ),
          lineColor: Colors.black,
          highlightColor: Colors.yellow,
          arrowHeight: 10.0,
        ),
        items: [
          MenuItem(
            title: jobTypeList[0].item[0]['name'],
            textStyle: TextStyle(
              color: Colors.white,
              fontFamily: GoogleFonts.montserrat().fontFamily,
            ),
            image:
                Image.asset('image/air-conditioner.png', height: 40, width: 40),
            textAlign: TextAlign.justify,
          ),
          MenuItem(
            title: jobTypeList[0].item[1]['name'],
            textStyle: TextStyle(
              color: Colors.white,
              fontFamily: GoogleFonts.montserrat().fontFamily,
            ),
            image:
                Image.asset('image/washing-machine.png', height: 40, width: 40),
            textAlign: TextAlign.right,
          ),
          MenuItem(
            title: jobTypeList[0].item[2]['name'],
            textStyle: TextStyle(
              color: Colors.white,
              fontFamily: GoogleFonts.montserrat().fontFamily,
            ),
            image: Image.asset('image/fan.png', height: 40, width: 40),
            textAlign: TextAlign.right,
          ),
          MenuItem(
            title: jobTypeList[0].item[3]['name'],
            textStyle: TextStyle(
              color: Colors.white,
              fontFamily: GoogleFonts.montserrat().fontFamily,
            ),
            image: Image.asset('image/fridge.png', height: 40, width: 40),
            textAlign: TextAlign.right,
          ),
        ],
        onClickMenu: onClickMenu,
        onDismiss: onDismiss);
    menu.show(
      widgetKey: btnKey,
    );
  }

  @override
  void initState() {
    // if (loginController.tokenString != '') {
    //   lyLichController.getInfo();
    // }
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

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
          toolbarHeight: MediaQuery.of(context).size.width * 0.2,
          leadingWidth: MediaQuery.of(context).size.width * 0.5,
          leading: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thợ 4.0 xin chào!',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        color: Colors.white,
                      ),
                ),
                loginController.tokenString != ''
                    ? Text(
                        nameDefault,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: loginController.tokenString != ''
                    ? const EdgeInsets.only(right: 8.0)
                    : const EdgeInsets.all(0),
                child: loginController.tokenString != ''
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            IconButton(
                              iconSize: 16,
                              padding: const EdgeInsets.all(0),
                              icon: FaIcon(
                                  showWallet
                                      ? FontAwesomeIcons.eyeSlash
                                      : FontAwesomeIcons.eye,
                                  color: Colors.black),
                              onPressed: () {
                                setState(() {
                                  showWallet = !showWallet;
                                });
                              },
                            ),
                            showWallet
                                ? Text(
                                    loginController.tokenString != ''
                                        ? '${lyLichInfo[0].wallet} GP'
                                        : '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                          fontFamily: GoogleFonts.montserrat()
                                              .fontFamily,
                                          fontWeight: FontWeight.w900,
                                          color: showWallet
                                              ? Colors.yellow
                                              : Colors.grey,
                                        ),
                                    textAlign: TextAlign.center,
                                  )
                                : const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      FaIcon(FontAwesomeIcons.ellipsis,
                                          color: Colors.grey, size: 18),
                                      SizedBox(width: 1),
                                      FaIcon(FontAwesomeIcons.ellipsis,
                                          color: Colors.grey, size: 18),
                                      SizedBox(width: 1),
                                      FaIcon(FontAwesomeIcons.ellipsis,
                                          color: Colors.grey, size: 18),
                                    ],
                                  ),
                          ])
                    : TextButton(
                        onPressed: () {
                          Get.to(() => const LoginScreen());
                        },
                        child: Text(
                          'Đăng Nhập',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                color: const Color.fromRGBO(39, 166, 82, 1),
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ),
          ],
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
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => Opacity(
                  opacity: _animationController.value,
                  child: child,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loginController.tokenString != ''
                            ? const FaIcon(FontAwesomeIcons.locationPin,
                                size: 15, color: Colors.grey)
                            : const Text(''),
                        const SizedBox(width: 10),
                        loginController.tokenString != ''
                            ? Flexible(
                                child: Text(
                                  addressDefault,
                                  maxLines: 2,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        fontFamily:
                                            GoogleFonts.montserrat().fontFamily,
                                        color: Colors.grey,
                                      ),
                                ),
                              )
                            : const Text(''),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.5),
                    end: const Offset(0, 0),
                  ).animate(
                    CurvedAnimation(
                        parent: _animationController, curve: Curves.easeInOut),
                  ),
                  child: child,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.2,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CarouselSlider(
                    carouselController: _controller,
                    options: CarouselOptions(
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                      autoPlay: true,
                      enableInfiniteScroll: false,
                      viewportFraction: 1,
                    ),
                    items: vouchersValid.map((photo) {
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.network(
                          photo.img,
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.95,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: vouchersValid.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey
                                  : const Color.fromRGBO(39, 166, 82, 1))
                              .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => Opacity(
                  opacity: _animationController.value,
                  child: child,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                    'DỊCH VỤ',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.grey,
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                        ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.5),
                    end: const Offset(0, 0),
                  ).animate(
                    CurvedAnimation(
                        parent: _animationController, curve: Curves.easeInOut),
                  ),
                  child: child,
                ),
                child: Card(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.only(top: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              key: btnKey,
                              onTap: () => customBackground(context),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(15.0),
                                    decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            230, 246, 235, 1),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Image.asset('image/fix.png',
                                        height: 50, width: 50),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: Text(
                                      jobTypeList[0].shortName,
                                      softWrap: true,
                                      maxLines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(
                                            fontFamily: GoogleFonts.montserrat()
                                                .fontFamily,
                                            color: Colors.grey,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          230, 246, 235, 1),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Image.asset(
                                      'image/electric-heater.png',
                                      height: 50,
                                      width: 50),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  jobTypeList[1].shortName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        fontFamily:
                                            GoogleFonts.montserrat().fontFamily,
                                        color: Colors.grey,
                                      ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          230, 246, 235, 1),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Image.asset('image/kitchen.png',
                                      height: 50, width: 50),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: Text(
                                    jobTypeList[2].shortName,
                                    softWrap: true,
                                    maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          fontFamily: GoogleFonts.montserrat()
                                              .fontFamily,
                                          color: Colors.grey,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          230, 246, 235, 1),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Image.asset('image/broom.png',
                                      height: 50, width: 50),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  jobTypeList[3].shortName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        fontFamily:
                                            GoogleFonts.montserrat().fontFamily,
                                        color: Colors.grey,
                                      ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          230, 246, 235, 1),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Image.asset(
                                      'image/troubleshooting.png',
                                      height: 50,
                                      width: 50),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: Text(
                                    jobTypeList[4].shortName,
                                    softWrap: true,
                                    maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          fontFamily: GoogleFonts.montserrat()
                                              .fontFamily,
                                          color: Colors.grey,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => Opacity(
                  opacity: _animationController.value,
                  child: child,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TIN TỨC',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.grey,
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                            ),
                        textAlign: TextAlign.start,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Xem thêm',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: const Color.fromRGBO(39, 166, 82, 1),
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                fontWeight: FontWeight.w800,
                              ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // const SizedBox(height: 15),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.5),
                    end: const Offset(0, 0),
                  ).animate(
                    CurvedAnimation(
                        parent: _animationController, curve: Curves.easeInOut),
                  ),
                  child: child,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: AlignedGridView.count(
                    shrinkWrap: true,
                    itemCount: itemNews.length,
                    physics: const ScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 10,
                    itemBuilder: (context, index) {
                      return NewsGridItem(
                        newItems: itemNews[index],
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
