import 'dart:async';

import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chotot/models/get_vouchers_valid_models.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class VoucherInfoScreen extends StatefulWidget {
  const VoucherInfoScreen({super.key, required this.voucherInfo});
  final VouchersValid voucherInfo;

  @override
  State<VoucherInfoScreen> createState() => _VoucherInfoScreenState();
}

class _VoucherInfoScreenState extends State<VoucherInfoScreen> {
  bool isLoading = true;
  @override
  void initState() {
    Timer(const Duration(milliseconds: 2000), () async {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  Widget centerLoading = Center(
    child: LoadingAnimationWidget.waveDots(
      color: const Color.fromRGBO(1, 142, 33, 1),
      size: 30,
    ),
  );
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
        body: isLoading
            ? centerLoading
            : SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 487 / 451,
                        child: CachedNetworkImage(
                          imageUrl: widget.voucherInfo.img,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              // borderRadius: const BorderRadius.only(
                              //     topLeft: Radius.circular(10),
                              //     topRight: Radius.circular(10)),
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
                          widget.voucherInfo.name,
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
                                widget.voucherInfo.description,
                                style: GoogleFonts.poppins(
                                  fontSize: widthDevice * 0.035,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Số lượng: ${widget.voucherInfo.count}',
                                style: GoogleFonts.poppins(
                                  fontSize: widthDevice * 0.035,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Tình trạng: ${widget.voucherInfo.status == 'valid' ? 'Có thể sử dụng' : 'Hết hạn sử dụng'}',
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
                                  '${getTimeVoucher(widget.voucherInfo.from).day < 10 ? 0 : ''}${getTimeVoucher(widget.voucherInfo.from).day}/${getTimeVoucher(widget.voucherInfo.from).month < 10 ? 0 : ''}${getTimeVoucher(widget.voucherInfo.from).month}/${getTimeVoucher(widget.voucherInfo.from).year} - ${getTimeVoucher(widget.voucherInfo.to).day < 10 ? 0 : ''}${getTimeVoucher(widget.voucherInfo.to).day}/${getTimeVoucher(widget.voucherInfo.to).month < 10 ? 0 : ''}${getTimeVoucher(widget.voucherInfo.to).month}/${getTimeVoucher(widget.voucherInfo.to).year}',
                                  style: GoogleFonts.poppins(
                                    fontSize: widthDevice * 0.035,
                                  ),
                                ),
                              ]),
                              const SizedBox(height: 10),
                              widget.voucherInfo.limit != '0'
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
                                            priceReverse(
                                                widget.voucherInfo.limit),
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
                                      priceReverse(widget.voucherInfo.sum),
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
                                    widget.voucherInfo.type == "discount_cash"
                                        ? '${StringUtils.reverse(
                                            priceReverse(
                                                widget.voucherInfo.value),
                                          )} VNĐ'
                                        : '${widget.voucherInfo.value}% giá trị đơn hàng.',
                                    style: GoogleFonts.poppins(
                                      fontSize: widthDevice * 0.035,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ));
  }
}
