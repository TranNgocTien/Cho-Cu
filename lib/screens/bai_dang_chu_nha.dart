import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chotot/data/docu_data.dart';

import 'package:chotot/controllers/get_stuffs.dart';
import 'package:chotot/screens/thongTinSanPham.dart';

class OwnerOrder extends StatefulWidget {
  const OwnerOrder({super.key});

  @override
  State<OwnerOrder> createState() => _OwnerOrderState();
}

class _OwnerOrderState extends State<OwnerOrder> {
  final GetStuffs _getStuffs = Get.put(GetStuffs());
  var currentIndex = 1;

  Widget center = const Center(
    child: CircularProgressIndicator(),
  );

  getData() async {
    itemsOwner.clear();
    await _getStuffs.getStuffs(currentIndex - 1);
    if (itemsOwner.isNotEmpty) {
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
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Bài đã đăng',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(54, 92, 69, 1),
                ),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(54, 92, 69, 1),
        elevation: 0,
      ),
      body: itemsOwner.isNotEmpty
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
                          itemCount: itemsOwner.length,
                          itemBuilder: (ctx, index) => Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 10,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 25),
                              padding: const EdgeInsets.all(15),
                              child: InkWell(
                                onTap: () {
                                  Get.to(
                                    ThongTinSanPhamScreen(
                                      docu: itemsOwner[index],
                                    ),
                                  );
                                },
                                splashColor:
                                    const Color.fromARGB(255, 136, 217, 187),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Đồ cũ của ${itemsOwner[index].name} ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: const Color.fromRGBO(
                                                54, 92, 69, 1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            fontFamily: GoogleFonts.montserrat()
                                                .fontFamily,
                                          ),
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(children: [
                                      Text(
                                        'Giá mong muốn:  ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              // color: const Color.fromRGBO(
                                              //     122, 191, 149, 1),
                                              color: Colors.black,
                                              fontFamily:
                                                  GoogleFonts.montserrat()
                                                      .fontFamily,
                                            ),
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(
                                        '  ${itemsOwner[index].price} VNĐ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: Colors.grey,
                                              fontFamily:
                                                  GoogleFonts.montserrat()
                                                      .fontFamily,
                                            ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ]),
                                    const SizedBox(height: 10),
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
                                                fontFamily:
                                                    GoogleFonts.montserrat()
                                                        .fontFamily,
                                              ),
                                          textAlign: TextAlign.start,
                                        ),
                                        Flexible(
                                          child: Text(
                                            itemsOwner[index].description,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  color: Colors.grey,
                                                  fontFamily:
                                                      GoogleFonts.montserrat()
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
                        ),
                      ),
                      const SizedBox(
                        height: 200,
                      ),
                    ],
                  ),
                ),
              ],
            )
          : center,
    );
  }
}
