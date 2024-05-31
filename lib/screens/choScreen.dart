import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:chotot/controllers/get_post_jobs.dart';
import 'package:chotot/controllers/get_stuffs_suggestion.dart';
import 'package:chotot/data/get_post_job_data.dart';

import 'package:chotot/screens/login.dart';

import 'package:chotot/screens/tim_tho_screen.dart';
import 'package:chotot/widgets/vieclam_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:chotot/data/docu_data.dart';
import 'package:chotot/screens/raoBan.dart';
import 'package:chotot/controllers/get_stuffs.dart';

// import 'package:chotot/screens/bai_dang_chu_nha.dart';
import 'package:chotot/widgets/docu_grid_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

class ChoScreen extends StatefulWidget {
  const ChoScreen({super.key});
  static const route = '/lib/screens/choScreen.dart';
  @override
  State<ChoScreen> createState() => _ChoScreenState();
}

class _ChoScreenState extends State<ChoScreen> {
  final _storage = const FlutterSecureStorage();

  String tokenString = '';

  Widget center = Center(
    child: LoadingAnimationWidget.waveDots(
      color: const Color.fromRGBO(1, 142, 33, 1),
      size: 30,
    ),
  );
  void isLogin() async {
    tokenString = await _storage.read(key: "TOKEN") ?? '';
  }

  int indexPage = 0;
  List<Widget> list = [
    Tab(
      child: Text('Chợ đồ cũ',
          style: GoogleFonts.poppins(
            fontSize: 15,
          )),
    ),
    Tab(
      child: Text('Chợ việc làm',
          style: GoogleFonts.poppins(
            fontSize: 15,
          )),
    ),
  ];
  @override
  void initState() {
    isLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final widthDevice = MediaQuery.of(context).size.width;
    final heightDevice = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              // backgroundColor: Colors.transparent,
              // title: Center(
              //   child: Text(
              //     'Chợ đồ cũ',
              //     style: Theme.of(context).textTheme.titleLarge!.copyWith(
              //           fontFamily: GoogleFonts.montserrat().fontFamily,
              //           fontWeight: FontWeight.bold,
              //         ),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              // foregroundColor: const Color.fromRGBO(54, 92, 69, 1),
              elevation: 1,
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

              bottom: PreferredSize(
                  preferredSize: Size.fromHeight(AppBar().preferredSize.height -
                      AppBar().preferredSize.height +
                      5),
                  child: Container(
                    height: 50,
                    // padding: const EdgeInsets.symmetric(
                    //   horizontal: 10,
                    //   vertical: 3,
                    // ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                    ),
                    child: TabBar(
                        dividerColor: const Color.fromRGBO(38, 166, 83, 1),
                        labelColor: Colors.white,
                        indicatorColor: Colors.white,
                        indicatorSize: TabBarIndicatorSize.label,
                        unselectedLabelColor: Colors.black87,
                        tabs: list,
                        isScrollable: false,
                        onTap: (index) {
                          setState(() {
                            indexPage = index;
                          });
                        }),
                  )),
            ),
            body: const TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                ChoDoCu(),
                ChoViecLamScreen(),
              ],
            ),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                    onPressed: () {
                      if (tokenString != '') {
                        indexPage == 0
                            ? Get.to(() => const RaoBanScreen())
                            : Get.to(() => const TimThoThongMinhScreen(
                                  codeService: '',
                                  nameService: '',
                                ));
                      } else {
                        AwesomeDialog(
                          context: Get.context!,
                          dialogType: DialogType.infoReverse,
                          animType: AnimType.rightSlide,
                          title: 'Vui lòng đăng nhập',
                          titleTextStyle: GoogleFonts.poppins(),
                          btnOkText: 'Đăng nhập',
                          btnOkColor: const Color.fromRGBO(38, 166, 83, 1),
                          btnOkOnPress: () {
                            Get.to(() => const LoginScreen());
                          },
                        ).show();
                        // showDialog(
                        //     context: Get.context!,
                        //     builder: (context) {
                        //       return SimpleDialog(
                        //         title: const Text(
                        //           'Vui lòng đăng nhập',
                        //           textAlign: TextAlign.center,
                        //         ),
                        //         contentPadding: const EdgeInsets.all(20),
                        //         children: [
                        //           Center(
                        //             child: TextButton(
                        //                 onPressed: () {
                        //                   Get.to(() => const LoginScreen());
                        //                 },
                        //                 child: const Text('Đăng nhập')),
                        //           ),
                        //         ],
                        //       );
                        //     });
                      }
                    },
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    height: heightDevice * 0.03,
                    minWidth: 100.0,
                    color: const Color.fromRGBO(38, 166, 83, 1),
                    child: indexPage == 0
                        ? Text('Đăng tin chợ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize: widthDevice * 0.04,
                                    color: Colors.white))
                        : Text('Đăng việc',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize: widthDevice * 0.04,
                                    color: Colors.white))),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.all(10),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(50),
                  //   border:
                  //       Border.all(color: const Color.fromRGBO(38, 166, 83, 1)),
                  // ),
                  child: indexPage == 0
                      ? const Icon(
                          Icons.post_add,
                          size: 30,
                          color: Color.fromRGBO(38, 166, 83, 1),
                        )
                      : const Icon(
                          Icons.work_outline,
                          size: 30,
                          color: Color.fromRGBO(38, 166, 83, 1),
                        ),
                ),
              ],
            )),
      ),
    );
  }
}

class ChoViecLamScreen extends StatefulWidget {
  const ChoViecLamScreen({super.key});

  @override
  State<ChoViecLamScreen> createState() => _ChoViecLamScreenState();
}

class _ChoViecLamScreenState extends State<ChoViecLamScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animationController;
  final GetPostJobs _getPostJobs = Get.put(GetPostJobs());
  late var timer;
  var currentIndexWorker = 1;
  bool isLoading = true;
  bool onLoading = false;
  late AnimationController animation;
  late Animation<double> _fadeInFadeOut;
  getDataJob() async {
    await _getPostJobs.getPostJobs(currentIndexWorker - 1);

    if (postJobData.isNotEmpty) {
      setState(() {});
    }
  }

  @override
  bool get wantKeepAlive => true;
  @override
  void dispose() {
    timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  fadeTransitionFunc() {
    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1).animate(animation);

    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     animation.reverse();
    //   } else if (status == AnimationStatus.dismissed) {
    //     animation.forward();
    //   }
    // });
    animation.forward();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
      lowerBound: 0,
      upperBound: 1,
    );
    postJobData.clear();
    fadeTransitionFunc();
    // currentIndexMarket = 1;
    currentIndexWorker = 1;
    if (mounted) {
      timer = Timer(const Duration(seconds: 3), () {
        setState(() {
          isLoading = false;
        });
      });
    }

    getDataJob();

    _animationController.forward();
    super.initState();
  }

  Widget centerLoading = Center(
    child: LoadingAnimationWidget.waveDots(
      color: const Color.fromRGBO(1, 142, 33, 1),
      size: 30,
    ),
  );
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return isLoading
        ? centerLoading
        : postJobData.isNotEmpty
            ? AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 1),
                    end: const Offset(0, 0),
                  ).animate(
                    CurvedAnimation(
                        parent: _animationController, curve: Curves.easeInOut),
                  ),
                  child: child,
                ),
                child: RefreshLoadmore(
                  onRefresh: () async {
                    setState(() {
                      isLoading = true;
                    });
                    postJobData.clear();
                    currentIndexWorker = 1;
                    timer = Timer(const Duration(seconds: 3), () {
                      setState(() {
                        isLoading = false;
                        _animationController.forward();
                      });
                    });

                    getDataJob();
                  },
                  // onLoadmore: () async {
                  //   if (onLoading == false) {
                  //     onLoading = true;
                  //     Timer(const Duration(seconds: 6), () {
                  //       setState(() {
                  //         onLoading = false;
                  //       });
                  //     });
                  //     currentIndex += 1;
                  //     await _getStuffs.getStuffs(currentIndex - 1);
                  //     setState(() {});
                  //   }
                  // },
                  onLoadmore: () async {
                    if (onLoading == false) {
                      await Future.delayed(const Duration(seconds: 6),
                          () async {
                        // onLoading = true;
                        // Timer(const Duration(seconds: 5), () {
                        //   setState(() {
                        //     onLoading = false;
                        //   });
                        // });
                        currentIndexWorker += 1;
                        await _getPostJobs.getPostJobs(currentIndexWorker - 1);
                        if (mounted) {
                          setState(() {
                            // _animationController.forward();
                          });
                        }
                      });
                    }
                  },
                  // noMoreWidget: Text(
                  //   'Bạn đã đến cuối trang',
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     color: Theme.of(context).disabledColor,
                  //   ),
                  // ),
                  isLastPage: _getPostJobs.isLastPage,
                  child: postJobData.isNotEmpty
                      ? AlignedGridView.count(
                          shrinkWrap: true,
                          itemCount: postJobData.length,
                          physics: const ScrollPhysics(),
                          crossAxisCount: 1,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 10,
                          itemBuilder: (context, index) {
                            return ViecLamGridItem(
                              job: postJobData[index],
                            );
                          },
                        )
                      : Stack(children: [
                          Positioned(
                            bottom: MediaQuery.of(context).size.height * 0.03,
                            left: MediaQuery.of(context).size.width * 0.05,
                            child: FadeTransition(
                              opacity: _fadeInFadeOut,
                              child: ShapeOfView(
                                elevation: 20,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                width: MediaQuery.of(context).size.width * 0.9,
                                shape: BubbleShape(
                                    position: BubblePosition.Bottom,
                                    arrowPositionPercent: 0.7,
                                    borderRadius: 20,
                                    arrowHeight:
                                        MediaQuery.of(context).size.height *
                                            0.2,
                                    arrowWidth: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: const Color.fromRGBO(
                                            84, 181, 111, 1),
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.205,
                                      ),
                                      top: const BorderSide(
                                        color: Color.fromRGBO(84, 181, 111, 1),
                                        width: 5,
                                      ),
                                      left: const BorderSide(
                                        color: Color.fromRGBO(84, 181, 111, 1),
                                        width: 5,
                                      ),
                                      right: const BorderSide(
                                        color: Color.fromRGBO(84, 181, 111, 1),
                                        width: 5,
                                      ),
                                    ),
                                  ),
                                  padding: const EdgeInsets.only(
                                      top: 15.0, left: 15.0, right: 15.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Thợ 4.0 hỗ trợ bạn có thể tìm kiếm những người thợ xung quanh thích hợp với nhu cầu mà bạn cần. Chúng tôi giúp bạn tiết kiệm thời gian, chi phí cho dịch vụ và đặc biệt giúp bạn tìm được 1 người thợ giỏi tay nghề.',
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.035,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Bạn đừng do dự mà hãy sử dụng chức năng tìm thợ trên "Chợ việc làm". Chúng tôi sẽ giúp bạn tìm được thợ trong thời gian nhanh nhất.',
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.035,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                ),
              )
            : Stack(children: [
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.03,
                  left: MediaQuery.of(context).size.width * 0.05,
                  child: FadeTransition(
                    opacity: _fadeInFadeOut,
                    child: ShapeOfView(
                      elevation: 20,
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.9,
                      shape: BubbleShape(
                          position: BubblePosition.Bottom,
                          arrowPositionPercent: 0.7,
                          borderRadius: 20,
                          arrowHeight: MediaQuery.of(context).size.height * 0.2,
                          arrowWidth: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border(
                            bottom: BorderSide(
                              color: const Color.fromRGBO(84, 181, 111, 1),
                              width: MediaQuery.of(context).size.height * 0.205,
                            ),
                            top: const BorderSide(
                              color: Color.fromRGBO(84, 181, 111, 1),
                              width: 5,
                            ),
                            left: const BorderSide(
                              color: Color.fromRGBO(84, 181, 111, 1),
                              width: 5,
                            ),
                            right: const BorderSide(
                              color: Color.fromRGBO(84, 181, 111, 1),
                              width: 5,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 15.0, right: 15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Thợ 4.0 hỗ trợ bạn có thể tìm kiếm những người thợ xung quanh thích hợp với nhu cầu mà bạn cần. Chúng tôi giúp bạn tiết kiệm thời gian, chi phí cho dịch vụ và đặc biệt giúp bạn tìm được 1 người thợ giỏi tay nghề.',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Bạn đừng do dự mà hãy sử dụng chức năng tìm thợ trên "Chợ việc làm". Chúng tôi sẽ giúp bạn tìm được thợ trong thời gian nhanh nhất.',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]);
  }
}

class ChoDoCu extends StatefulWidget {
  const ChoDoCu({super.key});

  @override
  State<ChoDoCu> createState() => _ChoDoCuState();
}

class _ChoDoCuState extends State<ChoDoCu>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animationController;
  final GetStuffs _getStuffs = Get.put(GetStuffs());
  final GetStuffsSuggestion _getStuffsSuggestion =
      Get.put(GetStuffsSuggestion());
  var currentIndexMarket = 1;
  late AnimationController animation;
  late Animation<double> _fadeInFadeOut;
  late var timer;
  bool isLoading = true;

  bool onLoading = false;

  getData() async {
    await _getStuffs.getStuffs(currentIndexMarket - 1);
    if (items.isNotEmpty) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  fadeTransitionFunc() {
    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1).animate(animation);

    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     animation.reverse();
    //   } else if (status == AnimationStatus.dismissed) {
    //     animation.forward();
    //   }
    // });
    animation.forward();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    _getStuffsSuggestion.getStuffs(0);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
      lowerBound: 0,
      upperBound: 1,
    );
    fadeTransitionFunc();
    items.clear();
    currentIndexMarket = 1;

    if (mounted) {
      timer = Timer(const Duration(seconds: 3), () {
        setState(() {
          isLoading = false;
        });
      });
    }

    getData();

    _animationController.forward();
    super.initState();
  }

  Widget centerLoading = Center(
    child: LoadingAnimationWidget.waveDots(
      color: const Color.fromRGBO(1, 142, 33, 1),
      size: 30,
    ),
  );
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return isLoading
        ? centerLoading
        : items.isNotEmpty
            ? AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 1),
                    end: const Offset(0, 0),
                  ).animate(
                    CurvedAnimation(
                        parent: _animationController, curve: Curves.easeInOut),
                  ),
                  child: child,
                ),
                child: RefreshLoadmore(
                  onRefresh: () async {
                    setState(() {
                      isLoading = true;
                    });
                    items.clear();
                    currentIndexMarket = 1;
                    timer = Timer(const Duration(seconds: 3), () {
                      setState(() {
                        isLoading = false;
                        _animationController.forward();
                      });
                    });

                    getData();
                  },
                  // onLoadmore: () async {
                  //   if (onLoading == false) {
                  //     onLoading = true;
                  //     Timer(const Duration(seconds: 6), () {
                  //       setState(() {
                  //         onLoading = false;
                  //       });
                  //     });
                  //     currentIndex += 1;
                  //     await _getStuffs.getStuffs(currentIndex - 1);
                  //     setState(() {});
                  //   }
                  // },
                  onLoadmore: () async {
                    if (onLoading == false) {
                      await Future.delayed(const Duration(seconds: 6),
                          () async {
                        // onLoading = true;
                        // Timer(const Duration(seconds: 5), () {
                        //   setState(() {
                        //     onLoading = false;
                        //   });
                        // });
                        currentIndexMarket += 1;
                        await _getStuffs.getStuffs(currentIndexMarket - 1);
                        if (mounted) {
                          setState(() {
                            // _animationController.forward();
                          });
                        }
                      });
                    }
                  },
                  // noMoreWidget: Text(
                  //   'Bạn đã đến cuối trang',
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     color: Theme.of(context).disabledColor,
                  //   ),
                  // ),
                  isLastPage: _getStuffs.isLastPage,
                  child: items.isNotEmpty
                      ? AlignedGridView.count(
                          shrinkWrap: true,
                          itemCount: items.length,
                          physics: const ScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 10,
                          itemBuilder: (context, index) {
                            return DoCuGridItem(
                              docu: items[index],
                            );
                          },
                        )
                      : Stack(
                          children: [
                            Positioned(
                              bottom: MediaQuery.of(context).size.height * 0.03,
                              left: MediaQuery.of(context).size.width * 0.05,
                              child: FadeTransition(
                                opacity: _fadeInFadeOut,
                                child: ShapeOfView(
                                  elevation: 20,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  shape: BubbleShape(
                                      position: BubblePosition.Bottom,
                                      arrowPositionPercent: 0.7,
                                      borderRadius: 20,
                                      arrowHeight:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      arrowWidth: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border(
                                        bottom: BorderSide(
                                          color: const Color.fromRGBO(
                                              84, 181, 111, 1),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.205,
                                        ),
                                        top: const BorderSide(
                                          color:
                                              Color.fromRGBO(84, 181, 111, 1),
                                          width: 5,
                                        ),
                                        left: const BorderSide(
                                          color:
                                              Color.fromRGBO(84, 181, 111, 1),
                                          width: 5,
                                        ),
                                        right: const BorderSide(
                                          color:
                                              Color.fromRGBO(84, 181, 111, 1),
                                          width: 5,
                                        ),
                                      ),
                                    ),
                                    padding: const EdgeInsets.only(
                                        top: 15.0, left: 15.0, right: 15.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Mỗi người trong số chúng ta đều có những sản phẩm có thể bán được. Bên cạnh việc giữ sản phẩm không cần đến ở nhà, bất kỳ ai cũng có thể kiếm thêm tiền bằng cách bán nó cho người khác thông qua "Chợ đồ cũ" này.',
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.035,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Sản phẩm mà bạn không cần đến vẫn có thể trở thành vật quý giá với người khác. Đừng do dự mà hãy đăng thông tin về sản phẩm của bạn ngay bây giờ!',
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              )
            : Stack(children: [
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.03,
                  left: MediaQuery.of(context).size.width * 0.05,
                  child: FadeTransition(
                    opacity: _fadeInFadeOut,
                    child: ShapeOfView(
                      elevation: 20,
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.9,
                      shape: BubbleShape(
                          position: BubblePosition.Bottom,
                          arrowPositionPercent: 0.7,
                          borderRadius: 20,
                          arrowHeight: MediaQuery.of(context).size.height * 0.2,
                          arrowWidth: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border(
                            bottom: BorderSide(
                              color: const Color.fromRGBO(84, 181, 111, 1),
                              width: MediaQuery.of(context).size.height * 0.205,
                            ),
                            top: const BorderSide(
                              color: Color.fromRGBO(84, 181, 111, 1),
                              width: 4,
                            ),
                            left: const BorderSide(
                              color: Color.fromRGBO(84, 181, 111, 1),
                              width: 4,
                            ),
                            right: const BorderSide(
                              color: Color.fromRGBO(84, 181, 111, 1),
                              width: 4,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 15.0, right: 15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Mỗi người trong số chúng ta đều có những sản phẩm có thể bán được. Bên cạnh việc giữ sản phẩm không cần đến ở nhà, bất kỳ ai cũng có thể kiếm thêm tiền bằng cách bán nó cho người khác thông qua "Chợ đồ cũ" này.',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Sản phẩm mà bạn không cần đến vẫn có thể trở thành vật quý giá với người khác. Đừng do dự mà hãy đăng thông tin về sản phẩm của bạn ngay bây giờ!',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]);
  }
}
