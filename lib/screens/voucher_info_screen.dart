import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chotot/models/get_vouchers_valid_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';

class VoucherInfoScreen extends StatelessWidget {
  const VoucherInfoScreen({super.key, required this.voucherInfo});
  final VouchersValid voucherInfo;
  @override
  Widget build(BuildContext context) {
    getTimeVoucher(date) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(date), isUtc: true);
    }

    priceReverse(price) {
      return StringUtils.addCharAtPosition(StringUtils.reverse(price), ".", 3,
          repeat: true);
    }

    final widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          // backgroundColor: Colors.transparent,
          backgroundColor: const Color.fromRGBO(38, 166, 83, 1),
          title: Text(
            'Thông tin mã giảm giá',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: widthDevice * 0.055,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 487 / 451,
                  child: CachedNetworkImage(
                    imageUrl: voucherInfo.img,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    filterQuality: FilterQuality.high,
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: Text(
                    voucherInfo.name,
                    style: GoogleFonts.poppins(
                      fontSize: widthDevice * 0.045,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Card(
                  color: Colors.white,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          voucherInfo.description,
                          style: GoogleFonts.poppins(
                            fontSize: widthDevice * 0.035,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Số lượng: ${voucherInfo.count}',
                          style: GoogleFonts.poppins(
                            fontSize: widthDevice * 0.035,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Tình trạng: ${voucherInfo.status == 'valid' ? 'Có thể sử dụng' : 'Hết hạn sử dụng'}',
                          style: GoogleFonts.poppins(
                            fontSize: widthDevice * 0.035,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(children: [
                          Text(
                            'Thời gian:',
                            style: GoogleFonts.poppins(
                              fontSize: widthDevice * 0.035,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${getTimeVoucher(voucherInfo.from).day < 10 ? 0 : ''}${getTimeVoucher(voucherInfo.from).day}/${getTimeVoucher(voucherInfo.from).month < 10 ? 0 : ''}${getTimeVoucher(voucherInfo.from).month}/${getTimeVoucher(voucherInfo.from).year} - ${getTimeVoucher(voucherInfo.to).day < 10 ? 0 : ''}${getTimeVoucher(voucherInfo.to).day}/${getTimeVoucher(voucherInfo.to).month < 10 ? 0 : ''}${getTimeVoucher(voucherInfo.to).month}/${getTimeVoucher(voucherInfo.to).year}',
                            style: GoogleFonts.poppins(
                              fontSize: widthDevice * 0.035,
                            ),
                          ),
                        ]),
                        const SizedBox(height: 10),
                        voucherInfo.limit != '0'
                            ? Row(
                                children: [
                                  Text(
                                    'Giảm giá tối đa:',
                                    style: GoogleFonts.poppins(
                                      fontSize: widthDevice * 0.035,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${StringUtils.reverse(
                                      priceReverse(voucherInfo.limit),
                                    )} VNĐ',
                                    style: GoogleFonts.poppins(
                                      fontSize: widthDevice * 0.035,
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Giá trị tối thiểu của đơn hàng:',
                              style: GoogleFonts.poppins(
                                fontSize: widthDevice * 0.035,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${StringUtils.reverse(
                                priceReverse(voucherInfo.sum),
                              )} VNĐ',
                              style: GoogleFonts.poppins(
                                fontSize: widthDevice * 0.035,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Giảm giá',
                              style: GoogleFonts.poppins(
                                fontSize: widthDevice * 0.035,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              voucherInfo.type == "discount_cash"
                                  ? '${StringUtils.reverse(
                                      priceReverse(voucherInfo.value),
                                    )} VNĐ'
                                  : '${voucherInfo.value}% giá trị đơn hàng.',
                              style: GoogleFonts.poppins(
                                fontSize: widthDevice * 0.035,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Code giảm giá: ${voucherInfo.code}',
                          style: GoogleFonts.poppins(
                            fontSize: widthDevice * 0.035,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
        ));
  }
}
