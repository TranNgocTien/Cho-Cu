import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chotot/data/docu_data.dart';
import 'package:chotot/screens/raoBan.dart';
import 'package:chotot/controllers/get_stuffs.dart';
import 'package:chotot/screens/thongTinSanPham.dart';
import 'package:chotot/screens/bai_dang_chu_nha.dart';

class ChoScreen extends StatefulWidget {
  const ChoScreen({super.key});

  @override
  State<ChoScreen> createState() => _ChoScreenState();
}

class _ChoScreenState extends State<ChoScreen> {
  final GetStuffs _getStuffs = Get.put(GetStuffs());
  var currentIndex = 1;

  Widget center = const Center(
    child: CircularProgressIndicator(),
  );

  getData() async {
    items.clear();
    await _getStuffs.getStuffs(currentIndex - 1);
    if (items.isNotEmpty) {
      setState(() {});
    }
  }

  @override
  void initState() {
    getData();
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
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              'Chợ đồ cũ',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(54, 92, 69, 1),
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          foregroundColor: const Color.fromRGBO(54, 92, 69, 1),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(const OwnerOrder());
                },
                icon: const FaIcon(FontAwesomeIcons.listUl)),
          ],
        ),
        body: items.isNotEmpty
            ? Stack(
                children: [
                  SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (ctx, index) => Column(
                              children: [
                                Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 10,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 25),
                                    padding: const EdgeInsets.all(15),
                                    // decoration: BoxDecoration(
                                    //   border: Border.all(
                                    //     width: 2,
                                    //     color: const Color.fromRGBO(54, 92, 69, 1),
                                    //   ),
                                    //   borderRadius: BorderRadius.circular(10),
                                    // ),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(
                                          ThongTinSanPhamScreen(
                                            docu: items[index],
                                          ),
                                        );
                                      },
                                      splashColor: const Color.fromARGB(
                                          255, 136, 217, 187),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Đồ cũ của ${items[index].name} ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  color: const Color.fromRGBO(
                                                      54, 92, 69, 1),
                                                  // color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  fontFamily:
                                                      GoogleFonts.montserrat()
                                                          .fontFamily,
                                                ),
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Giá mong muốn:  ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      // color: const Color.fromRGBO(
                                                      //     122, 191, 149, 1),
                                                      color: Colors.black,
                                                      fontFamily: GoogleFonts
                                                              .montserrat()
                                                          .fontFamily,
                                                    ),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                '${items[index].price} VNĐ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      // color: const Color.fromRGBO(
                                                      //     122, 191, 149, 1),
                                                      color: Colors.grey,
                                                      fontFamily: GoogleFonts
                                                              .montserrat()
                                                          .fontFamily,
                                                    ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Mô tả:  ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      color: Colors.black,
                                                      fontFamily: GoogleFonts
                                                              .montserrat()
                                                          .fontFamily,
                                                    ),
                                                textAlign: TextAlign.start,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  maxLines: 3,
                                                  items[index].description,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                        color: Colors.grey,
                                                        fontFamily: GoogleFonts
                                                                .montserrat()
                                                            .fontFamily,
                                                      ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 200,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.13,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                          ),
                        ],
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(width: 1, color: Colors.transparent),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  setState(() {
                                    currentIndex > 1
                                        ? currentIndex = currentIndex - 1
                                        : currentIndex = 1;
                                    getData();
                                  });
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.arrowLeft,
                                  color: Color.fromRGBO(122, 191, 149, 1),
                                ),
                              ),
                              Container(
                                height: 35,
                                width: 65,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color:
                                        const Color.fromRGBO(122, 191, 149, 1),
                                  ),
                                ),
                                child: Text(
                                  '$currentIndex',
                                  style: TextStyle(
                                    color:
                                        const Color.fromRGBO(122, 191, 149, 1),
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              IconButton(
                                disabledColor: Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    currentIndex = currentIndex + 1;
                                    getData();
                                  });
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.arrowRight,
                                  color: Color.fromRGBO(122, 191, 149, 1),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      const Color.fromRGBO(122, 191, 149, 1),
                                ),
                                child: Text(
                                  'Tìm thợ nhanh',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        color: const Color.fromRGBO(
                                            122, 191, 149, 1),
                                        fontFamily:
                                            GoogleFonts.montserrat().fontFamily,
                                      ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RaoBanScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(122, 191, 149, 1),
                                  foregroundColor: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    'Đăng tin',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                          color: Colors.white,
                                          fontFamily: GoogleFonts.montserrat()
                                              .fontFamily,
                                        ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      const Color.fromRGBO(122, 191, 149, 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    'Chợ đồ cũ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                          color: const Color.fromRGBO(
                                              122, 191, 149, 1),
                                          fontFamily: GoogleFonts.montserrat()
                                              .fontFamily,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : center,
      ),
    );
  }
}
