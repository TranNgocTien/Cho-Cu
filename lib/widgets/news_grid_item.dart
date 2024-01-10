import 'package:chotot/models/news.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

// import 'package:get/get.dart';
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

    String name = widget.newItems.name.length > 17
        ? '${widget.newItems.name.substring(0, 17)} ...'
        : widget.newItems.name;

    return
        // isLoading
        //     ? centerLoading
        //     :
        GestureDetector(
      onTap: () {},
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
                    imageUrl: widget.newItems.imageUrl,
                    imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            image: DecorationImage(
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
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                          fontSize: 13,
                        ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    widget.newItems.time,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontFamily: GoogleFonts.montserrat().fontFamily,
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

//  Card(
//               clipBehavior: Clip.antiAlias,
//               borderOnForeground: false,
//               semanticContainer: false,
//               elevation: 0,
//               color: Colors.transparent,
//               child: Image.network(
//                 docu.photos[0].split('"').join(''),
//                 width: 200,
//                 height: 300,
//                 scale: 1.5,
//               ),
//             ),



//  NetworkImage(
//                         widget.docu.photos[0].split('"').join(''),
//                         scale: 2,
//                       ),