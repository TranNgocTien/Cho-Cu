import 'package:chotot/controllers/get_price_v2.dart';
import 'package:chotot/data/get_vouchers_valid_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:getwidget/getwidget.dart';

class VoucherValidPageView extends StatefulWidget {
  const VoucherValidPageView({super.key});

  @override
  State<VoucherValidPageView> createState() => _VoucherValidPageViewState();
}

class _VoucherValidPageViewState extends State<VoucherValidPageView> {
  GetPrice getPrice = Get.put(GetPrice());

  @override
  Widget build(BuildContext context) {
    TextEditingController voucherCodeController =
        TextEditingController(text: '');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  controller: voucherCodeController,
                  maxLines: 1,
                  onTapOutside: (e) {
                    Navigator.pop(context, voucherCodeController.text);
                  },
                  onEditingComplete: () {
                    Navigator.pop(context, voucherCodeController.text);
                  },
                  decoration: InputDecoration(
                      icon: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(
                                  context, voucherCodeController.text);
                            },
                            icon: const Icon(Icons.search)),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.tealAccent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      hintText: 'Nhập mã giảm giá',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                      )),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Các mã giảm giá còn hiệu lực',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
              ),
              ...vouchersValid.map((voucher) {
                var tsFrom = DateTime.fromMillisecondsSinceEpoch(
                    int.parse(voucher.from));
                var tsTo =
                    DateTime.fromMillisecondsSinceEpoch(int.parse(voucher.to));
                var dateFrom = DateFormat('d/M/y').format(tsFrom);
                var dateTo = DateFormat('d/M/y').format(tsTo);
                return GFListTile(
                  avatar: GFAvatar(
                    shape: GFAvatarShape.square,
                    backgroundColor: Colors.white,
                    child: Image.network(voucher.img),
                  ),
                  titleText: voucher.name,
                  subTitleText: '$dateFrom - $dateTo',
                  description: Text(voucher.description),
                  // icon: Icon(Icons.home, color: Colors.red),
                  padding: EdgeInsets.zero,
                  radius: 50,
                  onTap: () {
                    Navigator.pop(context, voucher.code);
                  },
                  icon: getPrice.code == voucher.code
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              getPrice.code = '';
                            });
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.circleMinus,
                            color: Colors.red,
                          ),
                        )
                      : const SizedBox(),
                  // title: Text('$dateTo-$dateFrom'),
                );
              }).toList()
            ],
          ),
        ),
      ),
    );
  }
}

// ListView.builder(
//                 itemCount: vouchersValid.length,
//                 itemBuilder: (context, index) {
//                   var tsFrom = DateTime.fromMillisecondsSinceEpoch(
//                       int.parse(vouchersValid[index].from));
//                   var tsTo = DateTime.fromMillisecondsSinceEpoch(
//                       int.parse(vouchersValid[index].to));
//                   var dateFrom = DateFormat('d/M/y').format(tsFrom);
//                   var dateTo = DateFormat('d/M/y').format(tsTo);
//                   return GFListTile(
//                       avatar: GFAvatar(
//                         shape: GFAvatarShape.square,
//                         backgroundColor: Colors.white,
//                         child: Image.network(vouchersValid[index].img),
//                       ),
//                       titleText: vouchersValid[index].name,
//                       subTitleText: '$dateFrom - $dateTo',
//                       description: Text(vouchersValid[index].description),
//                       // icon: Icon(Icons.home, color: Colors.red),
//                       padding: EdgeInsets.zero,
//                       radius: 50,
//                       onTap: () {
//                         Navigator.pop(context, vouchersValid[index].code);
//                       }

//                       // title: Text('$dateTo-$dateFrom'),
//                       );
//                 },
//               ),