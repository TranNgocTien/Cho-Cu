import 'package:chotot/models/get_news_models.dart';
import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:webview_flutter/webview_flutter.dart';

import 'package:cached_network_image/cached_network_image.dart';

class NewsGridItem extends StatefulWidget {
  const NewsGridItem({super.key, required this.newItems});

  final News newItems;
  @override
  State<NewsGridItem> createState() => _NewsGridItemState();
}

class _NewsGridItemState extends State<NewsGridItem> {
  // bool isLoading = true;
  @override
  void initState() {
    // Timer(const Duration(seconds: 6), () {
    //   setState(() {
    //     isLoading = false;
    //   });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Widget centerLoading = const Center(
    //   child: CircularProgressIndicator(),
    // );

    String name = widget.newItems.tittle.length > 17
        ? '${widget.newItems.tittle.substring(0, 17)}...'
        : widget.newItems.tittle;
    String date =
        widget.newItems.date.substring(0, widget.newItems.date.indexOf('T'));

    return
        // isLoading
        //     ? centerLoading
        //     :
        GestureDetector(
      onTap: () async {
        Get.to(
          () => HtmlPageNew(
            contextHtmlPage: widget.newItems.content,
            imageLink: widget.newItems.link,
            content: widget.newItems.content,
            title: widget.newItems.tittle,
            date: date,
            author: widget.newItems.author,
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(127, 158, 158, 158)),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: 487 / 451,
                child: CachedNetworkImage(
                    imageUrl: widget.newItems.link,
                    // placeholder: (context, url) =>
                    //     const CircularProgressIndicator(strokeWidth: 5.0),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            image: DecorationImage(
                              filterQuality: FilterQuality.high,
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    memCacheWidth: 200,
                    maxHeightDiskCache: 200,
                    maxWidthDiskCache: 200),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 13,
                        ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    date,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: Colors.grey,
                        ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HtmlPageNew extends StatelessWidget {
  const HtmlPageNew({
    super.key,
    required this.contextHtmlPage,
    required this.imageLink,
    required this.content,
    required this.date,
    required this.author,
    required this.title,
  });
  final String contextHtmlPage;
  final String imageLink;
  final String content;
  final String title;
  final String date;
  final String author;
  @override
  Widget build(BuildContext context) {
    var dateCreateAt = DateTime.parse(date).toLocal();
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.3,
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(
                size: 30,
                color: Color.fromRGBO(39, 166, 82, 1),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color.fromRGBO(39, 166, 82, 1),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(imageLink, fit: BoxFit.cover),
                title: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      3.0,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 2.0,
                  ),
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                    // textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ];
        },
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      author,
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${dateCreateAt.day < 10 ? 0 : ''}${dateCreateAt.day}-${dateCreateAt.month < 10 ? 0 : ''}${dateCreateAt.month}-${dateCreateAt.year}',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: Center(
                child: HtmlWidget(
                  textStyle: GoogleFonts.poppins(),
                  contextHtmlPage,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
