import 'package:chotot/controllers/get_news.dart';
import 'package:chotot/data/get_news_data.dart';
import 'package:chotot/widgets/news_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with TickerProviderStateMixin {
  bool isLoading = false;
  int index = 0;
  late Animation<double> _fadeInFadeOut;
  late AnimationController animation;
  GetNews getNewsController = Get.put(GetNews());
  fadeTransitionFunc() {
    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1).animate(animation);

    animation.forward();
  }

  @override
  void initState() {
    super.initState();

    _fadeInFadeOut = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0,
      upperBound: 1,
    );
    fadeTransitionFunc();
    animation.forward();
  }

  @override
  Widget build(BuildContext context) {
    final widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: 60.0,
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
        title: Text(
          'Tin Tức',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: Colors.white,
              fontSize: widthDevice * 0.055),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // foregroundColor: Color.fromRGBO(54, 92, 69, 1),
        elevation: 3,
      ),
      body: isLoading == true
          ? Center(
              child: LoadingAnimationWidget.waveDots(
                color: const Color.fromRGBO(1, 142, 33, 1),
                size: 30,
              ),
            )
          : newsList.isNotEmpty
              ? AnimatedBuilder(
                  animation: _fadeInFadeOut,
                  builder: (context, child) => SlideTransition(
                    position: Tween(
                      begin: const Offset(0, 0.4),
                      end: const Offset(0, 0),
                    ).animate(
                      CurvedAnimation(
                          parent: _fadeInFadeOut, curve: Curves.easeInOut),
                    ),
                    child: child,
                  ),
                  child: RefreshLoadmore(
                    onRefresh: () async {
                      newsList.clear();
                      newsListHome.clear();
                      setState(() {
                        isLoading = true;
                      });
                      await Future.delayed(const Duration(seconds: 2),
                          () async {
                        index = 0;
                        await getNewsController.getNewsData(index: 0);
                        if (mounted) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      });
                    },
                    onLoadmore: () async {
                      if (isLoading == false) {
                        await Future.delayed(const Duration(seconds: 2),
                            () async {
                          index += 1;
                          await getNewsController.getNewsData(index: index);
                        });
                      }
                    },
                    noMoreWidget: Center(
                      child: Text(
                        'Không còn tin tức',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                    isLastPage: getNewsController.isLastPage,
                    child: AlignedGridView.count(
                      shrinkWrap: true,
                      itemCount: newsList.length,
                      physics: const ScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 10,
                      itemBuilder: (context, index) {
                        return NewsGridItem(
                          newItems: newsList[index],
                        );
                      },
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    'Không còn tin tức',
                    style: GoogleFonts.poppins(),
                  ),
                ),
    );
  }
}
