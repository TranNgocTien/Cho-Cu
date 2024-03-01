import 'dart:async';

import 'package:chotot/controllers/get_post_jobs.dart';
import 'package:chotot/data/get_post_job_data.dart';

import 'package:chotot/screens/login.dart';

import 'package:chotot/screens/tim_tho_screen.dart';
import 'package:chotot/widgets/vieclam_grid_item.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:chotot/data/docu_data.dart';
import 'package:chotot/screens/raoBan.dart';
import 'package:chotot/controllers/get_stuffs.dart';

// import 'package:chotot/screens/bai_dang_chu_nha.dart';
import 'package:chotot/widgets/docu_grid_item.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ChoScreen extends StatefulWidget {
  const ChoScreen({super.key});
  static const route = '/lib/screens/choScreen.dart';
  @override
  State<ChoScreen> createState() => _ChoScreenState();
}

class _ChoScreenState extends State<ChoScreen> {
  final _storage = const FlutterSecureStorage();

  String tokenString = '';

  Widget center = const Center(
    child: CircularProgressIndicator(),
  );
  void isLogin() async {
    tokenString = await _storage.read(key: "TOKEN") ?? '';
  }

  int indexPage = 0;
  List<Widget> list = [
    const Tab(
      text: 'Chợ đồ cũ',
    ),
    const Tab(
      text: 'Chợ việc làm',
    ),
  ];
  @override
  void initState() {
    isLogin();
    super.initState();
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

              bottom: PreferredSize(
                  preferredSize: Size.fromHeight(AppBar().preferredSize.height -
                      AppBar().preferredSize.height),
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
                        labelColor: const Color.fromRGBO(38, 166, 83, 1),
                        unselectedLabelColor: Colors.black,
                        // indicator: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(
                        //     10.0,
                        //   ),
                        //   color: const Color.fromRGBO(38, 166, 83, 1),
                        // ),
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
              children: [
                ChoDoCu(),
                ChoViecLamScreen(),
              ],
            ),
            floatingActionButton: ElevatedButton.icon(
                onPressed: () {
                  if (tokenString != '') {
                    indexPage == 0
                        ? Get.to(() => const RaoBanScreen())
                        : Get.to(
                            () => const TimThoThongMinhScreen(codeService: ''));
                  } else {
                    showDialog(
                        context: Get.context!,
                        builder: (context) {
                          return SimpleDialog(
                            title: const Text(
                              'Vui lòng đăng nhập',
                              textAlign: TextAlign.center,
                            ),
                            contentPadding: const EdgeInsets.all(20),
                            children: [
                              Center(
                                child: TextButton(
                                    onPressed: () {
                                      Get.to(() => const LoginScreen());
                                    },
                                    child: const Text('Đăng nhập')),
                              ),
                            ],
                          );
                        });
                  }
                },
                icon: const FaIcon(FontAwesomeIcons.squarePlus,
                    color: Colors.black),
                label: indexPage == 0
                    ? Text('Đăng bài',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily))
                    : Text('Đăng việc',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily)))),
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
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final GetPostJobs _getPostJobs = Get.put(GetPostJobs());
  late var timer;
  var currentIndexWorker = 1;
  bool isLoading = true;
  bool onLoading = false;
  getDataJob() async {
    await _getPostJobs.getPostJobs(currentIndexWorker - 1);

    if (postJobData.isNotEmpty) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    timer.cancel();
    _animationController.dispose();
    super.dispose();
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

  Widget centerLoading = const Center(
    child: CircularProgressIndicator(),
  );
  @override
  Widget build(BuildContext context) {
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
                      : const Center(
                          child: Text('Không có việc làm'),
                        ),
                ),
              )
            : const Center(
                child: Text('Không có việc làm'),
              );
  }
}

class ChoDoCu extends StatefulWidget {
  const ChoDoCu({super.key});

  @override
  State<ChoDoCu> createState() => _ChoDoCuState();
}

class _ChoDoCuState extends State<ChoDoCu> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final GetStuffs _getStuffs = Get.put(GetStuffs());
  var currentIndexMarket = 1;
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

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
      lowerBound: 0,
      upperBound: 1,
    );

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

  Widget centerLoading = const Center(
    child: CircularProgressIndicator(),
  );
  @override
  Widget build(BuildContext context) {
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
                      : const Center(
                          child: Text('Không có sản phẩm'),
                        ),
                ),
              )
            : const Center(
                child: Text('Không có sản phẩm'),
              );
  }
}
