import 'dart:async';

import 'package:chotot/controllers/get_post_jobs.dart';
import 'package:chotot/data/get_post_job_data.dart';
import 'package:chotot/data/notification_count.dart';
import 'package:chotot/screens/login.dart';
import 'package:chotot/screens/thongBaoScreen.dart';

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
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ChoScreen extends StatefulWidget {
  const ChoScreen({super.key});
  static const route = '/lib/screens/choScreen.dart';
  @override
  State<ChoScreen> createState() => _ChoScreenState();
}

class _ChoScreenState extends State<ChoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final GetStuffs _getStuffs = Get.put(GetStuffs());
  final GetPostJobs _getPostJobs = Get.put(GetPostJobs());
  final _storage = const FlutterSecureStorage();
  var currentIndexMarket = 1;
  var currentIndexWorker = 1;
  bool isLoading = true;
  bool onLoading = false;
  String tokenString = '';
  late var timer;
  String selectedScreen = 'market';
  HawkFabMenuController hawkFabMenuController = HawkFabMenuController();
  Widget center = const Center(
    child: CircularProgressIndicator(),
  );
  void isLogin() async {
    tokenString = await _storage.read(key: "TOKEN") ?? '';
  }

  getData() async {
    await _getStuffs.getStuffs(currentIndexMarket - 1);
    if (items.isNotEmpty) {
      setState(() {});
    }
  }

  getDataJob() async {
    await _getPostJobs.getPostJobs(currentIndexWorker - 1);

    if (postJobData.isNotEmpty) {
      setState(() {});
    }
  }

  @override
  void initState() {
    isLogin();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
      lowerBound: 0,
      upperBound: 1,
    );
    postJobData.clear();
    items.clear();
    currentIndexMarket = 1;
    currentIndexWorker = 1;
    if (mounted) {
      timer = Timer(const Duration(seconds: 3), () {
        setState(() {
          isLoading = false;
        });
      });
    }

    selectedScreen == 'market' ? getData() : getDataJob();

    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget centerLoading = const Center(
      child: CircularProgressIndicator(),
    );
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
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
          elevation: 0,
          actions: [
            // IconButton(
            //     onPressed: () {
            //       Get.to(const OwnerOrder());
            //     },
            //     icon: const FaIcon(FontAwesomeIcons.listUl)),
            Stack(children: [
              IconButton(
                onPressed: () {
                  if (tokenString != '') {
                    setState(() {
                      count.value = 0;
                    });
                    Get.to(const ThongBaoScreen());
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
                icon: const FaIcon(
                  FontAwesomeIcons.bell,
                ),
              ),
              tokenString != ''
                  ? ValueListenableBuilder<int>(
                      builder:
                          (BuildContext context, int value, Widget? child) {
                        if (value == 0) {
                          return const SizedBox();
                        }
                        return Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                value.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                      valueListenable: count,
                    )
                  : const SizedBox(),
            ]),
          ],
        ),
        body: HawkFabMenu(
          icon: AnimatedIcons.menu_arrow,
          fabColor: Colors.white,
          iconColor: Colors.black,
          hawkFabMenuController: hawkFabMenuController,
          items: [
            HawkFabMenuItem(
                label: 'Tìm thợ nhanh',
                ontap: () async {
                  await getDataJob();
                  isLoading = false;
                  setState(() {
                    selectedScreen = 'worker';
                  });
                },
                icon: const Icon(FontAwesomeIcons.peopleCarryBox),
                color: Colors.white,
                labelColor: Colors.black,
                labelBackgroundColor: Colors.greenAccent),
            HawkFabMenuItem(
                label:
                    selectedScreen == 'market' ? 'Đăng tin' : 'Đăng việc làm',
                ontap: () {
                  tokenString != ''
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => selectedScreen == "market"
                                ? const RaoBanScreen()
                                : const TimThoThongMinhScreen(),
                          ),
                        )
                      : showDialog(
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
                },
                icon: const Icon(Icons.add_circle_outline),
                labelColor: Colors.black,
                color: Colors.white,
                labelBackgroundColor: Colors.greenAccent),
            HawkFabMenuItem(
                label: 'Chợ đồ cũ',
                ontap: () {
                  setState(() {
                    selectedScreen = 'market';
                  });
                  tokenString != ''
                      ? setState(() {
                          selectedScreen = 'market';
                        })
                      : showDialog(
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
                },
                icon: const Icon(FontAwesomeIcons.store),
                labelColor: Colors.black,
                color: Colors.white,
                labelBackgroundColor: Colors.greenAccent),
          ],
          body: isLoading
              ? centerLoading
              : selectedScreen == 'market'
                  ? items.isNotEmpty
                      ? AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) => SlideTransition(
                            position: Tween(
                              begin: const Offset(0, 1),
                              end: const Offset(0, 0),
                            ).animate(
                              CurvedAnimation(
                                  parent: _animationController,
                                  curve: Curves.easeInOut),
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
                                  await _getStuffs
                                      .getStuffs(currentIndexMarket - 1);
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
                        )
                  : postJobData.isNotEmpty
                      ? AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) => SlideTransition(
                            position: Tween(
                              begin: const Offset(0, 1),
                              end: const Offset(0, 0),
                            ).animate(
                              CurvedAnimation(
                                  parent: _animationController,
                                  curve: Curves.easeInOut),
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
                                  await _getPostJobs
                                      .getPostJobs(currentIndexWorker - 1);
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
                        ),
        ),
      ),
    );
  }
}
// Expanded(
//                 child: RefreshLoadmore(
//                   onLoadmore: () async {
//                     currentIndex += 1;
//                     await _getStuffs.getStuffs(currentIndex - 1);
//                   },
//                   isLastPage: _getStuffs.isLastPage,
//                   child: GridView(
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       childAspectRatio: 1 / 2,
//                     ),
//                     children: [
//                       for (final docu in items)
//                         DoCuGridItem(
//                           docu: docu,
//                         ),
//                       // Row(
//                       //   mainAxisAlignment: MainAxisAlignment.center,
//                       //   children: [
//                       //     ElevatedButton(
//                       //       onPressed: () {
//                       //         setState(() {});
//                       //       },
//                       //       child: const Icon(Icons.arrow_left,
//                       //           size: 30, color: Colors.black),
//                       //     ),
//                       //     const SizedBox(width: 10),
//                       //     ElevatedButton(
//                       //       onPressed: null,
//                       //       child: Text(
//                       //         '$currentIndex',
//                       //         style: Theme.of(context)
//                       //             .textTheme
//                       //             .bodyMedium!
//                       //             .copyWith(
//                       //               fontFamily:
//                       //                   GoogleFonts.montserrat().fontFamily,
//                       //             ),
//                       //       ),
//                       //     ),
//                       //     const SizedBox(width: 10),
//                       //     ElevatedButton(
//                       //         onPressed: () {
//                       //           setState(() {});
//                       //         },
//                       //         child: const Icon(Icons.arrow_right,
//                       //             size: 30, color: Colors.black)),
//                       //   ],
//                       // ),
//                     ],
//                   ),
//                 ),
//               )