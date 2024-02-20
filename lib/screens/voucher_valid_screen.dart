import 'package:chotot/data/get_vouchers_valid_data.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:getwidget/getwidget.dart';

class VoucherValidPageView extends StatelessWidget {
  const VoucherValidPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          'Các mã giảm giá còn hiệu lực',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontFamily: GoogleFonts.montserrat().fontFamily,
              ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: vouchersValid.length,
          itemBuilder: (context, index) {
            var tsFrom = DateTime.fromMillisecondsSinceEpoch(
                int.parse(vouchersValid[index].from));
            var tsTo = DateTime.fromMillisecondsSinceEpoch(
                int.parse(vouchersValid[index].to));
            var dateFrom = DateFormat('d/M/y').format(tsFrom);
            var dateTo = DateFormat('d/M/y').format(tsTo);
            return GFListTile(
                avatar: GFAvatar(
                  shape: GFAvatarShape.square,
                  backgroundColor: Colors.white,
                  child: Image.network(vouchersValid[index].img),
                ),
                titleText: vouchersValid[index].name,
                subTitleText: '$dateFrom - $dateTo',
                description: Text(vouchersValid[index].description),
                // icon: Icon(Icons.home, color: Colors.red),
                padding: EdgeInsets.zero,
                radius: 50,
                onTap: () {
                  Navigator.pop(context, vouchersValid[index].code);
                }

                // title: Text('$dateTo-$dateFrom'),
                );
          },
        ),
      ),
    );
  }
}
