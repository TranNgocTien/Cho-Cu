import 'package:basic_utils/basic_utils.dart';
import 'package:chotot/controllers/get_price_v2.dart';
import 'package:chotot/data/selected_items.dart';
import 'package:chotot/models/get_price_model.dart';
import 'package:chotot/screens/voucher_valid_screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ConfirmBookWorkerScreen extends StatefulWidget {
  ConfirmBookWorkerScreen({
    super.key,
    required this.dataPrice,
    required this.bookJob,
    required this.miliseconds,
    required this.jobItemConfirm,
  });
  Price dataPrice;
  final Function bookJob;
  final String miliseconds;
  final List<dynamic> jobItemConfirm;
  @override
  State<ConfirmBookWorkerScreen> createState() =>
      _ConfirmBookWorkerScreenState();
}

class _ConfirmBookWorkerScreenState extends State<ConfirmBookWorkerScreen> {
  GetPrice getPrice = Get.put(GetPrice());
  int countGetPrice = 0;
  getPriceFunc() async {
    await getPrice.getPrice(
      countGetPrice == 0 ? '' : getPrice.dataPrice.priceId,
      widget.miliseconds,
      widget.jobItemConfirm,
      widget.bookJob,
    );
    setState(() {
      widget.dataPrice = getPrice.dataPrice;
    });
    countGetPrice++;
  }

  priceReserve(price) {
    return StringUtils.addCharAtPosition(StringUtils.reverse(price), ".", 3,
        repeat: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Chi phí đặt thợ',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Colors.white,
                ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Danh sách các dịch vụ:',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 192, 244, 210),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                      itemCount: selectedItems.length,
                      itemBuilder: (context, index) {
                        // int listJobItemFindId =
                        //     jobItemsSelected.indexWhere((element) =>
                        //         selectedItems.contains(element));
                        // print(listJobItemFindId);
                        // var jobItemCount = listJobItemFindId;
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Card(
                            color: Colors.white,
                            child: ListTile(
                              tileColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              title: Container(
                                padding: const EdgeInsets.only(right: 10),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  selectedItems[index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                      ),
                                ),
                              ),
                              subtitle: Text(
                                'Số lượng : ${jobItemsSelected[index].qt}  ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Colors.grey,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                    ),
                              ),
                              trailing: Text(
                                '${StringUtils.reverse(priceReserve(jobItemsSelected[index].price))} VNĐ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                    ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color.fromARGB(91, 158, 158, 158),
                      ),
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            getPrice.code = await showBarModalBottomSheet(
                              expand: true,
                              context: context,
                              builder: (context) =>
                                  const VoucherValidPageView(),
                            );
                            getPrice.isNext = false;
                            await getPriceFunc();
                            // if (getPrice.isSuccess == true) {
                            //   setState(() {
                            //     tempTotalPrice -=
                            //         int.parse(getPrice.dataPrice.discount);
                            //   });
                            // }
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(38, 166, 83, 1),
                            foregroundColor: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 2.0),
                            child: Text(
                              'Mã giảm giá',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: Colors.white,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                  ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              getPrice.code == null || getPrice.code == ''
                                  ? 'Chưa áp dụng'
                                  : getPrice.code,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: Colors.black,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                  ),
                            ),
                          ],
                        ),
                      ]),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Phí di chuyển:',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                        '${StringUtils.reverse(priceReserve(widget.dataPrice.movingFee))} VND',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            )),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Giảm giá:',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                        '${StringUtils.reverse(priceReserve(widget.dataPrice.discount))} VND',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            )),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Giá dịch vụ:',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                        '${StringUtils.reverse(priceReserve(widget.dataPrice.price))} VND',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            )),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Phụ thu ngày lễ:',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                        '${StringUtils.reverse(priceReserve(widget.dataPrice.holiday.sum))} VND',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            )),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color.fromARGB(91, 158, 158, 158),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng:',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w900,
                                ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                          '${StringUtils.reverse(priceReserve(widget.dataPrice.sumPrice))} VND',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              )),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.075),
                Center(
                  child: MaterialButton(
                    onPressed: () {
                      widget.bookJob();
                    },
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    height: 40.0,
                    minWidth: 100.0,
                    color: const Color.fromRGBO(38, 166, 83, 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 8),
                      child: Text(
                        'Đặt thợ',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
